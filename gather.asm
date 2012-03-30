section .data
align 32
shuffle1:
  db 0, 4, 0xFF, 0xFF
  db 8, 12, 0xFF, 0xFF
  db 0xFF, 0xFF, 0xFF, 0xFF
  db 0xFF, 0xFF, 0xFF, 0xFF
  db 16, 20, 0xFF, 0xFF
  db 24, 28, 0xFF, 0xFF
  db 0xFF, 0xFF, 0xFF, 0xFF
  db 0xFF, 0xFF, 0xFF, 0xFF
shuffle2 db\
  0, 8, 0xFF, 0xFF,\
  0xFF, 0xFF, 0xFF, 0xFF,\
  0xFF, 0xFF, 0xFF, 0xFF,\
  0xFF, 0xFF, 0xFF, 0xFF,\
  0xFF, 0xFF, 0xFF, 0xFF,\
  0xFF, 0xFF, 0xFF, 0xFF,\
  0xFF, 0xFF, 0xFF, 0xFF,\
  0xFF, 0xFF, 0xFF, 0xFF
section .text
global matching
;; 1st arg: rdi -> elements ptr
;; 2nd arg: rsi -> number of elements (currently fixed 16)
;; 3rd arg: rdx -> binary operation table's ptr
;; return value: result element
matching:
  ;; setup registers
  vpmovzxwd  ymm0, [rdi]
  vmovdqa    ymm1, [shuffle1]
  vmovdqa    ymm2, [shuffle2]
  vpcmpeqd   ymm3, ymm3, ymm3
  ;; 1st reduction: 16 elements -> 8 elements
  vmovapd ymm4, ymm3
  vpgatherdd ymm0, [rdx+ymm0], ymm4
  vpshufb    ymm0, ymm0, ymm1
  ;; 2nd reduction: 8 -> 4
  vmovapd ymm4, ymm3
  vpgatherdd ymm0, [rdx+ymm0], ymm4
  vpshufb    ymm0, ymm0, ymm1
  ;; 3rd reduction: 4 -> 2
  vmovapd ymm4, ymm3
  vpgatherdd ymm0, [rdx+ymm0], ymm4
  vpermq     ymm0, ymm0, 0x08 ;; we have to gather last two-elements into same lane.
  vpshufb    ymm0, ymm0, ymm2 ;; because vpshufb cannot operate cross-(128bit)lanes.
  ;; last reductin: 2 -> 1 (least significant byte)
  vmovapd ymm4, ymm3
  vpgatherdd ymm0, [rdx+ymm0], ymm4
  ;; return result element
  movq rax, xmm0
  ret