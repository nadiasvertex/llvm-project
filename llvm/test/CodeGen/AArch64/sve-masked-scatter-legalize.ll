; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -enable-misched=false < %s | FileCheck %s

target triple = "aarch64-linux-gnu"

; Tests that exercise various type legalisation scenarios for ISD::MSCATTER.

; Code generate the scenario where the offset vector type is illegal.
define void @masked_scatter_nxv16i8(<vscale x 16 x i8> %data, i8* %base, <vscale x 16 x i8> %offsets, <vscale x 16 x i1> %mask) #0 {
; CHECK-LABEL: masked_scatter_nxv16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    pfalse p1.b
; CHECK-NEXT:    zip1 p2.b, p0.b, p1.b
; CHECK-NEXT:    sunpklo z2.h, z1.b
; CHECK-NEXT:    uunpklo z4.h, z0.b
; CHECK-NEXT:    zip1 p3.h, p2.h, p1.h
; CHECK-NEXT:    sunpklo z3.s, z2.h
; CHECK-NEXT:    uunpklo z5.s, z4.h
; CHECK-NEXT:    st1b { z5.s }, p3, [x0, z3.s, sxtw]
; CHECK-NEXT:    zip2 p2.h, p2.h, p1.h
; CHECK-NEXT:    sunpkhi z2.s, z2.h
; CHECK-NEXT:    uunpkhi z3.s, z4.h
; CHECK-NEXT:    zip2 p0.b, p0.b, p1.b
; CHECK-NEXT:    sunpkhi z1.h, z1.b
; CHECK-NEXT:    uunpkhi z0.h, z0.b
; CHECK-NEXT:    st1b { z3.s }, p2, [x0, z2.s, sxtw]
; CHECK-NEXT:    zip1 p2.h, p0.h, p1.h
; CHECK-NEXT:    sunpklo z2.s, z1.h
; CHECK-NEXT:    uunpklo z3.s, z0.h
; CHECK-NEXT:    zip2 p0.h, p0.h, p1.h
; CHECK-NEXT:    sunpkhi z1.s, z1.h
; CHECK-NEXT:    uunpkhi z0.s, z0.h
; CHECK-NEXT:    st1b { z3.s }, p2, [x0, z2.s, sxtw]
; CHECK-NEXT:    st1b { z0.s }, p0, [x0, z1.s, sxtw]
; CHECK-NEXT:    ret
  %ptrs = getelementptr i8, i8* %base, <vscale x 16 x i8> %offsets
  call void @llvm.masked.scatter.nxv16i8(<vscale x 16 x i8> %data, <vscale x 16 x i8*> %ptrs, i32 1, <vscale x 16 x i1> %mask)
  ret void
}

