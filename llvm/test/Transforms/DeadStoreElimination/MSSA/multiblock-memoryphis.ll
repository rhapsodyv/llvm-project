; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basicaa -dse -enable-dse-memoryssa -S | FileCheck %s

target datalayout = "e-m:e-p:32:32-i64:64-v128:64:128-a:0:32-n32-S64"


define void @test4(i32* noalias %P) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    store i32 0, i32* [[P:%.*]], align 4
; CHECK-NEXT:    br i1 true, label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    [[X:%.*]] = load i32, i32* [[P]], align 4
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    store i32 0, i32* [[P]], align 4
; CHECK-NEXT:    ret void
;
  store i32 0, i32* %P
  br i1 true, label %bb1, label %bb2
bb1:
  br label %bb3
bb2:
  %x = load i32, i32* %P
  br label %bb3
bb3:
  store i32 0, i32* %P
  ret void
}

define void @test5(i32* noalias %P) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    br i1 true, label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    store i32 0, i32* [[P:%.*]], align 4
; CHECK-NEXT:    ret void
;
  br i1 true, label %bb1, label %bb2
bb1:
  store i32 1, i32* %P
  br label %bb3
bb2:
  store i32 1, i32* %P
  br label %bb3
bb3:
  store i32 0, i32* %P
  ret void
}

define void @test8(i32* %P, i32* %Q) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    br i1 true, label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    store i32 1, i32* [[Q:%.*]], align 4
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    store i32 0, i32* [[P:%.*]], align 4
; CHECK-NEXT:    ret void
;
  br i1 true, label %bb1, label %bb2
bb1:
  store i32 1, i32* %P
  br label %bb3
bb2:
  store i32 1, i32* %Q
  br label %bb3
bb3:
  store i32 0, i32* %P
  ret void
}

define void @test10(i32* noalias %P) {
; CHECK-LABEL: @test10(
; CHECK-NEXT:    store i32 1, i32* [[P:%.*]], align 4
; CHECK-NEXT:    br i1 true, label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    ret void
;
  %P2 = bitcast i32* %P to i8*
  store i32 0, i32* %P
  br i1 true, label %bb1, label %bb2
bb1:
  br label %bb3
bb2:
  br label %bb3
bb3:
  store i8 1, i8* %P2
  ret void
}

declare void @hoge()

; Check a function with a MemoryPhi with 3 incoming values.
define void @widget(i32* %Ptr, i1 %c1, i1 %c2, i32 %v1, i32 %v2, i32 %v3) {
; CHECK-LABEL: @widget(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    tail call void @hoge()
; CHECK-NEXT:    br i1 [[C1:%.*]], label [[BB3:%.*]], label [[BB1:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br i1 [[C2:%.*]], label [[BB2:%.*]], label [[BB3]]
; CHECK:       bb2:
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    br label [[BB4:%.*]]
; CHECK:       bb4:
; CHECK-NEXT:    switch i32 [[V1:%.*]], label [[BB8:%.*]] [
; CHECK-NEXT:    i32 0, label [[BB5:%.*]]
; CHECK-NEXT:    i32 1, label [[BB6:%.*]]
; CHECK-NEXT:    i32 2, label [[BB7:%.*]]
; CHECK-NEXT:    ]
; CHECK:       bb5:
; CHECK-NEXT:    store i32 0, i32* [[PTR:%.*]], align 4
; CHECK-NEXT:    br label [[BB8]]
; CHECK:       bb6:
; CHECK-NEXT:    store i32 1, i32* [[PTR]], align 4
; CHECK-NEXT:    br label [[BB8]]
; CHECK:       bb7:
; CHECK-NEXT:    store i32 2, i32* [[PTR]], align 4
; CHECK-NEXT:    br label [[BB8]]
; CHECK:       bb8:
; CHECK-NEXT:    br label [[BB4]]
;
bb:
  tail call void @hoge()
  br i1 %c1, label %bb3, label %bb1

bb1:                                              ; preds = %bb
  br i1 %c2, label %bb2, label %bb3

bb2:                                              ; preds = %bb1
  store i32 -1, i32* %Ptr, align 4
  br label %bb3

bb3:                                              ; preds = %bb2, %bb1, %bb
  br label %bb4

bb4:                                              ; preds = %bb8, %bb3
  switch i32 %v1, label %bb8 [
  i32 0, label %bb5
  i32 1, label %bb6
  i32 2, label %bb7
  ]

bb5:                                              ; preds = %bb4
  store i32 0, i32* %Ptr, align 4
  br label %bb8

bb6:                                              ; preds = %bb4
  store i32 1, i32* %Ptr, align 4
  br label %bb8

bb7:                                              ; preds = %bb4
  store i32 2, i32* %Ptr, align 4
  br label %bb8

bb8:                                              ; preds = %bb7, %bb6, %bb5, %bb4
  br label %bb4
}


declare void @fn1_test11()
declare void @fn2_test11()

define void @test11(i1 %c, i8** %ptr.1) {
; CHECK-LABEL: @test11(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[C:%.*]], label [[IF_THEN:%.*]], label [[EXIT:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    tail call void @fn2_test11() #0
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    store i8* null, i8** [[PTR_1:%.*]], align 8
; CHECK-NEXT:    tail call void @fn2_test11() #0
; CHECK-NEXT:    ret void
;
entry:
  br i1 %c, label %if.then, label %exit

if.then:                                      ; preds = %entry
  tail call void @fn2_test11() #1
  br label %exit

exit:
  store i8* null, i8** %ptr.1, align 8
  tail call void @fn2_test11() #1
  ret void
}

attributes #1 = { nounwind }
