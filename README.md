# 인스타그램 클론

강의는 유데미를 참고하였지만, 강의 내용 외에 직접 따라해보고 싶은 기능들을 추가로 구현하였습니다.

## 포토 라이브러리 선택기능

https://github.com/Parkjju/instagram-clone/assets/75518683/cd62f343-4ebd-48b2-b08d-eddec3aac0f9

기능 구현 과정에서 중점적으로 공부했던 부분은 `CGAffineTransform`에 대한 부분이었습니다. 기능 구현 과정에서 아핀변환에 대해 알게된 부분을 [블로그에](https://parkjju.github.io/vue-TIL/trash/230512-27.html) 정리해두었습니다

구현 과정에서 발생한 이슈로 `collectionView` 셀 클릭을 통해 셀의 이미지를 미리보기 뷰로 로드 후 `aspectFill` 형태로 이미지 리사이징 및 아핀변환을 해주어야 하는데, 
`didSelectItemAt` 컬렉션뷰 프로토콜 함수에서는 모종의 이유로 UI수정코드를 반드시 메인 스레드를 통해 태스크로 전달해야 한다는 것이었습니다.

`xcode instruments`를 돌려 CPU로그를 살피는 등의 시도를 해보았지만 내부적으로 왜 그런 문제가 발생했는지 명확하게 파악하지는 못하였습니다. 아래는 오류 해결 과정에서 작성했던 스케치 내용입니다.

```markdown
# 컬렉션뷰 didSelect UI 업데이트 관련 스케치

## 이슈내용
1. collectionView 델리게이트 메서드 중 `didSelect` 프로토콜 메서드 내에서 이미지뷰에 접근하여 `imageView.transform.a` , `imageView.transform.d` 값을 직접 세팅하여 너비와 높이에 대한 아핀변환 처리를 진행하고 있다
2. 컬렉션 뷰에서 선택한 이미지 자체가 반영되는 것은 문제가 없다
3. 이미지뷰에 첫 세팅된 후 `transform` 세팅 코드가 제대로 동작하지 않음
4. 동일한 컬렉션 뷰 아이템을 두번 클릭해야 해당 이미지에 맞는 스케일로 피팅됨


## 해결
1. `transform` 값을 모두 메인쓰레드에 전달하여 비동기처리를 하니 해결되었음

## 이유
1. `transform.a` 속성을 setting할때 내부적으로 알지 못하게 비동기적으로 동작하는가? -> 다른 위치에서 해당 코드에 직접 접근해보기 (그냥 세팅됨 -> 애초에 제스처쪽 함수도 동기적으로 다 세팅하고 있음)
2. 위의 방법에 문제가 없다면 didSelect 함수 자체에 문제가 있는거

1. [ios - UITableView and presentViewController takes 2 clicks to display - Stack Overflow](https://stackoverflow.com/questions/20320591/uitableview-and-presentviewcontroller-takes-2-clicks-to-display)
2. [ios - presentViewController:animated:YES view will not appear until user taps again - Stack Overflow](https://stackoverflow.com/questions/21075540/presentviewcontrolleranimatedyes-view-will-not-appear-until-user-taps-again?noredirect=1&lq=1)
3. [ios - Double tap on cell in UITableview to perform segue - Stack Overflow](https://stackoverflow.com/questions/53386575/double-tap-on-cell-in-uitableview-to-perform-segue?noredirect=1&lq=1)

0  0x7ff80b547a60
1  0x7ff80acdff27
2  0x7ff80ae5a8b9
3  0x7ff80ae80d91
4  0x7ff80ae6ecee
5  0x7ff80ae6e9c1
6  0x7ff808d5cfe4
7  0x7ff808d5cea1
8  0x7ff808b48a3a
9  0x7ff808eb7a95
10  0x7ff808e96f80
11  0x7ff808c5a671
12  0x7ff808f4e8f9
13  0x7ff808dab0c0
14  0x7ff808db74b1
15  0x7ff808db31f4
16  0x7ff808adce1b
17  0x7ff808de0da5
18  0x7ff808e6be04
19  0x7ff808e69568
20  0x7ff808e6d6ec
21  0x7ff808b502e6
22  0x7ff808b4f895
23  0x122f79763
24  0x122f7a2fe
25  0x122f7f4af
26  0x122f7f2e8
27  0x122f7a24b
28 instagram UIImage.scalePreservingAspectRatio(targetSize:) /Users/imac/Desktop/instagram-clone/instagram/Utils/Extensions.swift:63
29 instagram CustomPickerViewController.collectionView(_:didSelectItemAt:) /Users/imac/Desktop/instagram-clone/instagram/Controllers/Utils/CustomPickerViewController.swift:92
30 instagram @objc CustomPickerViewController.collectionView(_:didSelectItemAt:) /Users/imac/Desktop/instagram-clone/<compiler-generated>:0
31  0x1229ea2a2
32  0x122a26145
33  0x122a263f4
34  0x12352b3b9
35  0x122ef031a
36  0x122eed86d
37  0x12353feda
38  0x1235137f1
39  0x1235bae60
40  0x1235bd568
41  0x1235b38a0
42  0x7ff800387034
43  0x7ff800386f73
44  0x7ff800386770
45  0x7ff800380e72
46  0x7ff8003806f6
47  0x7ff809c5c289
48  0x1234f262a 
49  0x1234f7546
50  0x11083ec71
51 instagram static UIApplicationDelegate.main() /Users/imac/Desktop/instagram-clone/<compiler-generated>:0
52 instagram static AppDelegate.$main() /Users/imac/Desktop/instagram-clone/instagram/AppDelegate.swift:11
53 instagram main /Users/imac/Desktop/instagram-clone/<compiler-generated>:0
54  0x10fcb92be
55 dyld start

## 가설
비동기처리가 되어 있지 않은 코드
-> 이미지 데이터가 변경된 후 메모리 상에 정보만 저장되고 백그라운드로 넘어감
-> UI로 변경사항 반영을 시도하지 않음

비동기처리가 되어 있는 코드
```
  
스택 오버플로우에 남겨진 질문 가운데 테이블뷰 클릭을 두번 해야 UI변경이 이루어진다는 이슈가 있다는 것을 확인했습니다. 답변으로도 명확한 답을 제시하고 있지는 못하는 것을 확인하였습니다. transform 변환 값을 비동기처리 하여 문제는 해결되었습니다.

  
  
  
  