define void @masked_scatter_nxv8i16(<vscale x 8 x i16> %data, i16* %base, <vscale x 8 x i16> %offsets, <vscale x 8 x i1> %mask) #0 {
; CHECK-LABEL: masked_scatter_nxv8i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    pfalse p1.b
; CHECK-NEXT:    zip1 p2.h, p0.h, p1.h
; CHECK-NEXT:    sunpklo z2.s, z1.h
; CHECK-NEXT:    uunpklo z3.s, z0.h
; CHECK-NEXT:    zip2 p0.h, p0.h, p1.h
; CHECK-NEXT:    sunpkhi z1.s, z1.h
; CHECK-NEXT:    uunpkhi z0.s, z0.h
; CHECK-NEXT:    st1h { z3.s }, p2, [x0, z2.s, sxtw #1]
; CHECK-NEXT:    st1h { z0.s }, p0, [x0, z1.s, sxtw #1]
; CHECK-NEXT:    ret
  %ptrs = getelementptr i16, i16* %base, <vscale x 8 x i16> %offsets
  call void @llvm.masked.scatter.nxv8i16(<vscale x 8 x i16> %data, <vscale x 8 x i16*> %ptrs, i32 1, <vscale x 8 x i1> %mask)
  ret void
}

define void @masked_scatter_nxv8bf16(<vscale x 8 x bfloat> %data, bfloat* %base, <vscale x 8 x i16> %offsets, <vscale x 8 x i1> %mask) #0 {
; CHECK-LABEL: masked_scatter_nxv8bf16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    pfalse p1.b
; CHECK-NEXT:    zip1 p2.h, p0.h, p1.h
; CHECK-NEXT:    sunpklo z2.s, z1.h
; CHECK-NEXT:    uunpklo z3.s, z0.h
; CHECK-NEXT:    zip2 p0.h, p0.h, p1.h
; CHECK-NEXT:    sunpkhi z1.s, z1.h
; CHECK-NEXT:    uunpkhi z0.s, z0.h
; CHECK-NEXT:    st1h { z3.s }, p2, [x0, z2.s, sxtw #1]
; CHECK-NEXT:    st1h { z0.s }, p0, [x0, z1.s, sxtw #1]
; CHECK-NEXT:    ret
  %ptrs = getelementptr bfloat, bfloat* %base, <vscale x 8 x i16> %offsets
  call void @llvm.masked.scatter.nxv8bf16(<vscale x 8 x bfloat> %data, <vscale x 8 x bfloat*> %ptrs, i32 1, <vscale x 8 x i1> %mask)
  ret void
}

define void @masked_scatter_nxv8f32(<vscale x 8 x float> %data, float* %base, <vscale x 8 x i32> %indexes, <vscale x 8 x i1> %masks) #0 {
; CHECK-LABEL: masked_scatter_nxv8f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    pfalse p1.b
; CHECK-NEXT:    zip1 p2.h, p0.h, p1.h
; CHECK-NEXT:    zip2 p0.h, p0.h, p1.h
; CHECK-NEXT:    st1w { z0.s }, p2, [x0, z2.s, uxtw #2]
; CHECK-NEXT:    st1w { z1.s }, p0, [x0, z3.s, uxtw #2]
; CHECK-NEXT:    ret
  %ext = zext <vscale x 8 x i32> %indexes to <vscale x 8 x i64>
  %ptrs = getelementptr float, float* %base, <vscale x 8 x i64> %ext
  call void @llvm.masked.scatter.nxv8f32(<vscale x 8 x float> %data, <vscale x 8 x float*> %ptrs, i32 0, <vscale x 8 x i1> %masks)
  ret void
}

; Code generate the worst case scenario when all vector types are illegal.
define void @masked_scatter_nxv32i32(<vscale x 32 x i32> %data, i32* %base, <vscale x 32 x i32> %offsets, <vscale x 32 x i1> %mask) #0 {
; CHECK-LABEL: masked_scatter_nxv32i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x29, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-1
; CHECK-NEXT:    str p4, [sp, #7, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    ptrue p2.s
; CHECK-NEXT:    ld1w { z24.s }, p2/z, [x1, #7, mul vl]
; CHECK-NEXT:    ld1w { z25.s }, p2/z, [x1, #6, mul vl]
; CHECK-NEXT:    ld1w { z26.s }, p2/z, [x1, #5, mul vl]
; CHECK-NEXT:    ld1w { z27.s }, p2/z, [x1, #4, mul vl]
; CHECK-NEXT:    ld1w { z28.s }, p2/z, [x1, #3, mul vl]
; CHECK-NEXT:    ld1w { z29.s }, p2/z, [x1, #2, mul vl]
; CHECK-NEXT:    ld1w { z30.s }, p2/z, [x1, #1, mul vl]
; CHECK-NEXT:    ld1w { z31.s }, p2/z, [x1]
; CHECK-NEXT:    pfalse p2.b
; CHECK-NEXT:    zip1 p3.b, p0.b, p2.b
; CHECK-NEXT:    zip1 p4.h, p3.h, p2.h
; CHECK-NEXT:    zip2 p3.h, p3.h, p2.h
; CHECK-NEXT:    zip2 p0.b, p0.b, p2.b
; CHECK-NEXT:    st1w { z0.s }, p4, [x0, z31.s, sxtw #2]
; CHECK-NEXT:    st1w { z1.s }, p3, [x0, z30.s, sxtw #2]
; CHECK-NEXT:    zip1 p3.h, p0.h, p2.h
; CHECK-NEXT:    zip2 p0.h, p0.h, p2.h
; CHECK-NEXT:    st1w { z2.s }, p3, [x0, z29.s, sxtw #2]
; CHECK-NEXT:    st1w { z3.s }, p0, [x0, z28.s, sxtw #2]
; CHECK-NEXT:    zip1 p0.b, p1.b, p2.b
; CHECK-NEXT:    zip1 p3.h, p0.h, p2.h
; CHECK-NEXT:    zip2 p0.h, p0.h, p2.h
; CHECK-NEXT:    st1w { z4.s }, p3, [x0, z27.s, sxtw #2]
; CHECK-NEXT:    st1w { z5.s }, p0, [x0, z26.s, sxtw #2]
; CHECK-NEXT:    zip2 p0.b, p1.b, p2.b
; CHECK-NEXT:    zip1 p1.h, p0.h, p2.h
; CHECK-NEXT:    zip2 p0.h, p0.h, p2.h
; CHECK-NEXT:    st1w { z6.s }, p1, [x0, z25.s, sxtw #2]
; CHECK-NEXT:    st1w { z7.s }, p0, [x0, z24.s, sxtw #2]
; CHECK-NEXT:    ldr p4, [sp, #7, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    addvl sp, sp, #1
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %ptrs = getelementptr i32, i32* %base, <vscale x 32 x i32> %offsets
  call void @llvm.masked.scatter.nxv32i32(<vscale x 32 x i32> %data, <vscale x 32 x i32*> %ptrs, i32 4, <vscale x 32 x i1> %mask)
  ret void
}

declare void @llvm.masked.scatter.nxv16i8(<vscale x 16 x i8>, <vscale x 16 x i8*>,  i32, <vscale x 16 x i1>)
declare void @llvm.masked.scatter.nxv8i16(<vscale x 8 x i16>, <vscale x 8 x i16*>,  i32, <vscale x 8 x i1>)
declare void @llvm.masked.scatter.nxv8f32(<vscale x 8 x float>, <vscale x 8 x float*>, i32, <vscale x 8 x i1>)
declare void @llvm.masked.scatter.nxv8bf16(<vscale x 8 x bfloat>, <vscale x 8 x bfloat*>, i32, <vscale x 8 x i1>)
declare void @llvm.masked.scatter.nxv32i32(<vscale x 32 x i32>, <vscale x 32 x i32*>,  i32, <vscale x 32 x i1>)
attributes #0 = { nounwind "target-features"="+sve,+bf16" }
