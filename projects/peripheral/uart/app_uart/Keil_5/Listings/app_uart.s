
========================================================================

** ELF Header Information

    File Name: Objects\app_uart.axf

    Machine class: ELFCLASS32 (32-bit)
    Data encoding: ELFDATA2LSB (Little endian)
    Header version: EV_CURRENT (Current version)
    Operating System ABI: none
    ABI Version: 0
    File Type: ET_EXEC (Executable) (2)
    Machine: EM_ARM (ARM)

    Image Entry point: 0x01002041
    Flags: EF_ARM_HASENTRY (0x05000002)

    ARM ELF revision: 5 (ABI version 2)

    Conforms to Base float procedure-call standard

    Built with
    Component: ARM Compiler 5.06 update 7 (build 960) Tool: armasm [4d35fa]
    Component: ARM Compiler 5.06 update 6 (build 750) Tool: armasm [4d35ec]
    Component: ARM Compiler 5.06 update 7 (build 960) Tool: armlink [4d3601]
    Component: ARM Compiler 5.06 update 6 (build 750) Tool: armlink [4d35ed]

    Header size: 52 bytes (0x34)
    Program header entry size: 32 bytes (0x20)
    Section header entry size: 40 bytes (0x28)

    Program header entries: 1
    Section header entries: 21

    Program header offset: 1223108 (0x0012a9c4)
    Section header offset: 1223140 (0x0012a9e4)

    Section header string table index: 20

========================================================================

** Program header #0 (PT_LOAD) [PF_X + PF_W + PF_R + PF_ARM_ENTRY]
    Size : 59312 bytes (34652 bytes in file)
    Virtual address: 0x01002000 (Alignment 256)


========================================================================

** Section #1 'FLASH_CODE' (SHT_PROGBITS) [SHF_ALLOC + SHF_EXECINSTR]
    Size   : 23796 bytes (alignment 4)
    Address: 0x01002000

    $d.realdata
    RESET
    __Vectors
        0x01002000:    30040000    ...0    DCD    805568512
        0x01002004:    0100214d    M!..    DCD    16785741
        0x01002008:    010021f7    .!..    DCD    16785911
        0x0100200c:    00804101    .A..    DCD    8405249
        0x01002010:    010021f5    .!..    DCD    16785909
        0x01002014:    010021f1    .!..    DCD    16785905
        0x01002018:    010021fd    .!..    DCD    16785917
        0x0100201c:    00000000    ....    DCD    0
        0x01002020:    00000000    ....    DCD    0
        0x01002024:    00000000    ....    DCD    0
        0x01002028:    00000000    ....    DCD    0
        0x0100202c:    00804115    .A..    DCD    8405269
        0x01002030:    010021f3    .!..    DCD    16785907
        0x01002034:    00000000    ....    DCD    0
        0x01002038:    010021f9    .!..    DCD    16785913
        0x0100203c:    010021fb    .!..    DCD    16785915
    $t
    !!!main
    __Vectors_End
    __main
        0x01002040:    f000f802    ....    BL       __scatterload ; 0x1002048
        0x01002044:    f000f871    ..q.    BL       __rt_entry ; 0x100212a
    !!!scatter
    __scatterload
    __scatterload_rt2
    __scatterload_rt2_thumb_only
        0x01002048:    a00a        ..      ADR      r0,{pc}+0x2c ; 0x1002074
        0x0100204a:    e8900c00    ....    LDM      r0,{r10,r11}
        0x0100204e:    4482        .D      ADD      r10,r10,r0
        0x01002050:    4483        .D      ADD      r11,r11,r0
        0x01002052:    f1aa0701    ....    SUB      r7,r10,#1
    __scatterload_null
        0x01002056:    45da        .E      CMP      r10,r11
        0x01002058:    d101        ..      BNE      0x100205e ; __scatterload_null + 8
        0x0100205a:    f000f866    ..f.    BL       __rt_entry ; 0x100212a
        0x0100205e:    f2af0e09    ....    ADR      lr,{pc}-7 ; 0x1002057
        0x01002062:    e8ba000f    ....    LDM      r10!,{r0-r3}
        0x01002066:    f0130f01    ....    TST      r3,#1
        0x0100206a:    bf18        ..      IT       NE
        0x0100206c:    1afb        ..      SUBNE    r3,r7,r3
        0x0100206e:    f0430301    C...    ORR      r3,r3,#1
        0x01002072:    4718        .G      BX       r3
    $d
        0x01002074:    00005c2c    ,\..    DCD    23596
        0x01002078:    00005c7c    |\..    DCD    23676
    $t
    !!dczerorl2
    __decompress
    __decompress1
        0x0100207c:    440a        .D      ADD      r2,r2,r1
        0x0100207e:    f04f0c00    O...    MOV      r12,#0
        0x01002082:    f8103b01    ...;    LDRB     r3,[r0],#1
        0x01002086:    f0130407    ....    ANDS     r4,r3,#7
        0x0100208a:    bf08        ..      IT       EQ
        0x0100208c:    f8104b01    ...K    LDRBEQ   r4,[r0],#1
        0x01002090:    111d        ..      ASRS     r5,r3,#4
        0x01002092:    bf08        ..      IT       EQ
        0x01002094:    f8105b01    ...[    LDRBEQ   r5,[r0],#1
        0x01002098:    1e64        d.      SUBS     r4,r4,#1
        0x0100209a:    d005        ..      BEQ      0x10020a8 ; __decompress + 44
        0x0100209c:    f8106b01    ...k    LDRB     r6,[r0],#1
        0x010020a0:    1e64        d.      SUBS     r4,r4,#1
        0x010020a2:    f8016b01    ...k    STRB     r6,[r1],#1
        0x010020a6:    d1f9        ..      BNE      0x100209c ; __decompress + 32
        0x010020a8:    f0130f08    ....    TST      r3,#8
        0x010020ac:    bf1e        ..      ITTT     NE
        0x010020ae:    f8104b01    ...K    LDRBNE   r4,[r0],#1
        0x010020b2:    1cad        ..      ADDNE    r5,r5,#2
        0x010020b4:    1b0c        ..      SUBNE    r4,r1,r4
        0x010020b6:    d109        ..      BNE      0x10020cc ; __decompress + 80
        0x010020b8:    1e6d        m.      SUBS     r5,r5,#1
        0x010020ba:    bf58        X.      IT       PL
        0x010020bc:    f801cb01    ....    STRBPL   r12,[r1],#1
        0x010020c0:    d5fa        ..      BPL      0x10020b8 ; __decompress + 60
        0x010020c2:    e005        ..      B        0x10020d0 ; __decompress + 84
        0x010020c4:    f8146b01    ...k    LDRB     r6,[r4],#1
        0x010020c8:    f8016b01    ...k    STRB     r6,[r1],#1
        0x010020cc:    1e6d        m.      SUBS     r5,r5,#1
        0x010020ce:    d5f9        ..      BPL      0x10020c4 ; __decompress + 72
        0x010020d0:    4291        .B      CMP      r1,r2
        0x010020d2:    d3d6        ..      BCC      0x1002082 ; __decompress + 6
        0x010020d4:    4770        pG      BX       lr
        0x010020d6:    0000        ..      MOVS     r0,r0
    !!handler_copy
    __scatterload_copy
        0x010020d8:    3a10        .:      SUBS     r2,r2,#0x10
        0x010020da:    bf24        $.      ITT      CS
        0x010020dc:    c878        x.      LDMCS    r0!,{r3-r6}
        0x010020de:    c178        x.      STMCS    r1!,{r3-r6}
        0x010020e0:    d8fa        ..      BHI      __scatterload_copy ; 0x10020d8
        0x010020e2:    0752        R.      LSLS     r2,r2,#29
        0x010020e4:    bf24        $.      ITT      CS
        0x010020e6:    c830        0.      LDMCS    r0!,{r4,r5}
        0x010020e8:    c130        0.      STMCS    r1!,{r4,r5}
        0x010020ea:    bf44        D.      ITT      MI
        0x010020ec:    6804        .h      LDRMI    r4,[r0,#0]
        0x010020ee:    600c        .`      STRMI    r4,[r1,#0]
        0x010020f0:    4770        pG      BX       lr
        0x010020f2:    0000        ..      MOVS     r0,r0
    !!handler_zi
    __scatterload_zeroinit
        0x010020f4:    2300        .#      MOVS     r3,#0
        0x010020f6:    2400        .$      MOVS     r4,#0
        0x010020f8:    2500        .%      MOVS     r5,#0
        0x010020fa:    2600        .&      MOVS     r6,#0
        0x010020fc:    3a10        .:      SUBS     r2,r2,#0x10
        0x010020fe:    bf28        (.      IT       CS
        0x01002100:    c178        x.      STMCS    r1!,{r3-r6}
        0x01002102:    d8fb        ..      BHI      0x10020fc ; __scatterload_zeroinit + 8
        0x01002104:    0752        R.      LSLS     r2,r2,#29
        0x01002106:    bf28        (.      IT       CS
        0x01002108:    c130        0.      STMCS    r1!,{r4,r5}
        0x0100210a:    bf48        H.      IT       MI
        0x0100210c:    600b        .`      STRMI    r3,[r1,#0]
        0x0100210e:    4770        pG      BX       lr
    .ARM.Collect$$_printf_percent$$0000000C
    .ARM.Collect$$_printf_percent$$00000000
    _printf_percent
    _printf_x
        0x01002110:    2978        x)      CMP      r1,#0x78
        0x01002112:    f00080c0    ....    BEQ.W    _printf_int_hex ; 0x1002296
    .ARM.Collect$$_printf_percent$$00000017
    _printf_percent_end
        0x01002116:    2000        .       MOVS     r0,#0
        0x01002118:    4770        pG      BX       lr
    .ARM.Collect$$libinit$$00000000
    __rt_lib_init
        0x0100211a:    b51f        ..      PUSH     {r0-r4,lr}
    .ARM.Collect$$libinit$$00000001
    __rt_lib_init_fp_1
        0x0100211c:    f005fcd6    ....    BL       _fp_init ; 0x1007acc
    .ARM.Collect$$libinit$$00000004
    .ARM.Collect$$libinit$$0000000A
    .ARM.Collect$$libinit$$0000000C
    .ARM.Collect$$libinit$$0000000E
    .ARM.Collect$$libinit$$00000011
    .ARM.Collect$$libinit$$00000013
    .ARM.Collect$$libinit$$00000015
    .ARM.Collect$$libinit$$00000017
    .ARM.Collect$$libinit$$00000019
    .ARM.Collect$$libinit$$0000001B
    .ARM.Collect$$libinit$$0000001D
    .ARM.Collect$$libinit$$0000001F
    .ARM.Collect$$libinit$$00000021
    .ARM.Collect$$libinit$$00000023
    .ARM.Collect$$libinit$$00000025
    .ARM.Collect$$libinit$$0000002C
    .ARM.Collect$$libinit$$0000002E
    .ARM.Collect$$libinit$$00000030
    .ARM.Collect$$libinit$$00000031
    __rt_lib_init_alloca_1
    __rt_lib_init_argv_1
    __rt_lib_init_atexit_1
    __rt_lib_init_clock_1
    __rt_lib_init_cpp_2
    __rt_lib_init_exceptions_1
    __rt_lib_init_fp_trap_1
    __rt_lib_init_getenv_1
    __rt_lib_init_heap_1
    __rt_lib_init_lc_collate_1
    __rt_lib_init_lc_ctype_1
    __rt_lib_init_lc_monetary_1
    __rt_lib_init_lc_numeric_1
    __rt_lib_init_lc_time_1
    __rt_lib_init_preinit_1
    __rt_lib_init_rand_1
    __rt_lib_init_signal_1
    __rt_lib_init_stdio_1
    __rt_lib_init_user_alloc_1
        0x01002120:    f000f850    ..P.    BL       __cpp_initialize__aeabi_ ; 0x10021c4
    .ARM.Collect$$libinit$$00000032
    .ARM.Collect$$libinit$$00000033
    __rt_lib_init_cpp_1
    __rt_lib_init_return
        0x01002124:    bd1f        ..      POP      {r0-r4,pc}
    .ARM.Collect$$libshutdown$$00000000
    __rt_lib_shutdown
        0x01002126:    b510        ..      PUSH     {r4,lr}
    .ARM.Collect$$libshutdown$$00000002
    .ARM.Collect$$libshutdown$$00000004
    .ARM.Collect$$libshutdown$$00000006
    .ARM.Collect$$libshutdown$$00000009
    .ARM.Collect$$libshutdown$$0000000C
    .ARM.Collect$$libshutdown$$0000000E
    .ARM.Collect$$libshutdown$$00000011
    .ARM.Collect$$libshutdown$$00000012
    __rt_lib_shutdown_cpp_1
    __rt_lib_shutdown_fini_1
    __rt_lib_shutdown_fp_trap_1
    __rt_lib_shutdown_heap_1
    __rt_lib_shutdown_return
    __rt_lib_shutdown_signal_1
    __rt_lib_shutdown_stdio_1
    __rt_lib_shutdown_user_alloc_1
        0x01002128:    bd10        ..      POP      {r4,pc}
    .ARM.Collect$$rtentry$$00000000
    .ARM.Collect$$rtentry$$00000002
    .ARM.Collect$$rtentry$$00000007
    __rt_entry
    __rt_entry_presh_1
    __rt_entry_sh
        0x0100212a:    f8dfd010    ....    LDR      sp,__lit__00000000 ; [0x100213c] = 0x30040000
    .ARM.Collect$$rtentry$$00000009
    .ARM.Collect$$rtentry$$0000000A
    __rt_entry_li
    __rt_entry_postsh_1
        0x0100212e:    f7fffff4    ....    BL       __rt_lib_init ; 0x100211a
    .ARM.Collect$$rtentry$$0000000C
    .ARM.Collect$$rtentry$$0000000D
    __rt_entry_main
    __rt_entry_postli_1
        0x01002132:    f002ff47    ..G.    BL       main ; 0x1004fc4
        0x01002136:    f000fb01    ....    BL       exit ; 0x100273c
        0x0100213a:    0000        ..      MOVS     r0,r0
    $d
    .ARM.Collect$$rtentry$$00002718
    __lit__00000000
        0x0100213c:    30040000    ...0    DCD    805568512
    $t
    .ARM.Collect$$rtexit$$00000000
    __rt_exit
        0x01002140:    b403        ..      PUSH     {r0,r1}
    .ARM.Collect$$rtexit$$00000002
    .ARM.Collect$$rtexit$$00000003
    __rt_exit_ls
    __rt_exit_prels_1
        0x01002142:    f7fffff0    ....    BL       __rt_lib_shutdown ; 0x1002126
    .ARM.Collect$$rtexit$$00000004
    __rt_exit_exit
        0x01002146:    bc03        ..      POP      {r0,r1}
        0x01002148:    f000f859    ..Y.    BL       _sys_exit ; 0x10021fe
    .text
    $v0
    Reset_Handler
        0x0100214c:    4801        .H      LDR      r0,[pc,#4] ; [0x1002154] = 0x1002911
        0x0100214e:    4780        .G      BLX      r0
        0x01002150:    4801        .H      LDR      r0,[pc,#4] ; [0x1002158] = 0x1004fcf
        0x01002152:    4700        .G      BX       r0
    $d
        0x01002154:    01002911    .)..    DCD    16787729
        0x01002158:    01004fcf    .O..    DCD    16797647
    $t
    .text
    __2printf
        0x0100215c:    b40f        ..      PUSH     {r0-r3}
        0x0100215e:    4904        .I      LDR      r1,[pc,#16] ; [0x1002170] = 0x300065d4
        0x01002160:    b510        ..      PUSH     {r4,lr}
        0x01002162:    aa03        ..      ADD      r2,sp,#0xc
        0x01002164:    9802        ..      LDR      r0,[sp,#8]
        0x01002166:    f000fad7    ....    BL       _printf_char_file ; 0x1002718
        0x0100216a:    bc10        ..      POP      {r4}
        0x0100216c:    f85dfb14    ]...    LDR      pc,[sp],#0x14
    $d
        0x01002170:    300065d4    .e.0    DCD    805332436
    $t
    .text
    _printf_pre_padding
        0x01002174:    b570        p.      PUSH     {r4-r6,lr}
        0x01002176:    4604        .F      MOV      r4,r0
        0x01002178:    6985        .i      LDR      r5,[r0,#0x18]
        0x0100217a:    6800        .h      LDR      r0,[r0,#0]
        0x0100217c:    06c1        ..      LSLS     r1,r0,#27
        0x0100217e:    d501        ..      BPL      0x1002184 ; _printf_pre_padding + 16
        0x01002180:    2630        0&      MOVS     r6,#0x30
        0x01002182:    e000        ..      B        0x1002186 ; _printf_pre_padding + 18
        0x01002184:    2620         &      MOVS     r6,#0x20
        0x01002186:    07c0        ..      LSLS     r0,r0,#31
        0x01002188:    d007        ..      BEQ      0x100219a ; _printf_pre_padding + 38
        0x0100218a:    bd70        p.      POP      {r4-r6,pc}
        0x0100218c:    e9d42101    ...!    LDRD     r2,r1,[r4,#4]
        0x01002190:    4630        0F      MOV      r0,r6
        0x01002192:    4790        .G      BLX      r2
        0x01002194:    6a20         j      LDR      r0,[r4,#0x20]
        0x01002196:    1c40        @.      ADDS     r0,r0,#1
        0x01002198:    6220         b      STR      r0,[r4,#0x20]
        0x0100219a:    1e6d        m.      SUBS     r5,r5,#1
        0x0100219c:    d5f6        ..      BPL      0x100218c ; _printf_pre_padding + 24
        0x0100219e:    bd70        p.      POP      {r4-r6,pc}
    _printf_post_padding
        0x010021a0:    b570        p.      PUSH     {r4-r6,lr}
        0x010021a2:    4604        .F      MOV      r4,r0
        0x010021a4:    6985        .i      LDR      r5,[r0,#0x18]
        0x010021a6:    7800        .x      LDRB     r0,[r0,#0]
        0x010021a8:    07c0        ..      LSLS     r0,r0,#31
        0x010021aa:    d107        ..      BNE      0x10021bc ; _printf_post_padding + 28
        0x010021ac:    bd70        p.      POP      {r4-r6,pc}
        0x010021ae:    e9d42101    ...!    LDRD     r2,r1,[r4,#4]
        0x010021b2:    2020                MOVS     r0,#0x20
        0x010021b4:    4790        .G      BLX      r2
        0x010021b6:    6a20         j      LDR      r0,[r4,#0x20]
        0x010021b8:    1c40        @.      ADDS     r0,r0,#1
        0x010021ba:    6220         b      STR      r0,[r4,#0x20]
        0x010021bc:    1e6d        m.      SUBS     r5,r5,#1
        0x010021be:    d5f6        ..      BPL      0x10021ae ; _printf_post_padding + 14
        0x010021c0:    bd70        p.      POP      {r4-r6,pc}
        0x010021c2:    0000        ..      MOVS     r0,r0
    .text
    __cpp_initialize__aeabi_
        0x010021c4:    b570        p.      PUSH     {r4-r6,lr}
        0x010021c6:    4c06        .L      LDR      r4,[pc,#24] ; [0x10021e0] = 0x5b24
        0x010021c8:    447c        |D      ADD      r4,r4,pc
        0x010021ca:    4d06        .M      LDR      r5,[pc,#24] ; [0x10021e4] = 0x5b24
        0x010021cc:    447d        }D      ADD      r5,r5,pc
        0x010021ce:    e003        ..      B        0x10021d8 ; __cpp_initialize__aeabi_ + 20
        0x010021d0:    6820         h      LDR      r0,[r4,#0]
        0x010021d2:    4420         D      ADD      r0,r0,r4
        0x010021d4:    4780        .G      BLX      r0
        0x010021d6:    1d24        $.      ADDS     r4,r4,#4
        0x010021d8:    42ac        .B      CMP      r4,r5
        0x010021da:    d1f9        ..      BNE      0x10021d0 ; __cpp_initialize__aeabi_ + 12
        0x010021dc:    bd70        p.      POP      {r4-r6,pc}
    $d
        0x010021de:    0000        ..      DCW    0
        0x010021e0:    00005b24    $[..    DCD    23332
        0x010021e4:    00005b24    $[..    DCD    23332
    $t
    .text
    ferror
        0x010021e8:    7b00        .{      LDRB     r0,[r0,#0xc]
        0x010021ea:    f0000080    ....    AND      r0,r0,#0x80
        0x010021ee:    4770        pG      BX       lr
    i.BusFault_Handler
    BusFault_Handler
        0x010021f0:    e7fe        ..      B        BusFault_Handler ; 0x10021f0
    i.DebugMon_Handler
    DebugMon_Handler
        0x010021f2:    e7fe        ..      B        DebugMon_Handler ; 0x10021f2
    i.MemManage_Handler
    MemManage_Handler
        0x010021f4:    e7fe        ..      B        MemManage_Handler ; 0x10021f4
    i.NMI_Handler
    NMI_Handler
        0x010021f6:    e7fe        ..      B        NMI_Handler ; 0x10021f6
    i.PendSV_Handler
    PendSV_Handler
        0x010021f8:    e7fe        ..      B        PendSV_Handler ; 0x10021f8
    i.SysTick_Handler
    SysTick_Handler
        0x010021fa:    e7fe        ..      B        SysTick_Handler ; 0x10021fa
    i.UsageFault_Handler
    UsageFault_Handler
        0x010021fc:    e7fe        ..      B        UsageFault_Handler ; 0x10021fc
    i._sys_exit
    _sys_exit
        0x010021fe:    4770        pG      BX       lr
    $d.realdata
    .ARM.__AT_0x01002200
    BUILD_IN_APP_INFO
        0x01002200:    47525858    XXRG    DCD    1196578904
        0x01002204:    00000001    ....    DCD    1
        0x01002208:    00005515    .U..    DCD    21781
        0x0100220c:    01002000    . ..    DCD    16785408
        0x01002210:    01002000    . ..    DCD    16785408
        0x01002214:    4952ed6e    n.RI    DCD    1230171502
        0x01002218:    00000101    ....    DCD    257
        0x0100221c:    00000000    ....    DCD    0
        0x01002220:    00000000    ....    DCD    0
        0x01002224:    00000000    ....    DCD    0
        0x01002228:    00000000    ....    DCD    0
        0x0100222c:    00000000    ....    DCD    0
        0x01002230:    00000000    ....    DCD    0
        0x01002234:    00000000    ....    DCD    0
        0x01002238:    00000000    ....    DCD    0
        0x0100223c:    00000000    ....    DCD    0
    $t
    .text
    _printf_hex_common
    _printf_longlong_hex
        0x01002240:    b4f0        ..      PUSH     {r4-r7}
        0x01002242:    460d        .F      MOV      r5,r1
        0x01002244:    8801        ..      LDRH     r1,[r0,#0]
        0x01002246:    0509        ..      LSLS     r1,r1,#20
        0x01002248:    d502        ..      BPL      0x1002250 ; _printf_hex_common + 16
        0x0100224a:    4c21        !L      LDR      r4,[pc,#132] ; [0x10022d0] = 0x5a14
        0x0100224c:    447c        |D      ADD      r4,r4,pc
        0x0100224e:    e002        ..      B        0x1002256 ; _printf_hex_common + 22
        0x01002250:    4c1f        .L      LDR      r4,[pc,#124] ; [0x10022d0] = 0x5a14
        0x01002252:    447c        |D      ADD      r4,r4,pc
        0x01002254:    340e        .4      ADDS     r4,r4,#0xe
        0x01002256:    2100        .!      MOVS     r1,#0
        0x01002258:    f1000624    ..$.    ADD      r6,r0,#0x24
        0x0100225c:    e008        ..      B        0x1002270 ; _printf_hex_common + 48
        0x0100225e:    f002070f    ....    AND      r7,r2,#0xf
        0x01002262:    0912        ..      LSRS     r2,r2,#4
        0x01002264:    5de7        .]      LDRB     r7,[r4,r7]
        0x01002266:    ea427203    B..r    ORR      r2,r2,r3,LSL #28
        0x0100226a:    091b        ..      LSRS     r3,r3,#4
        0x0100226c:    5477        wT      STRB     r7,[r6,r1]
        0x0100226e:    1c49        I.      ADDS     r1,r1,#1
        0x01002270:    ea520703    R...    ORRS     r7,r2,r3
        0x01002274:    d1f3        ..      BNE      0x100225e ; _printf_hex_common + 30
        0x01002276:    7802        .x      LDRB     r2,[r0,#0]
        0x01002278:    2300        .#      MOVS     r3,#0
        0x0100227a:    0712        ..      LSLS     r2,r2,#28
        0x0100227c:    d504        ..      BPL      0x1002288 ; _printf_hex_common + 72
        0x0100227e:    2d70        p-      CMP      r5,#0x70
        0x01002280:    d006        ..      BEQ      0x1002290 ; _printf_hex_common + 80
        0x01002282:    b109        ..      CBZ      r1,0x1002288 ; _printf_hex_common + 72
        0x01002284:    2302        .#      MOVS     r3,#2
        0x01002286:    3411        .4      ADDS     r4,r4,#0x11
        0x01002288:    4622        "F      MOV      r2,r4
        0x0100228a:    bcf0        ..      POP      {r4-r7}
        0x0100228c:    f000b9d2    ....    B.W      _printf_int_common ; 0x1002634
        0x01002290:    2301        .#      MOVS     r3,#1
        0x01002292:    3410        .4      ADDS     r4,r4,#0x10
        0x01002294:    e7f8        ..      B        0x1002288 ; _printf_hex_common + 72
    _printf_int_hex
        0x01002296:    b570        p.      PUSH     {r4-r6,lr}
        0x01002298:    4604        .F      MOV      r4,r0
        0x0100229a:    460d        .F      MOV      r5,r1
        0x0100229c:    4621        !F      MOV      r1,r4
        0x0100229e:    6810        .h      LDR      r0,[r2,#0]
        0x010022a0:    f3af8000    ....    NOP.W    
        0x010022a4:    4602        .F      MOV      r2,r0
        0x010022a6:    4629        )F      MOV      r1,r5
        0x010022a8:    4620         F      MOV      r0,r4
        0x010022aa:    e8bd4070    ..p@    POP      {r4-r6,lr}
        0x010022ae:    2300        .#      MOVS     r3,#0
        0x010022b0:    e7c6        ..      B        _printf_hex_common ; 0x1002240
    _printf_ll_hex
        0x010022b2:    1dd2        ..      ADDS     r2,r2,#7
        0x010022b4:    f0220307    "...    BIC      r3,r2,#7
        0x010022b8:    e9d32300    ...#    LDRD     r2,r3,[r3,#0]
        0x010022bc:    e7c0        ..      B        _printf_hex_common ; 0x1002240
    _printf_hex_ptr
        0x010022be:    6803        .h      LDR      r3,[r0,#0]
        0x010022c0:    6812        .h      LDR      r2,[r2,#0]
        0x010022c2:    f0430320    C. .    ORR      r3,r3,#0x20
        0x010022c6:    6003        .`      STR      r3,[r0,#0]
        0x010022c8:    2308        .#      MOVS     r3,#8
        0x010022ca:    61c3        .a      STR      r3,[r0,#0x1c]
        0x010022cc:    2300        .#      MOVS     r3,#0
        0x010022ce:    e7b7        ..      B        _printf_hex_common ; 0x1002240
    $d
        0x010022d0:    00005a14    .Z..    DCD    23060
    $t
    .text
    __printf
        0x010022d4:    e92d5ff0    -.._    PUSH     {r4-r12,lr}
        0x010022d8:    4689        .F      MOV      r9,r1
        0x010022da:    4604        .F      MOV      r4,r0
        0x010022dc:    f04f0a00    O...    MOV      r10,#0
        0x010022e0:    f8dfb174    ..t.    LDR      r11,[pc,#372] ; [0x1002458] = 0x59a4
        0x010022e4:    44fb        .D      ADD      r11,r11,pc
        0x010022e6:    f8c0a020    .. .    STR      r10,[r0,#0x20]
        0x010022ea:    4620         F      MOV      r0,r4
        0x010022ec:    68e1        .h      LDR      r1,[r4,#0xc]
        0x010022ee:    4788        .G      BLX      r1
        0x010022f0:    2800        .(      CMP      r0,#0
        0x010022f2:    d074        t.      BEQ      0x10023de ; __printf + 266
        0x010022f4:    2825        %(      CMP      r0,#0x25
        0x010022f6:    d006        ..      BEQ      0x1002306 ; __printf + 50
        0x010022f8:    e9d42101    ...!    LDRD     r2,r1,[r4,#4]
        0x010022fc:    4790        .G      BLX      r2
        0x010022fe:    6a20         j      LDR      r0,[r4,#0x20]
        0x01002300:    1c40        @.      ADDS     r0,r0,#1
        0x01002302:    6220         b      STR      r0,[r4,#0x20]
        0x01002304:    e7f1        ..      B        0x10022ea ; __printf + 22
        0x01002306:    2600        .&      MOVS     r6,#0
        0x01002308:    465f        _F      MOV      r7,r11
        0x0100230a:    4620         F      MOV      r0,r4
        0x0100230c:    68e1        .h      LDR      r1,[r4,#0xc]
        0x0100230e:    4788        .G      BLX      r1
        0x01002310:    2820         (      CMP      r0,#0x20
        0x01002312:    4605        .F      MOV      r5,r0
        0x01002314:    db07        ..      BLT      0x1002326 ; __printf + 82
        0x01002316:    2d31        1-      CMP      r5,#0x31
        0x01002318:    d205        ..      BCS      0x1002326 ; __printf + 82
        0x0100231a:    1978        x.      ADDS     r0,r7,r5
        0x0100231c:    f8100c20    .. .    LDRB     r0,[r0,#-0x20]
        0x01002320:    b108        ..      CBZ      r0,0x1002326 ; __printf + 82
        0x01002322:    4306        .C      ORRS     r6,r6,r0
        0x01002324:    e7f1        ..      B        0x100230a ; __printf + 54
        0x01002326:    07b0        ..      LSLS     r0,r6,#30
        0x01002328:    d501        ..      BPL      0x100232e ; __printf + 90
        0x0100232a:    f0260604    &...    BIC      r6,r6,#4
        0x0100232e:    f8c4a01c    ....    STR      r10,[r4,#0x1c]
        0x01002332:    2700        .'      MOVS     r7,#0
        0x01002334:    f8c4a018    ....    STR      r10,[r4,#0x18]
        0x01002338:    2d2a        *-      CMP      r5,#0x2a
        0x0100233a:    d009        ..      BEQ      0x1002350 ; __printf + 124
        0x0100233c:    4628        (F      MOV      r0,r5
        0x0100233e:    f000fbb3    ....    BL       _is_digit ; 0x1002aa8
        0x01002342:    b338        8.      CBZ      r0,0x1002394 ; __printf + 192
        0x01002344:    eb040887    ....    ADD      r8,r4,r7,LSL #2
        0x01002348:    3d30        0=      SUBS     r5,r5,#0x30
        0x0100234a:    f8c85018    ...P    STR      r5,[r8,#0x18]
        0x0100234e:    e019        ..      B        0x1002384 ; __printf + 176
        0x01002350:    f8591b04    Y...    LDR      r1,[r9],#4
        0x01002354:    4620         F      MOV      r0,r4
        0x01002356:    eb040287    ....    ADD      r2,r4,r7,LSL #2
        0x0100235a:    6191        .a      STR      r1,[r2,#0x18]
        0x0100235c:    68e1        .h      LDR      r1,[r4,#0xc]
        0x0100235e:    4788        .G      BLX      r1
        0x01002360:    2f01        ./      CMP      r7,#1
        0x01002362:    4605        .F      MOV      r5,r0
        0x01002364:    d118        ..      BNE      0x1002398 ; __printf + 196
        0x01002366:    69e0        .i      LDR      r0,[r4,#0x1c]
        0x01002368:    2800        .(      CMP      r0,#0
        0x0100236a:    da20         .      BGE      0x10023ae ; __printf + 218
        0x0100236c:    f0260620    &. .    BIC      r6,r6,#0x20
        0x01002370:    e01d        ..      B        0x10023ae ; __printf + 218
        0x01002372:    f8d80018    ....    LDR      r0,[r8,#0x18]
        0x01002376:    eb000080    ....    ADD      r0,r0,r0,LSL #2
        0x0100237a:    eb050040    ..@.    ADD      r0,r5,r0,LSL #1
        0x0100237e:    3830        08      SUBS     r0,r0,#0x30
        0x01002380:    f8c80018    ....    STR      r0,[r8,#0x18]
        0x01002384:    4620         F      MOV      r0,r4
        0x01002386:    68e1        .h      LDR      r1,[r4,#0xc]
        0x01002388:    4788        .G      BLX      r1
        0x0100238a:    4605        .F      MOV      r5,r0
        0x0100238c:    f000fb8c    ....    BL       _is_digit ; 0x1002aa8
        0x01002390:    2800        .(      CMP      r0,#0
        0x01002392:    d1ee        ..      BNE      0x1002372 ; __printf + 158
        0x01002394:    2f01        ./      CMP      r7,#1
        0x01002396:    d00a        ..      BEQ      0x10023ae ; __printf + 218
        0x01002398:    2d2e        .-      CMP      r5,#0x2e
        0x0100239a:    d108        ..      BNE      0x10023ae ; __printf + 218
        0x0100239c:    4620         F      MOV      r0,r4
        0x0100239e:    68e1        .h      LDR      r1,[r4,#0xc]
        0x010023a0:    4788        .G      BLX      r1
        0x010023a2:    1c7f        ..      ADDS     r7,r7,#1
        0x010023a4:    4605        .F      MOV      r5,r0
        0x010023a6:    2f02        ./      CMP      r7,#2
        0x010023a8:    f0460620    F. .    ORR      r6,r6,#0x20
        0x010023ac:    dbc4        ..      BLT      0x1002338 ; __printf + 100
        0x010023ae:    69a0        .i      LDR      r0,[r4,#0x18]
        0x010023b0:    2800        .(      CMP      r0,#0
        0x010023b2:    da03        ..      BGE      0x10023bc ; __printf + 232
        0x010023b4:    4240        @B      RSBS     r0,r0,#0
        0x010023b6:    f0460601    F...    ORR      r6,r6,#1
        0x010023ba:    61a0        .a      STR      r0,[r4,#0x18]
        0x010023bc:    07f0        ..      LSLS     r0,r6,#31
        0x010023be:    d001        ..      BEQ      0x10023c4 ; __printf + 240
        0x010023c0:    f0260610    &...    BIC      r6,r6,#0x10
        0x010023c4:    2d6c        l-      CMP      r5,#0x6c
        0x010023c6:    d00b        ..      BEQ      0x10023e0 ; __printf + 268
        0x010023c8:    2d68        h-      CMP      r5,#0x68
        0x010023ca:    d009        ..      BEQ      0x10023e0 ; __printf + 268
        0x010023cc:    2d4c        L-      CMP      r5,#0x4c
        0x010023ce:    d039        9.      BEQ      0x1002444 ; __printf + 368
        0x010023d0:    2d6a        j-      CMP      r5,#0x6a
        0x010023d2:    d035        5.      BEQ      0x1002440 ; __printf + 364
        0x010023d4:    2d74        t-      CMP      r5,#0x74
        0x010023d6:    d035        5.      BEQ      0x1002444 ; __printf + 368
        0x010023d8:    2d7a        z-      CMP      r5,#0x7a
        0x010023da:    d033        3.      BEQ      0x1002444 ; __printf + 368
        0x010023dc:    e016        ..      B        0x100240c ; __printf + 312
        0x010023de:    e038        8.      B        0x1002452 ; __printf + 382
        0x010023e0:    68e1        .h      LDR      r1,[r4,#0xc]
        0x010023e2:    462f        /F      MOV      r7,r5
        0x010023e4:    4620         F      MOV      r0,r4
        0x010023e6:    4788        .G      BLX      r1
        0x010023e8:    42b8        .B      CMP      r0,r7
        0x010023ea:    4605        .F      MOV      r5,r0
        0x010023ec:    d109        ..      BNE      0x1002402 ; __printf + 302
        0x010023ee:    2f6c        l/      CMP      r7,#0x6c
        0x010023f0:    d026        &.      BEQ      0x1002440 ; __printf + 364
        0x010023f2:    f44f6080    O..`    MOV      r0,#0x400
        0x010023f6:    68e1        .h      LDR      r1,[r4,#0xc]
        0x010023f8:    4306        .C      ORRS     r6,r6,r0
        0x010023fa:    4620         F      MOV      r0,r4
        0x010023fc:    4788        .G      BLX      r1
        0x010023fe:    4605        .F      MOV      r5,r0
        0x01002400:    e004        ..      B        0x100240c ; __printf + 312
        0x01002402:    2f6c        l/      CMP      r7,#0x6c
        0x01002404:    d01a        ..      BEQ      0x100243c ; __printf + 360
        0x01002406:    f44f7080    O..p    MOV      r0,#0x100
        0x0100240a:    4306        .C      ORRS     r6,r6,r0
        0x0100240c:    b30d        ..      CBZ      r5,0x1002452 ; __printf + 382
        0x0100240e:    f1a50041    ..A.    SUB      r0,r5,#0x41
        0x01002412:    2819        .(      CMP      r0,#0x19
        0x01002414:    d802        ..      BHI      0x100241c ; __printf + 328
        0x01002416:    3520         5      ADDS     r5,r5,#0x20
        0x01002418:    f4466600    F..f    ORR      r6,r6,#0x800
        0x0100241c:    464a        JF      MOV      r2,r9
        0x0100241e:    4629        )F      MOV      r1,r5
        0x01002420:    4620         F      MOV      r0,r4
        0x01002422:    6026        &`      STR      r6,[r4,#0]
        0x01002424:    464e        NF      MOV      r6,r9
        0x01002426:    f7fffe73    ..s.    BL       _printf_percent ; 0x1002110
        0x0100242a:    b180        ..      CBZ      r0,0x100244e ; __printf + 378
        0x0100242c:    2801        .(      CMP      r0,#1
        0x0100242e:    d00b        ..      BEQ      0x1002448 ; __printf + 372
        0x01002430:    1df6        ..      ADDS     r6,r6,#7
        0x01002432:    f0260007    &...    BIC      r0,r6,#7
        0x01002436:    f1000908    ....    ADD      r9,r0,#8
        0x0100243a:    e756        V.      B        0x10022ea ; __printf + 22
        0x0100243c:    2040        @       MOVS     r0,#0x40
        0x0100243e:    e7e4        ..      B        0x100240a ; __printf + 310
        0x01002440:    2080        .       MOVS     r0,#0x80
        0x01002442:    e7d8        ..      B        0x10023f6 ; __printf + 290
        0x01002444:    2000        .       MOVS     r0,#0
        0x01002446:    e7d6        ..      B        0x10023f6 ; __printf + 290
        0x01002448:    f1060904    ....    ADD      r9,r6,#4
        0x0100244c:    e74d        M.      B        0x10022ea ; __printf + 22
        0x0100244e:    4628        (F      MOV      r0,r5
        0x01002450:    e752        R.      B        0x10022f8 ; __printf + 36
        0x01002452:    6a20         j      LDR      r0,[r4,#0x20]
        0x01002454:    e8bd9ff0    ....    POP      {r4-r12,pc}
    $d
        0x01002458:    000059a4    .Y..    DCD    22948
    $t
    .text
    memcmp
        0x0100245c:    ea400301    @...    ORR      r3,r0,r1
        0x01002460:    b510        ..      PUSH     {r4,lr}
        0x01002462:    079b        ..      LSLS     r3,r3,#30
        0x01002464:    d10f        ..      BNE      0x1002486 ; memcmp + 42
        0x01002466:    2a04        .*      CMP      r2,#4
        0x01002468:    d30d        ..      BCC      0x1002486 ; memcmp + 42
        0x0100246a:    c810        ..      LDM      r0!,{r4}
        0x0100246c:    c908        ..      LDM      r1!,{r3}
        0x0100246e:    1f12        ..      SUBS     r2,r2,#4
        0x01002470:    429c        .B      CMP      r4,r3
        0x01002472:    d0f8        ..      BEQ      0x1002466 ; memcmp + 10
        0x01002474:    ba20         .      REV      r0,r4
        0x01002476:    ba19        ..      REV      r1,r3
        0x01002478:    4288        .B      CMP      r0,r1
        0x0100247a:    d901        ..      BLS      0x1002480 ; memcmp + 36
        0x0100247c:    2001        .       MOVS     r0,#1
        0x0100247e:    bd10        ..      POP      {r4,pc}
        0x01002480:    f04f30ff    O..0    MOV      r0,#0xffffffff
        0x01002484:    bd10        ..      POP      {r4,pc}
        0x01002486:    b11a        ..      CBZ      r2,0x1002490 ; memcmp + 52
        0x01002488:    07d3        ..      LSLS     r3,r2,#31
        0x0100248a:    d003        ..      BEQ      0x1002494 ; memcmp + 56
        0x0100248c:    1c52        R.      ADDS     r2,r2,#1
        0x0100248e:    e007        ..      B        0x10024a0 ; memcmp + 68
        0x01002490:    2000        .       MOVS     r0,#0
        0x01002492:    bd10        ..      POP      {r4,pc}
        0x01002494:    f8103b01    ...;    LDRB     r3,[r0],#1
        0x01002498:    f8114b01    ...K    LDRB     r4,[r1],#1
        0x0100249c:    1b1b        ..      SUBS     r3,r3,r4
        0x0100249e:    d107        ..      BNE      0x10024b0 ; memcmp + 84
        0x010024a0:    f8103b01    ...;    LDRB     r3,[r0],#1
        0x010024a4:    f8114b01    ...K    LDRB     r4,[r1],#1
        0x010024a8:    1b1b        ..      SUBS     r3,r3,r4
        0x010024aa:    d101        ..      BNE      0x10024b0 ; memcmp + 84
        0x010024ac:    1e92        ..      SUBS     r2,r2,#2
        0x010024ae:    d1f1        ..      BNE      0x1002494 ; memcmp + 56
        0x010024b0:    4618        .F      MOV      r0,r3
        0x010024b2:    bd10        ..      POP      {r4,pc}
    .text
    __aeabi_memcpy
    __rt_memcpy
        0x010024b4:    2a03        .*      CMP      r2,#3
        0x010024b6:    f2408030    @.0.    BLS.W    _memcpy_lastbytes ; 0x100251a
        0x010024ba:    f0100c03    ....    ANDS     r12,r0,#3
        0x010024be:    f0008015    ....    BEQ.W    0x10024ec ; __aeabi_memcpy + 56
        0x010024c2:    f8113b01    ...;    LDRB     r3,[r1],#1
        0x010024c6:    f1bc0f02    ....    CMP      r12,#2
        0x010024ca:    4462        bD      ADD      r2,r2,r12
        0x010024cc:    bf98        ..      IT       LS
        0x010024ce:    f811cb01    ....    LDRBLS   r12,[r1],#1
        0x010024d2:    f8003b01    ...;    STRB     r3,[r0],#1
        0x010024d6:    bf38        8.      IT       CC
        0x010024d8:    f8113b01    ...;    LDRBCC   r3,[r1],#1
        0x010024dc:    f1a20204    ....    SUB      r2,r2,#4
        0x010024e0:    bf98        ..      IT       LS
        0x010024e2:    f800cb01    ....    STRBLS   r12,[r0],#1
        0x010024e6:    bf38        8.      IT       CC
        0x010024e8:    f8003b01    ...;    STRBCC   r3,[r0],#1
        0x010024ec:    f0110303    ....    ANDS     r3,r1,#3
        0x010024f0:    f0008025    ..%.    BEQ.W    __aeabi_memcpy4 ; 0x100253e
        0x010024f4:    3a08        .:      SUBS     r2,r2,#8
        0x010024f6:    f0c08008    ....    BCC.W    0x100250a ; __aeabi_memcpy + 86
        0x010024fa:    f8513b04    Q..;    LDR      r3,[r1],#4
        0x010024fe:    3a08        .:      SUBS     r2,r2,#8
        0x01002500:    f851cb04    Q...    LDR      r12,[r1],#4
        0x01002504:    e8a01008    ....    STM      r0!,{r3,r12}
        0x01002508:    e7f5        ..      B        0x10024f6 ; __aeabi_memcpy + 66
        0x0100250a:    1d12        ..      ADDS     r2,r2,#4
        0x0100250c:    bf5c        \.      ITT      PL
        0x0100250e:    f8513b04    Q..;    LDRPL    r3,[r1],#4
        0x01002512:    f8403b04    @..;    STRPL    r3,[r0],#4
        0x01002516:    f3af8000    ....    NOP.W    
    _memcpy_lastbytes
        0x0100251a:    07d2        ..      LSLS     r2,r2,#31
        0x0100251c:    bf24        $.      ITT      CS
        0x0100251e:    f8113b01    ...;    LDRBCS   r3,[r1],#1
        0x01002522:    f811cb01    ....    LDRBCS   r12,[r1],#1
        0x01002526:    bf48        H.      IT       MI
        0x01002528:    f8112b01    ...+    LDRBMI   r2,[r1],#1
        0x0100252c:    bf24        $.      ITT      CS
        0x0100252e:    f8003b01    ...;    STRBCS   r3,[r0],#1
        0x01002532:    f800cb01    ....    STRBCS   r12,[r0],#1
        0x01002536:    bf48        H.      IT       MI
        0x01002538:    f8002b01    ...+    STRBMI   r2,[r0],#1
        0x0100253c:    4770        pG      BX       lr
    .text
    __aeabi_memcpy4
    __aeabi_memcpy8
    __rt_memcpy_w
        0x0100253e:    b510        ..      PUSH     {r4,lr}
        0x01002540:    3a20         :      SUBS     r2,r2,#0x20
        0x01002542:    f0c0800b    ....    BCC.W    0x100255c ; __aeabi_memcpy4 + 30
        0x01002546:    e8b15018    ...P    LDM      r1!,{r3,r4,r12,lr}
        0x0100254a:    3a20         :      SUBS     r2,r2,#0x20
        0x0100254c:    e8a05018    ...P    STM      r0!,{r3,r4,r12,lr}
        0x01002550:    e8b15018    ...P    LDM      r1!,{r3,r4,r12,lr}
        0x01002554:    e8a05018    ...P    STM      r0!,{r3,r4,r12,lr}
        0x01002558:    f4bfaff5    ....    BCS.W    0x1002546 ; __aeabi_memcpy4 + 8
        0x0100255c:    ea5f7c02    _..|    LSLS     r12,r2,#28
        0x01002560:    bf24        $.      ITT      CS
        0x01002562:    e8b15018    ...P    LDMCS    r1!,{r3,r4,r12,lr}
        0x01002566:    e8a05018    ...P    STMCS    r0!,{r3,r4,r12,lr}
        0x0100256a:    bf44        D.      ITT      MI
        0x0100256c:    c918        ..      LDMMI    r1!,{r3,r4}
        0x0100256e:    c018        ..      STMMI    r0!,{r3,r4}
        0x01002570:    e8bd4010    ...@    POP      {r4,lr}
        0x01002574:    ea5f7c82    _..|    LSLS     r12,r2,#30
        0x01002578:    bf24        $.      ITT      CS
        0x0100257a:    f8513b04    Q..;    LDRCS    r3,[r1],#4
        0x0100257e:    f8403b04    @..;    STRCS    r3,[r0],#4
        0x01002582:    bf08        ..      IT       EQ
        0x01002584:    4770        pG      BXEQ     lr
    _memcpy_lastbytes_aligned
        0x01002586:    07d2        ..      LSLS     r2,r2,#31
        0x01002588:    bf28        (.      IT       CS
        0x0100258a:    f8313b02    1..;    LDRHCS   r3,[r1],#2
        0x0100258e:    bf48        H.      IT       MI
        0x01002590:    f8112b01    ...+    LDRBMI   r2,[r1],#1
        0x01002594:    bf28        (.      IT       CS
        0x01002596:    f8203b02     ..;    STRHCS   r3,[r0],#2
        0x0100259a:    bf48        H.      IT       MI
        0x0100259c:    f8002b01    ...+    STRBMI   r2,[r0],#1
        0x010025a0:    4770        pG      BX       lr
    .text
    __aeabi_memclr
    __rt_memclr
        0x010025a2:    f04f0200    O...    MOV      r2,#0
    _memset
        0x010025a6:    2904        .)      CMP      r1,#4
        0x010025a8:    f0c08012    ....    BCC.W    0x10025d0 ; _memset + 42
        0x010025ac:    f0100c03    ....    ANDS     r12,r0,#3
        0x010025b0:    f000801b    ....    BEQ.W    _memset_w ; 0x10025ea
        0x010025b4:    f1cc0c04    ....    RSB      r12,r12,#4
        0x010025b8:    f1bc0f02    ....    CMP      r12,#2
        0x010025bc:    bf18        ..      IT       NE
        0x010025be:    f8002b01    ...+    STRBNE   r2,[r0],#1
        0x010025c2:    bfa8        ..      IT       GE
        0x010025c4:    f8202b02     ..+    STRHGE   r2,[r0],#2
        0x010025c8:    eba1010c    ....    SUB      r1,r1,r12
        0x010025cc:    f000b80d    ....    B.W      _memset_w ; 0x10025ea
        0x010025d0:    ea5f7cc1    _..|    LSLS     r12,r1,#31
        0x010025d4:    bf24        $.      ITT      CS
        0x010025d6:    f8002b01    ...+    STRBCS   r2,[r0],#1
        0x010025da:    f8002b01    ...+    STRBCS   r2,[r0],#1
        0x010025de:    bf48        H.      IT       MI
        0x010025e0:    f8002b01    ...+    STRBMI   r2,[r0],#1
        0x010025e4:    4770        pG      BX       lr
    .text
    __aeabi_memclr4
    __aeabi_memclr8
    __rt_memclr_w
        0x010025e6:    f04f0200    O...    MOV      r2,#0
    _memset_w
        0x010025ea:    b500        ..      PUSH     {lr}
        0x010025ec:    4613        .F      MOV      r3,r2
        0x010025ee:    4694        .F      MOV      r12,r2
        0x010025f0:    4696        .F      MOV      lr,r2
        0x010025f2:    3920         9      SUBS     r1,r1,#0x20
        0x010025f4:    bf22        ".      ITTT     CS
        0x010025f6:    e8a0500c    ...P    STMCS    r0!,{r2,r3,r12,lr}
        0x010025fa:    e8a0500c    ...P    STMCS    r0!,{r2,r3,r12,lr}
        0x010025fe:    f1b10120    .. .    SUBSCS   r1,r1,#0x20
        0x01002602:    f4bfaff7    ....    BCS.W    0x10025f4 ; _memset_w + 10
        0x01002606:    0709        ..      LSLS     r1,r1,#28
        0x01002608:    bf28        (.      IT       CS
        0x0100260a:    e8a0500c    ...P    STMCS    r0!,{r2,r3,r12,lr}
        0x0100260e:    bf48        H.      IT       MI
        0x01002610:    c00c        ..      STMMI    r0!,{r2,r3}
        0x01002612:    f85deb04    ]...    POP      {lr}
        0x01002616:    0089        ..      LSLS     r1,r1,#2
        0x01002618:    bf28        (.      IT       CS
        0x0100261a:    f8402b04    @..+    STRCS    r2,[r0],#4
        0x0100261e:    bf08        ..      IT       EQ
        0x01002620:    4770        pG      BXEQ     lr
        0x01002622:    bf48        H.      IT       MI
        0x01002624:    f8202b02     ..+    STRHMI   r2,[r0],#2
        0x01002628:    f0114f80    ...O    TST      r1,#0x40000000
        0x0100262c:    bf18        ..      IT       NE
        0x0100262e:    f8002b01    ...+    STRBNE   r2,[r0],#1
        0x01002632:    4770        pG      BX       lr
    .text
    _printf_int_common
        0x01002634:    e92d47f0    -..G    PUSH     {r4-r10,lr}
        0x01002638:    460d        .F      MOV      r5,r1
        0x0100263a:    4699        .F      MOV      r9,r3
        0x0100263c:    4692        .F      MOV      r10,r2
        0x0100263e:    4604        .F      MOV      r4,r0
        0x01002640:    f1000824    ..$.    ADD      r8,r0,#0x24
        0x01002644:    6801        .h      LDR      r1,[r0,#0]
        0x01002646:    0688        ..      LSLS     r0,r1,#26
        0x01002648:    d504        ..      BPL      0x1002654 ; _printf_int_common + 32
        0x0100264a:    69e0        .i      LDR      r0,[r4,#0x1c]
        0x0100264c:    f0210110    !...    BIC      r1,r1,#0x10
        0x01002650:    6021        !`      STR      r1,[r4,#0]
        0x01002652:    e000        ..      B        0x1002656 ; _printf_int_common + 34
        0x01002654:    2001        .       MOVS     r0,#1
        0x01002656:    42a8        .B      CMP      r0,r5
        0x01002658:    dd01        ..      BLE      0x100265e ; _printf_int_common + 42
        0x0100265a:    1b47        G.      SUBS     r7,r0,r5
        0x0100265c:    e000        ..      B        0x1002660 ; _printf_int_common + 44
        0x0100265e:    2700        .'      MOVS     r7,#0
        0x01002660:    69a1        .i      LDR      r1,[r4,#0x18]
        0x01002662:    197a        z.      ADDS     r2,r7,r5
        0x01002664:    eb020009    ....    ADD      r0,r2,r9
        0x01002668:    1a08        ..      SUBS     r0,r1,r0
        0x0100266a:    61a0        .a      STR      r0,[r4,#0x18]
        0x0100266c:    7820         x      LDRB     r0,[r4,#0]
        0x0100266e:    06c0        ..      LSLS     r0,r0,#27
        0x01002670:    d402        ..      BMI      0x1002678 ; _printf_int_common + 68
        0x01002672:    4620         F      MOV      r0,r4
        0x01002674:    f7fffd7e    ..~.    BL       _printf_pre_padding ; 0x1002174
        0x01002678:    2600        .&      MOVS     r6,#0
        0x0100267a:    e008        ..      B        0x100268e ; _printf_int_common + 90
        0x0100267c:    e9d42101    ...!    LDRD     r2,r1,[r4,#4]
        0x01002680:    f81a0006    ....    LDRB     r0,[r10,r6]
        0x01002684:    4790        .G      BLX      r2
        0x01002686:    6a20         j      LDR      r0,[r4,#0x20]
        0x01002688:    1c40        @.      ADDS     r0,r0,#1
        0x0100268a:    1c76        v.      ADDS     r6,r6,#1
        0x0100268c:    6220         b      STR      r0,[r4,#0x20]
        0x0100268e:    454e        NE      CMP      r6,r9
        0x01002690:    dbf4        ..      BLT      0x100267c ; _printf_int_common + 72
        0x01002692:    7820         x      LDRB     r0,[r4,#0]
        0x01002694:    06c0        ..      LSLS     r0,r0,#27
        0x01002696:    d50a        ..      BPL      0x10026ae ; _printf_int_common + 122
        0x01002698:    4620         F      MOV      r0,r4
        0x0100269a:    f7fffd6b    ..k.    BL       _printf_pre_padding ; 0x1002174
        0x0100269e:    e006        ..      B        0x10026ae ; _printf_int_common + 122
        0x010026a0:    e9d42101    ...!    LDRD     r2,r1,[r4,#4]
        0x010026a4:    2030        0       MOVS     r0,#0x30
        0x010026a6:    4790        .G      BLX      r2
        0x010026a8:    6a20         j      LDR      r0,[r4,#0x20]
        0x010026aa:    1c40        @.      ADDS     r0,r0,#1
        0x010026ac:    6220         b      STR      r0,[r4,#0x20]
        0x010026ae:    1e38        8.      SUBS     r0,r7,#0
        0x010026b0:    f1a70701    ....    SUB      r7,r7,#1
        0x010026b4:    dcf4        ..      BGT      0x10026a0 ; _printf_int_common + 108
        0x010026b6:    e007        ..      B        0x10026c8 ; _printf_int_common + 148
        0x010026b8:    e9d42101    ...!    LDRD     r2,r1,[r4,#4]
        0x010026bc:    f8180005    ....    LDRB     r0,[r8,r5]
        0x010026c0:    4790        .G      BLX      r2
        0x010026c2:    6a20         j      LDR      r0,[r4,#0x20]
        0x010026c4:    1c40        @.      ADDS     r0,r0,#1
        0x010026c6:    6220         b      STR      r0,[r4,#0x20]
        0x010026c8:    1e28        (.      SUBS     r0,r5,#0
        0x010026ca:    f1a50501    ....    SUB      r5,r5,#1
        0x010026ce:    dcf3        ..      BGT      0x10026b8 ; _printf_int_common + 132
        0x010026d0:    4620         F      MOV      r0,r4
        0x010026d2:    f7fffd65    ..e.    BL       _printf_post_padding ; 0x10021a0
        0x010026d6:    7820         x      LDRB     r0,[r4,#0]
        0x010026d8:    0600        ..      LSLS     r0,r0,#24
        0x010026da:    d502        ..      BPL      0x10026e2 ; _printf_int_common + 174
        0x010026dc:    2002        .       MOVS     r0,#2
        0x010026de:    e8bd87f0    ....    POP      {r4-r10,pc}
        0x010026e2:    2001        .       MOVS     r0,#1
        0x010026e4:    e7fb        ..      B        0x10026de ; _printf_int_common + 170
        0x010026e6:    0000        ..      MOVS     r0,r0
    .text
    _printf_input_char
        0x010026e8:    6901        .i      LDR      r1,[r0,#0x10]
        0x010026ea:    1c4a        J.      ADDS     r2,r1,#1
        0x010026ec:    6102        .a      STR      r2,[r0,#0x10]
        0x010026ee:    7808        .x      LDRB     r0,[r1,#0]
        0x010026f0:    4770        pG      BX       lr
    _printf_char_common
        0x010026f2:    b500        ..      PUSH     {lr}
        0x010026f4:    b08f        ..      SUB      sp,sp,#0x3c
        0x010026f6:    e9cd3101    ...1    STRD     r3,r1,[sp,#4]
        0x010026fa:    2100        .!      MOVS     r1,#0
        0x010026fc:    9105        ..      STR      r1,[sp,#0x14]
        0x010026fe:    4905        .I      LDR      r1,[pc,#20] ; [0x1002714] = 0xffffffe5
        0x01002700:    4479        yD      ADD      r1,r1,pc
        0x01002702:    e9cd1003    ....    STRD     r1,r0,[sp,#0xc]
        0x01002706:    4611        .F      MOV      r1,r2
        0x01002708:    4668        hF      MOV      r0,sp
        0x0100270a:    f7fffde3    ....    BL       __printf ; 0x10022d4
        0x0100270e:    b00f        ..      ADD      sp,sp,#0x3c
        0x01002710:    bd00        ..      POP      {pc}
    $d
        0x01002712:    0000        ..      DCW    0
        0x01002714:    ffffffe5    ....    DCD    4294967269
    $t
    .text
    _printf_char_file
        0x01002718:    4b07        .K      LDR      r3,[pc,#28] ; [0x1002738] = 0x1527
        0x0100271a:    b570        p.      PUSH     {r4-r6,lr}
        0x0100271c:    460d        .F      MOV      r5,r1
        0x0100271e:    447b        {D      ADD      r3,r3,pc
        0x01002720:    f7ffffe7    ....    BL       _printf_char_common ; 0x10026f2
        0x01002724:    4604        .F      MOV      r4,r0
        0x01002726:    4628        (F      MOV      r0,r5
        0x01002728:    f7fffd5e    ..^.    BL       ferror ; 0x10021e8
        0x0100272c:    b110        ..      CBZ      r0,0x1002734 ; _printf_char_file + 28
        0x0100272e:    f04f30ff    O..0    MOV      r0,#0xffffffff
        0x01002732:    bd70        p.      POP      {r4-r6,pc}
        0x01002734:    4620         F      MOV      r0,r4
        0x01002736:    bd70        p.      POP      {r4-r6,pc}
    $d
        0x01002738:    00001527    '...    DCD    5415
    $t
    .text
    exit
        0x0100273c:    b510        ..      PUSH     {r4,lr}
        0x0100273e:    4604        .F      MOV      r4,r0
        0x01002740:    f3af8000    ....    NOP.W    
        0x01002744:    4620         F      MOV      r0,r4
        0x01002746:    e8bd4010    ...@    POP      {r4,lr}
        0x0100274a:    f7ffbcf9    ....    B.W      __rt_exit ; 0x1002140
        0x0100274e:    0000        ..      MOVS     r0,r0
    i.BLESLP_Handler_without_stack_init
    BLESLP_Handler_without_stack_init
        0x01002750:    b510        ..      PUSH     {r4,lr}
        0x01002752:    481e        .H      LDR      r0,[pc,#120] ; [0x10027cc] = 0x802460
        0x01002754:    6800        .h      LDR      r0,[r0,#0]
        0x01002756:    2800        .(      CMP      r0,#0
        0x01002758:    d000        ..      BEQ      0x100275c ; BLESLP_Handler_without_stack_init + 12
        0x0100275a:    4780        .G      BLX      r0
        0x0100275c:    481c        .H      LDR      r0,[pc,#112] ; [0x10027d0] = 0x30006980
        0x0100275e:    2100        .!      MOVS     r1,#0
        0x01002760:    7001        .p      STRB     r1,[r0,#0]
        0x01002762:    1e88        ..      SUBS     r0,r1,#2
        0x01002764:    491b        .I      LDR      r1,[pc,#108] ; [0x10027d4] = 0xa000c544
        0x01002766:    6008        .`      STR      r0,[r1,#0]
        0x01002768:    2019        .       MOVS     r0,#0x19
        0x0100276a:    f000f903    ....    BL       __NVIC_ClearPendingIRQ ; 0x1002974
        0x0100276e:    4c1a        .L      LDR      r4,[pc,#104] ; [0x10027d8] = 0xa000e000
        0x01002770:    f8d402c0    ....    LDR      r0,[r4,#0x2c0]
        0x01002774:    0780        ..      LSLS     r0,r0,#30
        0x01002776:    d404        ..      BMI      0x1002782 ; BLESLP_Handler_without_stack_init + 50
        0x01002778:    22f4        ."      MOVS     r2,#0xf4
        0x0100277a:    a118        ..      ADR      r1,{pc}+0x62 ; 0x10027dc
        0x0100277c:    a01c        ..      ADR      r0,{pc}+0x74 ; 0x10027f0
        0x0100277e:    f403f613    ....    BL       $Ven$TT$S$$assert_err ; 0x8063a8
        0x01002782:    482a        *H      LDR      r0,[pc,#168] ; [0x100282c] = 0x802454
        0x01002784:    6801        .h      LDR      r1,[r0,#0]
        0x01002786:    f8d402c4    ....    LDR      r0,[r4,#0x2c4]
        0x0100278a:    f361301d    a..0    BFI      r0,r1,#12,#18
        0x0100278e:    f0400001    @...    ORR      r0,r0,#1
        0x01002792:    f8c402c4    ....    STR      r0,[r4,#0x2c4]
        0x01002796:    f403f169    ..i.    BL       ble_wait_for_core_wakeup_stat ; 0x805a6c
        0x0100279a:    2100        .!      MOVS     r1,#0
        0x0100279c:    f04f4030    O.0@    MOV      r0,#0xb0000000
        0x010027a0:    60c1        .`      STR      r1,[r0,#0xc]
        0x010027a2:    6181        .a      STR      r1,[r0,#0x18]
        0x010027a4:    17c1        ..      ASRS     r1,r0,#31
        0x010027a6:    6141        Aa      STR      r1,[r0,#0x14]
        0x010027a8:    6201        .b      STR      r1,[r0,#0x20]
        0x010027aa:    f403f11b    ....    BL       ble_wakup_time_check ; 0x8059e4
        0x010027ae:    4809        .H      LDR      r0,[pc,#36] ; [0x10027d4] = 0xa000c544
        0x010027b0:    3840        @8      SUBS     r0,r0,#0x40
        0x010027b2:    6801        .h      LDR      r1,[r0,#0]
        0x010027b4:    f4210180    !...    BIC      r1,r1,#0x400000
        0x010027b8:    6001        .`      STR      r1,[r0,#0]
        0x010027ba:    481d        .H      LDR      r0,[pc,#116] ; [0x1002830] = 0x802464
        0x010027bc:    6800        .h      LDR      r0,[r0,#0]
        0x010027be:    2800        .(      CMP      r0,#0
        0x010027c0:    d002        ..      BEQ      0x10027c8 ; BLESLP_Handler_without_stack_init + 120
        0x010027c2:    e8bd4010    ...@    POP      {r4,lr}
        0x010027c6:    4700        .G      BX       r0
        0x010027c8:    bd10        ..      POP      {r4,pc}
    $d
        0x010027ca:    0000        ..      DCW    0
        0x010027cc:    00802460    `$..    DCD    8397920
        0x010027d0:    30006980    .i.0    DCD    805333376
        0x010027d4:    a000c544    D...    DCD    2684405060
        0x010027d8:    a000e000    ....    DCD    2684411904
        0x010027dc:    70697772    rwip    DCD    1885960050
        0x010027e0:    656c735f    _sle    DCD    1701606239
        0x010027e4:    635f7065    ep_c    DCD    1667199077
        0x010027e8:    6f6d6d6f    ommo    DCD    1869442415
        0x010027ec:    00632e6e    n.c.    DCD    6499950
        0x010027f0:    5f55434d    MCU_    DCD    1599423309
        0x010027f4:    2d425553    SUB-    DCD    759321939
        0x010027f8:    454c423e    >BLE    DCD    1162625598
        0x010027fc:    4c53445f    _DSL    DCD    1280525407
        0x01002800:    5f504545    EEP_    DCD    1599096133
        0x01002804:    52524f43    CORR    DCD    1381125955
        0x01002808:    204e455f    _EN     DCD    542000479
        0x0100280c:    434d2026    & MC    DCD    1129127974
        0x01002810:    55535f55    U_SU    DCD    1431527253
        0x01002814:    4c425f42    B_BL    DCD    1279418178
        0x01002818:    53445f45    E_DS    DCD    1396989765
        0x0100281c:    5045454c    LEEP    DCD    1346717004
        0x01002820:    524f435f    _COR    DCD    1380926303
        0x01002824:    57485f52    R_HW    DCD    1464360786
        0x01002828:    004e455f    _EN.    DCD    5129567
        0x0100282c:    00802454    T$..    DCD    8397908
        0x01002830:    00802464    d$..    DCD    8397924
    $t
    i.BLE_IRQ_Handler_without_stack_init
    BLE_IRQ_Handler_without_stack_init
        0x01002834:    b510        ..      PUSH     {r4,lr}
        0x01002836:    2100        .!      MOVS     r1,#0
        0x01002838:    f04f4030    O.0@    MOV      r0,#0xb0000000
        0x0100283c:    60c1        .`      STR      r1,[r0,#0xc]
        0x0100283e:    6181        .a      STR      r1,[r0,#0x18]
        0x01002840:    17c1        ..      ASRS     r1,r0,#31
        0x01002842:    6141        Aa      STR      r1,[r0,#0x14]
        0x01002844:    6201        .b      STR      r1,[r0,#0x20]
        0x01002846:    2002        .       MOVS     r0,#2
        0x01002848:    f000f8b2    ....    BL       __NVIC_DisableIRQ ; 0x10029b0
        0x0100284c:    e8bd4010    ...@    POP      {r4,lr}
        0x01002850:    2001        .       MOVS     r0,#1
        0x01002852:    f000b8ad    ....    B.W      __NVIC_DisableIRQ ; 0x10029b0
    i.BLE_SDK_IRQ_Handler_without_stack_init
    BLE_SDK_IRQ_Handler_without_stack_init
        0x01002856:    b510        ..      PUSH     {r4,lr}
        0x01002858:    2001        .       MOVS     r0,#1
        0x0100285a:    f000f88b    ....    BL       __NVIC_ClearPendingIRQ ; 0x1002974
        0x0100285e:    e8bd4010    ...@    POP      {r4,lr}
        0x01002862:    2001        .       MOVS     r0,#1
        0x01002864:    f000b8a4    ....    B.W      __NVIC_DisableIRQ ; 0x10029b0
    i.NVIC_EncodePriority
    NVIC_EncodePriority
        0x01002868:    b530        0.      PUSH     {r4,r5,lr}
        0x0100286a:    f0000307    ....    AND      r3,r0,#7
        0x0100286e:    f1c30407    ....    RSB      r4,r3,#7
        0x01002872:    2c08        .,      CMP      r4,#8
        0x01002874:    d900        ..      BLS      0x1002878 ; NVIC_EncodePriority + 16
        0x01002876:    2408        .$      MOVS     r4,#8
        0x01002878:    f1030008    ....    ADD      r0,r3,#8
        0x0100287c:    2807        .(      CMP      r0,#7
        0x0100287e:    d201        ..      BCS      0x1002884 ; NVIC_EncodePriority + 28
        0x01002880:    2300        .#      MOVS     r3,#0
        0x01002882:    e000        ..      B        0x1002886 ; NVIC_EncodePriority + 30
        0x01002884:    1c5b        [.      ADDS     r3,r3,#1
        0x01002886:    2501        .%      MOVS     r5,#1
        0x01002888:    fa05f004    ....    LSL      r0,r5,r4
        0x0100288c:    1e40        @.      SUBS     r0,r0,#1
        0x0100288e:    4008        .@      ANDS     r0,r0,r1
        0x01002890:    4098        .@      LSLS     r0,r0,r3
        0x01002892:    409d        .@      LSLS     r5,r5,r3
        0x01002894:    1e6d        m.      SUBS     r5,r5,#1
        0x01002896:    4015        .@      ANDS     r5,r5,r2
        0x01002898:    4328        (C      ORRS     r0,r0,r5
        0x0100289a:    bd30        0.      POP      {r4,r5,pc}
    i.SystemCoreGetClock
    SystemCoreGetClock
        0x0100289c:    4902        .I      LDR      r1,[pc,#8] ; [0x10028a8] = 0xa000c504
        0x0100289e:    6809        .h      LDR      r1,[r1,#0]
        0x010028a0:    f0010107    ....    AND      r1,r1,#7
        0x010028a4:    7001        .p      STRB     r1,[r0,#0]
        0x010028a6:    4770        pG      BX       lr
    $d
        0x010028a8:    a000c504    ....    DCD    2684404996
    $t
    i.SystemCoreSetClock
    SystemCoreSetClock
        0x010028ac:    b430        0.      PUSH     {r4,r5}
        0x010028ae:    2806        .(      CMP      r0,#6
        0x010028b0:    d221        !.      BCS      0x10028f6 ; SystemCoreSetClock + 74
        0x010028b2:    4912        .I      LDR      r1,[pc,#72] ; [0x10028fc] = 0xa000c504
        0x010028b4:    680a        .h      LDR      r2,[r1,#0]
        0x010028b6:    f0020207    ....    AND      r2,r2,#7
        0x010028ba:    4282        .B      CMP      r2,r0
        0x010028bc:    d012        ..      BEQ      0x10028e4 ; SystemCoreSetClock + 56
        0x010028be:    680a        .h      LDR      r2,[r1,#0]
        0x010028c0:    4b0f        .K      LDR      r3,[pc,#60] ; [0x1002900] = 0xffe3fff8
        0x010028c2:    401a        .@      ANDS     r2,r2,r3
        0x010028c4:    4c0f        .L      LDR      r4,[pc,#60] ; [0x1002904] = 0x80005
        0x010028c6:    4322        "C      ORRS     r2,r2,r4
        0x010028c8:    600a        .`      STR      r2,[r1,#0]
        0x010028ca:    bf00        ..      NOP      
        0x010028cc:    bf00        ..      NOP      
        0x010028ce:    bf00        ..      NOP      
        0x010028d0:    bf00        ..      NOP      
        0x010028d2:    680a        .h      LDR      r2,[r1,#0]
        0x010028d4:    401a        .@      ANDS     r2,r2,r3
        0x010028d6:    4b0c        .K      LDR      r3,[pc,#48] ; [0x1002908] = 0x1007b00
        0x010028d8:    4302        .C      ORRS     r2,r2,r0
        0x010028da:    f8333020    3. 0    LDRH     r3,[r3,r0,LSL #2]
        0x010028de:    ea424283    B..B    ORR      r2,r2,r3,LSL #18
        0x010028e2:    600a        .`      STR      r2,[r1,#0]
        0x010028e4:    4908        .I      LDR      r1,[pc,#32] ; [0x1002908] = 0x1007b00
        0x010028e6:    3918        .9      SUBS     r1,r1,#0x18
        0x010028e8:    f8510020    Q. .    LDR      r0,[r1,r0,LSL #2]
        0x010028ec:    4907        .I      LDR      r1,[pc,#28] ; [0x100290c] = 0x30006400
        0x010028ee:    6088        .`      STR      r0,[r1,#8]
        0x010028f0:    bc30        0.      POP      {r4,r5}
        0x010028f2:    f476937f    v...    B        pwr_mgmt_update_wkup_param ; 0x78ff4
        0x010028f6:    bc30        0.      POP      {r4,r5}
        0x010028f8:    4770        pG      BX       lr
    $d
        0x010028fa:    0000        ..      DCW    0
        0x010028fc:    a000c504    ....    DCD    2684404996
        0x01002900:    ffe3fff8    ....    DCD    4293132280
        0x01002904:    00080005    ....    DCD    524293
        0x01002908:    01007b00    .{..    DCD    16808704
        0x0100290c:    30006400    .d.0    DCD    805331968
    $t
    i.SystemInit
    SystemInit
        0x01002910:    4802        .H      LDR      r0,[pc,#8] ; [0x100291c] = 0xe000ed88
        0x01002912:    6801        .h      LDR      r1,[r0,#0]
        0x01002914:    f4410170    A.p.    ORR      r1,r1,#0xf00000
        0x01002918:    6001        .`      STR      r1,[r0,#0]
        0x0100291a:    4770        pG      BX       lr
    $d
        0x0100291c:    e000ed88    ....    DCD    3758157192
    $t
    i.UART0_IRQHandler
    UART0_IRQHandler
        0x01002920:    4802        .H      LDR      r0,[pc,#8] ; [0x100292c] = 0x300065cc
        0x01002922:    6800        .h      LDR      r0,[r0,#0]
        0x01002924:    1d00        ..      ADDS     r0,r0,#4
        0x01002926:    f41e9697    ....    B        hal_uart_irq_handler ; 0x21658
    $d
        0x0100292a:    0000        ..      DCW    0
        0x0100292c:    300065cc    .e.0    DCD    805332428
    $t
    i.UART1_IRQHandler
    UART1_IRQHandler
        0x01002930:    4802        .H      LDR      r0,[pc,#8] ; [0x100293c] = 0x300065cc
        0x01002932:    6840        @h      LDR      r0,[r0,#4]
        0x01002934:    1d00        ..      ADDS     r0,r0,#4
        0x01002936:    f41e968f    ....    B        hal_uart_irq_handler ; 0x21658
    $d
        0x0100293a:    0000        ..      DCW    0
        0x0100293c:    300065cc    .e.0    DCD    805332428
    $t
    i.__NVIC_ClearPendingIRQ
    __NVIC_ClearPendingIRQ
        0x01002940:    2800        .(      CMP      r0,#0
        0x01002942:    db09        ..      BLT      0x1002958 ; __NVIC_ClearPendingIRQ + 24
        0x01002944:    f000021f    ....    AND      r2,r0,#0x1f
        0x01002948:    2101        .!      MOVS     r1,#1
        0x0100294a:    4091        .@      LSLS     r1,r1,r2
        0x0100294c:    0940        @.      LSRS     r0,r0,#5
        0x0100294e:    0080        ..      LSLS     r0,r0,#2
        0x01002950:    f10020e0    ...     ADD      r0,r0,#0xe000e000
        0x01002954:    f8c01280    ....    STR      r1,[r0,#0x280]
        0x01002958:    4770        pG      BX       lr
    i.__NVIC_ClearPendingIRQ
    __NVIC_ClearPendingIRQ
        0x0100295a:    2800        .(      CMP      r0,#0
        0x0100295c:    db09        ..      BLT      0x1002972 ; __NVIC_ClearPendingIRQ + 24
        0x0100295e:    f000021f    ....    AND      r2,r0,#0x1f
        0x01002962:    2101        .!      MOVS     r1,#1
        0x01002964:    4091        .@      LSLS     r1,r1,r2
        0x01002966:    0940        @.      LSRS     r0,r0,#5
        0x01002968:    0080        ..      LSLS     r0,r0,#2
        0x0100296a:    f10020e0    ...     ADD      r0,r0,#0xe000e000
        0x0100296e:    f8c01280    ....    STR      r1,[r0,#0x280]
        0x01002972:    4770        pG      BX       lr
    i.__NVIC_ClearPendingIRQ
    __NVIC_ClearPendingIRQ
        0x01002974:    2800        .(      CMP      r0,#0
        0x01002976:    db09        ..      BLT      0x100298c ; __NVIC_ClearPendingIRQ + 24
        0x01002978:    f000021f    ....    AND      r2,r0,#0x1f
        0x0100297c:    2101        .!      MOVS     r1,#1
        0x0100297e:    4091        .@      LSLS     r1,r1,r2
        0x01002980:    0940        @.      LSRS     r0,r0,#5
        0x01002982:    0080        ..      LSLS     r0,r0,#2
        0x01002984:    f10020e0    ...     ADD      r0,r0,#0xe000e000
        0x01002988:    f8c01280    ....    STR      r1,[r0,#0x280]
        0x0100298c:    4770        pG      BX       lr
    i.__NVIC_DisableIRQ
    __NVIC_DisableIRQ
        0x0100298e:    2800        .(      CMP      r0,#0
        0x01002990:    db0d        ..      BLT      0x10029ae ; __NVIC_DisableIRQ + 32
        0x01002992:    f000021f    ....    AND      r2,r0,#0x1f
        0x01002996:    2101        .!      MOVS     r1,#1
        0x01002998:    4091        .@      LSLS     r1,r1,r2
        0x0100299a:    0940        @.      LSRS     r0,r0,#5
        0x0100299c:    0080        ..      LSLS     r0,r0,#2
        0x0100299e:    f10020e0    ...     ADD      r0,r0,#0xe000e000
        0x010029a2:    f8c01180    ....    STR      r1,[r0,#0x180]
        0x010029a6:    f3bf8f4f    ..O.    DSB      
        0x010029aa:    f3bf8f6f    ..o.    ISB      
        0x010029ae:    4770        pG      BX       lr
    i.__NVIC_DisableIRQ
    __NVIC_DisableIRQ
        0x010029b0:    2800        .(      CMP      r0,#0
        0x010029b2:    db0d        ..      BLT      0x10029d0 ; __NVIC_DisableIRQ + 32
        0x010029b4:    f000021f    ....    AND      r2,r0,#0x1f
        0x010029b8:    2101        .!      MOVS     r1,#1
        0x010029ba:    4091        .@      LSLS     r1,r1,r2
        0x010029bc:    0940        @.      LSRS     r0,r0,#5
        0x010029be:    0080        ..      LSLS     r0,r0,#2
        0x010029c0:    f10020e0    ...     ADD      r0,r0,#0xe000e000
        0x010029c4:    f8c01180    ....    STR      r1,[r0,#0x180]
        0x010029c8:    f3bf8f4f    ..O.    DSB      
        0x010029cc:    f3bf8f6f    ..o.    ISB      
        0x010029d0:    4770        pG      BX       lr
    i.__NVIC_EnableIRQ
    __NVIC_EnableIRQ
        0x010029d2:    2800        .(      CMP      r0,#0
        0x010029d4:    db09        ..      BLT      0x10029ea ; __NVIC_EnableIRQ + 24
        0x010029d6:    f000021f    ....    AND      r2,r0,#0x1f
        0x010029da:    2101        .!      MOVS     r1,#1
        0x010029dc:    4091        .@      LSLS     r1,r1,r2
        0x010029de:    0940        @.      LSRS     r0,r0,#5
        0x010029e0:    0080        ..      LSLS     r0,r0,#2
        0x010029e2:    f10020e0    ...     ADD      r0,r0,#0xe000e000
        0x010029e6:    f8c01100    ....    STR      r1,[r0,#0x100]
        0x010029ea:    4770        pG      BX       lr
    i.__NVIC_GetPendingIRQ
    __NVIC_GetPendingIRQ
        0x010029ec:    2800        .(      CMP      r0,#0
        0x010029ee:    db0f        ..      BLT      0x1002a10 ; __NVIC_GetPendingIRQ + 36
        0x010029f0:    0941        A.      LSRS     r1,r0,#5
        0x010029f2:    0089        ..      LSLS     r1,r1,#2
        0x010029f4:    f10121e0    ...!    ADD      r1,r1,#0xe000e000
        0x010029f8:    f8d11200    ....    LDR      r1,[r1,#0x200]
        0x010029fc:    f000021f    ....    AND      r2,r0,#0x1f
        0x01002a00:    2001        .       MOVS     r0,#1
        0x01002a02:    4090        .@      LSLS     r0,r0,r2
        0x01002a04:    4201        .B      TST      r1,r0
        0x01002a06:    d001        ..      BEQ      0x1002a0c ; __NVIC_GetPendingIRQ + 32
        0x01002a08:    2001        .       MOVS     r0,#1
        0x01002a0a:    4770        pG      BX       lr
        0x01002a0c:    2000        .       MOVS     r0,#0
        0x01002a0e:    4770        pG      BX       lr
        0x01002a10:    2000        .       MOVS     r0,#0
        0x01002a12:    4770        pG      BX       lr
    i.__NVIC_GetPendingIRQ
    __NVIC_GetPendingIRQ
        0x01002a14:    2800        .(      CMP      r0,#0
        0x01002a16:    db0f        ..      BLT      0x1002a38 ; __NVIC_GetPendingIRQ + 36
        0x01002a18:    0941        A.      LSRS     r1,r0,#5
        0x01002a1a:    0089        ..      LSLS     r1,r1,#2
        0x01002a1c:    f10121e0    ...!    ADD      r1,r1,#0xe000e000
        0x01002a20:    f8d11200    ....    LDR      r1,[r1,#0x200]
        0x01002a24:    f000021f    ....    AND      r2,r0,#0x1f
        0x01002a28:    2001        .       MOVS     r0,#1
        0x01002a2a:    4090        .@      LSLS     r0,r0,r2
        0x01002a2c:    4201        .B      TST      r1,r0
        0x01002a2e:    d001        ..      BEQ      0x1002a34 ; __NVIC_GetPendingIRQ + 32
        0x01002a30:    2001        .       MOVS     r0,#1
        0x01002a32:    4770        pG      BX       lr
        0x01002a34:    2000        .       MOVS     r0,#0
        0x01002a36:    4770        pG      BX       lr
        0x01002a38:    2000        .       MOVS     r0,#0
        0x01002a3a:    4770        pG      BX       lr
    i.__NVIC_GetPendingIRQ
    __NVIC_GetPendingIRQ
        0x01002a3c:    2800        .(      CMP      r0,#0
        0x01002a3e:    db0f        ..      BLT      0x1002a60 ; __NVIC_GetPendingIRQ + 36
        0x01002a40:    0941        A.      LSRS     r1,r0,#5
        0x01002a42:    0089        ..      LSLS     r1,r1,#2
        0x01002a44:    f10121e0    ...!    ADD      r1,r1,#0xe000e000
        0x01002a48:    f8d11200    ....    LDR      r1,[r1,#0x200]
        0x01002a4c:    f000021f    ....    AND      r2,r0,#0x1f
        0x01002a50:    2001        .       MOVS     r0,#1
        0x01002a52:    4090        .@      LSLS     r0,r0,r2
        0x01002a54:    4201        .B      TST      r1,r0
        0x01002a56:    d001        ..      BEQ      0x1002a5c ; __NVIC_GetPendingIRQ + 32
        0x01002a58:    2001        .       MOVS     r0,#1
        0x01002a5a:    4770        pG      BX       lr
        0x01002a5c:    2000        .       MOVS     r0,#0
        0x01002a5e:    4770        pG      BX       lr
        0x01002a60:    2000        .       MOVS     r0,#0
        0x01002a62:    4770        pG      BX       lr
    i.__NVIC_SetPendingIRQ
    __NVIC_SetPendingIRQ
        0x01002a64:    2800        .(      CMP      r0,#0
        0x01002a66:    db09        ..      BLT      0x1002a7c ; __NVIC_SetPendingIRQ + 24
        0x01002a68:    f000021f    ....    AND      r2,r0,#0x1f
        0x01002a6c:    2101        .!      MOVS     r1,#1
        0x01002a6e:    4091        .@      LSLS     r1,r1,r2
        0x01002a70:    0940        @.      LSRS     r0,r0,#5
        0x01002a72:    0080        ..      LSLS     r0,r0,#2
        0x01002a74:    f10020e0    ...     ADD      r0,r0,#0xe000e000
        0x01002a78:    f8c01200    ....    STR      r1,[r0,#0x200]
        0x01002a7c:    4770        pG      BX       lr
    i.__NVIC_SetPriority
    __NVIC_SetPriority
        0x01002a7e:    b2c9        ..      UXTB     r1,r1
        0x01002a80:    2800        .(      CMP      r0,#0
        0x01002a82:    db04        ..      BLT      0x1002a8e ; __NVIC_SetPriority + 16
        0x01002a84:    f10020e0    ...     ADD      r0,r0,#0xe000e000
        0x01002a88:    f8801400    ....    STRB     r1,[r0,#0x400]
        0x01002a8c:    4770        pG      BX       lr
        0x01002a8e:    f000000f    ....    AND      r0,r0,#0xf
        0x01002a92:    f10020e0    ...     ADD      r0,r0,#0xe000e000
        0x01002a96:    f8801d14    ....    STRB     r1,[r0,#0xd14]
        0x01002a9a:    4770        pG      BX       lr
    i.__get_PRIMASK
    __get_PRIMASK
        0x01002a9c:    f3ef8010    ....    MRS      r0,PRIMASK
        0x01002aa0:    4770        pG      BX       lr
    i.__set_PRIMASK
    __set_PRIMASK
        0x01002aa2:    f3808810    ....    MSR      PRIMASK,r0
        0x01002aa6:    4770        pG      BX       lr
    i._is_digit
    _is_digit
        0x01002aa8:    3830        08      SUBS     r0,r0,#0x30
        0x01002aaa:    280a        .(      CMP      r0,#0xa
        0x01002aac:    d201        ..      BCS      0x1002ab2 ; _is_digit + 10
        0x01002aae:    2001        .       MOVS     r0,#1
        0x01002ab0:    4770        pG      BX       lr
        0x01002ab2:    2000        .       MOVS     r0,#0
        0x01002ab4:    4770        pG      BX       lr
        0x01002ab6:    0000        ..      MOVS     r0,r0
    i.adc_conversion
    adc_conversion
        0x01002ab8:    e92d5ff0    -.._    PUSH     {r4-r12,lr}
        0x01002abc:    4607        .F      MOV      r7,r0
        0x01002abe:    4689        .F      MOV      r9,r1
        0x01002ac0:    4693        .F      MOV      r11,r2
        0x01002ac2:    ea4f045b    O.[.    LSR      r4,r11,#1
        0x01002ac6:    46a2        .F      MOV      r10,r4
        0x01002ac8:    464d        MF      MOV      r5,r9
        0x01002aca:    4e5f        _N      LDR      r6,[pc,#380] ; [0x1002c48] = 0xa000c508
        0x01002acc:    f8df817c    ..|.    LDR      r8,[pc,#380] ; [0x1002c4c] = 0xa000e000
        0x01002ad0:    f3ef8010    ....    MRS      r0,PRIMASK
        0x01002ad4:    2101        .!      MOVS     r1,#1
        0x01002ad6:    f3818810    ....    MSR      PRIMASK,r1
        0x01002ada:    f8d812a4    ....    LDR      r1,[r8,#0x2a4]
        0x01002ade:    f0210120    !. .    BIC      r1,r1,#0x20
        0x01002ae2:    f8c812a4    ....    STR      r1,[r8,#0x2a4]
        0x01002ae6:    f3808810    ....    MSR      PRIMASK,r0
        0x01002aea:    f3ef8010    ....    MRS      r0,PRIMASK
        0x01002aee:    2101        .!      MOVS     r1,#1
        0x01002af0:    f3818810    ....    MSR      PRIMASK,r1
        0x01002af4:    f8d812a0    ....    LDR      r1,[r8,#0x2a0]
        0x01002af8:    f0210120    !. .    BIC      r1,r1,#0x20
        0x01002afc:    f8c812a0    ....    STR      r1,[r8,#0x2a0]
        0x01002b00:    f3808810    ....    MSR      PRIMASK,r0
        0x01002b04:    6830        0h      LDR      r0,[r6,#0]
        0x01002b06:    f0204080     ..@    BIC      r0,r0,#0x40000000
        0x01002b0a:    6030        0`      STR      r0,[r6,#0]
        0x01002b0c:    4850        PH      LDR      r0,[pc,#320] ; [0x1002c50] = 0x708070a
        0x01002b0e:    6030        0`      STR      r0,[r6,#0]
        0x01002b10:    203f        ?       MOVS     r0,#0x3f
        0x01002b12:    f8d81100    ....    LDR      r1,[r8,#0x100]
        0x01002b16:    f3600105    `...    BFI      r1,r0,#0,#6
        0x01002b1a:    f8c81100    ....    STR      r1,[r8,#0x100]
        0x01002b1e:    6830        0h      LDR      r0,[r6,#0]
        0x01002b20:    f4201060     .`.    BIC      r0,r0,#0x380000
        0x01002b24:    ea4040c7    @..@    ORR      r0,r0,r7,LSL #19
        0x01002b28:    6030        0`      STR      r0,[r6,#0]
        0x01002b2a:    6830        0h      LDR      r0,[r6,#0]
        0x01002b2c:    f42020e0     ..     BIC      r0,r0,#0x70000
        0x01002b30:    ea404007    @..@    ORR      r0,r0,r7,LSL #16
        0x01002b34:    6030        0`      STR      r0,[r6,#0]
        0x01002b36:    2f05        ./      CMP      r7,#5
        0x01002b38:    d103        ..      BNE      0x1002b42 ; adc_conversion + 138
        0x01002b3a:    6830        0h      LDR      r0,[r6,#0]
        0x01002b3c:    f4404000    @..@    ORR      r0,r0,#0x8000
        0x01002b40:    6030        0`      STR      r0,[r6,#0]
        0x01002b42:    2f06        ./      CMP      r7,#6
        0x01002b44:    d103        ..      BNE      0x1002b4e ; adc_conversion + 150
        0x01002b46:    6830        0h      LDR      r0,[r6,#0]
        0x01002b48:    f4404080    @..@    ORR      r0,r0,#0x4000
        0x01002b4c:    6030        0`      STR      r0,[r6,#0]
        0x01002b4e:    6830        0h      LDR      r0,[r6,#0]
        0x01002b50:    f4405000    @..P    ORR      r0,r0,#0x2000
        0x01002b54:    6030        0`      STR      r0,[r6,#0]
        0x01002b56:    6830        0h      LDR      r0,[r6,#0]
        0x01002b58:    f0205060     .`P    BIC      r0,r0,#0x38000000
        0x01002b5c:    6030        0`      STR      r0,[r6,#0]
        0x01002b5e:    6830        0h      LDR      r0,[r6,#0]
        0x01002b60:    f020000f     ...    BIC      r0,r0,#0xf
        0x01002b64:    f0400003    @...    ORR      r0,r0,#3
        0x01002b68:    6030        0`      STR      r0,[r6,#0]
        0x01002b6a:    f3ef8010    ....    MRS      r0,PRIMASK
        0x01002b6e:    2101        .!      MOVS     r1,#1
        0x01002b70:    f3818810    ....    MSR      PRIMASK,r1
        0x01002b74:    4a34        4J      LDR      r2,[pc,#208] ; [0x1002c48] = 0xa000c508
        0x01002b76:    3238        82      ADDS     r2,r2,#0x38
        0x01002b78:    6811        .h      LDR      r1,[r2,#0]
        0x01002b7a:    f02141e0    !..A    BIC      r1,r1,#0x70000000
        0x01002b7e:    f0414180    A..A    ORR      r1,r1,#0x40000000
        0x01002b82:    6011        .`      STR      r1,[r2,#0]
        0x01002b84:    f3808810    ....    MSR      PRIMASK,r0
        0x01002b88:    6830        0h      LDR      r0,[r6,#0]
        0x01002b8a:    f0404080    @..@    ORR      r0,r0,#0x40000000
        0x01002b8e:    6030        0`      STR      r0,[r6,#0]
        0x01002b90:    e001        ..      B        0x1002b96 ; adc_conversion + 222
        0x01002b92:    f8d80000    ....    LDR      r0,[r8,#0]
        0x01002b96:    f8d80104    ....    LDR      r0,[r8,#0x104]
        0x01002b9a:    f3c02000    ...     UBFX     r0,r0,#8,#1
        0x01002b9e:    2800        .(      CMP      r0,#0
        0x01002ba0:    d1f7        ..      BNE      0x1002b92 ; adc_conversion + 218
        0x01002ba2:    f3ef8010    ....    MRS      r0,PRIMASK
        0x01002ba6:    2101        .!      MOVS     r1,#1
        0x01002ba8:    f3818810    ....    MSR      PRIMASK,r1
        0x01002bac:    6811        .h      LDR      r1,[r2,#0]
        0x01002bae:    f0414100    A..A    ORR      r1,r1,#0x80000000
        0x01002bb2:    6011        .`      STR      r1,[r2,#0]
        0x01002bb4:    f3808810    ....    MSR      PRIMASK,r0
        0x01002bb8:    e034        4.      B        0x1002c24 ; adc_conversion + 364
        0x01002bba:    2000        .       MOVS     r0,#0
        0x01002bbc:    f44f717a    O.zq    MOV      r1,#0x3e8
        0x01002bc0:    e01a        ..      B        0x1002bf8 ; adc_conversion + 320
        0x01002bc2:    4288        .B      CMP      r0,r1
        0x01002bc4:    d917        ..      BLS      0x1002bf6 ; adc_conversion + 318
        0x01002bc6:    6830        0h      LDR      r0,[r6,#0]
        0x01002bc8:    f0204080     ..@    BIC      r0,r0,#0x40000000
        0x01002bcc:    6030        0`      STR      r0,[r6,#0]
        0x01002bce:    6830        0h      LDR      r0,[r6,#0]
        0x01002bd0:    f0404000    @..@    ORR      r0,r0,#0x80000000
        0x01002bd4:    6030        0`      STR      r0,[r6,#0]
        0x01002bd6:    6830        0h      LDR      r0,[r6,#0]
        0x01002bd8:    f0204000     ..@    BIC      r0,r0,#0x80000000
        0x01002bdc:    6030        0`      STR      r0,[r6,#0]
        0x01002bde:    f002f845    ..E.    BL       ll_adc_disable_clock ; 0x1004c6c
        0x01002be2:    481c        .H      LDR      r0,[pc,#112] ; [0x1002c54] = 0x30006994
        0x01002be4:    6801        .h      LDR      r1,[r0,#0]
        0x01002be6:    1c49        I.      ADDS     r1,r1,#1
        0x01002be8:    6001        .`      STR      r1,[r0,#0]
        0x01002bea:    4654        TF      MOV      r4,r10
        0x01002bec:    464d        MF      MOV      r5,r9
        0x01002bee:    2005        .       MOVS     r0,#5
        0x01002bf0:    f479d005    y...    BL       sys_delay_us ; 0x7bbfe
        0x01002bf4:    e76c        l.      B        0x1002ad0 ; adc_conversion + 24
        0x01002bf6:    1c40        @.      ADDS     r0,r0,#1
        0x01002bf8:    f8d82104    ...!    LDR      r2,[r8,#0x104]
        0x01002bfc:    f3c22200    ..."    UBFX     r2,r2,#8,#1
        0x01002c00:    2a00        .*      CMP      r2,#0
        0x01002c02:    d0de        ..      BEQ      0x1002bc2 ; adc_conversion + 266
        0x01002c04:    f8d80104    ....    LDR      r0,[r8,#0x104]
        0x01002c08:    f000017f    ....    AND      r1,r0,#0x7f
        0x01002c0c:    42a1        .B      CMP      r1,r4
        0x01002c0e:    d900        ..      BLS      0x1002c12 ; adc_conversion + 346
        0x01002c10:    4621        !F      MOV      r1,r4
        0x01002c12:    2000        .       MOVS     r0,#0
        0x01002c14:    e003        ..      B        0x1002c1e ; adc_conversion + 358
        0x01002c16:    f8d82000    ...     LDR      r2,[r8,#0]
        0x01002c1a:    c504        ..      STM      r5!,{r2}
        0x01002c1c:    1c40        @.      ADDS     r0,r0,#1
        0x01002c1e:    4288        .B      CMP      r0,r1
        0x01002c20:    d3f9        ..      BCC      0x1002c16 ; adc_conversion + 350
        0x01002c22:    1a64        d.      SUBS     r4,r4,r1
        0x01002c24:    2c00        .,      CMP      r4,#0
        0x01002c26:    d1c8        ..      BNE      0x1002bba ; adc_conversion + 258
        0x01002c28:    ea5f70cb    _..p    LSLS     r0,r11,#31
        0x01002c2c:    d008        ..      BEQ      0x1002c40 ; adc_conversion + 392
        0x01002c2e:    f8d80104    ....    LDR      r0,[r8,#0x104]
        0x01002c32:    f3c02000    ...     UBFX     r0,r0,#8,#1
        0x01002c36:    2800        .(      CMP      r0,#0
        0x01002c38:    d0f9        ..      BEQ      0x1002c2e ; adc_conversion + 374
        0x01002c3a:    f8d80000    ....    LDR      r0,[r8,#0]
        0x01002c3e:    8028        (.      STRH     r0,[r5,#0]
        0x01002c40:    e8bd5ff0    ..._    POP      {r4-r12,lr}
        0x01002c44:    f002b812    ....    B.W      ll_adc_disable_clock ; 0x1004c6c
    $d
        0x01002c48:    a000c508    ....    DCD    2684405000
        0x01002c4c:    a000e000    ....    DCD    2684411904
        0x01002c50:    0708070a    ....    DCD    117966602
        0x01002c54:    30006994    .i.0    DCD    805333396
    $t
    i.aon_gpio_read_flag_it_patch
    aon_gpio_read_flag_it_patch
        0x01002c58:    4904        .I      LDR      r1,[pc,#16] ; [0x1002c6c] = 0xa0012000
        0x01002c5a:    6b89        .k      LDR      r1,[r1,#0x38]
        0x01002c5c:    4008        .@      ANDS     r0,r0,r1
        0x01002c5e:    4904        .I      LDR      r1,[pc,#16] ; [0x1002c70] = 0x300067a4
        0x01002c60:    780a        .x      LDRB     r2,[r1,#0]
        0x01002c62:    4310        .C      ORRS     r0,r0,r2
        0x01002c64:    2200        ."      MOVS     r2,#0
        0x01002c66:    700a        .p      STRB     r2,[r1,#0]
        0x01002c68:    4770        pG      BX       lr
    $d
        0x01002c6a:    0000        ..      DCW    0
        0x01002c6c:    a0012000    . ..    DCD    2684428288
        0x01002c70:    300067a4    .g.0    DCD    805332900
    $t
    i.aon_voltage_set
    aon_voltage_set
        0x01002c74:    490c        .I      LDR      r1,[pc,#48] ; [0x1002ca8] = 0xa000c50c
        0x01002c76:    2800        .(      CMP      r0,#0
        0x01002c78:    dc0b        ..      BGT      0x1002c92 ; aon_voltage_set + 30
        0x01002c7a:    6808        .h      LDR      r0,[r1,#0]
        0x01002c7c:    f3c02041    ..A     UBFX     r0,r0,#9,#2
        0x01002c80:    2801        .(      CMP      r0,#1
        0x01002c82:    d005        ..      BEQ      0x1002c90 ; aon_voltage_set + 28
        0x01002c84:    6808        .h      LDR      r0,[r1,#0]
        0x01002c86:    f42060c0     ..`    BIC      r0,r0,#0x600
        0x01002c8a:    f4407000    @..p    ORR      r0,r0,#0x200
        0x01002c8e:    6008        .`      STR      r0,[r1,#0]
        0x01002c90:    4770        pG      BX       lr
        0x01002c92:    280a        .(      CMP      r0,#0xa
        0x01002c94:    dbfc        ..      BLT      0x1002c90 ; aon_voltage_set + 28
        0x01002c96:    6808        .h      LDR      r0,[r1,#0]
        0x01002c98:    f4106fc0    ...o    TST      r0,#0x600
        0x01002c9c:    d0f8        ..      BEQ      0x1002c90 ; aon_voltage_set + 28
        0x01002c9e:    6808        .h      LDR      r0,[r1,#0]
        0x01002ca0:    f42060c0     ..`    BIC      r0,r0,#0x600
        0x01002ca4:    6008        .`      STR      r0,[r1,#0]
        0x01002ca6:    4770        pG      BX       lr
    $d
        0x01002ca8:    a000c50c    ....    DCD    2684405004
    $t
    i.app_io_init
    app_io_init
        0x01002cac:    b570        p.      PUSH     {r4-r6,lr}
        0x01002cae:    b08e        ..      SUB      sp,sp,#0x38
        0x01002cb0:    4605        .F      MOV      r5,r0
        0x01002cb2:    460c        .F      MOV      r4,r1
        0x01002cb4:    4956        VI      LDR      r1,[pc,#344] ; [0x1002e10] = 0x1007b18
        0x01002cb6:    f1010064    ..d.    ADD      r0,r1,#0x64
        0x01002cba:    c84d        M.      LDM      r0,{r0,r2,r3,r6}
        0x01002cbc:    e9cd020a    ....    STRD     r0,r2,[sp,#0x28]
        0x01002cc0:    e9cd360c    ...6    STRD     r3,r6,[sp,#0x30]
        0x01002cc4:    e9d1231e    ...#    LDRD     r2,r3,[r1,#0x78]
        0x01002cc8:    6f48        Ho      LDR      r0,[r1,#0x74]
        0x01002cca:    ae06        ..      ADD      r6,sp,#0x18
        0x01002ccc:    f8d11080    ....    LDR      r1,[r1,#0x80]
        0x01002cd0:    c60d        ..      STM      r6!,{r0,r2,r3}
        0x01002cd2:    9109        ..      STR      r1,[sp,#0x24]
        0x01002cd4:    2214        ."      MOVS     r2,#0x14
        0x01002cd6:    494e        NI      LDR      r1,[pc,#312] ; [0x1002e10] = 0x1007b18
        0x01002cd8:    3184        .1      ADDS     r1,r1,#0x84
        0x01002cda:    a801        ..      ADD      r0,sp,#4
        0x01002cdc:    f7fffc2f    ../.    BL       __aeabi_memcpy4 ; 0x100253e
        0x01002ce0:    b1ac        ..      CBZ      r4,0x1002d0e ; app_io_init + 98
        0x01002ce2:    494c        LI      LDR      r1,[pc,#304] ; [0x1002e14] = 0x8042ef
        0x01002ce4:    2006        .       MOVS     r0,#6
        0x01002ce6:    f003fa7d    ..}.    BL       soc_register_nvic ; 0x10061e4
        0x01002cea:    494b        KI      LDR      r1,[pc,#300] ; [0x1002e18] = 0x8042e9
        0x01002cec:    2007        .       MOVS     r0,#7
        0x01002cee:    f003fa79    ..y.    BL       soc_register_nvic ; 0x10061e4
        0x01002cf2:    494a        JI      LDR      r1,[pc,#296] ; [0x1002e1c] = 0x8042e5
        0x01002cf4:    2012        .       MOVS     r0,#0x12
        0x01002cf6:    f003fa75    ..u.    BL       soc_register_nvic ; 0x10061e4
        0x01002cfa:    4945        EI      LDR      r1,[pc,#276] ; [0x1002e10] = 0x1007b18
        0x01002cfc:    4a44        DJ      LDR      r2,[pc,#272] ; [0x1002e10] = 0x1007b18
        0x01002cfe:    312c        ,1      ADDS     r1,r1,#0x2c
        0x01002d00:    2d06        .-      CMP      r5,#6
        0x01002d02:    d27c        |.      BCS      0x1002dfe ; app_io_init + 338
        0x01002d04:    e8dff005    ....    TBB      [pc,r5]
    $d
        0x01002d08:    41060606    ...A    DCD    1090913798
        0x01002d0c:    2159        Y!      DCW    8537
    $t
        0x01002d0e:    20e5        .       MOVS     r0,#0xe5
        0x01002d10:    b00e        ..      ADD      sp,sp,#0x38
        0x01002d12:    bd70        p.      POP      {r4-r6,pc}
        0x01002d14:    7920         y      LDRB     r0,[r4,#4]
        0x01002d16:    f8310010    1...    LDRH     r0,[r1,r0,LSL #1]
        0x01002d1a:    900b        ..      STR      r0,[sp,#0x2c]
        0x01002d1c:    7960        `y      LDRB     r0,[r4,#5]
        0x01002d1e:    f8320010    2...    LDRH     r0,[r2,r0,LSL #1]
        0x01002d22:    900c        ..      STR      r0,[sp,#0x30]
        0x01002d24:    79a0        .y      LDRB     r0,[r4,#6]
        0x01002d26:    900d        ..      STR      r0,[sp,#0x34]
        0x01002d28:    6820         h      LDR      r0,[r4,#0]
        0x01002d2a:    900a        ..      STR      r0,[sp,#0x28]
        0x01002d2c:    4838        8H      LDR      r0,[pc,#224] ; [0x1002e10] = 0x1007b18
        0x01002d2e:    3014        .0      ADDS     r0,r0,#0x14
        0x01002d30:    f8500035    P.5.    LDR      r0,[r0,r5,LSL #3]
        0x01002d34:    8821        !.      LDRH     r1,[r4,#0]
        0x01002d36:    0409        ..      LSLS     r1,r1,#16
        0x01002d38:    0c09        ..      LSRS     r1,r1,#16
        0x01002d3a:    d004        ..      BEQ      0x1002d46 ; app_io_init + 154
        0x01002d3c:    b118        ..      CBZ      r0,0x1002d46 ; app_io_init + 154
        0x01002d3e:    a90a        ..      ADD      r1,sp,#0x28
        0x01002d40:    f001fbc0    ....    BL       hal_gpio_init ; 0x10044c4
        0x01002d44:    e059        Y.      B        0x1002dfa ; app_io_init + 334
        0x01002d46:    20e4        .       MOVS     r0,#0xe4
        0x01002d48:    e7e2        ..      B        0x1002d10 ; app_io_init + 100
        0x01002d4a:    7920         y      LDRB     r0,[r4,#4]
        0x01002d4c:    f8310010    1...    LDRH     r0,[r1,r0,LSL #1]
        0x01002d50:    900b        ..      STR      r0,[sp,#0x2c]
        0x01002d52:    7960        `y      LDRB     r0,[r4,#5]
        0x01002d54:    f8320010    2...    LDRH     r0,[r2,r0,LSL #1]
        0x01002d58:    900c        ..      STR      r0,[sp,#0x30]
        0x01002d5a:    79a0        .y      LDRB     r0,[r4,#6]
        0x01002d5c:    900d        ..      STR      r0,[sp,#0x34]
        0x01002d5e:    6820         h      LDR      r0,[r4,#0]
        0x01002d60:    900a        ..      STR      r0,[sp,#0x28]
        0x01002d62:    6820         h      LDR      r0,[r4,#0]
        0x01002d64:    0401        ..      LSLS     r1,r0,#16
        0x01002d66:    0c09        ..      LSRS     r1,r1,#16
        0x01002d68:    d005        ..      BEQ      0x1002d76 ; app_io_init + 202
        0x01002d6a:    b280        ..      UXTH     r0,r0
        0x01002d6c:    900a        ..      STR      r0,[sp,#0x28]
        0x01002d6e:    a90a        ..      ADD      r1,sp,#0x28
        0x01002d70:    482b        +H      LDR      r0,[pc,#172] ; [0x1002e20] = 0xa0010000
        0x01002d72:    f001fba7    ....    BL       hal_gpio_init ; 0x10044c4
        0x01002d76:    6820         h      LDR      r0,[r4,#0]
        0x01002d78:    0c01        ..      LSRS     r1,r0,#16
        0x01002d7a:    d03e        >.      BEQ      0x1002dfa ; app_io_init + 334
        0x01002d7c:    0c00        ..      LSRS     r0,r0,#16
        0x01002d7e:    900a        ..      STR      r0,[sp,#0x28]
        0x01002d80:    a90a        ..      ADD      r1,sp,#0x28
        0x01002d82:    4828        (H      LDR      r0,[pc,#160] ; [0x1002e24] = 0xa0011000
        0x01002d84:    f001fb9e    ....    BL       hal_gpio_init ; 0x10044c4
        0x01002d88:    e037        7.      B        0x1002dfa ; app_io_init + 334
        0x01002d8a:    7920         y      LDRB     r0,[r4,#4]
        0x01002d8c:    eb010040    ..@.    ADD      r0,r1,r0,LSL #1
        0x01002d90:    8a40        @.      LDRH     r0,[r0,#0x12]
        0x01002d92:    9007        ..      STR      r0,[sp,#0x1c]
        0x01002d94:    7960        `y      LDRB     r0,[r4,#5]
        0x01002d96:    eb020040    ..@.    ADD      r0,r2,r0,LSL #1
        0x01002d9a:    88c0        ..      LDRH     r0,[r0,#6]
        0x01002d9c:    9008        ..      STR      r0,[sp,#0x20]
        0x01002d9e:    79a0        .y      LDRB     r0,[r4,#6]
        0x01002da0:    9009        ..      STR      r0,[sp,#0x24]
        0x01002da2:    6820         h      LDR      r0,[r4,#0]
        0x01002da4:    9006        ..      STR      r0,[sp,#0x18]
        0x01002da6:    7820         x      LDRB     r0,[r4,#0]
        0x01002da8:    f0100fff    ....    TST      r0,#0xff
        0x01002dac:    d003        ..      BEQ      0x1002db6 ; app_io_init + 266
        0x01002dae:    a806        ..      ADD      r0,sp,#0x18
        0x01002db0:    f001f994    ....    BL       hal_aon_gpio_init ; 0x10040dc
        0x01002db4:    e021        !.      B        0x1002dfa ; app_io_init + 334
        0x01002db6:    20e4        .       MOVS     r0,#0xe4
        0x01002db8:    e7aa        ..      B        0x1002d10 ; app_io_init + 100
        0x01002dba:    7920         y      LDRB     r0,[r4,#4]
        0x01002dbc:    1f03        ..      SUBS     r3,r0,#4
        0x01002dbe:    2b03        .+      CMP      r3,#3
        0x01002dc0:    d801        ..      BHI      0x1002dc6 ; app_io_init + 282
        0x01002dc2:    20e7        .       MOVS     r0,#0xe7
        0x01002dc4:    e7a4        ..      B        0x1002d10 ; app_io_init + 100
        0x01002dc6:    2802        .(      CMP      r0,#2
        0x01002dc8:    d01a        ..      BEQ      0x1002e00 ; app_io_init + 340
        0x01002dca:    2001        .       MOVS     r0,#1
        0x01002dcc:    9002        ..      STR      r0,[sp,#8]
        0x01002dce:    7920         y      LDRB     r0,[r4,#4]
        0x01002dd0:    eb010040    ..@.    ADD      r0,r1,r0,LSL #1
        0x01002dd4:    8c80        ..      LDRH     r0,[r0,#0x24]
        0x01002dd6:    9003        ..      STR      r0,[sp,#0xc]
        0x01002dd8:    7960        `y      LDRB     r0,[r4,#5]
        0x01002dda:    eb020040    ..@.    ADD      r0,r2,r0,LSL #1
        0x01002dde:    8980        ..      LDRH     r0,[r0,#0xc]
        0x01002de0:    9004        ..      STR      r0,[sp,#0x10]
        0x01002de2:    79a0        .y      LDRB     r0,[r4,#6]
        0x01002de4:    9005        ..      STR      r0,[sp,#0x14]
        0x01002de6:    6820         h      LDR      r0,[r4,#0]
        0x01002de8:    9001        ..      STR      r0,[sp,#4]
        0x01002dea:    7820         x      LDRB     r0,[r4,#0]
        0x01002dec:    f0100fff    ....    TST      r0,#0xff
        0x01002df0:    d009        ..      BEQ      0x1002e06 ; app_io_init + 346
        0x01002df2:    a901        ..      ADD      r1,sp,#4
        0x01002df4:    2000        .       MOVS     r0,#0
        0x01002df6:    f001fb89    ....    BL       hal_msio_init ; 0x100450c
        0x01002dfa:    2000        .       MOVS     r0,#0
        0x01002dfc:    e788        ..      B        0x1002d10 ; app_io_init + 100
        0x01002dfe:    e004        ..      B        0x1002e0a ; app_io_init + 350
        0x01002e00:    2002        .       MOVS     r0,#2
        0x01002e02:    9002        ..      STR      r0,[sp,#8]
        0x01002e04:    e7e3        ..      B        0x1002dce ; app_io_init + 290
        0x01002e06:    20e4        .       MOVS     r0,#0xe4
        0x01002e08:    e782        ..      B        0x1002d10 ; app_io_init + 100
        0x01002e0a:    20e6        .       MOVS     r0,#0xe6
        0x01002e0c:    e780        ..      B        0x1002d10 ; app_io_init + 100
    $d
        0x01002e0e:    0000        ..      DCW    0
        0x01002e10:    01007b18    .{..    DCD    16808728
        0x01002e14:    008042ef    .B..    DCD    8405743
        0x01002e18:    008042e9    .B..    DCD    8405737
        0x01002e1c:    008042e5    .B..    DCD    8405733
        0x01002e20:    a0010000    ....    DCD    2684420096
        0x01002e24:    a0011000    ....    DCD    2684424192
    $t
    i.app_log_data_trans
    app_log_data_trans
        0x01002e28:    2800        .(      CMP      r0,#0
        0x01002e2a:    d006        ..      BEQ      0x1002e3a ; app_log_data_trans + 18
        0x01002e2c:    2900        .)      CMP      r1,#0
        0x01002e2e:    d004        ..      BEQ      0x1002e3a ; app_log_data_trans + 18
        0x01002e30:    4a02        .J      LDR      r2,[pc,#8] ; [0x1002e3c] = 0x30006db0
        0x01002e32:    69d2        .i      LDR      r2,[r2,#0x1c]
        0x01002e34:    2a00        .*      CMP      r2,#0
        0x01002e36:    d000        ..      BEQ      0x1002e3a ; app_log_data_trans + 18
        0x01002e38:    4710        .G      BX       r2
        0x01002e3a:    4770        pG      BX       lr
    $d
        0x01002e3c:    30006db0    .m.0    DCD    805334448
    $t
    i.app_log_flush
    app_log_flush
        0x01002e40:    4802        .H      LDR      r0,[pc,#8] ; [0x1002e4c] = 0x30006db0
        0x01002e42:    6a00        .j      LDR      r0,[r0,#0x20]
        0x01002e44:    2800        .(      CMP      r0,#0
        0x01002e46:    d000        ..      BEQ      0x1002e4a ; app_log_flush + 10
        0x01002e48:    4700        .G      BX       r0
        0x01002e4a:    4770        pG      BX       lr
    $d
        0x01002e4c:    30006db0    .m.0    DCD    805334448
    $t
    i.app_pwr_mgmt_init
    app_pwr_mgmt_init
        0x01002e50:    b510        ..      PUSH     {r4,lr}
        0x01002e52:    4808        .H      LDR      r0,[pc,#32] ; [0x1002e74] = 0x300065c8
        0x01002e54:    7801        .x      LDRB     r1,[r0,#0]
        0x01002e56:    2900        .)      CMP      r1,#0
        0x01002e58:    d10a        ..      BNE      0x1002e70 ; app_pwr_mgmt_init + 32
        0x01002e5a:    2101        .!      MOVS     r1,#1
        0x01002e5c:    7001        .p      STRB     r1,[r0,#0]
        0x01002e5e:    4806        .H      LDR      r0,[pc,#24] ; [0x1002e78] = 0x8042b1
        0x01002e60:    f475d550    u.P.    BL       pwr_mgmt_dev_init ; 0x78904
        0x01002e64:    e8bd4010    ...@    POP      {r4,lr}
        0x01002e68:    2100        .!      MOVS     r1,#0
        0x01002e6a:    4804        .H      LDR      r0,[pc,#16] ; [0x1002e7c] = 0x1005a4d
        0x01002e6c:    f47597ac    u...    B        pwr_mgmt_set_callback ; 0x78dc8
        0x01002e70:    bd10        ..      POP      {r4,pc}
    $d
        0x01002e72:    0000        ..      DCW    0
        0x01002e74:    300065c8    .e.0    DCD    805332424
        0x01002e78:    008042b1    .B..    DCD    8405681
        0x01002e7c:    01005a4d    MZ..    DCD    16800333
    $t
    i.app_uart_callback
    app_uart_callback
        0x01002e80:    b570        p.      PUSH     {r4-r6,lr}
        0x01002e82:    4604        .F      MOV      r4,r0
        0x01002e84:    2501        .%      MOVS     r5,#1
        0x01002e86:    7820         x      LDRB     r0,[r4,#0]
        0x01002e88:    4e0a        .N      LDR      r6,[pc,#40] ; [0x1002eb4] = 0x300065d8
        0x01002e8a:    2801        .(      CMP      r0,#1
        0x01002e8c:    d100        ..      BNE      0x1002e90 ; app_uart_callback + 16
        0x01002e8e:    7035        5p      STRB     r5,[r6,#0]
        0x01002e90:    7820         x      LDRB     r0,[r4,#0]
        0x01002e92:    2802        .(      CMP      r0,#2
        0x01002e94:    d108        ..      BNE      0x1002ea8 ; app_uart_callback + 40
        0x01002e96:    7075        up      STRB     r5,[r6,#1]
        0x01002e98:    88a0        ..      LDRH     r0,[r4,#4]
        0x01002e9a:    8070        p.      STRH     r0,[r6,#2]
        0x01002e9c:    8872        r.      LDRH     r2,[r6,#2]
        0x01002e9e:    4906        .I      LDR      r1,[pc,#24] ; [0x1002eb8] = 0x30006fd8
        0x01002ea0:    f5a17000    ...p    SUB      r0,r1,#0x200
        0x01002ea4:    f7fffb06    ....    BL       __aeabi_memcpy ; 0x10024b4
        0x01002ea8:    7820         x      LDRB     r0,[r4,#0]
        0x01002eaa:    2800        .(      CMP      r0,#0
        0x01002eac:    d101        ..      BNE      0x1002eb2 ; app_uart_callback + 50
        0x01002eae:    7035        5p      STRB     r5,[r6,#0]
        0x01002eb0:    7075        up      STRB     r5,[r6,#1]
        0x01002eb2:    bd70        p.      POP      {r4-r6,pc}
    $d
        0x01002eb4:    300065d8    .e.0    DCD    805332440
        0x01002eb8:    30006fd8    .o.0    DCD    805335000
    $t
    i.app_uart_demo
    app_uart_demo
        0x01002ebc:    b57c        |.      PUSH     {r2-r6,lr}
        0x01002ebe:    2500        .%      MOVS     r5,#0
        0x01002ec0:    4818        .H      LDR      r0,[pc,#96] ; [0x1002f24] = 0x300071d8
        0x01002ec2:    9000        ..      STR      r0,[sp,#0]
        0x01002ec4:    f44f7600    O..v    MOV      r6,#0x200
        0x01002ec8:    9601        ..      STR      r6,[sp,#4]
        0x01002eca:    466a        jF      MOV      r2,sp
        0x01002ecc:    4916        .I      LDR      r1,[pc,#88] ; [0x1002f28] = 0x1002e81
        0x01002ece:    4817        .H      LDR      r0,[pc,#92] ; [0x1002f2c] = 0x30006630
        0x01002ed0:    f000f86c    ..l.    BL       app_uart_init ; 0x1002fac
        0x01002ed4:    2800        .(      CMP      r0,#0
        0x01002ed6:    d123        #.      BNE      0x1002f20 ; app_uart_demo + 100
        0x01002ed8:    4914        .I      LDR      r1,[pc,#80] ; [0x1002f2c] = 0x30006630
        0x01002eda:    f2413488    A..4    MOV      r4,#0x1388
        0x01002ede:    4623        #F      MOV      r3,r4
        0x01002ee0:    2249        I"      MOVS     r2,#0x49
        0x01002ee2:    3954        T9      SUBS     r1,r1,#0x54
        0x01002ee4:    f000f97c    ..|.    BL       app_uart_transmit_sync ; 0x10031e0
        0x01002ee8:    4910        .I      LDR      r1,[pc,#64] ; [0x1002f2c] = 0x30006630
        0x01002eea:    4623        #F      MOV      r3,r4
        0x01002eec:    2209        ."      MOVS     r2,#9
        0x01002eee:    390b        .9      SUBS     r1,r1,#0xb
        0x01002ef0:    2000        .       MOVS     r0,#0
        0x01002ef2:    f000f975    ..u.    BL       app_uart_transmit_sync ; 0x10031e0
        0x01002ef6:    4c0d        .L      LDR      r4,[pc,#52] ; [0x1002f2c] = 0x30006630
        0x01002ef8:    3c58        X<      SUBS     r4,r4,#0x58
        0x01002efa:    7065        ep      STRB     r5,[r4,#1]
        0x01002efc:    4632        2F      MOV      r2,r6
        0x01002efe:    490c        .I      LDR      r1,[pc,#48] ; [0x1002f30] = 0x30006fd8
        0x01002f00:    2000        .       MOVS     r0,#0
        0x01002f02:    f000f8cb    ....    BL       app_uart_receive_async ; 0x100309c
        0x01002f06:    7860        `x      LDRB     r0,[r4,#1]
        0x01002f08:    2800        .(      CMP      r0,#0
        0x01002f0a:    d0fc        ..      BEQ      0x1002f06 ; app_uart_demo + 74
        0x01002f0c:    7025        %p      STRB     r5,[r4,#0]
        0x01002f0e:    8862        b.      LDRH     r2,[r4,#2]
        0x01002f10:    4908        .I      LDR      r1,[pc,#32] ; [0x1002f34] = 0x30006dd8
        0x01002f12:    2000        .       MOVS     r0,#0
        0x01002f14:    f000f92a    ..*.    BL       app_uart_transmit_async ; 0x100316c
        0x01002f18:    7820         x      LDRB     r0,[r4,#0]
        0x01002f1a:    2800        .(      CMP      r0,#0
        0x01002f1c:    d0fc        ..      BEQ      0x1002f18 ; app_uart_demo + 92
        0x01002f1e:    e7ec        ..      B        0x1002efa ; app_uart_demo + 62
        0x01002f20:    bd7c        |.      POP      {r2-r6,pc}
    $d
        0x01002f22:    0000        ..      DCW    0
        0x01002f24:    300071d8    .q.0    DCD    805335512
        0x01002f28:    01002e81    ....    DCD    16789121
        0x01002f2c:    30006630    0f.0    DCD    805332528
        0x01002f30:    30006fd8    .o.0    DCD    805335000
        0x01002f34:    30006dd8    .m.0    DCD    805334488
    $t
    i.app_uart_dma_start_transmit_async
    app_uart_dma_start_transmit_async
        0x01002f38:    b570        p.      PUSH     {r4-r6,lr}
        0x01002f3a:    4604        .F      MOV      r4,r0
        0x01002f3c:    4d1a        .M      LDR      r5,[pc,#104] ; [0x1002fa8] = 0x300065cc
        0x01002f3e:    f8550024    U.$.    LDR      r0,[r5,r4,LSL #2]
        0x01002f42:    3070        p0      ADDS     r0,r0,#0x70
        0x01002f44:    f002ff79    ..y.    BL       ring_buffer_items_count_get ; 0x1005e3a
        0x01002f48:    b282        ..      UXTH     r2,r0
        0x01002f4a:    4616        .F      MOV      r6,r2
        0x01002f4c:    b1a2        ..      CBZ      r2,0x1002f78 ; app_uart_dma_start_transmit_async + 64
        0x01002f4e:    f8550024    U.$.    LDR      r0,[r5,r4,LSL #2]
        0x01002f52:    f8901101    ....    LDRB     r1,[r0,#0x101]
        0x01002f56:    2901        .)      CMP      r1,#1
        0x01002f58:    d00e        ..      BEQ      0x1002f78 ; app_uart_dma_start_transmit_async + 64
        0x01002f5a:    2101        .!      MOVS     r1,#1
        0x01002f5c:    f8801104    ....    STRB     r1,[r0,#0x104]
        0x01002f60:    2a80        .*      CMP      r2,#0x80
        0x01002f62:    d30f        ..      BCC      0x1002f84 ; app_uart_dma_start_transmit_async + 76
        0x01002f64:    f8550024    U.$.    LDR      r0,[r5,r4,LSL #2]
        0x01002f68:    2280        ."      MOVS     r2,#0x80
        0x01002f6a:    f1000180    ....    ADD      r1,r0,#0x80
        0x01002f6e:    3070        p0      ADDS     r0,r0,#0x70
        0x01002f70:    f002ff78    ..x.    BL       ring_buffer_read ; 0x1005e64
        0x01002f74:    2680        .&      MOVS     r6,#0x80
        0x01002f76:    e00c        ..      B        0x1002f92 ; app_uart_dma_start_transmit_async + 90
        0x01002f78:    f8551024    U.$.    LDR      r1,[r5,r4,LSL #2]
        0x01002f7c:    2000        .       MOVS     r0,#0
        0x01002f7e:    f8810100    ....    STRB     r0,[r1,#0x100]
        0x01002f82:    bd70        p.      POP      {r4-r6,pc}
        0x01002f84:    f8550024    U.$.    LDR      r0,[r5,r4,LSL #2]
        0x01002f88:    f1000180    ....    ADD      r1,r0,#0x80
        0x01002f8c:    3070        p0      ADDS     r0,r0,#0x70
        0x01002f8e:    f002ff69    ..i.    BL       ring_buffer_read ; 0x1005e64
        0x01002f92:    f8550024    U.$.    LDR      r0,[r5,r4,LSL #2]
        0x01002f96:    4632        2F      MOV      r2,r6
        0x01002f98:    f1000180    ....    ADD      r1,r0,#0x80
        0x01002f9c:    1d00        ..      ADDS     r0,r0,#4
        0x01002f9e:    f41ed549    ..I.    BL       hal_uart_transmit_dma ; 0x21a34
        0x01002fa2:    2800        .(      CMP      r0,#0
        0x01002fa4:    d1ed        ..      BNE      0x1002f82 ; app_uart_dma_start_transmit_async + 74
        0x01002fa6:    bd70        p.      POP      {r4-r6,pc}
    $d
        0x01002fa8:    300065cc    .e.0    DCD    805332428
    $t
    i.app_uart_init
    app_uart_init
        0x01002fac:    e92d41f0    -..A    PUSH     {r4-r8,lr}
        0x01002fb0:    4605        .F      MOV      r5,r0
        0x01002fb2:    460f        .F      MOV      r7,r1
        0x01002fb4:    2d00        .-      CMP      r5,#0
        0x01002fb6:    d006        ..      BEQ      0x1002fc6 ; app_uart_init + 26
        0x01002fb8:    b12a        *.      CBZ      r2,0x1002fc6 ; app_uart_init + 26
        0x01002fba:    782c        ,x      LDRB     r4,[r5,#0]
        0x01002fbc:    2c02        .,      CMP      r4,#2
        0x01002fbe:    d304        ..      BCC      0x1002fca ; app_uart_init + 30
        0x01002fc0:    20e8        .       MOVS     r0,#0xe8
        0x01002fc2:    e8bd81f0    ....    POP      {r4-r8,pc}
        0x01002fc6:    20e5        .       MOVS     r0,#0xe5
        0x01002fc8:    e7fb        ..      B        0x1002fc2 ; app_uart_init + 22
        0x01002fca:    4e30        0N      LDR      r6,[pc,#192] ; [0x100308c] = 0x300065cc
        0x01002fcc:    f1050058    ..X.    ADD      r0,r5,#0x58
        0x01002fd0:    f8460024    F.$.    STR      r0,[r6,r4,LSL #2]
        0x01002fd4:    e9d23100    ...1    LDRD     r3,r1,[r2,#0]
        0x01002fd8:    460a        .F      MOV      r2,r1
        0x01002fda:    3070        p0      ADDS     r0,r0,#0x70
        0x01002fdc:    4619        .F      MOV      r1,r3
        0x01002fde:    f002ff17    ....    BL       ring_buffer_init ; 0x1005e10
        0x01002fe2:    1d29        ).      ADDS     r1,r5,#4
        0x01002fe4:    6d28        (m      LDR      r0,[r5,#0x50]
        0x01002fe6:    f003fdfb    ....    BL       uart_gpio_config ; 0x1006be0
        0x01002fea:    2800        .(      CMP      r0,#0
        0x01002fec:    d1e9        ..      BNE      0x1002fc2 ; app_uart_init + 22
        0x01002fee:    f8561024    V.$.    LDR      r1,[r6,r4,LSL #2]
        0x01002ff2:    1d28        (.      ADDS     r0,r5,#4
        0x01002ff4:    6648        Hf      STR      r0,[r1,#0x64]
        0x01002ff6:    f8560024    V.$.    LDR      r0,[r6,r4,LSL #2]
        0x01002ffa:    6007        .`      STR      r7,[r0,#0]
        0x01002ffc:    f8560024    V.$.    LDR      r0,[r6,r4,LSL #2]
        0x01003000:    2218        ."      MOVS     r2,#0x18
        0x01003002:    3008        .0      ADDS     r0,r0,#8
        0x01003004:    f1050140    ..@.    ADD      r1,r5,#0x40
        0x01003008:    f7fffa99    ....    BL       __aeabi_memcpy4 ; 0x100253e
        0x0100300c:    4820         H      LDR      r0,[pc,#128] ; [0x1003090] = 0x1007bc0
        0x0100300e:    f8561024    V.$.    LDR      r1,[r6,r4,LSL #2]
        0x01003012:    eb0005c4    ....    ADD      r5,r0,r4,LSL #3
        0x01003016:    6868        hh      LDR      r0,[r5,#4]
        0x01003018:    6048        H`      STR      r0,[r1,#4]
        0x0100301a:    f8560024    V.$.    LDR      r0,[r6,r4,LSL #2]
        0x0100301e:    1d00        ..      ADDS     r0,r0,#4
        0x01003020:    f001fb08    ....    BL       hal_uart_deinit ; 0x1004634
        0x01003024:    f8560024    V.$.    LDR      r0,[r6,r4,LSL #2]
        0x01003028:    1d00        ..      ADDS     r0,r0,#4
        0x0100302a:    f001fb39    ..9.    BL       hal_uart_init ; 0x10046a0
        0x0100302e:    4818        .H      LDR      r0,[pc,#96] ; [0x1003090] = 0x1007bc0
        0x01003030:    2201        ."      MOVS     r2,#1
        0x01003032:    2103        .!      MOVS     r1,#3
        0x01003034:    3810        .8      SUBS     r0,r0,#0x10
        0x01003036:    f002fd33    ..3.    BL       pwr_register_sleep_cb ; 0x1005aa0
        0x0100303a:    f8561024    V.$.    LDR      r1,[r6,r4,LSL #2]
        0x0100303e:    2001        .       MOVS     r0,#1
        0x01003040:    f881006c    ..l.    STRB     r0,[r1,#0x6c]
        0x01003044:    f8561024    V.$.    LDR      r1,[r6,r4,LSL #2]
        0x01003048:    2000        .       MOVS     r0,#0
        0x0100304a:    f8810100    ....    STRB     r0,[r1,#0x100]
        0x0100304e:    f8561024    V.$.    LDR      r1,[r6,r4,LSL #2]
        0x01003052:    f8810101    ....    STRB     r0,[r1,#0x101]
        0x01003056:    f8561024    V.$.    LDR      r1,[r6,r4,LSL #2]
        0x0100305a:    f8810102    ....    STRB     r0,[r1,#0x102]
        0x0100305e:    f8561024    V.$.    LDR      r1,[r6,r4,LSL #2]
        0x01003062:    f8810103    ....    STRB     r0,[r1,#0x103]
        0x01003066:    490b        .I      LDR      r1,[pc,#44] ; [0x1003094] = 0x1002921
        0x01003068:    200c        .       MOVS     r0,#0xc
        0x0100306a:    f003f8bb    ....    BL       soc_register_nvic ; 0x10061e4
        0x0100306e:    490a        .I      LDR      r1,[pc,#40] ; [0x1003098] = 0x1002931
        0x01003070:    200d        .       MOVS     r0,#0xd
        0x01003072:    f003f8b7    ....    BL       soc_register_nvic ; 0x10061e4
        0x01003076:    f9950001    ....    LDRSB    r0,[r5,#1]
        0x0100307a:    f419d0cd    ....    BL       hal_nvic_clear_pending_irq ; 0x1c218
        0x0100307e:    f9950001    ....    LDRSB    r0,[r5,#1]
        0x01003082:    f419d0e7    ....    BL       hal_nvic_enable_irq ; 0x1c254
        0x01003086:    2000        .       MOVS     r0,#0
        0x01003088:    e79b        ..      B        0x1002fc2 ; app_uart_init + 22
    $d
        0x0100308a:    0000        ..      DCW    0
        0x0100308c:    300065cc    .e.0    DCD    805332428
        0x01003090:    01007bc0    .{..    DCD    16808896
        0x01003094:    01002921    !)..    DCD    16787745
        0x01003098:    01002931    1)..    DCD    16787761
    $t
    i.app_uart_receive_async
    app_uart_receive_async
        0x0100309c:    b570        p.      PUSH     {r4-r6,lr}
        0x0100309e:    2802        .(      CMP      r0,#2
        0x010030a0:    d301        ..      BCC      0x10030a6 ; app_uart_receive_async + 10
        0x010030a2:    20e8        .       MOVS     r0,#0xe8
        0x010030a4:    bd70        p.      POP      {r4-r6,pc}
        0x010030a6:    4c13        .L      LDR      r4,[pc,#76] ; [0x10030f4] = 0x300065cc
        0x010030a8:    f8543020    T. 0    LDR      r3,[r4,r0,LSL #2]
        0x010030ac:    b14b        K.      CBZ      r3,0x10030c2 ; app_uart_receive_async + 38
        0x010030ae:    f893506c    ..lP    LDRB     r5,[r3,#0x6c]
        0x010030b2:    b135        5.      CBZ      r5,0x10030c2 ; app_uart_receive_async + 38
        0x010030b4:    b139        9.      CBZ      r1,0x10030c6 ; app_uart_receive_async + 42
        0x010030b6:    b132        2.      CBZ      r2,0x10030c6 ; app_uart_receive_async + 42
        0x010030b8:    f8935103    ...Q    LDRB     r5,[r3,#0x103]
        0x010030bc:    2d01        .-      CMP      r5,#1
        0x010030be:    d004        ..      BEQ      0x10030ca ; app_uart_receive_async + 46
        0x010030c0:    e010        ..      B        0x10030e4 ; app_uart_receive_async + 72
        0x010030c2:    20e5        .       MOVS     r0,#0xe5
        0x010030c4:    bd70        p.      POP      {r4-r6,pc}
        0x010030c6:    20e4        .       MOVS     r0,#0xe4
        0x010030c8:    bd70        p.      POP      {r4-r6,pc}
        0x010030ca:    2500        .%      MOVS     r5,#0
        0x010030cc:    f8835103    ...Q    STRB     r5,[r3,#0x103]
        0x010030d0:    f8543020    T. 0    LDR      r3,[r4,r0,LSL #2]
        0x010030d4:    685b        [h      LDR      r3,[r3,#4]
        0x010030d6:    2502        .%      MOVS     r5,#2
        0x010030d8:    f8c35088    ...P    STR      r5,[r3,#0x88]
        0x010030dc:    f8543020    T. 0    LDR      r3,[r4,r0,LSL #2]
        0x010030e0:    685b        [h      LDR      r3,[r3,#4]
        0x010030e2:    681b        .h      LDR      r3,[r3,#0]
        0x010030e4:    f8540020    T. .    LDR      r0,[r4,r0,LSL #2]
        0x010030e8:    1d00        ..      ADDS     r0,r0,#4
        0x010030ea:    f001faed    ....    BL       hal_uart_receive_it ; 0x10046c8
        0x010030ee:    2800        .(      CMP      r0,#0
        0x010030f0:    d1ea        ..      BNE      0x10030c8 ; app_uart_receive_async + 44
        0x010030f2:    bd70        p.      POP      {r4-r6,pc}
    $d
        0x010030f4:    300065cc    .e.0    DCD    805332428
    $t
    i.app_uart_start_transmit_async
    app_uart_start_transmit_async
        0x010030f8:    e92d41f0    -..A    PUSH     {r4-r8,lr}
        0x010030fc:    4604        .F      MOV      r4,r0
        0x010030fe:    4d1a        .M      LDR      r5,[pc,#104] ; [0x1003168] = 0x300065cc
        0x01003100:    f8550024    U.$.    LDR      r0,[r5,r4,LSL #2]
        0x01003104:    3070        p0      ADDS     r0,r0,#0x70
        0x01003106:    f002fe98    ....    BL       ring_buffer_items_count_get ; 0x1005e3a
        0x0100310a:    b282        ..      UXTH     r2,r0
        0x0100310c:    4616        .F      MOV      r6,r2
        0x0100310e:    2700        .'      MOVS     r7,#0
        0x01003110:    b17a        z.      CBZ      r2,0x1003132 ; app_uart_start_transmit_async + 58
        0x01003112:    f8550024    U.$.    LDR      r0,[r5,r4,LSL #2]
        0x01003116:    f8901101    ....    LDRB     r1,[r0,#0x101]
        0x0100311a:    2901        .)      CMP      r1,#1
        0x0100311c:    d009        ..      BEQ      0x1003132 ; app_uart_start_transmit_async + 58
        0x0100311e:    2a80        .*      CMP      r2,#0x80
        0x01003120:    d30e        ..      BCC      0x1003140 ; app_uart_start_transmit_async + 72
        0x01003122:    f1000180    ....    ADD      r1,r0,#0x80
        0x01003126:    3070        p0      ADDS     r0,r0,#0x70
        0x01003128:    2280        ."      MOVS     r2,#0x80
        0x0100312a:    f002fe9b    ....    BL       ring_buffer_read ; 0x1005e64
        0x0100312e:    2680        .&      MOVS     r6,#0x80
        0x01003130:    e00b        ..      B        0x100314a ; app_uart_start_transmit_async + 82
        0x01003132:    f8550024    U.$.    LDR      r0,[r5,r4,LSL #2]
        0x01003136:    f8807100    ...q    STRB     r7,[r0,#0x100]
        0x0100313a:    2000        .       MOVS     r0,#0
        0x0100313c:    e8bd81f0    ....    POP      {r4-r8,pc}
        0x01003140:    f1000180    ....    ADD      r1,r0,#0x80
        0x01003144:    3070        p0      ADDS     r0,r0,#0x70
        0x01003146:    f002fe8d    ....    BL       ring_buffer_read ; 0x1005e64
        0x0100314a:    f8550024    U.$.    LDR      r0,[r5,r4,LSL #2]
        0x0100314e:    f8807104    ...q    STRB     r7,[r0,#0x104]
        0x01003152:    f8550024    U.$.    LDR      r0,[r5,r4,LSL #2]
        0x01003156:    4632        2F      MOV      r2,r6
        0x01003158:    f1000180    ....    ADD      r1,r0,#0x80
        0x0100315c:    1d00        ..      ADDS     r0,r0,#4
        0x0100315e:    f41ed4af    ....    BL       hal_uart_transmit_it ; 0x21ac0
        0x01003162:    2800        .(      CMP      r0,#0
        0x01003164:    d1ea        ..      BNE      0x100313c ; app_uart_start_transmit_async + 68
        0x01003166:    e7e9        ..      B        0x100313c ; app_uart_start_transmit_async + 68
    $d
        0x01003168:    300065cc    .e.0    DCD    805332428
    $t
    i.app_uart_transmit_async
    app_uart_transmit_async
        0x0100316c:    b570        p.      PUSH     {r4-r6,lr}
        0x0100316e:    4604        .F      MOV      r4,r0
        0x01003170:    2c02        .,      CMP      r4,#2
        0x01003172:    d301        ..      BCC      0x1003178 ; app_uart_transmit_async + 12
        0x01003174:    20e8        .       MOVS     r0,#0xe8
        0x01003176:    bd70        p.      POP      {r4-r6,pc}
        0x01003178:    4d18        .M      LDR      r5,[pc,#96] ; [0x10031dc] = 0x300065cc
        0x0100317a:    f8550024    U.$.    LDR      r0,[r5,r4,LSL #2]
        0x0100317e:    b190        ..      CBZ      r0,0x10031a6 ; app_uart_transmit_async + 58
        0x01003180:    f890306c    ..l0    LDRB     r3,[r0,#0x6c]
        0x01003184:    b17b        {.      CBZ      r3,0x10031a6 ; app_uart_transmit_async + 58
        0x01003186:    b181        ..      CBZ      r1,0x10031aa ; app_uart_transmit_async + 62
        0x01003188:    b17a        z.      CBZ      r2,0x10031aa ; app_uart_transmit_async + 62
        0x0100318a:    2600        .&      MOVS     r6,#0
        0x0100318c:    f8806102    ...a    STRB     r6,[r0,#0x102]
        0x01003190:    f8550024    U.$.    LDR      r0,[r5,r4,LSL #2]
        0x01003194:    3070        p0      ADDS     r0,r0,#0x70
        0x01003196:    f002fea9    ....    BL       ring_buffer_write ; 0x1005eec
        0x0100319a:    f8550024    U.$.    LDR      r0,[r5,r4,LSL #2]
        0x0100319e:    f8901100    ....    LDRB     r1,[r0,#0x100]
        0x010031a2:    b121        !.      CBZ      r1,0x10031ae ; app_uart_transmit_async + 66
        0x010031a4:    e00a        ..      B        0x10031bc ; app_uart_transmit_async + 80
        0x010031a6:    20e5        .       MOVS     r0,#0xe5
        0x010031a8:    bd70        p.      POP      {r4-r6,pc}
        0x010031aa:    20e4        .       MOVS     r0,#0xe4
        0x010031ac:    bd70        p.      POP      {r4-r6,pc}
        0x010031ae:    f8901101    ....    LDRB     r1,[r0,#0x101]
        0x010031b2:    b919        ..      CBNZ     r1,0x10031bc ; app_uart_transmit_async + 80
        0x010031b4:    f890106c    ..l.    LDRB     r1,[r0,#0x6c]
        0x010031b8:    2901        .)      CMP      r1,#1
        0x010031ba:    d001        ..      BEQ      0x10031c0 ; app_uart_transmit_async + 84
        0x010031bc:    20e2        .       MOVS     r0,#0xe2
        0x010031be:    bd70        p.      POP      {r4-r6,pc}
        0x010031c0:    2101        .!      MOVS     r1,#1
        0x010031c2:    f8801100    ....    STRB     r1,[r0,#0x100]
        0x010031c6:    4620         F      MOV      r0,r4
        0x010031c8:    f7ffff96    ....    BL       app_uart_start_transmit_async ; 0x10030f8
        0x010031cc:    b120         .      CBZ      r0,0x10031d8 ; app_uart_transmit_async + 108
        0x010031ce:    f8551024    U.$.    LDR      r1,[r5,r4,LSL #2]
        0x010031d2:    f8816100    ...a    STRB     r6,[r1,#0x100]
        0x010031d6:    bd70        p.      POP      {r4-r6,pc}
        0x010031d8:    2000        .       MOVS     r0,#0
        0x010031da:    bd70        p.      POP      {r4-r6,pc}
    $d
        0x010031dc:    300065cc    .e.0    DCD    805332428
    $t
    i.app_uart_transmit_sync
    app_uart_transmit_sync
        0x010031e0:    b570        p.      PUSH     {r4-r6,lr}
        0x010031e2:    2802        .(      CMP      r0,#2
        0x010031e4:    d301        ..      BCC      0x10031ea ; app_uart_transmit_sync + 10
        0x010031e6:    20e8        .       MOVS     r0,#0xe8
        0x010031e8:    bd70        p.      POP      {r4-r6,pc}
        0x010031ea:    4d10        .M      LDR      r5,[pc,#64] ; [0x100322c] = 0x300065cc
        0x010031ec:    f8554020    U. @    LDR      r4,[r5,r0,LSL #2]
        0x010031f0:    b164        d.      CBZ      r4,0x100320c ; app_uart_transmit_sync + 44
        0x010031f2:    f894606c    ..l`    LDRB     r6,[r4,#0x6c]
        0x010031f6:    b14e        N.      CBZ      r6,0x100320c ; app_uart_transmit_sync + 44
        0x010031f8:    b151        Q.      CBZ      r1,0x1003210 ; app_uart_transmit_sync + 48
        0x010031fa:    b14a        J.      CBZ      r2,0x1003210 ; app_uart_transmit_sync + 48
        0x010031fc:    1c5e        ^.      ADDS     r6,r3,#1
        0x010031fe:    d009        ..      BEQ      0x1003214 ; app_uart_transmit_sync + 52
        0x01003200:    f6446620    D. f    MOV      r6,#0x4e20
        0x01003204:    42b3        .B      CMP      r3,r6
        0x01003206:    d905        ..      BLS      0x1003214 ; app_uart_transmit_sync + 52
        0x01003208:    20e4        .       MOVS     r0,#0xe4
        0x0100320a:    bd70        p.      POP      {r4-r6,pc}
        0x0100320c:    20e5        .       MOVS     r0,#0xe5
        0x0100320e:    bd70        p.      POP      {r4-r6,pc}
        0x01003210:    20e4        .       MOVS     r0,#0xe4
        0x01003212:    bd70        p.      POP      {r4-r6,pc}
        0x01003214:    2600        .&      MOVS     r6,#0
        0x01003216:    f8846102    ...a    STRB     r6,[r4,#0x102]
        0x0100321a:    f8550020    U. .    LDR      r0,[r5,r0,LSL #2]
        0x0100321e:    1d00        ..      ADDS     r0,r0,#4
        0x01003220:    f41ed3cd    ....    BL       hal_uart_transmit ; 0x219be
        0x01003224:    2800        .(      CMP      r0,#0
        0x01003226:    d1f4        ..      BNE      0x1003212 ; app_uart_transmit_sync + 50
        0x01003228:    bd70        p.      POP      {r4-r6,pc}
    $d
        0x0100322a:    0000        ..      DCW    0
        0x0100322c:    300065cc    .e.0    DCD    805332428
    $t
    i.append_item
    append_item
        0x01003230:    e92d41f0    -..A    PUSH     {r4-r8,lr}
        0x01003234:    4606        .F      MOV      r6,r0
        0x01003236:    460c        .F      MOV      r4,r1
        0x01003238:    4617        .F      MOV      r7,r2
        0x0100323a:    f1040508    ....    ADD      r5,r4,#8
        0x0100323e:    4620         F      MOV      r0,r4
        0x01003240:    f472d2ba    r...    BL       get_align_bytes ; 0x757b8
        0x01003244:    b2c3        ..      UXTB     r3,r0
        0x01003246:    481b        .H      LDR      r0,[pc,#108] ; [0x10032b4] = 0x8032d8
        0x01003248:    18e1        ..      ADDS     r1,r4,r3
        0x0100324a:    6842        Bh      LDR      r2,[r0,#4]
        0x0100324c:    4291        .B      CMP      r1,r2
        0x0100324e:    dd02        ..      BLE      0x1003256 ; append_item + 38
        0x01003250:    2003        .       MOVS     r0,#3
        0x01003252:    e8bd81f0    ....    POP      {r4-r8,pc}
        0x01003256:    4918        .I      LDR      r1,[pc,#96] ; [0x10032b8] = 0x8023d0
        0x01003258:    4a18        .J      LDR      r2,[pc,#96] ; [0x10032bc] = 0x8023cc
        0x0100325a:    6800        .h      LDR      r0,[r0,#0]
        0x0100325c:    6809        .h      LDR      r1,[r1,#0]
        0x0100325e:    6812        .h      LDR      r2,[r2,#0]
        0x01003260:    1a89        ..      SUBS     r1,r1,r2
        0x01003262:    1a08        ..      SUBS     r0,r1,r0
        0x01003264:    1f00        ..      SUBS     r0,r0,#4
        0x01003266:    18e9        ..      ADDS     r1,r5,r3
        0x01003268:    4281        .B      CMP      r1,r0
        0x0100326a:    d91c        ..      BLS      0x10032a6 ; append_item + 118
        0x0100326c:    f44f4500    O..E    MOV      r5,#0x8000
        0x01003270:    a213        ..      ADR      r2,{pc}+0x50 ; 0x10032c0
        0x01003272:    4629        )F      MOV      r1,r5
        0x01003274:    2000        .       MOVS     r0,#0
        0x01003276:    f409d591    ....    BL       dbg_log_printf ; 0xcd9c
        0x0100327a:    f000f923    ..#.    BL       compact_nvds ; 0x10034c4
        0x0100327e:    b130        0.      CBZ      r0,0x100328e ; append_item + 94
        0x01003280:    a218        ..      ADR      r2,{pc}+0x64 ; 0x10032e4
        0x01003282:    4629        )F      MOV      r1,r5
        0x01003284:    2000        .       MOVS     r0,#0
        0x01003286:    f409d589    ....    BL       dbg_log_printf ; 0xcd9c
        0x0100328a:    2008        .       MOVS     r0,#8
        0x0100328c:    e7e1        ..      B        0x1003252 ; append_item + 34
        0x0100328e:    a21d        ..      ADR      r2,{pc}+0x76 ; 0x1003304
        0x01003290:    4629        )F      MOV      r1,r5
        0x01003292:    2000        .       MOVS     r0,#0
        0x01003294:    f409d582    ....    BL       dbg_log_printf ; 0xcd9c
        0x01003298:    463a        :F      MOV      r2,r7
        0x0100329a:    4621        !F      MOV      r1,r4
        0x0100329c:    4630        0F      MOV      r0,r6
        0x0100329e:    e8bd41f0    ...A    POP      {r4-r8,lr}
        0x010032a2:    f003be73    ..s.    B.W      write_item ; 0x1006f8c
        0x010032a6:    463a        :F      MOV      r2,r7
        0x010032a8:    4621        !F      MOV      r1,r4
        0x010032aa:    4630        0F      MOV      r0,r6
        0x010032ac:    e8bd41f0    ...A    POP      {r4-r8,lr}
        0x010032b0:    f003be6c    ..l.    B.W      write_item ; 0x1006f8c
    $d
        0x010032b4:    008032d8    .2..    DCD    8401624
        0x010032b8:    008023d0    .#..    DCD    8397776
        0x010032bc:    008023cc    .#..    DCD    8397772
        0x010032c0:    3a353a52    R:5:    DCD    976566866
        0x010032c4:    5344564e    NVDS    DCD    1396987470
        0x010032c8:    65726120     are    DCD    1701994784
        0x010032cc:    73692061    a is    DCD    1936269409
        0x010032d0:    69656220     bei    DCD    1768251936
        0x010032d4:    6320676e    ng c    DCD    1663068014
        0x010032d8:    61706d6f    ompa    DCD    1634757999
        0x010032dc:    64657463    cted    DCD    1684370531
        0x010032e0:    000a0d2e    ....    DCD    658734
        0x010032e4:    3a353a52    R:5:    DCD    976566866
        0x010032e8:    706d6f43    Comp    DCD    1886220099
        0x010032ec:    69746361    acti    DCD    1769235297
        0x010032f0:    4e20676e    ng N    DCD    1310746478
        0x010032f4:    20534456    VDS     DCD    542327894
        0x010032f8:    6c696166    fail    DCD    1818845542
        0x010032fc:    0a0d6465    ed..    DCD    168649829
        0x01003300:    00000000    ....    DCD    0
        0x01003304:    3a353a52    R:5:    DCD    976566866
        0x01003308:    706d6f43    Comp    DCD    1886220099
        0x0100330c:    69746361    acti    DCD    1769235297
        0x01003310:    4e20676e    ng N    DCD    1310746478
        0x01003314:    20534456    VDS     DCD    542327894
        0x01003318:    63637573    succ    DCD    1667462515
        0x0100331c:    66737365    essf    DCD    1718842213
        0x01003320:    0a0d6c75    ul..    DCD    168651893
        0x01003324:    00000000    ....    DCD    0
    $t
    i.ble_communication_core_init
    ble_communication_core_init
        0x01003328:    f002bcbe    ....    B.W      rf_communication_core_init_patch ; 0x1005ca8
    i.ble_core_init_without_stack_init
    ble_core_init_without_stack_init
        0x0100332c:    b510        ..      PUSH     {r4,lr}
        0x0100332e:    f7fffffb    ....    BL       ble_communication_core_init ; 0x1003328
        0x01003332:    4905        .I      LDR      r1,[pc,#20] ; [0x1003348] = 0xa000c574
        0x01003334:    4803        .H      LDR      r0,[pc,#12] ; [0x1003344] = 0x480b817
        0x01003336:    6008        .`      STR      r0,[r1,#0]
        0x01003338:    e8bd4010    ...@    POP      {r4,lr}
        0x0100333c:    4803        .H      LDR      r0,[pc,#12] ; [0x100334c] = 0x3938700
        0x0100333e:    f4789305    x...    B        sys_ble_heartbeat_period_set ; 0x7b94c
    $d
        0x01003342:    0000        ..      DCW    0
        0x01003344:    0480b817    ....    DCD    75544599
        0x01003348:    a000c574    t...    DCD    2684405108
        0x0100334c:    03938700    ....    DCD    60000000
    $t
    i.ble_is_prevent_sleep_without_stack_init
    ble_is_prevent_sleep_without_stack_init
        0x01003350:    b510        ..      PUSH     {r4,lr}
        0x01003352:    4806        .H      LDR      r0,[pc,#24] ; [0x100336c] = 0x30006988
        0x01003354:    6800        .h      LDR      r0,[r0,#0]
        0x01003356:    2800        .(      CMP      r0,#0
        0x01003358:    d000        ..      BEQ      0x100335c ; ble_is_prevent_sleep_without_stack_init + 12
        0x0100335a:    4780        .G      BLX      r0
        0x0100335c:    f401f2c8    ....    BL       platform_rng2_calibration_is_busy ; 0x8048f0
        0x01003360:    b108        ..      CBZ      r0,0x1003366 ; ble_is_prevent_sleep_without_stack_init + 22
        0x01003362:    2001        .       MOVS     r0,#1
        0x01003364:    bd10        ..      POP      {r4,pc}
        0x01003366:    2000        .       MOVS     r0,#0
        0x01003368:    bd10        ..      POP      {r4,pc}
    $d
        0x0100336a:    0000        ..      DCW    0
        0x0100336c:    30006988    .i.0    DCD    805333384
    $t
    i.ble_sleep_successfully_without_stack_init
    ble_sleep_successfully_without_stack_init
        0x01003370:    b570        p.      PUSH     {r4-r6,lr}
        0x01003372:    4819        .H      LDR      r0,[pc,#100] ; [0x10033d8] = 0x80246c
        0x01003374:    6804        .h      LDR      r4,[r0,#0]
        0x01003376:    4d19        .M      LDR      r5,[pc,#100] ; [0x10033dc] = 0x30006980
        0x01003378:    7828        (x      LDRB     r0,[r5,#0]
        0x0100337a:    2800        .(      CMP      r0,#0
        0x0100337c:    d001        ..      BEQ      0x1003382 ; ble_sleep_successfully_without_stack_init + 18
        0x0100337e:    2000        .       MOVS     r0,#0
        0x01003380:    bd70        p.      POP      {r4-r6,pc}
        0x01003382:    f04f6080    O..`    MOV      r0,#0x4000000
        0x01003386:    f475d6b3    u...    BL       pwr_mgmt_wakeup_source_setup ; 0x790f0
        0x0100338a:    f402f321    ..!.    BL       ble_sleep_time_record ; 0x8059d0
        0x0100338e:    0860        `.      LSRS     r0,r4,#1
        0x01003390:    f476d5be    v...    BL       rwip_us_2_lpcycles ; 0x79f10
        0x01003394:    4912        .I      LDR      r1,[pc,#72] ; [0x10033e0] = 0xa000c570
        0x01003396:    6008        .`      STR      r0,[r1,#0]
        0x01003398:    1788        ..      ASRS     r0,r1,#30
        0x0100339a:    4911        .I      LDR      r1,[pc,#68] ; [0x10033e0] = 0xa000c570
        0x0100339c:    2601        .&      MOVS     r6,#1
        0x0100339e:    392c        ,9      SUBS     r1,r1,#0x2c
        0x010033a0:    6008        .`      STR      r0,[r1,#0]
        0x010033a2:    2019        .       MOVS     r0,#0x19
        0x010033a4:    f7fffae6    ....    BL       __NVIC_ClearPendingIRQ ; 0x1002974
        0x010033a8:    490e        .I      LDR      r1,[pc,#56] ; [0x10033e4] = 0xe000e100
        0x010033aa:    0670        p.      LSLS     r0,r6,#25
        0x010033ac:    6008        .`      STR      r0,[r1,#0]
        0x010033ae:    f04f4130    O.0A    MOV      r1,#0xb0000000
        0x010033b2:    6b08        .k      LDR      r0,[r1,#0x30]
        0x010033b4:    f0400007    @...    ORR      r0,r0,#7
        0x010033b8:    6308        .c      STR      r0,[r1,#0x30]
        0x010033ba:    4c09        .L      LDR      r4,[pc,#36] ; [0x10033e0] = 0xa000c570
        0x010033bc:    3c30        0<      SUBS     r4,r4,#0x30
        0x010033be:    6820         h      LDR      r0,[r4,#0]
        0x010033c0:    f44020e0    @..     ORR      r0,r0,#0x70000
        0x010033c4:    6020         `      STR      r0,[r4,#0]
        0x010033c6:    f402f345    ..E.    BL       ble_wait_for_core_sleep_stat ; 0x805a54
        0x010033ca:    702e        .p      STRB     r6,[r5,#0]
        0x010033cc:    6820         h      LDR      r0,[r4,#0]
        0x010033ce:    f42020e0     ..     BIC      r0,r0,#0x70000
        0x010033d2:    6020         `      STR      r0,[r4,#0]
        0x010033d4:    2001        .       MOVS     r0,#1
        0x010033d6:    bd70        p.      POP      {r4-r6,pc}
    $d
        0x010033d8:    0080246c    l$..    DCD    8397932
        0x010033dc:    30006980    .i.0    DCD    805333376
        0x010033e0:    a000c570    p...    DCD    2684405104
        0x010033e4:    e000e100    ....    DCD    3758153984
    $t
    i.ble_sleep_without_stack_init
    ble_sleep_without_stack_init
        0x010033e8:    b570        p.      PUSH     {r4-r6,lr}
        0x010033ea:    2400        .$      MOVS     r4,#0
        0x010033ec:    f3ef8610    ....    MRS      r6,PRIMASK
        0x010033f0:    2001        .       MOVS     r0,#1
        0x010033f2:    f3808810    ....    MSR      PRIMASK,r0
        0x010033f6:    f402f348    ..H.    BL       ble_is_in_sleep_state ; 0x805a8a
        0x010033fa:    4d10        .M      LDR      r5,[pc,#64] ; [0x100343c] = 0x80245c
        0x010033fc:    b128        (.      CBZ      r0,0x100340a ; ble_sleep_without_stack_init + 34
        0x010033fe:    2402        .$      MOVS     r4,#2
        0x01003400:    6829        )h      LDR      r1,[r5,#0]
        0x01003402:    b1b9        ..      CBZ      r1,0x1003434 ; ble_sleep_without_stack_init + 76
        0x01003404:    2002        .       MOVS     r0,#2
        0x01003406:    4788        .G      BLX      r1
        0x01003408:    e014        ..      B        0x1003434 ; ble_sleep_without_stack_init + 76
        0x0100340a:    f7ffffa1    ....    BL       ble_is_prevent_sleep_without_stack_init ; 0x1003350
        0x0100340e:    b120         .      CBZ      r0,0x100341a ; ble_sleep_without_stack_init + 50
        0x01003410:    6829        )h      LDR      r1,[r5,#0]
        0x01003412:    b179        y.      CBZ      r1,0x1003434 ; ble_sleep_without_stack_init + 76
        0x01003414:    2000        .       MOVS     r0,#0
        0x01003416:    4788        .G      BLX      r1
        0x01003418:    e00c        ..      B        0x1003434 ; ble_sleep_without_stack_init + 76
        0x0100341a:    f7ffffa9    ....    BL       ble_sleep_successfully_without_stack_init ; 0x1003370
        0x0100341e:    b128        (.      CBZ      r0,0x100342c ; ble_sleep_without_stack_init + 68
        0x01003420:    2402        .$      MOVS     r4,#2
        0x01003422:    6829        )h      LDR      r1,[r5,#0]
        0x01003424:    b131        1.      CBZ      r1,0x1003434 ; ble_sleep_without_stack_init + 76
        0x01003426:    2002        .       MOVS     r0,#2
        0x01003428:    4788        .G      BLX      r1
        0x0100342a:    e003        ..      B        0x1003434 ; ble_sleep_without_stack_init + 76
        0x0100342c:    6829        )h      LDR      r1,[r5,#0]
        0x0100342e:    b109        ..      CBZ      r1,0x1003434 ; ble_sleep_without_stack_init + 76
        0x01003430:    2000        .       MOVS     r0,#0
        0x01003432:    4788        .G      BLX      r1
        0x01003434:    f3868810    ....    MSR      PRIMASK,r6
        0x01003438:    4620         F      MOV      r0,r4
        0x0100343a:    bd70        p.      POP      {r4-r6,pc}
    $d
        0x0100343c:    0080245c    \$..    DCD    8397916
    $t
    i.ble_wakeup_osc_time_get
    ble_wakeup_osc_time_get
        0x01003440:    4903        .I      LDR      r1,[pc,#12] ; [0x1003450] = 0x30006864
        0x01003442:    eb000080    ....    ADD      r0,r0,r0,LSL #2
        0x01003446:    eb010080    ....    ADD      r0,r1,r0,LSL #2
        0x0100344a:    8880        ..      LDRH     r0,[r0,#4]
        0x0100344c:    4770        pG      BX       lr
    $d
        0x0100344e:    0000        ..      DCW    0
        0x01003450:    30006864    dh.0    DCD    805333092
    $t
    i.ble_wakeup_osc_time_set
    ble_wakeup_osc_time_set
        0x01003454:    4a03        .J      LDR      r2,[pc,#12] ; [0x1003464] = 0x30006864
        0x01003456:    eb000080    ....    ADD      r0,r0,r0,LSL #2
        0x0100345a:    eb020080    ....    ADD      r0,r2,r0,LSL #2
        0x0100345e:    8081        ..      STRH     r1,[r0,#4]
        0x01003460:    4770        pG      BX       lr
    $d
        0x01003462:    0000        ..      DCW    0
        0x01003464:    30006864    dh.0    DCD    805333092
    $t
    i.clk_period_1V_set
    clk_period_1V_set
        0x01003468:    490e        .I      LDR      r1,[pc,#56] ; [0x10034a4] = 0xa000c524
        0x0100346a:    f1100f21    ..!.    CMN      r0,#0x21
        0x0100346e:    da06        ..      BGE      0x100347e ; clk_period_1V_set + 22
        0x01003470:    6808        .h      LDR      r0,[r1,#0]
        0x01003472:    f4204070     .p@    BIC      r0,r0,#0xf000
        0x01003476:    f4405040    @.@P    ORR      r0,r0,#0x3000
        0x0100347a:    6008        .`      STR      r0,[r1,#0]
        0x0100347c:    4770        pG      BX       lr
        0x0100347e:    f110021d    ....    ADDS     r2,r0,#0x1d
        0x01003482:    d306        ..      BCC      0x1003492 ; clk_period_1V_set + 42
        0x01003484:    6808        .h      LDR      r0,[r1,#0]
        0x01003486:    f4204070     .p@    BIC      r0,r0,#0xf000
        0x0100348a:    f4404080    @..@    ORR      r0,r0,#0x4000
        0x0100348e:    6008        .`      STR      r0,[r1,#0]
        0x01003490:    4770        pG      BX       lr
        0x01003492:    280a        .(      CMP      r0,#0xa
        0x01003494:    ddfc        ..      BLE      0x1003490 ; clk_period_1V_set + 40
        0x01003496:    6808        .h      LDR      r0,[r1,#0]
        0x01003498:    f4204070     .p@    BIC      r0,r0,#0xf000
        0x0100349c:    f44040a0    @..@    ORR      r0,r0,#0x5000
        0x010034a0:    6008        .`      STR      r0,[r1,#0]
        0x010034a2:    4770        pG      BX       lr
    $d
        0x010034a4:    a000c524    $...    DCD    2684405028
    $t
    i.cold_patch_apply
    cold_patch_apply
        0x010034a8:    b510        ..      PUSH     {r4,lr}
        0x010034aa:    f002fe31    ..1.    BL       rwip_sleep_without_stack_init_replace ; 0x1006110
        0x010034ae:    f002fae1    ....    BL       pwr_mgmt_shutdown_replace ; 0x1005a74
        0x010034b2:    f003f897    ....    BL       system_conf_correction ; 0x10065e4
        0x010034b6:    f000faf5    ....    BL       dfu_cmd_handler_replace ; 0x1003aa4
        0x010034ba:    e8bd4010    ...@    POP      {r4,lr}
        0x010034be:    f002be1f    ....    B.W      rom_callback_replace ; 0x1006100
        0x010034c2:    0000        ..      MOVS     r0,r0
    i.compact_nvds
    compact_nvds
        0x010034c4:    e92d4ff0    -..O    PUSH     {r4-r11,lr}
        0x010034c8:    b087        ..      SUB      sp,sp,#0x1c
        0x010034ca:    487b        {H      LDR      r0,[pc,#492] ; [0x10036b8] = 0x300067d4
        0x010034cc:    f8d09000    ....    LDR      r9,[r0,#0]
        0x010034d0:    2400        .$      MOVS     r4,#0
        0x010034d2:    2500        .%      MOVS     r5,#0
        0x010034d4:    46a2        .F      MOV      r10,r4
        0x010034d6:    2600        .&      MOVS     r6,#0
        0x010034d8:    f003fa26    ..&.    BL       tags_cache_clean ; 0x1006928
        0x010034dc:    4877        wH      LDR      r0,[pc,#476] ; [0x10036bc] = 0x7d5ac
        0x010034de:    6801        .h      LDR      r1,[r0,#0]
        0x010034e0:    f8c91000    ....    STR      r1,[r9,#0]
        0x010034e4:    6840        @h      LDR      r0,[r0,#4]
        0x010034e6:    f8c90004    ....    STR      r0,[r9,#4]
        0x010034ea:    4875        uH      LDR      r0,[pc,#468] ; [0x10036c0] = 0x8023cc
        0x010034ec:    6800        .h      LDR      r0,[r0,#0]
        0x010034ee:    3008        .0      ADDS     r0,r0,#8
        0x010034f0:    9005        ..      STR      r0,[sp,#0x14]
        0x010034f2:    f1090008    ....    ADD      r0,r9,#8
        0x010034f6:    9006        ..      STR      r0,[sp,#0x18]
        0x010034f8:    2204        ."      MOVS     r2,#4
        0x010034fa:    a903        ..      ADD      r1,sp,#0xc
        0x010034fc:    9805        ..      LDR      r0,[sp,#0x14]
        0x010034fe:    f000fa9d    ....    BL       dec_flash_read ; 0x1003a3c
        0x01003502:    f8bd100c    ....    LDRH     r1,[sp,#0xc]
        0x01003506:    f5a1407f    ...@    SUB      r0,r1,#0xff00
        0x0100350a:    38ff        .8      SUBS     r0,r0,#0xff
        0x0100350c:    d043        C.      BEQ      0x1003596 ; compact_nvds + 210
        0x0100350e:    2208        ."      MOVS     r2,#8
        0x01003510:    a903        ..      ADD      r1,sp,#0xc
        0x01003512:    9805        ..      LDR      r0,[sp,#0x14]
        0x01003514:    f000fa92    ....    BL       dec_flash_read ; 0x1003a3c
        0x01003518:    f8bd000e    ....    LDRH     r0,[sp,#0xe]
        0x0100351c:    f472d14c    r.L.    BL       get_align_bytes ; 0x757b8
        0x01003520:    f00008ff    ....    AND      r8,r0,#0xff
        0x01003524:    f8bd000c    ....    LDRH     r0,[sp,#0xc]
        0x01003528:    2800        .(      CMP      r0,#0
        0x0100352a:    d067        g.      BEQ      0x10035fc ; compact_nvds + 312
        0x0100352c:    9806        ..      LDR      r0,[sp,#0x18]
        0x0100352e:    eba90700    ....    SUB      r7,r9,r0
        0x01003532:    f5075780    ...W    ADD      r7,r7,#0x1000
        0x01003536:    f8bd100e    ....    LDRH     r1,[sp,#0xe]
        0x0100353a:    f1080008    ....    ADD      r0,r8,#8
        0x0100353e:    4683        .F      MOV      r11,r0
        0x01003540:    4408        .D      ADD      r0,r0,r1
        0x01003542:    42b8        .B      CMP      r0,r7
        0x01003544:    d863        c.      BHI      0x100360e ; compact_nvds + 330
        0x01003546:    ab05        ..      ADD      r3,sp,#0x14
        0x01003548:    2208        ."      MOVS     r2,#8
        0x0100354a:    a903        ..      ADD      r1,sp,#0xc
        0x0100354c:    a806        ..      ADD      r0,sp,#0x18
        0x0100354e:    f000f8d7    ....    BL       cp_hdr_incr ; 0x1003700
        0x01003552:    f8bd000e    ....    LDRH     r0,[sp,#0xe]
        0x01003556:    2300        .#      MOVS     r3,#0
        0x01003558:    eb000208    ....    ADD      r2,r0,r8
        0x0100355c:    a905        ..      ADD      r1,sp,#0x14
        0x0100355e:    a806        ..      ADD      r0,sp,#0x18
        0x01003560:    f002faee    ....    BL       read_incr ; 0x1005b40
        0x01003564:    1c64        d.      ADDS     r4,r4,#1
        0x01003566:    f8bd000e    ....    LDRH     r0,[sp,#0xe]
        0x0100356a:    4458        XD      ADD      r0,r0,r11
        0x0100356c:    42b8        .B      CMP      r0,r7
        0x0100356e:    d1c3        ..      BNE      0x10034f8 ; compact_nvds + 52
        0x01003570:    2000        .       MOVS     r0,#0
        0x01003572:    e9cd6000    ...`    STRD     r6,r0,[sp,#0]
        0x01003576:    4653        SF      MOV      r3,r10
        0x01003578:    464a        JF      MOV      r2,r9
        0x0100357a:    4621        !F      MOV      r1,r4
        0x0100357c:    4628        (F      MOV      r0,r5
        0x0100357e:    f003fc1b    ....    BL       write_compacted_items ; 0x1006db8
        0x01003582:    2800        .(      CMP      r0,#0
        0x01003584:    d126        &.      BNE      0x10035d4 ; compact_nvds + 272
        0x01003586:    4682        .F      MOV      r10,r0
        0x01003588:    2600        .&      MOVS     r6,#0
        0x0100358a:    2400        .$      MOVS     r4,#0
        0x0100358c:    f8cd9018    ....    STR      r9,[sp,#0x18]
        0x01003590:    1c6d        m.      ADDS     r5,r5,#1
        0x01003592:    b2ed        ..      UXTB     r5,r5
        0x01003594:    e7b0        ..      B        0x10034f8 ; compact_nvds + 52
        0x01003596:    2000        .       MOVS     r0,#0
        0x01003598:    e9cd6000    ...`    STRD     r6,r0,[sp,#0]
        0x0100359c:    4653        SF      MOV      r3,r10
        0x0100359e:    464a        JF      MOV      r2,r9
        0x010035a0:    4621        !F      MOV      r1,r4
        0x010035a2:    4628        (F      MOV      r0,r5
        0x010035a4:    f003fc08    ....    BL       write_compacted_items ; 0x1006db8
        0x010035a8:    2800        .(      CMP      r0,#0
        0x010035aa:    d113        ..      BNE      0x10035d4 ; compact_nvds + 272
        0x010035ac:    1c6d        m.      ADDS     r5,r5,#1
        0x010035ae:    b2ec        ..      UXTB     r4,r5
        0x010035b0:    4d43        CM      LDR      r5,[pc,#268] ; [0x10036c0] = 0x8023cc
        0x010035b2:    f44f5780    O..W    MOV      r7,#0x1000
        0x010035b6:    4e43        CN      LDR      r6,[pc,#268] ; [0x10036c4] = 0x8032d8
        0x010035b8:    e008        ..      B        0x10035cc ; compact_nvds + 264
        0x010035ba:    6828        (h      LDR      r0,[r5,#0]
        0x010035bc:    eb003004    ...0    ADD      r0,r0,r4,LSL #12
        0x010035c0:    4639        9F      MOV      r1,r7
        0x010035c2:    f000febb    ....    BL       hal_flash_erase ; 0x100433c
        0x010035c6:    b140        @.      CBZ      r0,0x10035da ; compact_nvds + 278
        0x010035c8:    1c64        d.      ADDS     r4,r4,#1
        0x010035ca:    b2e4        ..      UXTB     r4,r4
        0x010035cc:    7a70        pz      LDRB     r0,[r6,#9]
        0x010035ce:    42a0        .B      CMP      r0,r4
        0x010035d0:    d8f3        ..      BHI      0x10035ba ; compact_nvds + 246
        0x010035d2:    2000        .       MOVS     r0,#0
        0x010035d4:    b007        ..      ADD      sp,sp,#0x1c
        0x010035d6:    e8bd8ff0    ....    POP      {r4-r11,pc}
        0x010035da:    483b        ;H      LDR      r0,[pc,#236] ; [0x10036c8] = 0x801f64
        0x010035dc:    6981        .i      LDR      r1,[r0,#0x18]
        0x010035de:    7a40        @z      LDRB     r0,[r0,#9]
        0x010035e0:    f240427c    @.|B    MOV      r2,#0x47c
        0x010035e4:    e9cd2000    ...     STRD     r2,r0,[sp,#0]
        0x010035e8:    9102        ..      STR      r1,[sp,#8]
        0x010035ea:    4b38        8K      LDR      r3,[pc,#224] ; [0x10036cc] = 0x1007c22
        0x010035ec:    a238        8.      ADR      r2,{pc}+0xe4 ; 0x10036d0
        0x010035ee:    f44f4100    O..A    MOV      r1,#0x8000
        0x010035f2:    2000        .       MOVS     r0,#0
        0x010035f4:    f409d3d2    ....    BL       dbg_log_printf ; 0xcd9c
        0x010035f8:    2009        .       MOVS     r0,#9
        0x010035fa:    e7eb        ..      B        0x10035d4 ; compact_nvds + 272
        0x010035fc:    f8bd000e    ....    LDRH     r0,[sp,#0xe]
        0x01003600:    9905        ..      LDR      r1,[sp,#0x14]
        0x01003602:    f1080808    ....    ADD      r8,r8,#8
        0x01003606:    4408        .D      ADD      r0,r0,r1
        0x01003608:    4440        @D      ADD      r0,r0,r8
        0x0100360a:    9005        ..      STR      r0,[sp,#0x14]
        0x0100360c:    e774        t.      B        0x10034f8 ; compact_nvds + 52
        0x0100360e:    2f08        ./      CMP      r7,#8
        0x01003610:    d329        ).      BCC      0x1003666 ; compact_nvds + 418
        0x01003612:    ab05        ..      ADD      r3,sp,#0x14
        0x01003614:    2208        ."      MOVS     r2,#8
        0x01003616:    a903        ..      ADD      r1,sp,#0xc
        0x01003618:    a806        ..      ADD      r0,sp,#0x18
        0x0100361a:    f000f871    ..q.    BL       cp_hdr_incr ; 0x1003700
        0x0100361e:    3f08        .?      SUBS     r7,r7,#8
        0x01003620:    b12f        /.      CBZ      r7,0x100362e ; compact_nvds + 362
        0x01003622:    2300        .#      MOVS     r3,#0
        0x01003624:    463a        :F      MOV      r2,r7
        0x01003626:    a905        ..      ADD      r1,sp,#0x14
        0x01003628:    a806        ..      ADD      r0,sp,#0x18
        0x0100362a:    f002fa89    ....    BL       read_incr ; 0x1005b40
        0x0100362e:    1c61        a.      ADDS     r1,r4,#1
        0x01003630:    2000        .       MOVS     r0,#0
        0x01003632:    e9cd6000    ...`    STRD     r6,r0,[sp,#0]
        0x01003636:    4653        SF      MOV      r3,r10
        0x01003638:    464a        JF      MOV      r2,r9
        0x0100363a:    4628        (F      MOV      r0,r5
        0x0100363c:    f003fbbc    ....    BL       write_compacted_items ; 0x1006db8
        0x01003640:    2800        .(      CMP      r0,#0
        0x01003642:    d1c7        ..      BNE      0x10035d4 ; compact_nvds + 272
        0x01003644:    4682        .F      MOV      r10,r0
        0x01003646:    f8bd000e    ....    LDRH     r0,[sp,#0xe]
        0x0100364a:    4440        @D      ADD      r0,r0,r8
        0x0100364c:    1bc6        ..      SUBS     r6,r0,r7
        0x0100364e:    2400        .$      MOVS     r4,#0
        0x01003650:    f8cd9018    ....    STR      r9,[sp,#0x18]
        0x01003654:    1c6d        m.      ADDS     r5,r5,#1
        0x01003656:    b2ed        ..      UXTB     r5,r5
        0x01003658:    2300        .#      MOVS     r3,#0
        0x0100365a:    4632        2F      MOV      r2,r6
        0x0100365c:    a905        ..      ADD      r1,sp,#0x14
        0x0100365e:    a806        ..      ADD      r0,sp,#0x18
        0x01003660:    f002fa6e    ..n.    BL       read_incr ; 0x1005b40
        0x01003664:    e748        H.      B        0x10034f8 ; compact_nvds + 52
        0x01003666:    ab05        ..      ADD      r3,sp,#0x14
        0x01003668:    463a        :F      MOV      r2,r7
        0x0100366a:    a903        ..      ADD      r1,sp,#0xc
        0x0100366c:    a806        ..      ADD      r0,sp,#0x18
        0x0100366e:    f000f847    ..G.    BL       cp_hdr_incr ; 0x1003700
        0x01003672:    1c61        a.      ADDS     r1,r4,#1
        0x01003674:    a803        ..      ADD      r0,sp,#0xc
        0x01003676:    e9cd6000    ...`    STRD     r6,r0,[sp,#0]
        0x0100367a:    4653        SF      MOV      r3,r10
        0x0100367c:    464a        JF      MOV      r2,r9
        0x0100367e:    4628        (F      MOV      r0,r5
        0x01003680:    f003fb9a    ....    BL       write_compacted_items ; 0x1006db8
        0x01003684:    2800        .(      CMP      r0,#0
        0x01003686:    d1a5        ..      BNE      0x10035d4 ; compact_nvds + 272
        0x01003688:    f1c70a08    ....    RSB      r10,r7,#8
        0x0100368c:    f8bd000e    ....    LDRH     r0,[sp,#0xe]
        0x01003690:    eb000608    ....    ADD      r6,r0,r8
        0x01003694:    2400        .$      MOVS     r4,#0
        0x01003696:    f8cd9018    ....    STR      r9,[sp,#0x18]
        0x0100369a:    1c6d        m.      ADDS     r5,r5,#1
        0x0100369c:    b2ed        ..      UXTB     r5,r5
        0x0100369e:    2301        .#      MOVS     r3,#1
        0x010036a0:    4652        RF      MOV      r2,r10
        0x010036a2:    a905        ..      ADD      r1,sp,#0x14
        0x010036a4:    a806        ..      ADD      r0,sp,#0x18
        0x010036a6:    f002fa4b    ..K.    BL       read_incr ; 0x1005b40
        0x010036aa:    2300        .#      MOVS     r3,#0
        0x010036ac:    4632        2F      MOV      r2,r6
        0x010036ae:    a905        ..      ADD      r1,sp,#0x14
        0x010036b0:    a806        ..      ADD      r0,sp,#0x18
        0x010036b2:    f002fa45    ..E.    BL       read_incr ; 0x1005b40
        0x010036b6:    e71f        ..      B        0x10034f8 ; compact_nvds + 52
    $d
        0x010036b8:    300067d4    .g.0    DCD    805332948
        0x010036bc:    0007d5ac    ....    DCD    513452
        0x010036c0:    008023cc    .#..    DCD    8397772
        0x010036c4:    008032d8    .2..    DCD    8401624
        0x010036c8:    00801f64    d...    DCD    8396644
        0x010036cc:    01007c22    "|..    DCD    16808994
        0x010036d0:    3a353a52    R:5:    DCD    976566866
        0x010036d4:    202c7325    %s,     DCD    539783973
        0x010036d8:    2064254c    L%d     DCD    543434060
        0x010036dc:    73616c66    flas    DCD    1935764582
        0x010036e0:    74732068    h st    DCD    1953701992
        0x010036e4:    20657461    ate     DCD    543519841
        0x010036e8:    30257830    0x%0    DCD    807761968
        0x010036ec:    202c5832    2X,     DCD    539777074
        0x010036f0:    6f727265    erro    DCD    1869771365
        0x010036f4:    78302072    r 0x    DCD    2016419954
        0x010036f8:    58383025    %08X    DCD    1480077349
        0x010036fc:    00000a0d    ....    DCD    2573
    $t
    i.cp_hdr_incr
    cp_hdr_incr
        0x01003700:    b570        p.      PUSH     {r4-r6,lr}
        0x01003702:    4604        .F      MOV      r4,r0
        0x01003704:    4615        .F      MOV      r5,r2
        0x01003706:    461e        .F      MOV      r6,r3
        0x01003708:    462a        *F      MOV      r2,r5
        0x0100370a:    6820         h      LDR      r0,[r4,#0]
        0x0100370c:    f7fefed2    ....    BL       __aeabi_memcpy ; 0x10024b4
        0x01003710:    6830        0h      LDR      r0,[r6,#0]
        0x01003712:    4428        (D      ADD      r0,r0,r5
        0x01003714:    6030        0`      STR      r0,[r6,#0]
        0x01003716:    6820         h      LDR      r0,[r4,#0]
        0x01003718:    4428        (D      ADD      r0,r0,r5
        0x0100371a:    6020         `      STR      r0,[r4,#0]
        0x0100371c:    bd70        p.      POP      {r4-r6,pc}
        0x0100371e:    0000        ..      MOVS     r0,r0
    i.cpll_calibration
    cpll_calibration
        0x01003720:    b510        ..      PUSH     {r4,lr}
        0x01003722:    4805        .H      LDR      r0,[pc,#20] ; [0x1003738] = 0x30006814
        0x01003724:    7b01        .{      LDRB     r1,[r0,#0xc]
        0x01003726:    1c49        I.      ADDS     r1,r1,#1
        0x01003728:    7301        .s      STRB     r1,[r0,#0xc]
        0x0100372a:    2000        .       MOVS     r0,#0
        0x0100372c:    f476d25e    v.^.    BL       rf_set_recalibration_flag ; 0x79bec
        0x01003730:    e8bd4010    ...@    POP      {r4,lr}
        0x01003734:    f000b844    ..D.    B.W      cpll_lock_check_recover ; 0x10037c0
    $d
        0x01003738:    30006814    .h.0    DCD    805333012
    $t
    i.cpll_calibration_init
    cpll_calibration_init
        0x0100373c:    b53e        >.      PUSH     {r1-r5,lr}
        0x0100373e:    f7fffdf3    ....    BL       ble_communication_core_init ; 0x1003328
        0x01003742:    481a        .H      LDR      r0,[pc,#104] ; [0x10037ac] = 0xa000c530
        0x01003744:    6801        .h      LDR      r1,[r0,#0]
        0x01003746:    f4213100    !..1    BIC      r1,r1,#0x20000
        0x0100374a:    6001        .`      STR      r1,[r0,#0]
        0x0100374c:    4d17        .M      LDR      r5,[pc,#92] ; [0x10037ac] = 0xa000c530
        0x0100374e:    3d08        .=      SUBS     r5,r5,#8
        0x01003750:    6828        (h      LDR      r0,[r5,#0]
        0x01003752:    4917        .I      LDR      r1,[pc,#92] ; [0x10037b0] = 0x118f0000
        0x01003754:    b280        ..      UXTH     r0,r0
        0x01003756:    4308        .C      ORRS     r0,r0,r1
        0x01003758:    6028        (`      STR      r0,[r5,#0]
        0x0100375a:    4816        .H      LDR      r0,[pc,#88] ; [0x10037b4] = 0x1003a00
        0x0100375c:    c803        ..      LDM      r0,{r0,r1}
        0x0100375e:    e9cd0100    ....    STRD     r0,r1,[sp,#0]
        0x01003762:    4812        .H      LDR      r0,[pc,#72] ; [0x10037ac] = 0xa000c530
        0x01003764:    382c        ,8      SUBS     r0,r0,#0x2c
        0x01003766:    6800        .h      LDR      r0,[r0,#0]
        0x01003768:    f0000107    ....    AND      r1,r0,#7
        0x0100376c:    f81d0001    ....    LDRB     r0,[sp,r1]
        0x01003770:    21c8        .!      MOVS     r1,#0xc8
        0x01003772:    fb10f401    ....    SMULBB   r4,r0,r1
        0x01003776:    f000fd21    ..!.    BL       hal_dwt_enable ; 0x10041bc
        0x0100377a:    480f        .H      LDR      r0,[pc,#60] ; [0x10037b8] = 0xe0001000
        0x0100377c:    6841        Ah      LDR      r1,[r0,#4]
        0x0100377e:    6842        Bh      LDR      r2,[r0,#4]
        0x01003780:    1a52        R.      SUBS     r2,r2,r1
        0x01003782:    42a2        .B      CMP      r2,r4
        0x01003784:    d3fb        ..      BCC      0x100377e ; cpll_calibration_init + 66
        0x01003786:    f000fcfd    ....    BL       hal_dwt_disable ; 0x1004184
        0x0100378a:    f002f9a1    ....    BL       read_adc_value ; 0x1005ad0
        0x0100378e:    9002        ..      STR      r0,[sp,#8]
        0x01003790:    f89d0008    ....    LDRB     r0,[sp,#8]
        0x01003794:    b128        (.      CBZ      r0,0x10037a2 ; cpll_calibration_init + 102
        0x01003796:    f89d0008    ....    LDRB     r0,[sp,#8]
        0x0100379a:    4908        .I      LDR      r1,[pc,#32] ; [0x10037bc] = 0x30006814
        0x0100379c:    6148        Ha      STR      r0,[r1,#0x14]
        0x0100379e:    6188        .a      STR      r0,[r1,#0x18]
        0x010037a0:    61c8        .a      STR      r0,[r1,#0x1c]
        0x010037a2:    6828        (h      LDR      r0,[r5,#0]
        0x010037a4:    f020407f     ..@    BIC      r0,r0,#0xff000000
        0x010037a8:    6028        (`      STR      r0,[r5,#0]
        0x010037aa:    bd3e        >.      POP      {r1-r5,pc}
    $d
        0x010037ac:    a000c530    0...    DCD    2684405040
        0x010037b0:    118f0000    ....    DCD    294584320
        0x010037b4:    01003a00    .:..    DCD    16792064
        0x010037b8:    e0001000    ....    DCD    3758100480
        0x010037bc:    30006814    .h.0    DCD    805333012
    $t
    i.cpll_lock_check_recover
    cpll_lock_check_recover
        0x010037c0:    e92d41fc    -..A    PUSH     {r2-r8,lr}
        0x010037c4:    4d29        )M      LDR      r5,[pc,#164] ; [0x100386c] = 0xa000c528
        0x010037c6:    6828        (h      LDR      r0,[r5,#0]
        0x010037c8:    f020407f     ..@    BIC      r0,r0,#0xff000000
        0x010037cc:    f0405088    @..P    ORR      r0,r0,#0x11000000
        0x010037d0:    6028        (`      STR      r0,[r5,#0]
        0x010037d2:    4827        'H      LDR      r0,[pc,#156] ; [0x1003870] = 0x1003a00
        0x010037d4:    c803        ..      LDM      r0,{r0,r1}
        0x010037d6:    e9cd0100    ....    STRD     r0,r1,[sp,#0]
        0x010037da:    4824        $H      LDR      r0,[pc,#144] ; [0x100386c] = 0xa000c528
        0x010037dc:    3824        $8      SUBS     r0,r0,#0x24
        0x010037de:    6800        .h      LDR      r0,[r0,#0]
        0x010037e0:    21c8        .!      MOVS     r1,#0xc8
        0x010037e2:    f0000007    ....    AND      r0,r0,#7
        0x010037e6:    f81d0000    ....    LDRB     r0,[sp,r0]
        0x010037ea:    fb10f401    ....    SMULBB   r4,r0,r1
        0x010037ee:    f000fce5    ....    BL       hal_dwt_enable ; 0x10041bc
        0x010037f2:    4820         H      LDR      r0,[pc,#128] ; [0x1003874] = 0xe0001000
        0x010037f4:    6841        Ah      LDR      r1,[r0,#4]
        0x010037f6:    6842        Bh      LDR      r2,[r0,#4]
        0x010037f8:    1a52        R.      SUBS     r2,r2,r1
        0x010037fa:    42a2        .B      CMP      r2,r4
        0x010037fc:    d3fb        ..      BCC      0x10037f6 ; cpll_lock_check_recover + 54
        0x010037fe:    f000fcc1    ....    BL       hal_dwt_disable ; 0x1004184
        0x01003802:    2600        .&      MOVS     r6,#0
        0x01003804:    f002f964    ..d.    BL       read_adc_value ; 0x1005ad0
        0x01003808:    4604        .F      MOV      r4,r0
        0x0100380a:    f8df806c    ..l.    LDR      r8,[pc,#108] ; [0x1003878] = 0x30006814
        0x0100380e:    f8d80018    ....    LDR      r0,[r8,#0x18]
        0x01003812:    4284        .B      CMP      r4,r0
        0x01003814:    d901        ..      BLS      0x100381a ; cpll_lock_check_recover + 90
        0x01003816:    2701        .'      MOVS     r7,#1
        0x01003818:    e000        ..      B        0x100381c ; cpll_lock_check_recover + 92
        0x0100381a:    2700        .'      MOVS     r7,#0
        0x0100381c:    f476d08c    v...    BL       rf_get_recalibration_flag ; 0x79938
        0x01003820:    b940        @.      CBNZ     r0,0x1003834 ; cpll_lock_check_recover + 116
        0x01003822:    b11f        ..      CBZ      r7,0x100382c ; cpll_lock_check_recover + 108
        0x01003824:    f8d80018    ....    LDR      r0,[r8,#0x18]
        0x01003828:    1a20         .      SUBS     r0,r4,r0
        0x0100382a:    e002        ..      B        0x1003832 ; cpll_lock_check_recover + 114
        0x0100382c:    f8d80018    ....    LDR      r0,[r8,#0x18]
        0x01003830:    1b00        ..      SUBS     r0,r0,r4
        0x01003832:    b2c6        ..      UXTB     r6,r0
        0x01003834:    f8d80018    ....    LDR      r0,[r8,#0x18]
        0x01003838:    f8c80020    .. .    STR      r0,[r8,#0x20]
        0x0100383c:    ebb60f90    ....    CMP      r6,r0,LSR #2
        0x01003840:    d803        ..      BHI      0x100384a ; cpll_lock_check_recover + 138
        0x01003842:    2c29        ),      CMP      r4,#0x29
        0x01003844:    d801        ..      BHI      0x100384a ; cpll_lock_check_recover + 138
        0x01003846:    2c11        .,      CMP      r4,#0x11
        0x01003848:    d202        ..      BCS      0x1003850 ; cpll_lock_check_recover + 144
        0x0100384a:    f000f817    ....    BL       cpll_renew_vco_base ; 0x100387c
        0x0100384e:    e007        ..      B        0x1003860 ; cpll_lock_check_recover + 160
        0x01003850:    eb0000c0    ....    ADD      r0,r0,r0,LSL #3
        0x01003854:    4420         D      ADD      r0,r0,r4
        0x01003856:    210a        .!      MOVS     r1,#0xa
        0x01003858:    fbb0f0f1    ....    UDIV     r0,r0,r1
        0x0100385c:    f8c80018    ....    STR      r0,[r8,#0x18]
        0x01003860:    6828        (h      LDR      r0,[r5,#0]
        0x01003862:    f020407f     ..@    BIC      r0,r0,#0xff000000
        0x01003866:    6028        (`      STR      r0,[r5,#0]
        0x01003868:    e8bd81fc    ....    POP      {r2-r8,pc}
    $d
        0x0100386c:    a000c528    (...    DCD    2684405032
        0x01003870:    01003a00    .:..    DCD    16792064
        0x01003874:    e0001000    ....    DCD    3758100480
        0x01003878:    30006814    .h.0    DCD    805333012
    $t
    i.cpll_renew_vco_base
    cpll_renew_vco_base
        0x0100387c:    e92d5fff    -.._    PUSH     {r0-r12,lr}
        0x01003880:    f04f0b00    O...    MOV      r11,#0
        0x01003884:    2408        .$      MOVS     r4,#8
        0x01003886:    f8df816c    ..l.    LDR      r8,[pc,#364] ; [0x10039f4] = 0x30006814
        0x0100388a:    201a        .       MOVS     r0,#0x1a
        0x0100388c:    f8c80014    ....    STR      r0,[r8,#0x14]
        0x01003890:    4859        YH      LDR      r0,[pc,#356] ; [0x10039f8] = 0xa000c528
        0x01003892:    6801        .h      LDR      r1,[r0,#0]
        0x01003894:    4a59        YJ      LDR      r2,[pc,#356] ; [0x10039fc] = 0x118f0000
        0x01003896:    b289        ..      UXTH     r1,r1
        0x01003898:    4311        .C      ORRS     r1,r1,r2
        0x0100389a:    6001        .`      STR      r1,[r0,#0]
        0x0100389c:    a803        ..      ADD      r0,sp,#0xc
        0x0100389e:    f7fefffd    ....    BL       SystemCoreGetClock ; 0x100289c
        0x010038a2:    2002        .       MOVS     r0,#2
        0x010038a4:    f7fff802    ....    BL       SystemCoreSetClock ; 0x10028ac
        0x010038a8:    f8df914c    ..L.    LDR      r9,[pc,#332] ; [0x10039f8] = 0xa000c528
        0x010038ac:    f1090908    ....    ADD      r9,r9,#8
        0x010038b0:    f8d90000    ....    LDR      r0,[r9,#0]
        0x010038b4:    f420307c     .|0    BIC      r0,r0,#0x3f000
        0x010038b8:    f4403020    @. 0    ORR      r0,r0,#0x28000
        0x010038bc:    f8c90000    ....    STR      r0,[r9,#0]
        0x010038c0:    a04f        O.      ADR      r0,{pc}+0x140 ; 0x1003a00
        0x010038c2:    c803        ..      LDM      r0,{r0,r1}
        0x010038c4:    e9cd0100    ....    STRD     r0,r1,[sp,#0]
        0x010038c8:    f8dfa12c    ..,.    LDR      r10,[pc,#300] ; [0x10039f8] = 0xa000c528
        0x010038cc:    f1aa0a24    ..$.    SUB      r10,r10,#0x24
        0x010038d0:    f8da0000    ....    LDR      r0,[r10,#0]
        0x010038d4:    21c8        .!      MOVS     r1,#0xc8
        0x010038d6:    f0000007    ....    AND      r0,r0,#7
        0x010038da:    f81d0000    ....    LDRB     r0,[sp,r0]
        0x010038de:    fb10f501    ....    SMULBB   r5,r0,r1
        0x010038e2:    f000fc6b    ..k.    BL       hal_dwt_enable ; 0x10041bc
        0x010038e6:    4f48        HO      LDR      r7,[pc,#288] ; [0x1003a08] = 0xe0001000
        0x010038e8:    6878        xh      LDR      r0,[r7,#4]
        0x010038ea:    6879        yh      LDR      r1,[r7,#4]
        0x010038ec:    1a09        ..      SUBS     r1,r1,r0
        0x010038ee:    42a9        .B      CMP      r1,r5
        0x010038f0:    d3fb        ..      BCC      0x10038ea ; cpll_renew_vco_base + 110
        0x010038f2:    f000fc47    ..G.    BL       hal_dwt_disable ; 0x1004184
        0x010038f6:    f002f8eb    ....    BL       read_adc_value ; 0x1005ad0
        0x010038fa:    9002        ..      STR      r0,[sp,#8]
        0x010038fc:    f89d1008    ....    LDRB     r1,[sp,#8]
        0x01003900:    f8d80014    ....    LDR      r0,[r8,#0x14]
        0x01003904:    4281        .B      CMP      r1,r0
        0x01003906:    d904        ..      BLS      0x1003912 ; cpll_renew_vco_base + 150
        0x01003908:    f89d2008    ...     LDRB     r2,[sp,#8]
        0x0100390c:    1c81        ..      ADDS     r1,r0,#2
        0x0100390e:    428a        .B      CMP      r2,r1
        0x01003910:    d95a        Z.      BLS      0x10039c8 ; cpll_renew_vco_base + 332
        0x01003912:    f89d1008    ....    LDRB     r1,[sp,#8]
        0x01003916:    4281        .B      CMP      r1,r0
        0x01003918:    d204        ..      BCS      0x1003924 ; cpll_renew_vco_base + 168
        0x0100391a:    f89d2008    ...     LDRB     r2,[sp,#8]
        0x0100391e:    1e81        ..      SUBS     r1,r0,#2
        0x01003920:    428a        .B      CMP      r2,r1
        0x01003922:    d251        Q.      BCS      0x10039c8 ; cpll_renew_vco_base + 332
        0x01003924:    f89d1008    ....    LDRB     r1,[sp,#8]
        0x01003928:    4281        .B      CMP      r1,r0
        0x0100392a:    d901        ..      BLS      0x1003930 ; cpll_renew_vco_base + 180
        0x0100392c:    2501        .%      MOVS     r5,#1
        0x0100392e:    e000        ..      B        0x1003932 ; cpll_renew_vco_base + 182
        0x01003930:    2500        .%      MOVS     r5,#0
        0x01003932:    b115        ..      CBZ      r5,0x100393a ; cpll_renew_vco_base + 190
        0x01003934:    1c64        d.      ADDS     r4,r4,#1
        0x01003936:    b264        d.      SXTB     r4,r4
        0x01003938:    e001        ..      B        0x100393e ; cpll_renew_vco_base + 194
        0x0100393a:    1e64        d.      SUBS     r4,r4,#1
        0x0100393c:    b264        d.      SXTB     r4,r4
        0x0100393e:    2c20         ,      CMP      r4,#0x20
        0x01003940:    d311        ..      BCC      0x1003966 ; cpll_renew_vco_base + 234
        0x01003942:    f8d90000    ....    LDR      r0,[r9,#0]
        0x01003946:    f420307c     .|0    BIC      r0,r0,#0x3f000
        0x0100394a:    f4403020    @. 0    ORR      r0,r0,#0x28000
        0x0100394e:    f8c90000    ....    STR      r0,[r9,#0]
        0x01003952:    f8d8003c    ..<.    LDR      r0,[r8,#0x3c]
        0x01003956:    1c40        @.      ADDS     r0,r0,#1
        0x01003958:    f8c8003c    ..<.    STR      r0,[r8,#0x3c]
        0x0100395c:    2000        .       MOVS     r0,#0
        0x0100395e:    9002        ..      STR      r0,[sp,#8]
        0x01003960:    f04f0b01    O...    MOV      r11,#1
        0x01003964:    e030        0.      B        0x10039c8 ; cpll_renew_vco_base + 332
        0x01003966:    f8d90000    ....    LDR      r0,[r9,#0]
        0x0100396a:    f420307c     .|0    BIC      r0,r0,#0x3f000
        0x0100396e:    ea403004    @..0    ORR      r0,r0,r4,LSL #12
        0x01003972:    f4403000    @..0    ORR      r0,r0,#0x20000
        0x01003976:    f8c90000    ....    STR      r0,[r9,#0]
        0x0100397a:    a021        !.      ADR      r0,{pc}+0x86 ; 0x1003a00
        0x0100397c:    c803        ..      LDM      r0,{r0,r1}
        0x0100397e:    e9cd0100    ....    STRD     r0,r1,[sp,#0]
        0x01003982:    f8da0000    ....    LDR      r0,[r10,#0]
        0x01003986:    2164        d!      MOVS     r1,#0x64
        0x01003988:    f0000007    ....    AND      r0,r0,#7
        0x0100398c:    f81d0000    ....    LDRB     r0,[sp,r0]
        0x01003990:    fb10f601    ....    SMULBB   r6,r0,r1
        0x01003994:    f000fc12    ....    BL       hal_dwt_enable ; 0x10041bc
        0x01003998:    6878        xh      LDR      r0,[r7,#4]
        0x0100399a:    6879        yh      LDR      r1,[r7,#4]
        0x0100399c:    1a09        ..      SUBS     r1,r1,r0
        0x0100399e:    42b1        .B      CMP      r1,r6
        0x010039a0:    d3fb        ..      BCC      0x100399a ; cpll_renew_vco_base + 286
        0x010039a2:    f000fbef    ....    BL       hal_dwt_disable ; 0x1004184
        0x010039a6:    f002f893    ....    BL       read_adc_value ; 0x1005ad0
        0x010039aa:    9002        ..      STR      r0,[sp,#8]
        0x010039ac:    b135        5.      CBZ      r5,0x10039bc ; cpll_renew_vco_base + 320
        0x010039ae:    f89d0008    ....    LDRB     r0,[sp,#8]
        0x010039b2:    f8d81014    ....    LDR      r1,[r8,#0x14]
        0x010039b6:    4288        .B      CMP      r0,r1
        0x010039b8:    d8bb        ..      BHI      0x1003932 ; cpll_renew_vco_base + 182
        0x010039ba:    e005        ..      B        0x10039c8 ; cpll_renew_vco_base + 332
        0x010039bc:    f89d0008    ....    LDRB     r0,[sp,#8]
        0x010039c0:    f8d81014    ....    LDR      r1,[r8,#0x14]
        0x010039c4:    4288        .B      CMP      r0,r1
        0x010039c6:    d3b4        ..      BCC      0x1003932 ; cpll_renew_vco_base + 182
        0x010039c8:    f89d000c    ....    LDRB     r0,[sp,#0xc]
        0x010039cc:    f7feff6e    ..n.    BL       SystemCoreSetClock ; 0x10028ac
        0x010039d0:    4809        .H      LDR      r0,[pc,#36] ; [0x10039f8] = 0xa000c528
        0x010039d2:    6801        .h      LDR      r1,[r0,#0]
        0x010039d4:    f021417f    !..A    BIC      r1,r1,#0xff000000
        0x010039d8:    6001        .`      STR      r1,[r0,#0]
        0x010039da:    f89d0008    ....    LDRB     r0,[sp,#8]
        0x010039de:    f8c80018    ....    STR      r0,[r8,#0x18]
        0x010039e2:    f8d80024    ..$.    LDR      r0,[r8,#0x24]
        0x010039e6:    1c40        @.      ADDS     r0,r0,#1
        0x010039e8:    f8c80024    ..$.    STR      r0,[r8,#0x24]
        0x010039ec:    b004        ..      ADD      sp,sp,#0x10
        0x010039ee:    4658        XF      MOV      r0,r11
        0x010039f0:    e8bd9ff0    ....    POP      {r4-r12,pc}
    $d
        0x010039f4:    30006814    .h.0    DCD    805333012
        0x010039f8:    a000c528    (...    DCD    2684405032
        0x010039fc:    118f0000    ....    DCD    294584320
        0x01003a00:    18103040    @0..    DCD    403714112
        0x01003a04:    00002010    . ..    DCD    8208
        0x01003a08:    e0001000    ....    DCD    3758100480
    $t
    i.current_shape_set
    current_shape_set
        0x01003a0c:    490a        .I      LDR      r1,[pc,#40] ; [0x1003a38] = 0xa000e000
        0x01003a0e:    2832        2(      CMP      r0,#0x32
        0x01003a10:    dd08        ..      BLE      0x1003a24 ; current_shape_set + 24
        0x01003a12:    f8d10220    .. .    LDR      r0,[r1,#0x220]
        0x01003a16:    f4206070     .p`    BIC      r0,r0,#0xf00
        0x01003a1a:    f4407040    @.@p    ORR      r0,r0,#0x300
        0x01003a1e:    f8c10220    .. .    STR      r0,[r1,#0x220]
        0x01003a22:    4770        pG      BX       lr
        0x01003a24:    2828        ((      CMP      r0,#0x28
        0x01003a26:    dafc        ..      BGE      0x1003a22 ; current_shape_set + 22
        0x01003a28:    f8d10220    .. .    LDR      r0,[r1,#0x220]
        0x01003a2c:    f4206070     .p`    BIC      r0,r0,#0xf00
        0x01003a30:    f8c10220    .. .    STR      r0,[r1,#0x220]
        0x01003a34:    4770        pG      BX       lr
    $d
        0x01003a36:    0000        ..      DCW    0
        0x01003a38:    a000e000    ....    DCD    2684411904
    $t
    i.dec_flash_read
    dec_flash_read
        0x01003a3c:    e92d41f0    -..A    PUSH     {r4-r8,lr}
        0x01003a40:    4605        .F      MOV      r5,r0
        0x01003a42:    460e        .F      MOV      r6,r1
        0x01003a44:    4617        .F      MOV      r7,r2
        0x01003a46:    4c09        .L      LDR      r4,[pc,#36] ; [0x1003a6c] = 0x8023c9
        0x01003a48:    7823        #x      LDRB     r3,[r4,#0]
        0x01003a4a:    2b00        .+      CMP      r3,#0
        0x01003a4c:    d002        ..      BEQ      0x1003a54 ; dec_flash_read + 24
        0x01003a4e:    2000        .       MOVS     r0,#0
        0x01003a50:    f472d226    r.&.    BL       hal_flash_set_security ; 0x75ea0
        0x01003a54:    463a        :F      MOV      r2,r7
        0x01003a56:    4631        1F      MOV      r1,r6
        0x01003a58:    4628        (F      MOV      r0,r5
        0x01003a5a:    f000fcaf    ....    BL       hal_flash_read ; 0x10043bc
        0x01003a5e:    4605        .F      MOV      r5,r0
        0x01003a60:    7820         x      LDRB     r0,[r4,#0]
        0x01003a62:    f472d21d    r...    BL       hal_flash_set_security ; 0x75ea0
        0x01003a66:    4628        (F      MOV      r0,r5
        0x01003a68:    e8bd81f0    ....    POP      {r4-r8,pc}
    $d
        0x01003a6c:    008023c9    .#..    DCD    8397769
    $t
    i.dec_flash_write
    dec_flash_write
        0x01003a70:    e92d41f0    -..A    PUSH     {r4-r8,lr}
        0x01003a74:    4605        .F      MOV      r5,r0
        0x01003a76:    460e        .F      MOV      r6,r1
        0x01003a78:    4617        .F      MOV      r7,r2
        0x01003a7a:    4c09        .L      LDR      r4,[pc,#36] ; [0x1003aa0] = 0x8023c9
        0x01003a7c:    7823        #x      LDRB     r3,[r4,#0]
        0x01003a7e:    2b00        .+      CMP      r3,#0
        0x01003a80:    d002        ..      BEQ      0x1003a88 ; dec_flash_write + 24
        0x01003a82:    2000        .       MOVS     r0,#0
        0x01003a84:    f472d20c    r...    BL       hal_flash_set_security ; 0x75ea0
        0x01003a88:    463a        :F      MOV      r2,r7
        0x01003a8a:    4631        1F      MOV      r1,r6
        0x01003a8c:    4628        (F      MOV      r0,r5
        0x01003a8e:    f000fca5    ....    BL       hal_flash_write_r ; 0x10043dc
        0x01003a92:    4605        .F      MOV      r5,r0
        0x01003a94:    7820         x      LDRB     r0,[r4,#0]
        0x01003a96:    f472d203    r...    BL       hal_flash_set_security ; 0x75ea0
        0x01003a9a:    4628        (F      MOV      r0,r5
        0x01003a9c:    e8bd81f0    ....    POP      {r4-r8,pc}
    $d
        0x01003aa0:    008023c9    .#..    DCD    8397769
    $t
    i.dfu_cmd_handler_replace
    dfu_cmd_handler_replace
        0x01003aa4:    2101        .!      MOVS     r1,#1
        0x01003aa6:    4a02        .J      LDR      r2,[pc,#8] ; [0x1003ab0] = 0x1003d8d
        0x01003aa8:    2000        .       MOVS     r0,#0
        0x01003aaa:    f46c905d    l.].    B        dfu_set_cmd_handler ; 0x6fb68
    $d
        0x01003aae:    0000        ..      DCW    0
        0x01003ab0:    01003d8d    .=..    DCD    16792973
    $t
    i.exflash_io_pull_config
    exflash_io_pull_config
        0x01003ab4:    b510        ..      PUSH     {r4,lr}
        0x01003ab6:    4c10        .L      LDR      r4,[pc,#64] ; [0x1003af8] = 0xa0011000
        0x01003ab8:    2202        ."      MOVS     r2,#2
        0x01003aba:    2104        .!      MOVS     r1,#4
        0x01003abc:    4620         F      MOV      r0,r4
        0x01003abe:    f001f9bd    ....    BL       ll_gpio_set_pin_pull ; 0x1004e3c
        0x01003ac2:    2201        ."      MOVS     r2,#1
        0x01003ac4:    2110        .!      MOVS     r1,#0x10
        0x01003ac6:    4620         F      MOV      r0,r4
        0x01003ac8:    f001f9b8    ....    BL       ll_gpio_set_pin_pull ; 0x1004e3c
        0x01003acc:    2202        ."      MOVS     r2,#2
        0x01003ace:    2180        .!      MOVS     r1,#0x80
        0x01003ad0:    4620         F      MOV      r0,r4
        0x01003ad2:    f001f9b3    ....    BL       ll_gpio_set_pin_pull ; 0x1004e3c
        0x01003ad6:    2202        ."      MOVS     r2,#2
        0x01003ad8:    2140        @!      MOVS     r1,#0x40
        0x01003ada:    4620         F      MOV      r0,r4
        0x01003adc:    f001f9ae    ....    BL       ll_gpio_set_pin_pull ; 0x1004e3c
        0x01003ae0:    2202        ."      MOVS     r2,#2
        0x01003ae2:    2120         !      MOVS     r1,#0x20
        0x01003ae4:    4620         F      MOV      r0,r4
        0x01003ae6:    f001f9a9    ....    BL       ll_gpio_set_pin_pull ; 0x1004e3c
        0x01003aea:    4620         F      MOV      r0,r4
        0x01003aec:    2202        ."      MOVS     r2,#2
        0x01003aee:    e8bd4010    ...@    POP      {r4,lr}
        0x01003af2:    2108        .!      MOVS     r1,#8
        0x01003af4:    f001b9a2    ....    B.W      ll_gpio_set_pin_pull ; 0x1004e3c
    $d
        0x01003af8:    a0011000    ....    DCD    2684424192
    $t
    i.find_item
    find_item
        0x01003afc:    e92d4ffe    -..O    PUSH     {r1-r11,lr}
        0x01003b00:    4607        .F      MOV      r7,r0
        0x01003b02:    460d        .F      MOV      r5,r1
        0x01003b04:    aa02        ..      ADD      r2,sp,#8
        0x01003b06:    4629        )F      MOV      r1,r5
        0x01003b08:    4638        8F      MOV      r0,r7
        0x01003b0a:    f002ffd7    ....    BL       tags_cache_rec_find ; 0x1006abc
        0x01003b0e:    b110        ..      CBZ      r0,0x1003b16 ; find_item + 26
        0x01003b10:    9802        ..      LDR      r0,[sp,#8]
        0x01003b12:    e8bd8ffe    ....    POP      {r1-r11,pc}
        0x01003b16:    9c02        ..      LDR      r4,[sp,#8]
        0x01003b18:    2600        .&      MOVS     r6,#0
        0x01003b1a:    9602        ..      STR      r6,[sp,#8]
        0x01003b1c:    f8df8068    ..h.    LDR      r8,[pc,#104] ; [0x1003b88] = 0x8023c9
        0x01003b20:    f8980000    ....    LDRB     r0,[r8,#0]
        0x01003b24:    b110        ..      CBZ      r0,0x1003b2c ; find_item + 48
        0x01003b26:    2000        .       MOVS     r0,#0
        0x01003b28:    f472d1ba    r...    BL       hal_flash_set_security ; 0x75ea0
        0x01003b2c:    f8dfa05c    ..\.    LDR      r10,[pc,#92] ; [0x1003b8c] = 0x8023d0
        0x01003b30:    f64f79ff    O..y    MOV      r9,#0xffff
        0x01003b34:    2208        ."      MOVS     r2,#8
        0x01003b36:    4669        iF      MOV      r1,sp
        0x01003b38:    4620         F      MOV      r0,r4
        0x01003b3a:    f000fc3f    ..?.    BL       hal_flash_read ; 0x10043bc
        0x01003b3e:    f8bd0000    ....    LDRH     r0,[sp,#0]
        0x01003b42:    4548        HE      CMP      r0,r9
        0x01003b44:    d102        ..      BNE      0x1003b4c ; find_item + 80
        0x01003b46:    802e        ..      STRH     r6,[r5,#0]
        0x01003b48:    9602        ..      STR      r6,[sp,#8]
        0x01003b4a:    e017        ..      B        0x1003b7c ; find_item + 128
        0x01003b4c:    42b8        .B      CMP      r0,r7
        0x01003b4e:    d106        ..      BNE      0x1003b5e ; find_item + 98
        0x01003b50:    b115        ..      CBZ      r5,0x1003b58 ; find_item + 92
        0x01003b52:    f8bd0002    ....    LDRH     r0,[sp,#2]
        0x01003b56:    8028        (.      STRH     r0,[r5,#0]
        0x01003b58:    3408        .4      ADDS     r4,r4,#8
        0x01003b5a:    9402        ..      STR      r4,[sp,#8]
        0x01003b5c:    e00e        ..      B        0x1003b7c ; find_item + 128
        0x01003b5e:    f8bd0002    ....    LDRH     r0,[sp,#2]
        0x01003b62:    f471d629    q.).    BL       get_align_bytes ; 0x757b8
        0x01003b66:    f8bd1002    ....    LDRH     r1,[sp,#2]
        0x01003b6a:    3008        .0      ADDS     r0,r0,#8
        0x01003b6c:    4421        !D      ADD      r1,r1,r4
        0x01003b6e:    1844        D.      ADDS     r4,r0,r1
        0x01003b70:    f8da0000    ....    LDR      r0,[r10,#0]
        0x01003b74:    4284        .B      CMP      r4,r0
        0x01003b76:    d3dd        ..      BCC      0x1003b34 ; find_item + 56
        0x01003b78:    802e        ..      STRH     r6,[r5,#0]
        0x01003b7a:    9602        ..      STR      r6,[sp,#8]
        0x01003b7c:    f8980000    ....    LDRB     r0,[r8,#0]
        0x01003b80:    f472d18e    r...    BL       hal_flash_set_security ; 0x75ea0
        0x01003b84:    9802        ..      LDR      r0,[sp,#8]
        0x01003b86:    e7c4        ..      B        0x1003b12 ; find_item + 22
    $d
        0x01003b88:    008023c9    .#..    DCD    8397769
        0x01003b8c:    008023d0    .#..    DCD    8397776
    $t
    i.fpb_load_state_local
    fpb_load_state_local
        0x01003b90:    b570        p.      PUSH     {r4-r6,lr}
        0x01003b92:    4604        .F      MOV      r4,r0
        0x01003b94:    bf00        ..      NOP      
        0x01003b96:    f7feff81    ....    BL       __get_PRIMASK ; 0x1002a9c
        0x01003b9a:    4605        .F      MOV      r5,r0
        0x01003b9c:    2001        .       MOVS     r0,#1
        0x01003b9e:    f7feff80    ....    BL       __set_PRIMASK ; 0x1002aa2
        0x01003ba2:    4809        .H      LDR      r0,[pc,#36] ; [0x1003bc8] = 0x30006790
        0x01003ba4:    7004        .p      STRB     r4,[r0,#0]
        0x01003ba6:    b924        $.      CBNZ     r4,0x1003bb2 ; fpb_load_state_local + 34
        0x01003ba8:    2248        H"      MOVS     r2,#0x48
        0x01003baa:    4908        .I      LDR      r1,[pc,#32] ; [0x1003bcc] = 0x30007420
        0x01003bac:    4808        .H      LDR      r0,[pc,#32] ; [0x1003bd0] = 0xe0002000
        0x01003bae:    f7fefcc6    ....    BL       __aeabi_memcpy4 ; 0x100253e
        0x01003bb2:    b91d        ..      CBNZ     r5,0x1003bbc ; fpb_load_state_local + 44
        0x01003bb4:    2000        .       MOVS     r0,#0
        0x01003bb6:    f7feff74    ..t.    BL       __set_PRIMASK ; 0x1002aa2
        0x01003bba:    e002        ..      B        0x1003bc2 ; fpb_load_state_local + 50
        0x01003bbc:    2001        .       MOVS     r0,#1
        0x01003bbe:    f7feff70    ..p.    BL       __set_PRIMASK ; 0x1002aa2
        0x01003bc2:    bf00        ..      NOP      
        0x01003bc4:    bd70        p.      POP      {r4-r6,pc}
    $d
        0x01003bc6:    0000        ..      DCW    0
        0x01003bc8:    30006790    .g.0    DCD    805332880
        0x01003bcc:    30007420     t.0    DCD    805336096
        0x01003bd0:    e0002000    . ..    DCD    3758104576
    $t
    i.fpb_patch_reg_resume
    fpb_patch_reg_resume
        0x01003bd4:    b510        ..      PUSH     {r4,lr}
        0x01003bd6:    4807        .H      LDR      r0,[pc,#28] ; [0x1003bf4] = 0x300073d8
        0x01003bd8:    6840        @h      LDR      r0,[r0,#4]
        0x01003bda:    4907        .I      LDR      r1,[pc,#28] ; [0x1003bf8] = 0xe0002000
        0x01003bdc:    6048        H`      STR      r0,[r1,#4]
        0x01003bde:    4806        .H      LDR      r0,[pc,#24] ; [0x1003bf8] = 0xe0002000
        0x01003be0:    3008        .0      ADDS     r0,r0,#8
        0x01003be2:    2240        @"      MOVS     r2,#0x40
        0x01003be4:    4903        .I      LDR      r1,[pc,#12] ; [0x1003bf4] = 0x300073d8
        0x01003be6:    3108        .1      ADDS     r1,r1,#8
        0x01003be8:    f7fefca9    ....    BL       __aeabi_memcpy4 ; 0x100253e
        0x01003bec:    2003        .       MOVS     r0,#3
        0x01003bee:    4902        .I      LDR      r1,[pc,#8] ; [0x1003bf8] = 0xe0002000
        0x01003bf0:    6008        .`      STR      r0,[r1,#0]
        0x01003bf2:    bd10        ..      POP      {r4,pc}
    $d
        0x01003bf4:    300073d8    .s.0    DCD    805336024
        0x01003bf8:    e0002000    . ..    DCD    3758104576
    $t
    i.fpb_save_state_local
    fpb_save_state_local
        0x01003bfc:    b570        p.      PUSH     {r4-r6,lr}
        0x01003bfe:    bf00        ..      NOP      
        0x01003c00:    f7feff4c    ..L.    BL       __get_PRIMASK ; 0x1002a9c
        0x01003c04:    4605        .F      MOV      r5,r0
        0x01003c06:    2001        .       MOVS     r0,#1
        0x01003c08:    f7feff4b    ..K.    BL       __set_PRIMASK ; 0x1002aa2
        0x01003c0c:    480b        .H      LDR      r0,[pc,#44] ; [0x1003c3c] = 0x30006790
        0x01003c0e:    7804        .x      LDRB     r4,[r0,#0]
        0x01003c10:    b934        4.      CBNZ     r4,0x1003c20 ; fpb_save_state_local + 36
        0x01003c12:    2248        H"      MOVS     r2,#0x48
        0x01003c14:    490a        .I      LDR      r1,[pc,#40] ; [0x1003c40] = 0xe0002000
        0x01003c16:    480b        .H      LDR      r0,[pc,#44] ; [0x1003c44] = 0x30007420
        0x01003c18:    f7fefc91    ....    BL       __aeabi_memcpy4 ; 0x100253e
        0x01003c1c:    f7ffffda    ....    BL       fpb_patch_reg_resume ; 0x1003bd4
        0x01003c20:    2001        .       MOVS     r0,#1
        0x01003c22:    4906        .I      LDR      r1,[pc,#24] ; [0x1003c3c] = 0x30006790
        0x01003c24:    7008        .p      STRB     r0,[r1,#0]
        0x01003c26:    b91d        ..      CBNZ     r5,0x1003c30 ; fpb_save_state_local + 52
        0x01003c28:    2000        .       MOVS     r0,#0
        0x01003c2a:    f7feff3a    ..:.    BL       __set_PRIMASK ; 0x1002aa2
        0x01003c2e:    e002        ..      B        0x1003c36 ; fpb_save_state_local + 58
        0x01003c30:    2001        .       MOVS     r0,#1
        0x01003c32:    f7feff36    ..6.    BL       __set_PRIMASK ; 0x1002aa2
        0x01003c36:    bf00        ..      NOP      
        0x01003c38:    4620         F      MOV      r0,r4
        0x01003c3a:    bd70        p.      POP      {r4-r6,pc}
    $d
        0x01003c3c:    30006790    .g.0    DCD    805332880
        0x01003c40:    e0002000    . ..    DCD    3758104576
        0x01003c44:    30007420     t.0    DCD    805336096
    $t
    i.fputc
    fputc
        0x01003c48:    b513        ..      PUSH     {r0,r1,r4,lr}
        0x01003c4a:    2101        .!      MOVS     r1,#1
        0x01003c4c:    4668        hF      MOV      r0,sp
        0x01003c4e:    f7fff8eb    ....    BL       app_log_data_trans ; 0x1002e28
        0x01003c52:    2001        .       MOVS     r0,#1
        0x01003c54:    bd1c        ..      POP      {r2-r4,pc}
    i.gen_hdr_checksum
    gen_hdr_checksum
        0x01003c56:    7801        .x      LDRB     r1,[r0,#0]
        0x01003c58:    7882        .x      LDRB     r2,[r0,#2]
        0x01003c5a:    4411        .D      ADD      r1,r1,r2
        0x01003c5c:    b2c9        ..      UXTB     r1,r1
        0x01003c5e:    7101        .q      STRB     r1,[r0,#4]
        0x01003c60:    4608        .F      MOV      r0,r1
        0x01003c62:    4770        pG      BX       lr
    i.gen_value_checksum
    gen_value_checksum
        0x01003c64:    b530        0.      PUSH     {r4,r5,lr}
        0x01003c66:    2200        ."      MOVS     r2,#0
        0x01003c68:    7142        Bq      STRB     r2,[r0,#5]
        0x01003c6a:    8843        C.      LDRH     r3,[r0,#2]
        0x01003c6c:    e005        ..      B        0x1003c7a ; gen_value_checksum + 22
        0x01003c6e:    7944        Dy      LDRB     r4,[r0,#5]
        0x01003c70:    5c8d        .\      LDRB     r5,[r1,r2]
        0x01003c72:    442c        ,D      ADD      r4,r4,r5
        0x01003c74:    7144        Dq      STRB     r4,[r0,#5]
        0x01003c76:    1c52        R.      ADDS     r2,r2,#1
        0x01003c78:    b292        ..      UXTH     r2,r2
        0x01003c7a:    4293        .B      CMP      r3,r2
        0x01003c7c:    d8f7        ..      BHI      0x1003c6e ; gen_value_checksum + 10
        0x01003c7e:    7940        @y      LDRB     r0,[r0,#5]
        0x01003c80:    bd30        0.      POP      {r4,r5,pc}
        0x01003c82:    0000        ..      MOVS     r0,r0
    i.get_data_from_adc
    get_data_from_adc
        0x01003c84:    b570        p.      PUSH     {r4-r6,lr}
        0x01003c86:    4606        .F      MOV      r6,r0
        0x01003c88:    ed2d8b06    -...    VPUSH    {d8-d10}
        0x01003c8c:    b088        ..      SUB      sp,sp,#0x20
        0x01003c8e:    460d        .F      MOV      r5,r1
        0x01003c90:    ed9f8b36    ..6.    VLDR     d8,[pc,#216] ; [0x1003d6c] = 0
        0x01003c94:    2120         !      MOVS     r1,#0x20
        0x01003c96:    4668        hF      MOV      r0,sp
        0x01003c98:    f7fefca5    ....    BL       __aeabi_memclr4 ; 0x10025e6
        0x01003c9c:    2400        .$      MOVS     r4,#0
        0x01003c9e:    2210        ."      MOVS     r2,#0x10
        0x01003ca0:    4669        iF      MOV      r1,sp
        0x01003ca2:    4630        0F      MOV      r0,r6
        0x01003ca4:    f7feff08    ....    BL       adc_conversion ; 0x1002ab8
        0x01003ca8:    2000        .       MOVS     r0,#0
        0x01003caa:    4669        iF      MOV      r1,sp
        0x01003cac:    f1000208    ....    ADD      r2,r0,#8
        0x01003cb0:    f8312012    1..     LDRH     r2,[r1,r2,LSL #1]
        0x01003cb4:    4422        "D      ADD      r2,r2,r4
        0x01003cb6:    b294        ..      UXTH     r4,r2
        0x01003cb8:    1c40        @.      ADDS     r0,r0,#1
        0x01003cba:    b2c0        ..      UXTB     r0,r0
        0x01003cbc:    2808        .(      CMP      r0,#8
        0x01003cbe:    d3f5        ..      BCC      0x1003cac ; get_data_from_adc + 40
        0x01003cc0:    08e4        ..      LSRS     r4,r4,#3
        0x01003cc2:    2e05        ..      CMP      r6,#5
        0x01003cc4:    d002        ..      BEQ      0x1003ccc ; get_data_from_adc + 72
        0x01003cc6:    2e06        ..      CMP      r6,#6
        0x01003cc8:    d024        $.      BEQ      0x1003d14 ; get_data_from_adc + 144
        0x01003cca:    e046        F.      B        0x1003d5a ; get_data_from_adc + 214
        0x01003ccc:    8868        h.      LDRH     r0,[r5,#2]
        0x01003cce:    f003fcb0    ....    BL       __aeabi_ui2d ; 0x1007632
        0x01003cd2:    ec410b18    A...    VMOV     d8,r0,r1
        0x01003cd6:    8828        (.      LDRH     r0,[r5,#0]
        0x01003cd8:    f003fcab    ....    BL       __aeabi_ui2d ; 0x1007632
        0x01003cdc:    ec410b19    A...    VMOV     d9,r0,r1
        0x01003ce0:    4620         F      MOV      r0,r4
        0x01003ce2:    f003fca6    ....    BL       __aeabi_ui2d ; 0x1007632
        0x01003ce6:    ec532b19    S..+    VMOV     r2,r3,d9
        0x01003cea:    f003fe05    ....    BL       __aeabi_dsub ; 0x10078f8
        0x01003cee:    ec532b18    S..+    VMOV     r2,r3,d8
        0x01003cf2:    f003fae9    ....    BL       __aeabi_ddiv ; 0x10072c8
        0x01003cf6:    ed9f1b1f    ....    VLDR     d1,[pc,#124] ; [0x1003d74] = 0x3126e979
        0x01003cfa:    ec532b11    S..+    VMOV     r2,r3,d1
        0x01003cfe:    f003fae3    ....    BL       __aeabi_ddiv ; 0x10072c8
        0x01003d02:    ed9f1b1e    ....    VLDR     d1,[pc,#120] ; [0x1003d7c] = 0
        0x01003d06:    ec532b11    S..+    VMOV     r2,r3,d1
        0x01003d0a:    f003fde9    ....    BL       __aeabi_drsub ; 0x10078e0
        0x01003d0e:    ec410b18    A...    VMOV     d8,r0,r1
        0x01003d12:    e022        ".      B        0x1003d5a ; get_data_from_adc + 214
        0x01003d14:    ed9f0b1b    ....    VLDR     d0,[pc,#108] ; [0x1003d84] = 0xb6db6db7
        0x01003d18:    ec510b10    Q...    VMOV     r0,r1,d0
        0x01003d1c:    f003f9ee    ....    BL       __aeabi_dneg ; 0x10070fc
        0x01003d20:    ec410b19    A...    VMOV     d9,r0,r1
        0x01003d24:    8868        h.      LDRH     r0,[r5,#2]
        0x01003d26:    f003fc84    ....    BL       __aeabi_ui2d ; 0x1007632
        0x01003d2a:    ec410b1a    A...    VMOV     d10,r0,r1
        0x01003d2e:    88a8        ..      LDRH     r0,[r5,#4]
        0x01003d30:    f003fc7f    ....    BL       __aeabi_ui2d ; 0x1007632
        0x01003d34:    ec410b18    A...    VMOV     d8,r0,r1
        0x01003d38:    4620         F      MOV      r0,r4
        0x01003d3a:    f003fc7a    ..z.    BL       __aeabi_ui2d ; 0x1007632
        0x01003d3e:    ec532b18    S..+    VMOV     r2,r3,d8
        0x01003d42:    f003fdd9    ....    BL       __aeabi_dsub ; 0x10078f8
        0x01003d46:    ec532b1a    S..+    VMOV     r2,r3,d10
        0x01003d4a:    f003fabd    ....    BL       __aeabi_ddiv ; 0x10072c8
        0x01003d4e:    ec532b19    S..+    VMOV     r2,r3,d9
        0x01003d52:    f003fcc7    ....    BL       __aeabi_dmul ; 0x10076e4
        0x01003d56:    ec410b18    A...    VMOV     d8,r0,r1
        0x01003d5a:    b008        ..      ADD      sp,sp,#0x20
        0x01003d5c:    eeb00a48    ..H.    VMOV.F32 s0,s16
        0x01003d60:    eef00a68    ..h.    VMOV.F32 s1,s17
        0x01003d64:    ecbd8b06    ....    VPOP     {d8-d10}
        0x01003d68:    bd70        p.      POP      {r4-r6,pc}
    $d
        0x01003d6a:    0000        ..      DCW    0
        0x01003d6c:    00000000    ....    DCD    0
        0x01003d70:    00000000    ....    DCD    0
        0x01003d74:    3126e979    y.&1    DCD    824633721
        0x01003d78:    bf5cac08    ..\.    DCD    3210521608
        0x01003d7c:    00000000    ....    DCD    0
        0x01003d80:    40390000    ..9@    DCD    1077477376
        0x01003d84:    b6db6db7    .m..    DCD    3067833783
        0x01003d88:    400edb6d    m..@    DCD    1074715501
    $t
    i.get_info
    get_info
        0x01003d8c:    b51c        ..      PUSH     {r2-r4,lr}
        0x01003d8e:    6842        Bh      LDR      r2,[r0,#4]
        0x01003d90:    2101        .!      MOVS     r1,#1
        0x01003d92:    7011        .p      STRB     r1,[r2,#0]
        0x01003d94:    2100        .!      MOVS     r1,#0
        0x01003d96:    f44f228a    O.."    MOV      r2,#0x45000
        0x01003d9a:    e005        ..      B        0x1003da8 ; get_info + 28
        0x01003d9c:    f8123b01    ...;    LDRB     r3,[r2],#1
        0x01003da0:    6844        Dh      LDR      r4,[r0,#4]
        0x01003da2:    1c49        I.      ADDS     r1,r1,#1
        0x01003da4:    5463        cT      STRB     r3,[r4,r1]
        0x01003da6:    b2c9        ..      UXTB     r1,r1
        0x01003da8:    2908        .)      CMP      r1,#8
        0x01003daa:    d3f7        ..      BCC      0x1003d9c ; get_info + 16
        0x01003dac:    4909        .I      LDR      r1,[pc,#36] ; [0x1003dd4] = 0x1007c5c
        0x01003dae:    c906        ..      LDM      r1,{r1,r2}
        0x01003db0:    e9cd1200    ....    STRD     r1,r2,[sp,#0]
        0x01003db4:    6841        Ah      LDR      r1,[r0,#4]
        0x01003db6:    9a00        ..      LDR      r2,[sp,#0]
        0x01003db8:    f8412f09    A../    STR      r2,[r1,#9]!
        0x01003dbc:    9a01        ..      LDR      r2,[sp,#4]
        0x01003dbe:    604a        J`      STR      r2,[r1,#4]
        0x01003dc0:    8802        ..      LDRH     r2,[r0,#0]
        0x01003dc2:    6840        @h      LDR      r0,[r0,#4]
        0x01003dc4:    2111        .!      MOVS     r1,#0x11
        0x01003dc6:    f46bd691    k...    BL       dfu_send_frame ; 0x6faec
        0x01003dca:    4903        .I      LDR      r1,[pc,#12] ; [0x1003dd8] = 0x802548
        0x01003dcc:    2000        .       MOVS     r0,#0
        0x01003dce:    7008        .p      STRB     r0,[r1,#0]
        0x01003dd0:    bd1c        ..      POP      {r2-r4,pc}
    $d
        0x01003dd2:    0000        ..      DCW    0
        0x01003dd4:    01007c5c    \|..    DCD    16809052
        0x01003dd8:    00802548    H%..    DCD    8398152
    $t
    i.get_patch_rep_addr
    get_patch_rep_addr
        0x01003ddc:    4602        .F      MOV      r2,r0
        0x01003dde:    2100        .!      MOVS     r1,#0
        0x01003de0:    e00b        ..      B        0x1003dfa ; get_patch_rep_addr + 30
        0x01003de2:    4808        .H      LDR      r0,[pc,#32] ; [0x1003e04] = 0x30007468
        0x01003de4:    f8503031    P.10    LDR      r3,[r0,r1,LSL #3]
        0x01003de8:    1e50        P.      SUBS     r0,r2,#1
        0x01003dea:    4283        .B      CMP      r3,r0
        0x01003dec:    d104        ..      BNE      0x1003df8 ; get_patch_rep_addr + 28
        0x01003dee:    4805        .H      LDR      r0,[pc,#20] ; [0x1003e04] = 0x30007468
        0x01003df0:    eb0000c1    ....    ADD      r0,r0,r1,LSL #3
        0x01003df4:    6840        @h      LDR      r0,[r0,#4]
        0x01003df6:    4770        pG      BX       lr
        0x01003df8:    1c49        I.      ADDS     r1,r1,#1
        0x01003dfa:    2910        .)      CMP      r1,#0x10
        0x01003dfc:    dbf1        ..      BLT      0x1003de2 ; get_patch_rep_addr + 6
        0x01003dfe:    2000        .       MOVS     r0,#0
        0x01003e00:    e7f9        ..      B        0x1003df6 ; get_patch_rep_addr + 26
    $d
        0x01003e02:    0000        ..      DCW    0
        0x01003e04:    30007468    ht.0    DCD    805336168
    $t
    i.get_pin_index
    get_pin_index
        0x01003e08:    2100        .!      MOVS     r1,#0
        0x01003e0a:    e001        ..      B        0x1003e10 ; get_pin_index + 8
        0x01003e0c:    1c49        I.      ADDS     r1,r1,#1
        0x01003e0e:    0840        @.      LSRS     r0,r0,#1
        0x01003e10:    07c2        ..      LSLS     r2,r0,#31
        0x01003e12:    d0fb        ..      BEQ      0x1003e0c ; get_pin_index + 4
        0x01003e14:    4608        .F      MOV      r0,r1
        0x01003e16:    4770        pG      BX       lr
    i.get_ton_value_for_1p5uH
    get_ton_value_for_1p5uH
        0x01003e18:    4601        .F      MOV      r1,r0
        0x01003e1a:    4817        .H      LDR      r0,[pc,#92] ; [0x1003e78] = 0xa000c510
        0x01003e1c:    6800        .h      LDR      r0,[r0,#0]
        0x01003e1e:    f3c020c2    ...     UBFX     r0,r0,#11,#3
        0x01003e22:    29dc        .)      CMP      r1,#0xdc
        0x01003e24:    da01        ..      BGE      0x1003e2a ; get_ton_value_for_1p5uH + 18
        0x01003e26:    2006        .       MOVS     r0,#6
        0x01003e28:    4770        pG      BX       lr
        0x01003e2a:    f1a102dc    ....    SUB      r2,r1,#0xdc
        0x01003e2e:    2a0a        .*      CMP      r2,#0xa
        0x01003e30:    d203        ..      BCS      0x1003e3a ; get_ton_value_for_1p5uH + 34
        0x01003e32:    2804        .(      CMP      r0,#4
        0x01003e34:    d0f8        ..      BEQ      0x1003e28 ; get_ton_value_for_1p5uH + 16
        0x01003e36:    2006        .       MOVS     r0,#6
        0x01003e38:    4770        pG      BX       lr
        0x01003e3a:    f1a102e6    ....    SUB      r2,r1,#0xe6
        0x01003e3e:    2a14        .*      CMP      r2,#0x14
        0x01003e40:    d801        ..      BHI      0x1003e46 ; get_ton_value_for_1p5uH + 46
        0x01003e42:    2004        .       MOVS     r0,#4
        0x01003e44:    4770        pG      BX       lr
        0x01003e46:    f1a102fb    ....    SUB      r2,r1,#0xfb
        0x01003e4a:    2a09        .*      CMP      r2,#9
        0x01003e4c:    d203        ..      BCS      0x1003e56 ; get_ton_value_for_1p5uH + 62
        0x01003e4e:    2803        .(      CMP      r0,#3
        0x01003e50:    d0f8        ..      BEQ      0x1003e44 ; get_ton_value_for_1p5uH + 44
        0x01003e52:    2004        .       MOVS     r0,#4
        0x01003e54:    4770        pG      BX       lr
        0x01003e56:    f5a17282    ...r    SUB      r2,r1,#0x104
        0x01003e5a:    2a28        (*      CMP      r2,#0x28
        0x01003e5c:    d801        ..      BHI      0x1003e62 ; get_ton_value_for_1p5uH + 74
        0x01003e5e:    2003        .       MOVS     r0,#3
        0x01003e60:    4770        pG      BX       lr
        0x01003e62:    f2a1112d    ..-.    SUB      r1,r1,#0x12d
        0x01003e66:    2909        .)      CMP      r1,#9
        0x01003e68:    d203        ..      BCS      0x1003e72 ; get_ton_value_for_1p5uH + 90
        0x01003e6a:    2802        .(      CMP      r0,#2
        0x01003e6c:    d0f8        ..      BEQ      0x1003e60 ; get_ton_value_for_1p5uH + 72
        0x01003e6e:    2003        .       MOVS     r0,#3
        0x01003e70:    4770        pG      BX       lr
        0x01003e72:    2002        .       MOVS     r0,#2
        0x01003e74:    4770        pG      BX       lr
    $d
        0x01003e76:    0000        ..      DCW    0
        0x01003e78:    a000c510    ....    DCD    2684405008
    $t
    i.get_ton_value_for_2p2uH
    get_ton_value_for_2p2uH
        0x01003e7c:    4601        .F      MOV      r1,r0
        0x01003e7e:    481e        .H      LDR      r0,[pc,#120] ; [0x1003ef8] = 0xa000c510
        0x01003e80:    6800        .h      LDR      r0,[r0,#0]
        0x01003e82:    f3c020c2    ...     UBFX     r0,r0,#11,#3
        0x01003e86:    29dc        .)      CMP      r1,#0xdc
        0x01003e88:    da01        ..      BGE      0x1003e8e ; get_ton_value_for_2p2uH + 18
        0x01003e8a:    2007        .       MOVS     r0,#7
        0x01003e8c:    4770        pG      BX       lr
        0x01003e8e:    f1a102dc    ....    SUB      r2,r1,#0xdc
        0x01003e92:    2a0a        .*      CMP      r2,#0xa
        0x01003e94:    d203        ..      BCS      0x1003e9e ; get_ton_value_for_2p2uH + 34
        0x01003e96:    2805        .(      CMP      r0,#5
        0x01003e98:    d0f8        ..      BEQ      0x1003e8c ; get_ton_value_for_2p2uH + 16
        0x01003e9a:    2007        .       MOVS     r0,#7
        0x01003e9c:    4770        pG      BX       lr
        0x01003e9e:    f1a102e6    ....    SUB      r2,r1,#0xe6
        0x01003ea2:    2a14        .*      CMP      r2,#0x14
        0x01003ea4:    d801        ..      BHI      0x1003eaa ; get_ton_value_for_2p2uH + 46
        0x01003ea6:    2005        .       MOVS     r0,#5
        0x01003ea8:    4770        pG      BX       lr
        0x01003eaa:    f1a102fb    ....    SUB      r2,r1,#0xfb
        0x01003eae:    2a09        .*      CMP      r2,#9
        0x01003eb0:    d203        ..      BCS      0x1003eba ; get_ton_value_for_2p2uH + 62
        0x01003eb2:    2804        .(      CMP      r0,#4
        0x01003eb4:    d0f8        ..      BEQ      0x1003ea8 ; get_ton_value_for_2p2uH + 44
        0x01003eb6:    2005        .       MOVS     r0,#5
        0x01003eb8:    4770        pG      BX       lr
        0x01003eba:    f5a17282    ...r    SUB      r2,r1,#0x104
        0x01003ebe:    2a28        (*      CMP      r2,#0x28
        0x01003ec0:    d801        ..      BHI      0x1003ec6 ; get_ton_value_for_2p2uH + 74
        0x01003ec2:    2004        .       MOVS     r0,#4
        0x01003ec4:    4770        pG      BX       lr
        0x01003ec6:    f2a1122d    ..-.    SUB      r2,r1,#0x12d
        0x01003eca:    2a09        .*      CMP      r2,#9
        0x01003ecc:    d203        ..      BCS      0x1003ed6 ; get_ton_value_for_2p2uH + 90
        0x01003ece:    2803        .(      CMP      r0,#3
        0x01003ed0:    d0f8        ..      BEQ      0x1003ec4 ; get_ton_value_for_2p2uH + 72
        0x01003ed2:    2004        .       MOVS     r0,#4
        0x01003ed4:    4770        pG      BX       lr
        0x01003ed6:    f5a1729b    ...r    SUB      r2,r1,#0x136
        0x01003eda:    2a3c        <*      CMP      r2,#0x3c
        0x01003edc:    d801        ..      BHI      0x1003ee2 ; get_ton_value_for_2p2uH + 102
        0x01003ede:    2003        .       MOVS     r0,#3
        0x01003ee0:    4770        pG      BX       lr
        0x01003ee2:    f2a11173    ..s.    SUB      r1,r1,#0x173
        0x01003ee6:    2909        .)      CMP      r1,#9
        0x01003ee8:    d203        ..      BCS      0x1003ef2 ; get_ton_value_for_2p2uH + 118
        0x01003eea:    2802        .(      CMP      r0,#2
        0x01003eec:    d0f8        ..      BEQ      0x1003ee0 ; get_ton_value_for_2p2uH + 100
        0x01003eee:    2003        .       MOVS     r0,#3
        0x01003ef0:    4770        pG      BX       lr
        0x01003ef2:    2002        .       MOVS     r0,#2
        0x01003ef4:    4770        pG      BX       lr
    $d
        0x01003ef6:    0000        ..      DCW    0
        0x01003ef8:    a000c510    ....    DCD    2684405008
    $t
    i.gr5xx_fpb_func_register
    gr5xx_fpb_func_register
        0x01003efc:    e92d47f0    -..G    PUSH     {r4-r10,lr}
        0x01003f00:    4604        .F      MOV      r4,r0
        0x01003f02:    460d        .F      MOV      r5,r1
        0x01003f04:    f04f0800    O...    MOV      r8,#0
        0x01003f08:    bf00        ..      NOP      
        0x01003f0a:    f7fefdc7    ....    BL       __get_PRIMASK ; 0x1002a9c
        0x01003f0e:    4681        .F      MOV      r9,r0
        0x01003f10:    2001        .       MOVS     r0,#1
        0x01003f12:    f7fefdc6    ....    BL       __set_PRIMASK ; 0x1002aa2
        0x01003f16:    4830        0H      LDR      r0,[pc,#192] ; [0x1003fd8] = 0x30006794
        0x01003f18:    6800        .h      LDR      r0,[r0,#0]
        0x01003f1a:    2810        .(      CMP      r0,#0x10
        0x01003f1c:    d302        ..      BCC      0x1003f24 ; gr5xx_fpb_func_register + 40
        0x01003f1e:    f04f38ff    O..8    MOV      r8,#0xffffffff
        0x01003f22:    e04b        K.      B        0x1003fbc ; gr5xx_fpb_func_register + 192
        0x01003f24:    2248        H"      MOVS     r2,#0x48
        0x01003f26:    492d        -I      LDR      r1,[pc,#180] ; [0x1003fdc] = 0xe0002000
        0x01003f28:    482d        -H      LDR      r0,[pc,#180] ; [0x1003fe0] = 0x30007420
        0x01003f2a:    f7fefb08    ....    BL       __aeabi_memcpy4 ; 0x100253e
        0x01003f2e:    2248        H"      MOVS     r2,#0x48
        0x01003f30:    492c        ,I      LDR      r1,[pc,#176] ; [0x1003fe4] = 0x300073d8
        0x01003f32:    482a        *H      LDR      r0,[pc,#168] ; [0x1003fdc] = 0xe0002000
        0x01003f34:    f7fefb03    ....    BL       __aeabi_memcpy4 ; 0x100253e
        0x01003f38:    482b        +H      LDR      r0,[pc,#172] ; [0x1003fe8] = 0x30007468
        0x01003f3a:    4927        'I      LDR      r1,[pc,#156] ; [0x1003fd8] = 0x30006794
        0x01003f3c:    6809        .h      LDR      r1,[r1,#0]
        0x01003f3e:    f8404031    @.1@    STR      r4,[r0,r1,LSL #3]
        0x01003f42:    4925        %I      LDR      r1,[pc,#148] ; [0x1003fd8] = 0x30006794
        0x01003f44:    6809        .h      LDR      r1,[r1,#0]
        0x01003f46:    eb0000c1    ....    ADD      r0,r0,r1,LSL #3
        0x01003f4a:    6045        E`      STR      r5,[r0,#4]
        0x01003f4c:    8827        '.      LDRH     r7,[r4,#0]
        0x01003f4e:    f64d76ff    M..v    MOV      r6,#0xdfff
        0x01003f52:    f0240401    $...    BIC      r4,r4,#1
        0x01003f56:    f0250501    %...    BIC      r5,r5,#1
        0x01003f5a:    f0040003    ....    AND      r0,r4,#3
        0x01003f5e:    b180        ..      CBZ      r0,0x1003f82 ; gr5xx_fpb_func_register + 134
        0x01003f60:    1ea0        ..      SUBS     r0,r4,#2
        0x01003f62:    f0400101    @...    ORR      r1,r0,#1
        0x01003f66:    481d        .H      LDR      r0,[pc,#116] ; [0x1003fdc] = 0xe0002000
        0x01003f68:    3008        .0      ADDS     r0,r0,#8
        0x01003f6a:    4a1b        .J      LDR      r2,[pc,#108] ; [0x1003fd8] = 0x30006794
        0x01003f6c:    6812        .h      LDR      r2,[r2,#0]
        0x01003f6e:    f8401022    @.".    STR      r1,[r0,r2,LSL #2]
        0x01003f72:    eb074006    ...@    ADD      r0,r7,r6,LSL #16
        0x01003f76:    491d        .I      LDR      r1,[pc,#116] ; [0x1003fec] = 0x30007600
        0x01003f78:    4a17        .J      LDR      r2,[pc,#92] ; [0x1003fd8] = 0x30006794
        0x01003f7a:    6812        .h      LDR      r2,[r2,#0]
        0x01003f7c:    f8410022    A.".    STR      r0,[r1,r2,LSL #2]
        0x01003f80:    e00c        ..      B        0x1003f9c ; gr5xx_fpb_func_register + 160
        0x01003f82:    f0440101    D...    ORR      r1,r4,#1
        0x01003f86:    4815        .H      LDR      r0,[pc,#84] ; [0x1003fdc] = 0xe0002000
        0x01003f88:    3008        .0      ADDS     r0,r0,#8
        0x01003f8a:    4a13        .J      LDR      r2,[pc,#76] ; [0x1003fd8] = 0x30006794
        0x01003f8c:    6812        .h      LDR      r2,[r2,#0]
        0x01003f8e:    f8401022    @.".    STR      r1,[r0,r2,LSL #2]
        0x01003f92:    4816        .H      LDR      r0,[pc,#88] ; [0x1003fec] = 0x30007600
        0x01003f94:    4910        .I      LDR      r1,[pc,#64] ; [0x1003fd8] = 0x30006794
        0x01003f96:    6809        .h      LDR      r1,[r1,#0]
        0x01003f98:    f8406021    @.!`    STR      r6,[r0,r1,LSL #2]
        0x01003f9c:    2248        H"      MOVS     r2,#0x48
        0x01003f9e:    490f        .I      LDR      r1,[pc,#60] ; [0x1003fdc] = 0xe0002000
        0x01003fa0:    4810        .H      LDR      r0,[pc,#64] ; [0x1003fe4] = 0x300073d8
        0x01003fa2:    f7fefacc    ....    BL       __aeabi_memcpy4 ; 0x100253e
        0x01003fa6:    2248        H"      MOVS     r2,#0x48
        0x01003fa8:    490d        .I      LDR      r1,[pc,#52] ; [0x1003fe0] = 0x30007420
        0x01003faa:    480c        .H      LDR      r0,[pc,#48] ; [0x1003fdc] = 0xe0002000
        0x01003fac:    f7fefac7    ....    BL       __aeabi_memcpy4 ; 0x100253e
        0x01003fb0:    4809        .H      LDR      r0,[pc,#36] ; [0x1003fd8] = 0x30006794
        0x01003fb2:    6800        .h      LDR      r0,[r0,#0]
        0x01003fb4:    1c40        @.      ADDS     r0,r0,#1
        0x01003fb6:    4908        .I      LDR      r1,[pc,#32] ; [0x1003fd8] = 0x30006794
        0x01003fb8:    6008        .`      STR      r0,[r1,#0]
        0x01003fba:    bf00        ..      NOP      
        0x01003fbc:    f1b90f00    ....    CMP      r9,#0
        0x01003fc0:    d103        ..      BNE      0x1003fca ; gr5xx_fpb_func_register + 206
        0x01003fc2:    2000        .       MOVS     r0,#0
        0x01003fc4:    f7fefd6d    ..m.    BL       __set_PRIMASK ; 0x1002aa2
        0x01003fc8:    e002        ..      B        0x1003fd0 ; gr5xx_fpb_func_register + 212
        0x01003fca:    2001        .       MOVS     r0,#1
        0x01003fcc:    f7fefd69    ..i.    BL       __set_PRIMASK ; 0x1002aa2
        0x01003fd0:    bf00        ..      NOP      
        0x01003fd2:    4640        @F      MOV      r0,r8
        0x01003fd4:    e8bd87f0    ....    POP      {r4-r10,pc}
    $d
        0x01003fd8:    30006794    .g.0    DCD    805332884
        0x01003fdc:    e0002000    . ..    DCD    3758104576
        0x01003fe0:    30007420     t.0    DCD    805336096
        0x01003fe4:    300073d8    .s.0    DCD    805336024
        0x01003fe8:    30007468    ht.0    DCD    805336168
        0x01003fec:    30007600    .v.0    DCD    805336576
    $t
    i.gr5xx_fpb_init
    gr5xx_fpb_init
        0x01003ff0:    b570        p.      PUSH     {r4-r6,lr}
        0x01003ff2:    4604        .F      MOV      r4,r0
        0x01003ff4:    bf00        ..      NOP      
        0x01003ff6:    f7fefd51    ..Q.    BL       __get_PRIMASK ; 0x1002a9c
        0x01003ffa:    4605        .F      MOV      r5,r0
        0x01003ffc:    2001        .       MOVS     r0,#1
        0x01003ffe:    f7fefd50    ..P.    BL       __set_PRIMASK ; 0x1002aa2
        0x01004002:    2000        .       MOVS     r0,#0
        0x01004004:    4914        .I      LDR      r1,[pc,#80] ; [0x1004058] = 0x30006790
        0x01004006:    7008        .p      STRB     r0,[r1,#0]
        0x01004008:    4814        .H      LDR      r0,[pc,#80] ; [0x100405c] = 0x1003b91
        0x0100400a:    4915        .I      LDR      r1,[pc,#84] ; [0x1004060] = 0x8026ec
        0x0100400c:    6008        .`      STR      r0,[r1,#0]
        0x0100400e:    4815        .H      LDR      r0,[pc,#84] ; [0x1004064] = 0x1003bfd
        0x01004010:    4915        .I      LDR      r1,[pc,#84] ; [0x1004068] = 0x8026e8
        0x01004012:    6008        .`      STR      r0,[r1,#0]
        0x01004014:    2248        H"      MOVS     r2,#0x48
        0x01004016:    4915        .I      LDR      r1,[pc,#84] ; [0x100406c] = 0xe0002000
        0x01004018:    4815        .H      LDR      r0,[pc,#84] ; [0x1004070] = 0x30007420
        0x0100401a:    f7fefa90    ....    BL       __aeabi_memcpy4 ; 0x100253e
        0x0100401e:    4815        .H      LDR      r0,[pc,#84] ; [0x1004074] = 0x30007600
        0x01004020:    4912        .I      LDR      r1,[pc,#72] ; [0x100406c] = 0xe0002000
        0x01004022:    6048        H`      STR      r0,[r1,#4]
        0x01004024:    2003        .       MOVS     r0,#3
        0x01004026:    6008        .`      STR      r0,[r1,#0]
        0x01004028:    2248        H"      MOVS     r2,#0x48
        0x0100402a:    4813        .H      LDR      r0,[pc,#76] ; [0x1004078] = 0x300073d8
        0x0100402c:    f7fefa87    ....    BL       __aeabi_memcpy4 ; 0x100253e
        0x01004030:    2248        H"      MOVS     r2,#0x48
        0x01004032:    490f        .I      LDR      r1,[pc,#60] ; [0x1004070] = 0x30007420
        0x01004034:    480d        .H      LDR      r0,[pc,#52] ; [0x100406c] = 0xe0002000
        0x01004036:    f7fefa82    ....    BL       __aeabi_memcpy4 ; 0x100253e
        0x0100403a:    2c88        .,      CMP      r4,#0x88
        0x0100403c:    d001        ..      BEQ      0x1004042 ; gr5xx_fpb_init + 82
        0x0100403e:    f002fad3    ....    BL       system_driver_patch_enable ; 0x10065e8
        0x01004042:    b91d        ..      CBNZ     r5,0x100404c ; gr5xx_fpb_init + 92
        0x01004044:    2000        .       MOVS     r0,#0
        0x01004046:    f7fefd2c    ..,.    BL       __set_PRIMASK ; 0x1002aa2
        0x0100404a:    e002        ..      B        0x1004052 ; gr5xx_fpb_init + 98
        0x0100404c:    2001        .       MOVS     r0,#1
        0x0100404e:    f7fefd28    ..(.    BL       __set_PRIMASK ; 0x1002aa2
        0x01004052:    bf00        ..      NOP      
        0x01004054:    bd70        p.      POP      {r4-r6,pc}
    $d
        0x01004056:    0000        ..      DCW    0
        0x01004058:    30006790    .g.0    DCD    805332880
        0x0100405c:    01003b91    .;..    DCD    16792465
        0x01004060:    008026ec    .&..    DCD    8398572
        0x01004064:    01003bfd    .;..    DCD    16792573
        0x01004068:    008026e8    .&..    DCD    8398568
        0x0100406c:    e0002000    . ..    DCD    3758104576
        0x01004070:    30007420     t.0    DCD    805336096
        0x01004074:    30007600    .v.0    DCD    805336576
        0x01004078:    300073d8    .s.0    DCD    805336024
    $t
    i.hal_adc_is_using
    hal_adc_is_using
        0x0100407c:    4805        .H      LDR      r0,[pc,#20] ; [0x1004094] = 0xa000c540
        0x0100407e:    6800        .h      LDR      r0,[r0,#0]
        0x01004080:    0fc0        ..      LSRS     r0,r0,#31
        0x01004082:    2800        .(      CMP      r0,#0
        0x01004084:    d004        ..      BEQ      0x1004090 ; hal_adc_is_using + 20
        0x01004086:    4804        .H      LDR      r0,[pc,#16] ; [0x1004098] = 0x30006814
        0x01004088:    7900        .y      LDRB     r0,[r0,#4]
        0x0100408a:    b108        ..      CBZ      r0,0x1004090 ; hal_adc_is_using + 20
        0x0100408c:    2001        .       MOVS     r0,#1
        0x0100408e:    4770        pG      BX       lr
        0x01004090:    2000        .       MOVS     r0,#0
        0x01004092:    4770        pG      BX       lr
    $d
        0x01004094:    a000c540    @...    DCD    2684405056
        0x01004098:    30006814    .h.0    DCD    805333012
    $t
    i.hal_aon_gpio_callback
    hal_aon_gpio_callback
        0x0100409c:    b5fe        ..      PUSH     {r1-r7,lr}
        0x0100409e:    4605        .F      MOV      r5,r0
        0x010040a0:    2400        .$      MOVS     r4,#0
        0x010040a2:    2003        .       MOVS     r0,#3
        0x010040a4:    f88d0000    ....    STRB     r0,[sp,#0]
        0x010040a8:    2600        .&      MOVS     r6,#0
        0x010040aa:    4f0b        .O      LDR      r7,[pc,#44] ; [0x10040d8] = 0x30006c50
        0x010040ac:    07e8        ..      LSLS     r0,r5,#31
        0x010040ae:    d00c        ..      BEQ      0x10040ca ; hal_aon_gpio_callback + 46
        0x010040b0:    2001        .       MOVS     r0,#1
        0x010040b2:    40a0        .@      LSLS     r0,r0,r4
        0x010040b4:    9001        ..      STR      r0,[sp,#4]
        0x010040b6:    eb040044    ..D.    ADD      r0,r4,r4,LSL #1
        0x010040ba:    eb070080    ....    ADD      r0,r7,r0,LSL #2
        0x010040be:    6881        .h      LDR      r1,[r0,#8]
        0x010040c0:    9102        ..      STR      r1,[sp,#8]
        0x010040c2:    6841        Ah      LDR      r1,[r0,#4]
        0x010040c4:    b109        ..      CBZ      r1,0x10040ca ; hal_aon_gpio_callback + 46
        0x010040c6:    4668        hF      MOV      r0,sp
        0x010040c8:    4788        .G      BLX      r1
        0x010040ca:    1c64        d.      ADDS     r4,r4,#1
        0x010040cc:    b2a4        ..      UXTH     r4,r4
        0x010040ce:    086d        m.      LSRS     r5,r5,#1
        0x010040d0:    1c76        v.      ADDS     r6,r6,#1
        0x010040d2:    2e08        ..      CMP      r6,#8
        0x010040d4:    dbea        ..      BLT      0x10040ac ; hal_aon_gpio_callback + 16
        0x010040d6:    bdfe        ..      POP      {r1-r7,pc}
    $d
        0x010040d8:    30006c50    Pl.0    DCD    805334096
    $t
    i.hal_aon_gpio_init
    hal_aon_gpio_init
        0x010040dc:    b570        p.      PUSH     {r4-r6,lr}
        0x010040de:    4605        .F      MOV      r5,r0
        0x010040e0:    4806        .H      LDR      r0,[pc,#24] ; [0x10040fc] = 0x300067e0
        0x010040e2:    f413d4d3    ....    BL       hal_aon_gpio_register_callback ; 0x17a8c
        0x010040e6:    f3ef8410    ....    MRS      r4,PRIMASK
        0x010040ea:    2101        .!      MOVS     r1,#1
        0x010040ec:    f3818810    ....    MSR      PRIMASK,r1
        0x010040f0:    4628        (F      MOV      r0,r5
        0x010040f2:    f000f805    ....    BL       hal_aon_gpio_init_ext ; 0x1004100
        0x010040f6:    f3848810    ....    MSR      PRIMASK,r4
        0x010040fa:    bd70        p.      POP      {r4-r6,pc}
    $d
        0x010040fc:    300067e0    .g.0    DCD    805332960
    $t
    i.hal_aon_gpio_init_ext
    hal_aon_gpio_init_ext
        0x01004100:    b500        ..      PUSH     {lr}
        0x01004102:    b085        ..      SUB      sp,sp,#0x14
        0x01004104:    6801        .h      LDR      r1,[r0,#0]
        0x01004106:    9100        ..      STR      r1,[sp,#0]
        0x01004108:    7901        .y      LDRB     r1,[r0,#4]
        0x0100410a:    f0010103    ....    AND      r1,r1,#3
        0x0100410e:    9101        ..      STR      r1,[sp,#4]
        0x01004110:    6881        .h      LDR      r1,[r0,#8]
        0x01004112:    9102        ..      STR      r1,[sp,#8]
        0x01004114:    68c1        .h      LDR      r1,[r0,#0xc]
        0x01004116:    9103        ..      STR      r1,[sp,#0xc]
        0x01004118:    6840        @h      LDR      r0,[r0,#4]
        0x0100411a:    0900        ..      LSRS     r0,r0,#4
        0x0100411c:    9004        ..      STR      r0,[sp,#0x10]
        0x0100411e:    4668        hF      MOV      r0,sp
        0x01004120:    f000fdb4    ....    BL       ll_aon_gpio_init ; 0x1004c8c
        0x01004124:    b005        ..      ADD      sp,sp,#0x14
        0x01004126:    bd00        ..      POP      {pc}
    i.hal_aon_gpio_irq_handler
    hal_aon_gpio_irq_handler
        0x01004128:    b510        ..      PUSH     {r4,lr}
        0x0100412a:    20ff        .       MOVS     r0,#0xff
        0x0100412c:    f7fefd94    ....    BL       aon_gpio_read_flag_it_patch ; 0x1002c58
        0x01004130:    b280        ..      UXTH     r0,r0
        0x01004132:    2800        .(      CMP      r0,#0
        0x01004134:    d021        !.      BEQ      0x100417a ; hal_aon_gpio_irq_handler + 82
        0x01004136:    4911        .I      LDR      r1,[pc,#68] ; [0x100417c] = 0xa0012000
        0x01004138:    6388        .c      STR      r0,[r1,#0x38]
        0x0100413a:    f3ef8110    ....    MRS      r1,PRIMASK
        0x0100413e:    2201        ."      MOVS     r2,#1
        0x01004140:    f3828810    ....    MSR      PRIMASK,r2
        0x01004144:    4a0e        .J      LDR      r2,[pc,#56] ; [0x1004180] = 0xa000c544
        0x01004146:    ea6f4300    o..C    MVN      r3,r0,LSL #16
        0x0100414a:    6013        .`      STR      r3,[r2,#0]
        0x0100414c:    f3818810    ....    MSR      PRIMASK,r1
        0x01004150:    f06f0104    o...    MVN      r1,#4
        0x01004154:    6011        .`      STR      r1,[r2,#0]
        0x01004156:    490a        .I      LDR      r1,[pc,#40] ; [0x1004180] = 0xa000c544
        0x01004158:    3940        @9      SUBS     r1,r1,#0x40
        0x0100415a:    6809        .h      LDR      r1,[r1,#0]
        0x0100415c:    f3c11100    ....    UBFX     r1,r1,#4,#1
        0x01004160:    b139        9.      CBZ      r1,0x1004172 ; hal_aon_gpio_irq_handler + 74
        0x01004162:    2820         (      CMP      r0,#0x20
        0x01004164:    d005        ..      BEQ      0x1004172 ; hal_aon_gpio_irq_handler + 74
        0x01004166:    e8bd4010    ...@    POP      {r4,lr}
        0x0100416a:    f0200020     . .    BIC      r0,r0,#0x20
        0x0100416e:    f4139405    ....    B        hal_aon_gpio_br_callback ; 0x1797c
        0x01004172:    e8bd4010    ...@    POP      {r4,lr}
        0x01004176:    f4139401    ....    B        hal_aon_gpio_br_callback ; 0x1797c
        0x0100417a:    bd10        ..      POP      {r4,pc}
    $d
        0x0100417c:    a0012000    . ..    DCD    2684428288
        0x01004180:    a000c544    D...    DCD    2684405060
    $t
    i.hal_dwt_disable
    hal_dwt_disable
        0x01004184:    f3ef8110    ....    MRS      r1,PRIMASK
        0x01004188:    2001        .       MOVS     r0,#1
        0x0100418a:    f3808810    ....    MSR      PRIMASK,r0
        0x0100418e:    4808        .H      LDR      r0,[pc,#32] ; [0x10041b0] = 0x30006798
        0x01004190:    6802        .h      LDR      r2,[r0,#0]
        0x01004192:    1e52        R.      SUBS     r2,r2,#1
        0x01004194:    6002        .`      STR      r2,[r0,#0]
        0x01004196:    6802        .h      LDR      r2,[r0,#0]
        0x01004198:    2a00        .*      CMP      r2,#0
        0x0100419a:    d105        ..      BNE      0x10041a8 ; hal_dwt_disable + 36
        0x0100419c:    6882        .h      LDR      r2,[r0,#8]
        0x0100419e:    4b05        .K      LDR      r3,[pc,#20] ; [0x10041b4] = 0xe0001000
        0x010041a0:    601a        .`      STR      r2,[r3,#0]
        0x010041a2:    6840        @h      LDR      r0,[r0,#4]
        0x010041a4:    4a04        .J      LDR      r2,[pc,#16] ; [0x10041b8] = 0xe000edfc
        0x010041a6:    6010        .`      STR      r0,[r2,#0]
        0x010041a8:    f3818810    ....    MSR      PRIMASK,r1
        0x010041ac:    4770        pG      BX       lr
    $d
        0x010041ae:    0000        ..      DCW    0
        0x010041b0:    30006798    .g.0    DCD    805332888
        0x010041b4:    e0001000    ....    DCD    3758100480
        0x010041b8:    e000edfc    ....    DCD    3758157308
    $t
    i.hal_dwt_enable
    hal_dwt_enable
        0x010041bc:    b510        ..      PUSH     {r4,lr}
        0x010041be:    f3ef8110    ....    MRS      r1,PRIMASK
        0x010041c2:    2001        .       MOVS     r0,#1
        0x010041c4:    f3808810    ....    MSR      PRIMASK,r0
        0x010041c8:    480b        .H      LDR      r0,[pc,#44] ; [0x10041f8] = 0x30006798
        0x010041ca:    6802        .h      LDR      r2,[r0,#0]
        0x010041cc:    2a00        .*      CMP      r2,#0
        0x010041ce:    d10d        ..      BNE      0x10041ec ; hal_dwt_enable + 48
        0x010041d0:    4b0a        .K      LDR      r3,[pc,#40] ; [0x10041fc] = 0xe000edfc
        0x010041d2:    681a        .h      LDR      r2,[r3,#0]
        0x010041d4:    6042        B`      STR      r2,[r0,#4]
        0x010041d6:    4a0a        .J      LDR      r2,[pc,#40] ; [0x1004200] = 0xe0001000
        0x010041d8:    6814        .h      LDR      r4,[r2,#0]
        0x010041da:    6084        .`      STR      r4,[r0,#8]
        0x010041dc:    6844        Dh      LDR      r4,[r0,#4]
        0x010041de:    f0447480    D..t    ORR      r4,r4,#0x1000000
        0x010041e2:    601c        .`      STR      r4,[r3,#0]
        0x010041e4:    6883        .h      LDR      r3,[r0,#8]
        0x010041e6:    f0430301    C...    ORR      r3,r3,#1
        0x010041ea:    6013        .`      STR      r3,[r2,#0]
        0x010041ec:    6802        .h      LDR      r2,[r0,#0]
        0x010041ee:    1c52        R.      ADDS     r2,r2,#1
        0x010041f0:    6002        .`      STR      r2,[r0,#0]
        0x010041f2:    f3818810    ....    MSR      PRIMASK,r1
        0x010041f6:    bd10        ..      POP      {r4,pc}
    $d
        0x010041f8:    30006798    .g.0    DCD    805332888
        0x010041fc:    e000edfc    ....    DCD    3758157308
        0x01004200:    e0001000    ....    DCD    3758100480
    $t
    i.hal_efuse_deinit_ext
    hal_efuse_deinit_ext
        0x01004204:    b510        ..      PUSH     {r4,lr}
        0x01004206:    4604        .F      MOV      r4,r0
        0x01004208:    2c00        .,      CMP      r4,#0
        0x0100420a:    d01d        ..      BEQ      0x1004248 ; hal_efuse_deinit_ext + 68
        0x0100420c:    7a20         z      LDRB     r0,[r4,#8]
        0x0100420e:    2801        .(      CMP      r0,#1
        0x01004210:    d01c        ..      BEQ      0x100424c ; hal_efuse_deinit_ext + 72
        0x01004212:    2001        .       MOVS     r0,#1
        0x01004214:    7220         r      STRB     r0,[r4,#8]
        0x01004216:    481a        .H      LDR      r0,[pc,#104] ; [0x1004280] = 0x800384
        0x01004218:    6800        .h      LDR      r0,[r0,#0]
        0x0100421a:    b118        ..      CBZ      r0,0x1004224 ; hal_efuse_deinit_ext + 32
        0x0100421c:    6841        Ah      LDR      r1,[r0,#4]
        0x0100421e:    b109        ..      CBZ      r1,0x1004224 ; hal_efuse_deinit_ext + 32
        0x01004220:    4620         F      MOV      r0,r4
        0x01004222:    4788        .G      BLX      r1
        0x01004224:    4817        .H      LDR      r0,[pc,#92] ; [0x1004284] = 0xa000c514
        0x01004226:    6801        .h      LDR      r1,[r0,#0]
        0x01004228:    f4216180    !..a    BIC      r1,r1,#0x400
        0x0100422c:    6001        .`      STR      r1,[r0,#0]
        0x0100422e:    f3ef8110    ....    MRS      r1,PRIMASK
        0x01004232:    2001        .       MOVS     r0,#1
        0x01004234:    f3808810    ....    MSR      PRIMASK,r0
        0x01004238:    4813        .H      LDR      r0,[pc,#76] ; [0x1004288] = 0x30006954
        0x0100423a:    6802        .h      LDR      r2,[r0,#0]
        0x0100423c:    f0220202    "...    BIC      r2,r2,#2
        0x01004240:    6002        .`      STR      r2,[r0,#0]
        0x01004242:    6800        .h      LDR      r0,[r0,#0]
        0x01004244:    b120         .      CBZ      r0,0x1004250 ; hal_efuse_deinit_ext + 76
        0x01004246:    e014        ..      B        0x1004272 ; hal_efuse_deinit_ext + 110
        0x01004248:    2001        .       MOVS     r0,#1
        0x0100424a:    bd10        ..      POP      {r4,pc}
        0x0100424c:    2002        .       MOVS     r0,#2
        0x0100424e:    bd10        ..      POP      {r4,pc}
        0x01004250:    480e        .H      LDR      r0,[pc,#56] ; [0x100428c] = 0xa000e2a0
        0x01004252:    6842        Bh      LDR      r2,[r0,#4]
        0x01004254:    f0420201    B...    ORR      r2,r2,#1
        0x01004258:    6042        B`      STR      r2,[r0,#4]
        0x0100425a:    68c2        .h      LDR      r2,[r0,#0xc]
        0x0100425c:    f0427200    B..r    ORR      r2,r2,#0x2000000
        0x01004260:    60c2        .`      STR      r2,[r0,#0xc]
        0x01004262:    6802        .h      LDR      r2,[r0,#0]
        0x01004264:    f0420201    B...    ORR      r2,r2,#1
        0x01004268:    6002        .`      STR      r2,[r0,#0]
        0x0100426a:    68c2        .h      LDR      r2,[r0,#0xc]
        0x0100426c:    f0427280    B..r    ORR      r2,r2,#0x1000000
        0x01004270:    60c2        .`      STR      r2,[r0,#0xc]
        0x01004272:    f3818810    ....    MSR      PRIMASK,r1
        0x01004276:    2000        .       MOVS     r0,#0
        0x01004278:    60e0        .`      STR      r0,[r4,#0xc]
        0x0100427a:    7260        `r      STRB     r0,[r4,#9]
        0x0100427c:    7220         r      STRB     r0,[r4,#8]
        0x0100427e:    bd10        ..      POP      {r4,pc}
    $d
        0x01004280:    00800384    ....    DCD    8389508
        0x01004284:    a000c514    ....    DCD    2684405012
        0x01004288:    30006954    Ti.0    DCD    805333332
        0x0100428c:    a000e2a0    ....    DCD    2684412576
    $t
    i.hal_efuse_init_ext
    hal_efuse_init_ext
        0x01004290:    b570        p.      PUSH     {r4-r6,lr}
        0x01004292:    4604        .F      MOV      r4,r0
        0x01004294:    2c00        .,      CMP      r4,#0
        0x01004296:    d003        ..      BEQ      0x10042a0 ; hal_efuse_init_ext + 16
        0x01004298:    4923        #I      LDR      r1,[pc,#140] ; [0x1004328] = 0xa0016400
        0x0100429a:    6820         h      LDR      r0,[r4,#0]
        0x0100429c:    4288        .B      CMP      r0,r1
        0x0100429e:    d001        ..      BEQ      0x10042a4 ; hal_efuse_init_ext + 20
        0x010042a0:    2001        .       MOVS     r0,#1
        0x010042a2:    bd70        p.      POP      {r4-r6,pc}
        0x010042a4:    7a20         z      LDRB     r0,[r4,#8]
        0x010042a6:    2801        .(      CMP      r0,#1
        0x010042a8:    d005        ..      BEQ      0x10042b6 ; hal_efuse_init_ext + 38
        0x010042aa:    2501        .%      MOVS     r5,#1
        0x010042ac:    7225        %r      STRB     r5,[r4,#8]
        0x010042ae:    7a60        `z      LDRB     r0,[r4,#9]
        0x010042b0:    2600        .&      MOVS     r6,#0
        0x010042b2:    b110        ..      CBZ      r0,0x10042ba ; hal_efuse_init_ext + 42
        0x010042b4:    e01e        ..      B        0x10042f4 ; hal_efuse_init_ext + 100
        0x010042b6:    2002        .       MOVS     r0,#2
        0x010042b8:    bd70        p.      POP      {r4-r6,pc}
        0x010042ba:    7226        &r      STRB     r6,[r4,#8]
        0x010042bc:    481b        .H      LDR      r0,[pc,#108] ; [0x100432c] = 0xa000e2a4
        0x010042be:    6801        .h      LDR      r1,[r0,#0]
        0x010042c0:    f0210101    !...    BIC      r1,r1,#1
        0x010042c4:    6001        .`      STR      r1,[r0,#0]
        0x010042c6:    6881        .h      LDR      r1,[r0,#8]
        0x010042c8:    f0217100    !..q    BIC      r1,r1,#0x2000000
        0x010042cc:    6081        .`      STR      r1,[r0,#8]
        0x010042ce:    f3ef8010    ....    MRS      r0,PRIMASK
        0x010042d2:    2101        .!      MOVS     r1,#1
        0x010042d4:    f3818810    ....    MSR      PRIMASK,r1
        0x010042d8:    4915        .I      LDR      r1,[pc,#84] ; [0x1004330] = 0x30006954
        0x010042da:    680a        .h      LDR      r2,[r1,#0]
        0x010042dc:    f0420202    B...    ORR      r2,r2,#2
        0x010042e0:    600a        .`      STR      r2,[r1,#0]
        0x010042e2:    f3808810    ....    MSR      PRIMASK,r0
        0x010042e6:    4813        .H      LDR      r0,[pc,#76] ; [0x1004334] = 0x800384
        0x010042e8:    6800        .h      LDR      r0,[r0,#0]
        0x010042ea:    b118        ..      CBZ      r0,0x10042f4 ; hal_efuse_init_ext + 100
        0x010042ec:    6801        .h      LDR      r1,[r0,#0]
        0x010042ee:    b109        ..      CBZ      r1,0x10042f4 ; hal_efuse_init_ext + 100
        0x010042f0:    4620         F      MOV      r0,r4
        0x010042f2:    4788        .G      BLX      r1
        0x010042f4:    2002        .       MOVS     r0,#2
        0x010042f6:    7260        `r      STRB     r0,[r4,#9]
        0x010042f8:    480f        .H      LDR      r0,[pc,#60] ; [0x1004338] = 0xa000c514
        0x010042fa:    6801        .h      LDR      r1,[r0,#0]
        0x010042fc:    f4416180    A..a    ORR      r1,r1,#0x400
        0x01004300:    6001        .`      STR      r1,[r0,#0]
        0x01004302:    6860        `h      LDR      r0,[r4,#4]
        0x01004304:    2801        .(      CMP      r0,#1
        0x01004306:    d009        ..      BEQ      0x100431c ; hal_efuse_init_ext + 140
        0x01004308:    6820         h      LDR      r0,[r4,#0]
        0x0100430a:    6801        .h      LDR      r1,[r0,#0]
        0x0100430c:    f4215180    !..Q    BIC      r1,r1,#0x1000
        0x01004310:    6001        .`      STR      r1,[r0,#0]
        0x01004312:    4630        0F      MOV      r0,r6
        0x01004314:    60e6        .`      STR      r6,[r4,#0xc]
        0x01004316:    7265        er      STRB     r5,[r4,#9]
        0x01004318:    7220         r      STRB     r0,[r4,#8]
        0x0100431a:    bd70        p.      POP      {r4-r6,pc}
        0x0100431c:    6820         h      LDR      r0,[r4,#0]
        0x0100431e:    6801        .h      LDR      r1,[r0,#0]
        0x01004320:    f4415180    A..Q    ORR      r1,r1,#0x1000
        0x01004324:    6001        .`      STR      r1,[r0,#0]
        0x01004326:    e7f4        ..      B        0x1004312 ; hal_efuse_init_ext + 130
    $d
        0x01004328:    a0016400    .d..    DCD    2684445696
        0x0100432c:    a000e2a4    ....    DCD    2684412580
        0x01004330:    30006954    Ti.0    DCD    805333332
        0x01004334:    00800384    ....    DCD    8389508
        0x01004338:    a000c514    ....    DCD    2684405012
    $t
    i.hal_flash_erase
    hal_flash_erase
        0x0100433c:    b510        ..      PUSH     {r4,lr}
        0x0100433e:    460b        .F      MOV      r3,r1
        0x01004340:    4602        .F      MOV      r2,r0
        0x01004342:    2100        .!      MOVS     r1,#0
        0x01004344:    4803        .H      LDR      r0,[pc,#12] ; [0x1004354] = 0x801f64
        0x01004346:    f400f7da    ....    BL       hal_exflash_erase ; 0x8052fe
        0x0100434a:    b108        ..      CBZ      r0,0x1004350 ; hal_flash_erase + 20
        0x0100434c:    2000        .       MOVS     r0,#0
        0x0100434e:    bd10        ..      POP      {r4,pc}
        0x01004350:    2001        .       MOVS     r0,#1
        0x01004352:    bd10        ..      POP      {r4,pc}
    $d
        0x01004354:    00801f64    d...    DCD    8396644
    $t
    i.hal_flash_init
    hal_flash_init
        0x01004358:    b538        8.      PUSH     {r3-r5,lr}
        0x0100435a:    2002        .       MOVS     r0,#2
        0x0100435c:    9000        ..      STR      r0,[sp,#0]
        0x0100435e:    4668        hF      MOV      r0,sp
        0x01004360:    f7fefa9c    ....    BL       SystemCoreGetClock ; 0x100289c
        0x01004364:    4c11        .L      LDR      r4,[pc,#68] ; [0x10043ac] = 0x801f64
        0x01004366:    6820         h      LDR      r0,[r4,#0]
        0x01004368:    b980        ..      CBNZ     r0,0x100438c ; hal_flash_init + 52
        0x0100436a:    4811        .H      LDR      r0,[pc,#68] ; [0x10043b0] = 0x801f28
        0x0100436c:    6020         `      STR      r0,[r4,#0]
        0x0100436e:    4911        .I      LDR      r1,[pc,#68] ; [0x10043b4] = 0xa000d000
        0x01004370:    6001        .`      STR      r1,[r0,#0]
        0x01004372:    2101        .!      MOVS     r1,#1
        0x01004374:    6041        A`      STR      r1,[r0,#4]
        0x01004376:    6081        .`      STR      r1,[r0,#8]
        0x01004378:    21eb        .!      MOVS     r1,#0xeb
        0x0100437a:    60c1        .`      STR      r1,[r0,#0xc]
        0x0100437c:    490e        .I      LDR      r1,[pc,#56] ; [0x10043b8] = 0x300067bc
        0x0100437e:    f89d2000    ...     LDRB     r2,[sp,#0]
        0x01004382:    f8511022    Q.".    LDR      r1,[r1,r2,LSL #2]
        0x01004386:    6101        .a      STR      r1,[r0,#0x10]
        0x01004388:    2100        .!      MOVS     r1,#0
        0x0100438a:    6141        Aa      STR      r1,[r0,#0x14]
        0x0100438c:    f477d5ee    w...    BL       sys_security_enable_status_check ; 0x7bf6c
        0x01004390:    b108        ..      CBZ      r0,0x1004396 ; hal_flash_init + 62
        0x01004392:    2001        .       MOVS     r0,#1
        0x01004394:    e000        ..      B        0x1004398 ; hal_flash_init + 64
        0x01004396:    2000        .       MOVS     r0,#0
        0x01004398:    72a0        .r      STRB     r0,[r4,#0xa]
        0x0100439a:    4804        .H      LDR      r0,[pc,#16] ; [0x10043ac] = 0x801f64
        0x0100439c:    f414d7de    ....    BL       hal_exflash_init_ext ; 0x1935c
        0x010043a0:    b108        ..      CBZ      r0,0x10043a6 ; hal_flash_init + 78
        0x010043a2:    2000        .       MOVS     r0,#0
        0x010043a4:    bd38        8.      POP      {r3-r5,pc}
        0x010043a6:    2001        .       MOVS     r0,#1
        0x010043a8:    bd38        8.      POP      {r3-r5,pc}
    $d
        0x010043aa:    0000        ..      DCW    0
        0x010043ac:    00801f64    d...    DCD    8396644
        0x010043b0:    00801f28    (...    DCD    8396584
        0x010043b4:    a000d000    ....    DCD    2684407808
        0x010043b8:    300067bc    .g.0    DCD    805332924
    $t
    i.hal_flash_read
    hal_flash_read
        0x010043bc:    b510        ..      PUSH     {r4,lr}
        0x010043be:    4614        .F      MOV      r4,r2
        0x010043c0:    460a        .F      MOV      r2,r1
        0x010043c2:    4601        .F      MOV      r1,r0
        0x010043c4:    4623        #F      MOV      r3,r4
        0x010043c6:    4804        .H      LDR      r0,[pc,#16] ; [0x10043d8] = 0x801f64
        0x010043c8:    f401f3fc    ....    BL       hal_exflash_read ; 0x805bc4
        0x010043cc:    b108        ..      CBZ      r0,0x10043d2 ; hal_flash_read + 22
        0x010043ce:    2000        .       MOVS     r0,#0
        0x010043d0:    bd10        ..      POP      {r4,pc}
        0x010043d2:    4620         F      MOV      r0,r4
        0x010043d4:    bd10        ..      POP      {r4,pc}
    $d
        0x010043d6:    0000        ..      DCW    0
        0x010043d8:    00801f64    d...    DCD    8396644
    $t
    i.hal_flash_write_r
    hal_flash_write_r
        0x010043dc:    e92d47f0    -..G    PUSH     {r4-r10,lr}
        0x010043e0:    b0c0        ..      SUB      sp,sp,#0x100
        0x010043e2:    4681        .F      MOV      r9,r0
        0x010043e4:    468a        .F      MOV      r10,r1
        0x010043e6:    4617        .F      MOV      r7,r2
        0x010043e8:    463b        ;F      MOV      r3,r7
        0x010043ea:    4652        RF      MOV      r2,r10
        0x010043ec:    4649        IF      MOV      r1,r9
        0x010043ee:    4817        .H      LDR      r0,[pc,#92] ; [0x100444c] = 0x801f64
        0x010043f0:    f400f67b    ..{.    BL       hal_exflash_write ; 0x8050ea
        0x010043f4:    bb18        ..      CBNZ     r0,0x100443e ; hal_flash_write_r + 98
        0x010043f6:    2400        .$      MOVS     r4,#0
        0x010043f8:    463d        =F      MOV      r5,r7
        0x010043fa:    f44f7880    O..x    MOV      r8,#0x100
        0x010043fe:    4547        GE      CMP      r7,r8
        0x01004400:    d901        ..      BLS      0x1004406 ; hal_flash_write_r + 42
        0x01004402:    4646        FF      MOV      r6,r8
        0x01004404:    e000        ..      B        0x1004408 ; hal_flash_write_r + 44
        0x01004406:    463e        >F      MOV      r6,r7
        0x01004408:    eb090104    ....    ADD      r1,r9,r4
        0x0100440c:    4633        3F      MOV      r3,r6
        0x0100440e:    466a        jF      MOV      r2,sp
        0x01004410:    480e        .H      LDR      r0,[pc,#56] ; [0x100444c] = 0x801f64
        0x01004412:    f401f3d7    ....    BL       hal_exflash_read ; 0x805bc4
        0x01004416:    b990        ..      CBNZ     r0,0x100443e ; hal_flash_write_r + 98
        0x01004418:    eb0a0004    ....    ADD      r0,r10,r4
        0x0100441c:    4632        2F      MOV      r2,r6
        0x0100441e:    4669        iF      MOV      r1,sp
        0x01004420:    f7fef81c    ....    BL       memcmp ; 0x100245c
        0x01004424:    b958        X.      CBNZ     r0,0x100443e ; hal_flash_write_r + 98
        0x01004426:    1bad        ..      SUBS     r5,r5,r6
        0x01004428:    b16d        m.      CBZ      r5,0x1004446 ; hal_flash_write_r + 106
        0x0100442a:    4434        4D      ADD      r4,r4,r6
        0x0100442c:    4646        FF      MOV      r6,r8
        0x0100442e:    42b5        .B      CMP      r5,r6
        0x01004430:    d800        ..      BHI      0x1004434 ; hal_flash_write_r + 88
        0x01004432:    462e        .F      MOV      r6,r5
        0x01004434:    42bc        .B      CMP      r4,r7
        0x01004436:    d202        ..      BCS      0x100443e ; hal_flash_write_r + 98
        0x01004438:    19a0        ..      ADDS     r0,r4,r6
        0x0100443a:    42b8        .B      CMP      r0,r7
        0x0100443c:    d9e4        ..      BLS      0x1004408 ; hal_flash_write_r + 44
        0x0100443e:    2000        .       MOVS     r0,#0
        0x01004440:    b040        @.      ADD      sp,sp,#0x100
        0x01004442:    e8bd87f0    ....    POP      {r4-r10,pc}
        0x01004446:    4638        8F      MOV      r0,r7
        0x01004448:    e7fa        ..      B        0x1004440 ; hal_flash_write_r + 100
    $d
        0x0100444a:    0000        ..      DCW    0
        0x0100444c:    00801f64    d...    DCD    8396644
    $t
    i.hal_gpio_exti_callback
    hal_gpio_exti_callback
        0x01004450:    e92d43fe    -..C    PUSH     {r1-r9,lr}
        0x01004454:    4607        .F      MOV      r7,r0
        0x01004456:    460e        .F      MOV      r6,r1
        0x01004458:    4630        0F      MOV      r0,r6
        0x0100445a:    f7fffcd5    ....    BL       get_pin_index ; 0x1003e08
        0x0100445e:    b285        ..      UXTH     r5,r0
        0x01004460:    2400        .$      MOVS     r4,#0
        0x01004462:    f8df9054    ..T.    LDR      r9,[pc,#84] ; [0x10044b8] = 0x1007b2c
        0x01004466:    f8df8054    ..T.    LDR      r8,[pc,#84] ; [0x10044bc] = 0x30006ad0
        0x0100446a:    f8590034    Y.4.    LDR      r0,[r9,r4,LSL #3]
        0x0100446e:    42b8        .B      CMP      r0,r7
        0x01004470:    d11d        ..      BNE      0x10044ae ; hal_gpio_exti_callback + 94
        0x01004472:    eb051004    ....    ADD      r0,r5,r4,LSL #4
        0x01004476:    b285        ..      UXTH     r5,r0
        0x01004478:    eb050245    ..E.    ADD      r2,r5,r5,LSL #1
        0x0100447c:    f8180022    ..".    LDRB     r0,[r8,r2,LSL #2]
        0x01004480:    2805        .(      CMP      r0,#5
        0x01004482:    d007        ..      BEQ      0x1004494 ; hal_gpio_exti_callback + 68
        0x01004484:    f88d4000    ...@    STRB     r4,[sp,#0]
        0x01004488:    480d        .H      LDR      r0,[pc,#52] ; [0x10044c0] = 0xa0011000
        0x0100448a:    4287        .B      CMP      r7,r0
        0x0100448c:    d106        ..      BNE      0x100449c ; hal_gpio_exti_callback + 76
        0x0100448e:    0430        0.      LSLS     r0,r6,#16
        0x01004490:    9001        ..      STR      r0,[sp,#4]
        0x01004492:    e004        ..      B        0x100449e ; hal_gpio_exti_callback + 78
        0x01004494:    2005        .       MOVS     r0,#5
        0x01004496:    f88d0000    ....    STRB     r0,[sp,#0]
        0x0100449a:    e7f5        ..      B        0x1004488 ; hal_gpio_exti_callback + 56
        0x0100449c:    9601        ..      STR      r6,[sp,#4]
        0x0100449e:    eb080082    ....    ADD      r0,r8,r2,LSL #2
        0x010044a2:    6881        .h      LDR      r1,[r0,#8]
        0x010044a4:    9102        ..      STR      r1,[sp,#8]
        0x010044a6:    6842        Bh      LDR      r2,[r0,#4]
        0x010044a8:    b10a        ..      CBZ      r2,0x10044ae ; hal_gpio_exti_callback + 94
        0x010044aa:    4668        hF      MOV      r0,sp
        0x010044ac:    4790        .G      BLX      r2
        0x010044ae:    1c64        d.      ADDS     r4,r4,#1
        0x010044b0:    2c03        .,      CMP      r4,#3
        0x010044b2:    dbda        ..      BLT      0x100446a ; hal_gpio_exti_callback + 26
        0x010044b4:    e8bd83fe    ....    POP      {r1-r9,pc}
    $d
        0x010044b8:    01007b2c    ,{..    DCD    16808748
        0x010044bc:    30006ad0    .j.0    DCD    805333712
        0x010044c0:    a0011000    ....    DCD    2684424192
    $t
    i.hal_gpio_init
    hal_gpio_init
        0x010044c4:    b570        p.      PUSH     {r4-r6,lr}
        0x010044c6:    4605        .F      MOV      r5,r0
        0x010044c8:    460e        .F      MOV      r6,r1
        0x010044ca:    4807        .H      LDR      r0,[pc,#28] ; [0x10044e8] = 0x300067e4
        0x010044cc:    f415d308    ....    BL       hal_gpio_register_callback ; 0x19ae0
        0x010044d0:    f3ef8410    ....    MRS      r4,PRIMASK
        0x010044d4:    2201        ."      MOVS     r2,#1
        0x010044d6:    f3828810    ....    MSR      PRIMASK,r2
        0x010044da:    4631        1F      MOV      r1,r6
        0x010044dc:    4628        (F      MOV      r0,r5
        0x010044de:    f415d2f4    ....    BL       hal_gpio_init_ext ; 0x19aca
        0x010044e2:    f3848810    ....    MSR      PRIMASK,r4
        0x010044e6:    bd70        p.      POP      {r4-r6,pc}
    $d
        0x010044e8:    300067e4    .g.0    DCD    805332964
    $t
    i.hal_init
    hal_init
        0x010044ec:    b510        ..      PUSH     {r4,lr}
        0x010044ee:    4806        .H      LDR      r0,[pc,#24] ; [0x1004508] = 0x300067d8
        0x010044f0:    f41bd216    ....    BL       hal_register_callback ; 0x1f920
        0x010044f4:    f3ef8410    ....    MRS      r4,PRIMASK
        0x010044f8:    2001        .       MOVS     r0,#1
        0x010044fa:    f3808810    ....    MSR      PRIMASK,r0
        0x010044fe:    f417d5b7    ....    BL       hal_init_ext ; 0x1c070
        0x01004502:    f3848810    ....    MSR      PRIMASK,r4
        0x01004506:    bd10        ..      POP      {r4,pc}
    $d
        0x01004508:    300067d8    .g.0    DCD    805332952
    $t
    i.hal_msio_init
    hal_msio_init
        0x0100450c:    4608        .F      MOV      r0,r1
        0x0100450e:    f000bcb7    ....    B.W      ll_msio_init ; 0x1004e80
    i.hal_msp_deinit
    hal_msp_deinit
        0x01004512:    4770        pG      BX       lr
    i.hal_msp_init
    hal_msp_init
        0x01004514:    4770        pG      BX       lr
        0x01004516:    0000        ..      MOVS     r0,r0
    i.hal_nvic_system_reset
    hal_nvic_system_reset
        0x01004518:    2001        .       MOVS     r0,#1
        0x0100451a:    f3808810    ....    MSR      PRIMASK,r0
        0x0100451e:    480f        .H      LDR      r0,[pc,#60] ; [0x100455c] = 0xa000c558
        0x01004520:    6801        .h      LDR      r1,[r0,#0]
        0x01004522:    f0217180    !..q    BIC      r1,r1,#0x1000000
        0x01004526:    6001        .`      STR      r1,[r0,#0]
        0x01004528:    2101        .!      MOVS     r1,#1
        0x0100452a:    4a0c        .J      LDR      r2,[pc,#48] ; [0x100455c] = 0xa000c558
        0x0100452c:    3238        82      ADDS     r2,r2,#0x38
        0x0100452e:    6011        .`      STR      r1,[r2,#0]
        0x01004530:    6801        .h      LDR      r1,[r0,#0]
        0x01004532:    f0417100    A..q    ORR      r1,r1,#0x2000000
        0x01004536:    6001        .`      STR      r1,[r0,#0]
        0x01004538:    4a08        .J      LDR      r2,[pc,#32] ; [0x100455c] = 0xa000c558
        0x0100453a:    f06f0140    o.@.    MVN      r1,#0x40
        0x0100453e:    3a14        .:      SUBS     r2,r2,#0x14
        0x01004540:    6011        .`      STR      r1,[r2,#0]
        0x01004542:    2100        .!      MOVS     r1,#0
        0x01004544:    6802        .h      LDR      r2,[r0,#0]
        0x01004546:    f36162df    a..b    BFI      r2,r1,#27,#5
        0x0100454a:    6002        .`      STR      r2,[r0,#0]
        0x0100454c:    4a05        .J      LDR      r2,[pc,#20] ; [0x1004564] = 0x807000
        0x0100454e:    4904        .I      LDR      r1,[pc,#16] ; [0x1004560] = 0x676f6f64
        0x01004550:    6011        .`      STR      r1,[r2,#0]
        0x01004552:    6801        .h      LDR      r1,[r0,#0]
        0x01004554:    f0417180    A..q    ORR      r1,r1,#0x1000000
        0x01004558:    6001        .`      STR      r1,[r0,#0]
        0x0100455a:    e7fe        ..      B        0x100455a ; hal_nvic_system_reset + 66
    $d
        0x0100455c:    a000c558    X...    DCD    2684405080
        0x01004560:    676f6f64    doog    DCD    1735356260
        0x01004564:    00807000    .p..    DCD    8417280
    $t
    i.hal_sleep_timer_get_clock_freq
    hal_sleep_timer_get_clock_freq
        0x01004568:    480e        .H      LDR      r0,[pc,#56] ; [0x10045a4] = 0x300067a5
        0x0100456a:    7881        .x      LDRB     r1,[r0,#2]
        0x0100456c:    2900        .)      CMP      r1,#0
        0x0100456e:    d109        ..      BNE      0x1004584 ; hal_sleep_timer_get_clock_freq + 28
        0x01004570:    490d        .I      LDR      r1,[pc,#52] ; [0x10045a8] = 0xa000c550
        0x01004572:    6809        .h      LDR      r1,[r1,#0]
        0x01004574:    f0015140    ..@Q    AND      r1,r1,#0x30000000
        0x01004578:    2201        ."      MOVS     r2,#1
        0x0100457a:    7082        .p      STRB     r2,[r0,#2]
        0x0100457c:    f1b15f80    ..._    CMP      r1,#0x10000000
        0x01004580:    d100        ..      BNE      0x1004584 ; hal_sleep_timer_get_clock_freq + 28
        0x01004582:    7042        Bp      STRB     r2,[r0,#1]
        0x01004584:    7840        @x      LDRB     r0,[r0,#1]
        0x01004586:    b158        X.      CBZ      r0,0x10045a0 ; hal_sleep_timer_get_clock_freq + 56
        0x01004588:    4808        .H      LDR      r0,[pc,#32] ; [0x10045ac] = 0x300067ac
        0x0100458a:    eef60a00    ....    VMOV.F32 s1,#0.50000000
        0x0100458e:    ed900a00    ....    VLDR     s0,[r0,#0]
        0x01004592:    ee300a20    0. .    VADD.F32 s0,s0,s1
        0x01004596:    eebc0ac0    ....    VCVT.U32.F32 s0,s0
        0x0100459a:    ee100a10    ....    VMOV     r0,s0
        0x0100459e:    4770        pG      BX       lr
        0x010045a0:    f4779438    w.8.    B        sys_lpclk_get ; 0x7be14
    $d
        0x010045a4:    300067a5    .g.0    DCD    805332901
        0x010045a8:    a000c550    P...    DCD    2684405072
        0x010045ac:    300067ac    .g.0    DCD    805332908
    $t
    i.hal_uart_abort_cplt_callback
    hal_uart_abort_cplt_callback
        0x010045b0:    b51c        ..      PUSH     {r2-r4,lr}
        0x010045b2:    f002fb03    ....    BL       uart_get_id ; 0x1006bbc
        0x010045b6:    2105        .!      MOVS     r1,#5
        0x010045b8:    f88d1000    ....    STRB     r1,[sp,#0]
        0x010045bc:    4906        .I      LDR      r1,[pc,#24] ; [0x10045d8] = 0x300065cc
        0x010045be:    2200        ."      MOVS     r2,#0
        0x010045c0:    f8513020    Q. 0    LDR      r3,[r1,r0,LSL #2]
        0x010045c4:    f8832100    ...!    STRB     r2,[r3,#0x100]
        0x010045c8:    f8510020    Q. .    LDR      r0,[r1,r0,LSL #2]
        0x010045cc:    6801        .h      LDR      r1,[r0,#0]
        0x010045ce:    2900        .)      CMP      r1,#0
        0x010045d0:    d001        ..      BEQ      0x10045d6 ; hal_uart_abort_cplt_callback + 38
        0x010045d2:    4668        hF      MOV      r0,sp
        0x010045d4:    4788        .G      BLX      r1
        0x010045d6:    bd1c        ..      POP      {r2-r4,pc}
    $d
        0x010045d8:    300065cc    .e.0    DCD    805332428
    $t
    i.hal_uart_abort_rx_cplt_callback
    hal_uart_abort_rx_cplt_callback
        0x010045dc:    b51c        ..      PUSH     {r2-r4,lr}
        0x010045de:    f002faed    ....    BL       uart_get_id ; 0x1006bbc
        0x010045e2:    2104        .!      MOVS     r1,#4
        0x010045e4:    f88d1000    ....    STRB     r1,[sp,#0]
        0x010045e8:    4906        .I      LDR      r1,[pc,#24] ; [0x1004604] = 0x300065cc
        0x010045ea:    2200        ."      MOVS     r2,#0
        0x010045ec:    f8513020    Q. 0    LDR      r3,[r1,r0,LSL #2]
        0x010045f0:    f8832100    ...!    STRB     r2,[r3,#0x100]
        0x010045f4:    f8510020    Q. .    LDR      r0,[r1,r0,LSL #2]
        0x010045f8:    6801        .h      LDR      r1,[r0,#0]
        0x010045fa:    2900        .)      CMP      r1,#0
        0x010045fc:    d001        ..      BEQ      0x1004602 ; hal_uart_abort_rx_cplt_callback + 38
        0x010045fe:    4668        hF      MOV      r0,sp
        0x01004600:    4788        .G      BLX      r1
        0x01004602:    bd1c        ..      POP      {r2-r4,pc}
    $d
        0x01004604:    300065cc    .e.0    DCD    805332428
    $t
    i.hal_uart_abort_tx_cplt_callback
    hal_uart_abort_tx_cplt_callback
        0x01004608:    b51c        ..      PUSH     {r2-r4,lr}
        0x0100460a:    f002fad7    ....    BL       uart_get_id ; 0x1006bbc
        0x0100460e:    2103        .!      MOVS     r1,#3
        0x01004610:    f88d1000    ....    STRB     r1,[sp,#0]
        0x01004614:    4906        .I      LDR      r1,[pc,#24] ; [0x1004630] = 0x300065cc
        0x01004616:    2200        ."      MOVS     r2,#0
        0x01004618:    f8513020    Q. 0    LDR      r3,[r1,r0,LSL #2]
        0x0100461c:    f8832100    ...!    STRB     r2,[r3,#0x100]
        0x01004620:    f8510020    Q. .    LDR      r0,[r1,r0,LSL #2]
        0x01004624:    6801        .h      LDR      r1,[r0,#0]
        0x01004626:    2900        .)      CMP      r1,#0
        0x01004628:    d001        ..      BEQ      0x100462e ; hal_uart_abort_tx_cplt_callback + 38
        0x0100462a:    4668        hF      MOV      r0,sp
        0x0100462c:    4788        .G      BLX      r1
        0x0100462e:    bd1c        ..      POP      {r2-r4,pc}
    $d
        0x01004630:    300065cc    .e.0    DCD    805332428
    $t
    i.hal_uart_deinit
    hal_uart_deinit
        0x01004634:    b570        p.      PUSH     {r4-r6,lr}
        0x01004636:    4605        .F      MOV      r5,r0
        0x01004638:    4806        .H      LDR      r0,[pc,#24] ; [0x1004654] = 0x300067e8
        0x0100463a:    f41dd169    ..i.    BL       hal_uart_register_callback ; 0x21910
        0x0100463e:    f3ef8410    ....    MRS      r4,PRIMASK
        0x01004642:    2101        .!      MOVS     r1,#1
        0x01004644:    f3818810    ....    MSR      PRIMASK,r1
        0x01004648:    4628        (F      MOV      r0,r5
        0x0100464a:    f41cd715    ....    BL       hal_uart_deinit_ext ; 0x21478
        0x0100464e:    f3848810    ....    MSR      PRIMASK,r4
        0x01004652:    bd70        p.      POP      {r4-r6,pc}
    $d
        0x01004654:    300067e8    .g.0    DCD    805332968
    $t
    i.hal_uart_error_callback
    hal_uart_error_callback
        0x01004658:    b51c        ..      PUSH     {r2-r4,lr}
        0x0100465a:    4604        .F      MOV      r4,r0
        0x0100465c:    4620         F      MOV      r0,r4
        0x0100465e:    f002faad    ....    BL       uart_get_id ; 0x1006bbc
        0x01004662:    2200        ."      MOVS     r2,#0
        0x01004664:    f88d2000    ...     STRB     r2,[sp,#0]
        0x01004668:    6be1        .k      LDR      r1,[r4,#0x3c]
        0x0100466a:    9101        ..      STR      r1,[sp,#4]
        0x0100466c:    4906        .I      LDR      r1,[pc,#24] ; [0x1004688] = 0x300065cc
        0x0100466e:    f8513020    Q. 0    LDR      r3,[r1,r0,LSL #2]
        0x01004672:    f8832100    ...!    STRB     r2,[r3,#0x100]
        0x01004676:    f8510020    Q. .    LDR      r0,[r1,r0,LSL #2]
        0x0100467a:    6801        .h      LDR      r1,[r0,#0]
        0x0100467c:    2900        .)      CMP      r1,#0
        0x0100467e:    d001        ..      BEQ      0x1004684 ; hal_uart_error_callback + 44
        0x01004680:    4668        hF      MOV      r0,sp
        0x01004682:    4788        .G      BLX      r1
        0x01004684:    bd1c        ..      POP      {r2-r4,pc}
    $d
        0x01004686:    0000        ..      DCW    0
        0x01004688:    300065cc    .e.0    DCD    805332428
    $t
    i.hal_uart_get_state
    hal_uart_get_state
        0x0100468c:    2800        .(      CMP      r0,#0
        0x0100468e:    d004        ..      BEQ      0x100469a ; hal_uart_get_state + 14
        0x01004690:    f8101f37    ..7.    LDRB     r1,[r0,#0x37]!
        0x01004694:    7840        @x      LDRB     r0,[r0,#1]
        0x01004696:    4308        .C      ORRS     r0,r0,r1
        0x01004698:    4770        pG      BX       lr
        0x0100469a:    2000        .       MOVS     r0,#0
        0x0100469c:    4770        pG      BX       lr
        0x0100469e:    0000        ..      MOVS     r0,r0
    i.hal_uart_init
    hal_uart_init
        0x010046a0:    b570        p.      PUSH     {r4-r6,lr}
        0x010046a2:    4605        .F      MOV      r5,r0
        0x010046a4:    4806        .H      LDR      r0,[pc,#24] ; [0x10046c0] = 0x300067e8
        0x010046a6:    f41dd133    ..3.    BL       hal_uart_register_callback ; 0x21910
        0x010046aa:    f3ef8410    ....    MRS      r4,PRIMASK
        0x010046ae:    2101        .!      MOVS     r1,#1
        0x010046b0:    f3818810    ....    MSR      PRIMASK,r1
        0x010046b4:    4628        (F      MOV      r0,r5
        0x010046b6:    f41cd7cd    ....    BL       hal_uart_init_ext ; 0x21654
        0x010046ba:    f3848810    ....    MSR      PRIMASK,r4
        0x010046be:    bd70        p.      POP      {r4-r6,pc}
    $d
        0x010046c0:    300067e8    .g.0    DCD    805332968
    $t
    i.hal_uart_msp_deinit
    hal_uart_msp_deinit
        0x010046c4:    4770        pG      BX       lr
    i.hal_uart_msp_init
    hal_uart_msp_init
        0x010046c6:    4770        pG      BX       lr
    i.hal_uart_receive_it
    hal_uart_receive_it
        0x010046c8:    f8903038    ..80    LDRB     r3,[r0,#0x38]
        0x010046cc:    2b10        .+      CMP      r3,#0x10
        0x010046ce:    d001        ..      BEQ      0x10046d4 ; hal_uart_receive_it + 12
        0x010046d0:    2002        .       MOVS     r0,#2
        0x010046d2:    4770        pG      BX       lr
        0x010046d4:    b321        !.      CBZ      r1,0x1004720 ; hal_uart_receive_it + 88
        0x010046d6:    b31a        ..      CBZ      r2,0x1004720 ; hal_uart_receive_it + 88
        0x010046d8:    6241        Ab      STR      r1,[r0,#0x24]
        0x010046da:    8502        ..      STRH     r2,[r0,#0x28]
        0x010046dc:    8542        B.      STRH     r2,[r0,#0x2a]
        0x010046de:    2300        .#      MOVS     r3,#0
        0x010046e0:    63c3        .c      STR      r3,[r0,#0x3c]
        0x010046e2:    2112        .!      MOVS     r1,#0x12
        0x010046e4:    f8801038    ..8.    STRB     r1,[r0,#0x38]
        0x010046e8:    6801        .h      LDR      r1,[r0,#0]
        0x010046ea:    2202        ."      MOVS     r2,#2
        0x010046ec:    f8c1209c    ...     STR      r2,[r1,#0x9c]
        0x010046f0:    6801        .h      LDR      r1,[r0,#0]
        0x010046f2:    694a        Ji      LDR      r2,[r1,#0x14]
        0x010046f4:    0792        ..      LSLS     r2,r2,#30
        0x010046f6:    d503        ..      BPL      0x1004700 ; hal_uart_receive_it + 56
        0x010046f8:    680a        .h      LDR      r2,[r1,#0]
        0x010046fa:    2202        ."      MOVS     r2,#2
        0x010046fc:    f8c12088    ...     STR      r2,[r1,#0x88]
        0x01004700:    f8803036    ..60    STRB     r3,[r0,#0x36]
        0x01004704:    f3ef8110    ....    MRS      r1,PRIMASK
        0x01004708:    2201        ."      MOVS     r2,#1
        0x0100470a:    f3828810    ....    MSR      PRIMASK,r2
        0x0100470e:    6800        .h      LDR      r0,[r0,#0]
        0x01004710:    6842        Bh      LDR      r2,[r0,#4]
        0x01004712:    f0420205    B...    ORR      r2,r2,#5
        0x01004716:    6042        B`      STR      r2,[r0,#4]
        0x01004718:    f3818810    ....    MSR      PRIMASK,r1
        0x0100471c:    2000        .       MOVS     r0,#0
        0x0100471e:    4770        pG      BX       lr
        0x01004720:    2001        .       MOVS     r0,#1
        0x01004722:    4770        pG      BX       lr
    i.hal_uart_rx_cplt_callback
    hal_uart_rx_cplt_callback
        0x01004724:    b51c        ..      PUSH     {r2-r4,lr}
        0x01004726:    4604        .F      MOV      r4,r0
        0x01004728:    4620         F      MOV      r0,r4
        0x0100472a:    f002fa47    ..G.    BL       uart_get_id ; 0x1006bbc
        0x0100472e:    2102        .!      MOVS     r1,#2
        0x01004730:    f88d1000    ....    STRB     r1,[sp,#0]
        0x01004734:    8d21        !.      LDRH     r1,[r4,#0x28]
        0x01004736:    8d62        b.      LDRH     r2,[r4,#0x2a]
        0x01004738:    1a89        ..      SUBS     r1,r1,r2
        0x0100473a:    f8ad1004    ....    STRH     r1,[sp,#4]
        0x0100473e:    4904        .I      LDR      r1,[pc,#16] ; [0x1004750] = 0x300065cc
        0x01004740:    f8510020    Q. .    LDR      r0,[r1,r0,LSL #2]
        0x01004744:    6801        .h      LDR      r1,[r0,#0]
        0x01004746:    2900        .)      CMP      r1,#0
        0x01004748:    d001        ..      BEQ      0x100474e ; hal_uart_rx_cplt_callback + 42
        0x0100474a:    4668        hF      MOV      r0,sp
        0x0100474c:    4788        .G      BLX      r1
        0x0100474e:    bd1c        ..      POP      {r2-r4,pc}
    $d
        0x01004750:    300065cc    .e.0    DCD    805332428
    $t
    i.hal_uart_tx_cplt_callback
    hal_uart_tx_cplt_callback
        0x01004754:    b57c        |.      PUSH     {r2-r6,lr}
        0x01004756:    4605        .F      MOV      r5,r0
        0x01004758:    4628        (F      MOV      r0,r5
        0x0100475a:    f002fa2f    ../.    BL       uart_get_id ; 0x1006bbc
        0x0100475e:    4604        .F      MOV      r4,r0
        0x01004760:    2001        .       MOVS     r0,#1
        0x01004762:    f88d0000    ....    STRB     r0,[sp,#0]
        0x01004766:    8c28        (.      LDRH     r0,[r5,#0x20]
        0x01004768:    8c69        i.      LDRH     r1,[r5,#0x22]
        0x0100476a:    1a40        @.      SUBS     r0,r0,r1
        0x0100476c:    f8ad0004    ....    STRH     r0,[sp,#4]
        0x01004770:    4d0c        .M      LDR      r5,[pc,#48] ; [0x10047a4] = 0x300065cc
        0x01004772:    f8550024    U.$.    LDR      r0,[r5,r4,LSL #2]
        0x01004776:    f8900104    ....    LDRB     r0,[r0,#0x104]
        0x0100477a:    b118        ..      CBZ      r0,0x1004784 ; hal_uart_tx_cplt_callback + 48
        0x0100477c:    4620         F      MOV      r0,r4
        0x0100477e:    f7fefbdb    ....    BL       app_uart_dma_start_transmit_async ; 0x1002f38
        0x01004782:    e002        ..      B        0x100478a ; hal_uart_tx_cplt_callback + 54
        0x01004784:    4620         F      MOV      r0,r4
        0x01004786:    f7fefcb7    ....    BL       app_uart_start_transmit_async ; 0x10030f8
        0x0100478a:    f8550024    U.$.    LDR      r0,[r5,r4,LSL #2]
        0x0100478e:    f8901100    ....    LDRB     r1,[r0,#0x100]
        0x01004792:    2900        .)      CMP      r1,#0
        0x01004794:    d104        ..      BNE      0x10047a0 ; hal_uart_tx_cplt_callback + 76
        0x01004796:    6801        .h      LDR      r1,[r0,#0]
        0x01004798:    2900        .)      CMP      r1,#0
        0x0100479a:    d001        ..      BEQ      0x10047a0 ; hal_uart_tx_cplt_callback + 76
        0x0100479c:    4668        hF      MOV      r0,sp
        0x0100479e:    4788        .G      BLX      r1
        0x010047a0:    bd7c        |.      POP      {r2-r6,pc}
    $d
        0x010047a2:    0000        ..      DCW    0
        0x010047a4:    300065cc    .e.0    DCD    805332428
    $t
    i.i0nd_ioldo_3v_get
    i0nd_ioldo_3v_get
        0x010047a8:    b538        8.      PUSH     {r3-r5,lr}
        0x010047aa:    2000        .       MOVS     r0,#0
        0x010047ac:    9000        ..      STR      r0,[sp,#0]
        0x010047ae:    4c12        .L      LDR      r4,[pc,#72] ; [0x10047f8] = 0x803212
        0x010047b0:    7820         x      LDRB     r0,[r4,#0]
        0x010047b2:    2890        .(      CMP      r0,#0x90
        0x010047b4:    d008        ..      BEQ      0x10047c8 ; i0nd_ioldo_3v_get + 32
        0x010047b6:    d215        ..      BCS      0x10047e4 ; i0nd_ioldo_3v_get + 60
        0x010047b8:    f8940028    ..(.    LDRB     r0,[r4,#0x28]
        0x010047bc:    f000007f    ....    AND      r0,r0,#0x7f
        0x010047c0:    f1000046    ..F.    ADD      r0,r0,#0x46
        0x010047c4:    9000        ..      STR      r0,[sp,#0]
        0x010047c6:    e012        ..      B        0x10047ee ; i0nd_ioldo_3v_get + 70
        0x010047c8:    4668        hF      MOV      r0,sp
        0x010047ca:    f001fe3f    ..?.    BL       sys_get_efuse_io_ldo ; 0x100644c
        0x010047ce:    f8940028    ..(.    LDRB     r0,[r4,#0x28]
        0x010047d2:    f8bd1000    ....    LDRH     r1,[sp,#0]
        0x010047d6:    4288        .B      CMP      r0,r1
        0x010047d8:    d909        ..      BLS      0x10047ee ; i0nd_ioldo_3v_get + 70
        0x010047da:    f000007f    ....    AND      r0,r0,#0x7f
        0x010047de:    3046        F0      ADDS     r0,r0,#0x46
        0x010047e0:    9000        ..      STR      r0,[sp,#0]
        0x010047e2:    e004        ..      B        0x10047ee ; i0nd_ioldo_3v_get + 70
        0x010047e4:    7ca0        .|      LDRB     r0,[r4,#0x12]
        0x010047e6:    f000007f    ....    AND      r0,r0,#0x7f
        0x010047ea:    3812        .8      SUBS     r0,r0,#0x12
        0x010047ec:    9000        ..      STR      r0,[sp,#0]
        0x010047ee:    f8bd0000    ....    LDRH     r0,[sp,#0]
        0x010047f2:    f000007f    ....    AND      r0,r0,#0x7f
        0x010047f6:    bd38        8.      POP      {r3-r5,pc}
    $d
        0x010047f8:    00803212    .2..    DCD    8401426
    $t
    i.init_unused_nvds
    init_unused_nvds
        0x010047fc:    b5f0        ..      PUSH     {r4-r7,lr}
        0x010047fe:    b085        ..      SUB      sp,sp,#0x14
        0x01004800:    4604        .F      MOV      r4,r0
        0x01004802:    4f22        "O      LDR      r7,[pc,#136] ; [0x100488c] = 0x8023cc
        0x01004804:    0321        !.      LSLS     r1,r4,#12
        0x01004806:    6838        8h      LDR      r0,[r7,#0]
        0x01004808:    f7fffd98    ....    BL       hal_flash_erase ; 0x100433c
        0x0100480c:    4e20         N      LDR      r6,[pc,#128] ; [0x1004890] = 0x801f64
        0x0100480e:    f44f4500    O..E    MOV      r5,#0x8000
        0x01004812:    b1d8        ..      CBZ      r0,0x100484c ; init_unused_nvds + 80
        0x01004814:    481f        .H      LDR      r0,[pc,#124] ; [0x1004894] = 0x7d5ac
        0x01004816:    6801        .h      LDR      r1,[r0,#0]
        0x01004818:    9103        ..      STR      r1,[sp,#0xc]
        0x0100481a:    6840        @h      LDR      r0,[r0,#4]
        0x0100481c:    9004        ..      STR      r0,[sp,#0x10]
        0x0100481e:    2208        ."      MOVS     r2,#8
        0x01004820:    a903        ..      ADD      r1,sp,#0xc
        0x01004822:    6838        8h      LDR      r0,[r7,#0]
        0x01004824:    f7fff924    ..$.    BL       dec_flash_write ; 0x1003a70
        0x01004828:    2808        .(      CMP      r0,#8
        0x0100482a:    d01e        ..      BEQ      0x100486a ; init_unused_nvds + 110
        0x0100482c:    69b0        .i      LDR      r0,[r6,#0x18]
        0x0100482e:    7a71        qz      LDRB     r1,[r6,#9]
        0x01004830:    f240226a    @.j"    MOV      r2,#0x26a
        0x01004834:    e9cd2100    ...!    STRD     r2,r1,[sp,#0]
        0x01004838:    9002        ..      STR      r0,[sp,#8]
        0x0100483a:    4b17        .K      LDR      r3,[pc,#92] ; [0x1004898] = 0x1007be3
        0x0100483c:    a217        ..      ADR      r2,{pc}+0x60 ; 0x100489c
        0x0100483e:    4629        )F      MOV      r1,r5
        0x01004840:    2000        .       MOVS     r0,#0
        0x01004842:    f408d2ab    ....    BL       dbg_log_printf ; 0xcd9c
        0x01004846:    2009        .       MOVS     r0,#9
        0x01004848:    b005        ..      ADD      sp,sp,#0x14
        0x0100484a:    bdf0        ..      POP      {r4-r7,pc}
        0x0100484c:    69b0        .i      LDR      r0,[r6,#0x18]
        0x0100484e:    7a71        qz      LDRB     r1,[r6,#9]
        0x01004850:    f44f7215    O..r    MOV      r2,#0x254
        0x01004854:    e9cd2100    ...!    STRD     r2,r1,[sp,#0]
        0x01004858:    9002        ..      STR      r0,[sp,#8]
        0x0100485a:    4b0f        .K      LDR      r3,[pc,#60] ; [0x1004898] = 0x1007be3
        0x0100485c:    a20f        ..      ADR      r2,{pc}+0x40 ; 0x100489c
        0x0100485e:    4629        )F      MOV      r1,r5
        0x01004860:    2000        .       MOVS     r0,#0
        0x01004862:    f408d29b    ....    BL       dbg_log_printf ; 0xcd9c
        0x01004866:    2009        .       MOVS     r0,#9
        0x01004868:    e7ee        ..      B        0x1004848 ; init_unused_nvds + 76
        0x0100486a:    4818        .H      LDR      r0,[pc,#96] ; [0x10048cc] = 0x8032d8
        0x0100486c:    2108        .!      MOVS     r1,#8
        0x0100486e:    6001        .`      STR      r1,[r0,#0]
        0x01004870:    f06f0113    o...    MVN      r1,#0x13
        0x01004874:    eb013304    ...3    ADD      r3,r1,r4,LSL #12
        0x01004878:    6043        C`      STR      r3,[r0,#4]
        0x0100487a:    7244        Dr      STRB     r4,[r0,#9]
        0x0100487c:    a214        ..      ADR      r2,{pc}+0x54 ; 0x10048d0
        0x0100487e:    4629        )F      MOV      r1,r5
        0x01004880:    2000        .       MOVS     r0,#0
        0x01004882:    f408d28b    ....    BL       dbg_log_printf ; 0xcd9c
        0x01004886:    2000        .       MOVS     r0,#0
        0x01004888:    e7de        ..      B        0x1004848 ; init_unused_nvds + 76
    $d
        0x0100488a:    0000        ..      DCW    0
        0x0100488c:    008023cc    .#..    DCD    8397772
        0x01004890:    00801f64    d...    DCD    8396644
        0x01004894:    0007d5ac    ....    DCD    513452
        0x01004898:    01007be3    .{..    DCD    16808931
        0x0100489c:    3a353a52    R:5:    DCD    976566866
        0x010048a0:    202c7325    %s,     DCD    539783973
        0x010048a4:    2064254c    L%d     DCD    543434060
        0x010048a8:    73616c66    flas    DCD    1935764582
        0x010048ac:    74732068    h st    DCD    1953701992
        0x010048b0:    20657461    ate     DCD    543519841
        0x010048b4:    30257830    0x%0    DCD    807761968
        0x010048b8:    202c5832    2X,     DCD    539777074
        0x010048bc:    6f727265    erro    DCD    1869771365
        0x010048c0:    78302072    r 0x    DCD    2016419954
        0x010048c4:    58383025    %08X    DCD    1480077349
        0x010048c8:    00000a0d    ....    DCD    2573
        0x010048cc:    008032d8    .2..    DCD    8401624
        0x010048d0:    3a353a52    R:5:    DCD    976566866
        0x010048d4:    74696e49    Init    DCD    1953066569
        0x010048d8:    696c6169    iali    DCD    1768710505
        0x010048dc:    7520657a    ze u    DCD    1965057402
        0x010048e0:    6573756e    nuse    DCD    1702065518
        0x010048e4:    766e2064    d nv    DCD    1986928740
        0x010048e8:    202c7364    ds,     DCD    539784036
        0x010048ec:    69617661    avai    DCD    1767994977
        0x010048f0:    69735f6c    l_si    DCD    1769168748
        0x010048f4:    253d657a    ze=%    DCD    624780666
        0x010048f8:    000a0d64    d...    DCD    658788
    $t
    i.init_used_nvds
    init_used_nvds
        0x010048fc:    e92d5ffc    -.._    PUSH     {r2-r12,lr}
        0x01004900:    494a        JI      LDR      r1,[pc,#296] ; [0x1004a2c] = 0x8023cc
        0x01004902:    680c        .h      LDR      r4,[r1,#0]
        0x01004904:    3408        .4      ADDS     r4,r4,#8
        0x01004906:    4f4a        JO      LDR      r7,[pc,#296] ; [0x1004a30] = 0x8032d8
        0x01004908:    7278        xr      STRB     r0,[r7,#9]
        0x0100490a:    2108        .!      MOVS     r1,#8
        0x0100490c:    6039        9`      STR      r1,[r7,#0]
        0x0100490e:    f06f0113    o...    MVN      r1,#0x13
        0x01004912:    eb013800    ...8    ADD      r8,r1,r0,LSL #12
        0x01004916:    f1080008    ....    ADD      r0,r8,#8
        0x0100491a:    6078        x`      STR      r0,[r7,#4]
        0x0100491c:    f04f0901    O...    MOV      r9,#1
        0x01004920:    f04f0a00    O...    MOV      r10,#0
        0x01004924:    f8dfb10c    ....    LDR      r11,[pc,#268] ; [0x1004a34] = 0x8023c9
        0x01004928:    f89b0000    ....    LDRB     r0,[r11,#0]
        0x0100492c:    2800        .(      CMP      r0,#0
        0x0100492e:    d002        ..      BEQ      0x1004936 ; init_used_nvds + 58
        0x01004930:    2000        .       MOVS     r0,#0
        0x01004932:    f471d2b5    q...    BL       hal_flash_set_security ; 0x75ea0
        0x01004936:    2204        ."      MOVS     r2,#4
        0x01004938:    4669        iF      MOV      r1,sp
        0x0100493a:    4620         F      MOV      r0,r4
        0x0100493c:    f7fffd3e    ..>.    BL       hal_flash_read ; 0x10043bc
        0x01004940:    f8bd1000    ....    LDRH     r1,[sp,#0]
        0x01004944:    f5a1407f    ...@    SUB      r0,r1,#0xff00
        0x01004948:    38ff        .8      SUBS     r0,r0,#0xff
        0x0100494a:    d026        &.      BEQ      0x100499a ; init_used_nvds + 158
        0x0100494c:    2208        ."      MOVS     r2,#8
        0x0100494e:    4669        iF      MOV      r1,sp
        0x01004950:    4620         F      MOV      r0,r4
        0x01004952:    f7fffd33    ..3.    BL       hal_flash_read ; 0x10043bc
        0x01004956:    f8bd0002    ....    LDRH     r0,[sp,#2]
        0x0100495a:    f1000508    ....    ADD      r5,r0,#8
        0x0100495e:    f470d72b    p.+.    BL       get_align_bytes ; 0x757b8
        0x01004962:    b2c6        ..      UXTB     r6,r0
        0x01004964:    f8bd0000    ....    LDRH     r0,[sp,#0]
        0x01004968:    2800        .(      CMP      r0,#0
        0x0100496a:    d02b        +.      BEQ      0x10049c4 ; init_used_nvds + 200
        0x0100496c:    4668        hF      MOV      r0,sp
        0x0100496e:    f002f9e7    ....    BL       verify_hdr_checksum ; 0x1006d40
        0x01004972:    b1a8        ..      CBZ      r0,0x10049a0 ; init_used_nvds + 164
        0x01004974:    6878        xh      LDR      r0,[r7,#4]
        0x01004976:    19a9        ..      ADDS     r1,r5,r6
        0x01004978:    1a40        @.      SUBS     r0,r0,r1
        0x0100497a:    6078        x`      STR      r0,[r7,#4]
        0x0100497c:    2800        .(      CMP      r0,#0
        0x0100497e:    da1b        ..      BGE      0x10049b8 ; init_used_nvds + 188
        0x01004980:    a22d        -.      ADR      r2,{pc}+0xb8 ; 0x1004a38
        0x01004982:    f44f4100    O..A    MOV      r1,#0x8000
        0x01004986:    2000        .       MOVS     r0,#0
        0x01004988:    f408d208    ....    BL       dbg_log_printf ; 0xcd9c
        0x0100498c:    f89b0000    ....    LDRB     r0,[r11,#0]
        0x01004990:    f471d286    q...    BL       hal_flash_set_security ; 0x75ea0
        0x01004994:    2001        .       MOVS     r0,#1
        0x01004996:    e8bd9ffc    ....    POP      {r2-r12,pc}
        0x0100499a:    f04f0a01    O...    MOV      r10,#1
        0x0100499e:    e01a        ..      B        0x10049d6 ; init_used_nvds + 218
        0x010049a0:    a233        3.      ADR      r2,{pc}+0xd0 ; 0x1004a70
        0x010049a2:    f44f4100    O..A    MOV      r1,#0x8000
        0x010049a6:    2000        .       MOVS     r0,#0
        0x010049a8:    f408d1f8    ....    BL       dbg_log_printf ; 0xcd9c
        0x010049ac:    f89b0000    ....    LDRB     r0,[r11,#0]
        0x010049b0:    f471d276    q.v.    BL       hal_flash_set_security ; 0x75ea0
        0x010049b4:    2009        .       MOVS     r0,#9
        0x010049b6:    e7ee        ..      B        0x1004996 ; init_used_nvds + 154
        0x010049b8:    f04f0900    O...    MOV      r9,#0
        0x010049bc:    4621        !F      MOV      r1,r4
        0x010049be:    4668        hF      MOV      r0,sp
        0x010049c0:    f001ffc0    ....    BL       tags_cache_rec_add ; 0x1006944
        0x010049c4:    6839        9h      LDR      r1,[r7,#0]
        0x010049c6:    19a8        ..      ADDS     r0,r5,r6
        0x010049c8:    4401        .D      ADD      r1,r1,r0
        0x010049ca:    6039        9`      STR      r1,[r7,#0]
        0x010049cc:    4404        .D      ADD      r4,r4,r0
        0x010049ce:    4837        7H      LDR      r0,[pc,#220] ; [0x1004aac] = 0x8023d0
        0x010049d0:    6800        .h      LDR      r0,[r0,#0]
        0x010049d2:    4284        .B      CMP      r4,r0
        0x010049d4:    d3af        ..      BCC      0x1004936 ; init_used_nvds + 58
        0x010049d6:    f89b0000    ....    LDRB     r0,[r11,#0]
        0x010049da:    f471d261    q.a.    BL       hal_flash_set_security ; 0x75ea0
        0x010049de:    f1ba0f00    ....    CMP      r10,#0
        0x010049e2:    d005        ..      BEQ      0x10049f0 ; init_used_nvds + 244
        0x010049e4:    f1b90f00    ....    CMP      r9,#0
        0x010049e8:    d004        ..      BEQ      0x10049f4 ; init_used_nvds + 248
        0x010049ea:    f8c78004    ....    STR      r8,[r7,#4]
        0x010049ee:    e00a        ..      B        0x1004a06 ; init_used_nvds + 266
        0x010049f0:    2001        .       MOVS     r0,#1
        0x010049f2:    e7d0        ..      B        0x1004996 ; init_used_nvds + 154
        0x010049f4:    6878        xh      LDR      r0,[r7,#4]
        0x010049f6:    2808        .(      CMP      r0,#8
        0x010049f8:    d902        ..      BLS      0x1004a00 ; init_used_nvds + 260
        0x010049fa:    3808        .8      SUBS     r0,r0,#8
        0x010049fc:    6078        x`      STR      r0,[r7,#4]
        0x010049fe:    e002        ..      B        0x1004a06 ; init_used_nvds + 266
        0x01004a00:    7238        8r      STRB     r0,[r7,#8]
        0x01004a02:    2000        .       MOVS     r0,#0
        0x01004a04:    6078        x`      STR      r0,[r7,#4]
        0x01004a06:    687b        {h      LDR      r3,[r7,#4]
        0x01004a08:    4543        CE      CMP      r3,r8
        0x01004a0a:    d807        ..      BHI      0x1004a1c ; init_used_nvds + 288
        0x01004a0c:    a228        (.      ADR      r2,{pc}+0xa4 ; 0x1004ab0
        0x01004a0e:    f44f4100    O..A    MOV      r1,#0x8000
        0x01004a12:    2000        .       MOVS     r0,#0
        0x01004a14:    f408d1c2    ....    BL       dbg_log_printf ; 0xcd9c
        0x01004a18:    2000        .       MOVS     r0,#0
        0x01004a1a:    e7bc        ..      B        0x1004996 ; init_used_nvds + 154
        0x01004a1c:    a22f        /.      ADR      r2,{pc}+0xc0 ; 0x1004adc
        0x01004a1e:    f44f4100    O..A    MOV      r1,#0x8000
        0x01004a22:    2000        .       MOVS     r0,#0
        0x01004a24:    f408d1ba    ....    BL       dbg_log_printf ; 0xcd9c
        0x01004a28:    2001        .       MOVS     r0,#1
        0x01004a2a:    e7b4        ..      B        0x1004996 ; init_used_nvds + 154
    $d
        0x01004a2c:    008023cc    .#..    DCD    8397772
        0x01004a30:    008032d8    .2..    DCD    8401624
        0x01004a34:    008023c9    .#..    DCD    8397769
        0x01004a38:    3a353a52    R:5:    DCD    976566866
        0x01004a3c:    5344564e    NVDS    DCD    1396987470
        0x01004a40:    696e6920     ini    DCD    1768843552
        0x01004a44:    6c616974    tial    DCD    1818323316
        0x01004a48:    74617a69    izat    DCD    1952545385
        0x01004a4c:    206e6f69    ion     DCD    544108393
        0x01004a50:    6c696166    fail    DCD    1818845542
        0x01004a54:    66206465    ed f    DCD    1713398885
        0x01004a58:    7720726f    or w    DCD    1998615151
        0x01004a5c:    676e6f72    rong    DCD    1735290738
        0x01004a60:    67617420     tag    DCD    1734439968
        0x01004a64:    6e656c20     len    DCD    1852140576
        0x01004a68:    0d687467    gth.    DCD    224949351
        0x01004a6c:    0000000a    ....    DCD    10
        0x01004a70:    3a353a52    R:5:    DCD    976566866
        0x01004a74:    5344564e    NVDS    DCD    1396987470
        0x01004a78:    696e6920     ini    DCD    1768843552
        0x01004a7c:    6c616974    tial    DCD    1818323316
        0x01004a80:    74617a69    izat    DCD    1952545385
        0x01004a84:    206e6f69    ion     DCD    544108393
        0x01004a88:    6c696166    fail    DCD    1818845542
        0x01004a8c:    66206465    ed f    DCD    1713398885
        0x01004a90:    6920726f    or i    DCD    1763734127
        0x01004a94:    6c61766e    nval    DCD    1818326638
        0x01004a98:    64206469    id d    DCD    1679844457
        0x01004a9c:    20617461    ata     DCD    543257697
        0x01004aa0:    46206e69    in F    DCD    1176530537
        0x01004aa4:    6873616c    lash    DCD    1752392044
        0x01004aa8:    00000a0d    ....    DCD    2573
        0x01004aac:    008023d0    .#..    DCD    8397776
        0x01004ab0:    3a353a52    R:5:    DCD    976566866
        0x01004ab4:    74696e49    Init    DCD    1953066569
        0x01004ab8:    696c6169    iali    DCD    1768710505
        0x01004abc:    7520657a    ze u    DCD    1965057402
        0x01004ac0:    20646573    sed     DCD    543450483
        0x01004ac4:    7364766e    nvds    DCD    1935963758
        0x01004ac8:    7661202c    , av    DCD    1986076716
        0x01004acc:    5f6c6961    ail_    DCD    1600940385
        0x01004ad0:    657a6973    size    DCD    1702521203
        0x01004ad4:    0d75253d    =%u.    DCD    225781053
        0x01004ad8:    0000000a    ....    DCD    10
        0x01004adc:    3a353a52    R:5:    DCD    976566866
        0x01004ae0:    5344564e    NVDS    DCD    1396987470
        0x01004ae4:    696e6920     ini    DCD    1768843552
        0x01004ae8:    6c616974    tial    DCD    1818323316
        0x01004aec:    74617a69    izat    DCD    1952545385
        0x01004af0:    206e6f69    ion     DCD    544108393
        0x01004af4:    6c696166    fail    DCD    1818845542
        0x01004af8:    66206465    ed f    DCD    1713398885
        0x01004afc:    6920726f    or i    DCD    1763734127
        0x01004b00:    67656c6c    lleg    DCD    1734700140
        0x01004b04:    61206c61    al a    DCD    1629514849
        0x01004b08:    6c696176    vail    DCD    1818845558
        0x01004b0c:    7a69735f    _siz    DCD    2053731167
        0x01004b10:    75253d65    e=%u    DCD    1965374821
        0x01004b14:    00000a0d    ....    DCD    2573
    $t
    i.internal_3p3_ioldo_update
    internal_3p3_ioldo_update
        0x01004b18:    b510        ..      PUSH     {r4,lr}
        0x01004b1a:    4604        .F      MOV      r4,r0
        0x01004b1c:    f7fffe44    ..D.    BL       i0nd_ioldo_3v_get ; 0x10047a8
        0x01004b20:    f5b47fa3    ....    CMP      r4,#0x146
        0x01004b24:    da10        ..      BGE      0x1004b48 ; internal_3p3_ioldo_update + 48
        0x01004b26:    f44f718c    O..q    MOV      r1,#0x118
        0x01004b2a:    428c        .B      CMP      r4,r1
        0x01004b2c:    da00        ..      BGE      0x1004b30 ; internal_3p3_ioldo_update + 24
        0x01004b2e:    460c        .F      MOV      r4,r1
        0x01004b30:    4261        aB      RSBS     r1,r4,#0
        0x01004b32:    eb010181    ....    ADD      r1,r1,r1,LSL #2
        0x01004b36:    f64042b2    @..B    MOV      r2,#0xcb2
        0x01004b3a:    eb020241    ..A.    ADD      r2,r2,r1,LSL #1
        0x01004b3e:    2111        .!      MOVS     r1,#0x11
        0x01004b40:    fb92f1f1    ....    SDIV     r1,r2,r1
        0x01004b44:    1a40        @.      SUBS     r0,r0,r1
        0x01004b46:    b2c0        ..      UXTB     r0,r0
        0x01004b48:    4903        .I      LDR      r1,[pc,#12] ; [0x1004b58] = 0xa000c50c
        0x01004b4a:    680a        .h      LDR      r2,[r1,#0]
        0x01004b4c:    f02242fe    "..B    BIC      r2,r2,#0x7f000000
        0x01004b50:    ea426000    B..`    ORR      r0,r2,r0,LSL #24
        0x01004b54:    6008        .`      STR      r0,[r1,#0]
        0x01004b56:    bd10        ..      POP      {r4,pc}
    $d
        0x01004b58:    a000c50c    ....    DCD    2684405004
    $t
    i.is_item_same
    is_item_same
        0x01004b5c:    b570        p.      PUSH     {r4-r6,lr}
        0x01004b5e:    4603        .F      MOV      r3,r0
        0x01004b60:    460e        .F      MOV      r6,r1
        0x01004b62:    4615        .F      MOV      r5,r2
        0x01004b64:    4808        .H      LDR      r0,[pc,#32] ; [0x1004b88] = 0x300067d4
        0x01004b66:    6804        .h      LDR      r4,[r0,#0]
        0x01004b68:    4632        2F      MOV      r2,r6
        0x01004b6a:    4621        !F      MOV      r1,r4
        0x01004b6c:    4618        .F      MOV      r0,r3
        0x01004b6e:    f7fffc25    ..%.    BL       hal_flash_read ; 0x10043bc
        0x01004b72:    4632        2F      MOV      r2,r6
        0x01004b74:    4629        )F      MOV      r1,r5
        0x01004b76:    4620         F      MOV      r0,r4
        0x01004b78:    f7fdfc70    ..p.    BL       memcmp ; 0x100245c
        0x01004b7c:    b108        ..      CBZ      r0,0x1004b82 ; is_item_same + 38
        0x01004b7e:    2000        .       MOVS     r0,#0
        0x01004b80:    bd70        p.      POP      {r4-r6,pc}
        0x01004b82:    2001        .       MOVS     r0,#1
        0x01004b84:    bd70        p.      POP      {r4-r6,pc}
    $d
        0x01004b86:    0000        ..      DCW    0
        0x01004b88:    300067d4    .g.0    DCD    805332948
    $t
    i.ldo_voltage_set
    ldo_voltage_set
        0x01004b8c:    b57c        |.      PUSH     {r2-r6,lr}
        0x01004b8e:    4604        .F      MOV      r4,r0
        0x01004b90:    2000        .       MOVS     r0,#0
        0x01004b92:    9000        ..      STR      r0,[sp,#0]
        0x01004b94:    9001        ..      STR      r0,[sp,#4]
        0x01004b96:    4668        hF      MOV      r0,sp
        0x01004b98:    f001fcc6    ....    BL       sys_pmu_trim_get ; 0x1006528
        0x01004b9c:    2800        .(      CMP      r0,#0
        0x01004b9e:    d15e        ^.      BNE      0x1004c5e ; ldo_voltage_set + 210
        0x01004ba0:    f001fcae    ....    BL       sys_is_use_internal_3p3_ioldo ; 0x1006500
        0x01004ba4:    f0800001    ....    EOR      r0,r0,#1
        0x01004ba8:    b320         .      CBZ      r0,0x1004bf4 ; ldo_voltage_set + 104
        0x01004baa:    f001fc89    ....    BL       sys_is_use_ext_flash ; 0x10064c0
        0x01004bae:    0002        ..      MOVS     r2,r0
        0x01004bb0:    482b        +H      LDR      r0,[pc,#172] ; [0x1004c60] = 0x803212
        0x01004bb2:    492c        ,I      LDR      r1,[pc,#176] ; [0x1004c64] = 0xa000c50c
        0x01004bb4:    d009        ..      BEQ      0x1004bca ; ldo_voltage_set + 62
        0x01004bb6:    f8900028    ..(.    LDRB     r0,[r0,#0x28]
        0x01004bba:    3008        .0      ADDS     r0,r0,#8
        0x01004bbc:    680a        .h      LDR      r2,[r1,#0]
        0x01004bbe:    f02242fe    "..B    BIC      r2,r2,#0x7f000000
        0x01004bc2:    ea426000    B..`    ORR      r0,r2,r0,LSL #24
        0x01004bc6:    6008        .`      STR      r0,[r1,#0]
        0x01004bc8:    e014        ..      B        0x1004bf4 ; ldo_voltage_set + 104
        0x01004bca:    f8900028    ..(.    LDRB     r0,[r0,#0x28]
        0x01004bce:    2c32        2,      CMP      r4,#0x32
        0x01004bd0:    db07        ..      BLT      0x1004be2 ; ldo_voltage_set + 86
        0x01004bd2:    3008        .0      ADDS     r0,r0,#8
        0x01004bd4:    680a        .h      LDR      r2,[r1,#0]
        0x01004bd6:    f02242fe    "..B    BIC      r2,r2,#0x7f000000
        0x01004bda:    ea426000    B..`    ORR      r0,r2,r0,LSL #24
        0x01004bde:    6008        .`      STR      r0,[r1,#0]
        0x01004be0:    e008        ..      B        0x1004bf4 ; ldo_voltage_set + 104
        0x01004be2:    2c28        (,      CMP      r4,#0x28
        0x01004be4:    dc06        ..      BGT      0x1004bf4 ; ldo_voltage_set + 104
        0x01004be6:    1cc0        ..      ADDS     r0,r0,#3
        0x01004be8:    680a        .h      LDR      r2,[r1,#0]
        0x01004bea:    f02242fe    "..B    BIC      r2,r2,#0x7f000000
        0x01004bee:    ea426000    B..`    ORR      r0,r2,r0,LSL #24
        0x01004bf2:    6008        .`      STR      r0,[r1,#0]
        0x01004bf4:    f89d0004    ....    LDRB     r0,[sp,#4]
        0x01004bf8:    f000021f    ....    AND      r2,r0,#0x1f
        0x01004bfc:    f89d0002    ....    LDRB     r0,[sp,#2]
        0x01004c00:    f000051f    ....    AND      r5,r0,#0x1f
        0x01004c04:    2102        .!      MOVS     r1,#2
        0x01004c06:    2004        .       MOVS     r0,#4
        0x01004c08:    2301        .#      MOVS     r3,#1
        0x01004c0a:    2c3c        <,      CMP      r4,#0x3c
        0x01004c0c:    dd02        ..      BLE      0x1004c14 ; ldo_voltage_set + 136
        0x01004c0e:    2104        .!      MOVS     r1,#4
        0x01004c10:    2006        .       MOVS     r0,#6
        0x01004c12:    e007        ..      B        0x1004c24 ; ldo_voltage_set + 152
        0x01004c14:    2c20         ,      CMP      r4,#0x20
        0x01004c16:    dd02        ..      BLE      0x1004c1e ; ldo_voltage_set + 146
        0x01004c18:    2103        .!      MOVS     r1,#3
        0x01004c1a:    2005        .       MOVS     r0,#5
        0x01004c1c:    e002        ..      B        0x1004c24 ; ldo_voltage_set + 152
        0x01004c1e:    2c1b        .,      CMP      r4,#0x1b
        0x01004c20:    db00        ..      BLT      0x1004c24 ; ldo_voltage_set + 152
        0x01004c22:    2300        .#      MOVS     r3,#0
        0x01004c24:    2b00        .+      CMP      r3,#0
        0x01004c26:    d01a        ..      BEQ      0x1004c5e ; ldo_voltage_set + 210
        0x01004c28:    4429        )D      ADD      r1,r1,r5
        0x01004c2a:    291f        .)      CMP      r1,#0x1f
        0x01004c2c:    d300        ..      BCC      0x1004c30 ; ldo_voltage_set + 164
        0x01004c2e:    211f        .!      MOVS     r1,#0x1f
        0x01004c30:    4282        .B      CMP      r2,r0
        0x01004c32:    d901        ..      BLS      0x1004c38 ; ldo_voltage_set + 172
        0x01004c34:    1a10        ..      SUBS     r0,r2,r0
        0x01004c36:    e000        ..      B        0x1004c3a ; ldo_voltage_set + 174
        0x01004c38:    2000        .       MOVS     r0,#0
        0x01004c3a:    4a0b        .J      LDR      r2,[pc,#44] ; [0x1004c68] = 0x30006814
        0x01004c3c:    72d0        .r      STRB     r0,[r2,#0xb]
        0x01004c3e:    4a09        .J      LDR      r2,[pc,#36] ; [0x1004c64] = 0xa000c50c
        0x01004c40:    3218        .2      ADDS     r2,r2,#0x18
        0x01004c42:    6813        .h      LDR      r3,[r2,#0]
        0x01004c44:    f423031f    #...    BIC      r3,r3,#0x9f0000
        0x01004c48:    ea434101    C..A    ORR      r1,r3,r1,LSL #16
        0x01004c4c:    6011        .`      STR      r1,[r2,#0]
        0x01004c4e:    4905        .I      LDR      r1,[pc,#20] ; [0x1004c64] = 0xa000c50c
        0x01004c50:    1d09        ..      ADDS     r1,r1,#4
        0x01004c52:    680a        .h      LDR      r2,[r1,#0]
        0x01004c54:    f4220278    ".x.    BIC      r2,r2,#0xf80000
        0x01004c58:    ea4240c0    B..@    ORR      r0,r2,r0,LSL #19
        0x01004c5c:    6008        .`      STR      r0,[r1,#0]
        0x01004c5e:    bd7c        |.      POP      {r2-r6,pc}
    $d
        0x01004c60:    00803212    .2..    DCD    8401426
        0x01004c64:    a000c50c    ....    DCD    2684405004
        0x01004c68:    30006814    .h.0    DCD    805333012
    $t
    i.ll_adc_disable_clock
    ll_adc_disable_clock
        0x01004c6c:    f3ef8010    ....    MRS      r0,PRIMASK
        0x01004c70:    2101        .!      MOVS     r1,#1
        0x01004c72:    f3818810    ....    MSR      PRIMASK,r1
        0x01004c76:    4904        .I      LDR      r1,[pc,#16] ; [0x1004c88] = 0xa000c540
        0x01004c78:    680a        .h      LDR      r2,[r1,#0]
        0x01004c7a:    f0224200    "..B    BIC      r2,r2,#0x80000000
        0x01004c7e:    600a        .`      STR      r2,[r1,#0]
        0x01004c80:    f3808810    ....    MSR      PRIMASK,r0
        0x01004c84:    4770        pG      BX       lr
    $d
        0x01004c86:    0000        ..      DCW    0
        0x01004c88:    a000c540    @...    DCD    2684405056
    $t
    i.ll_aon_gpio_init
    ll_aon_gpio_init
        0x01004c8c:    e92d41f0    -..A    PUSH     {r4-r8,lr}
        0x01004c90:    4604        .F      MOV      r4,r0
        0x01004c92:    6820         h      LDR      r0,[r4,#0]
        0x01004c94:    4d3b        ;M      LDR      r5,[pc,#236] ; [0x1004d84] = 0xa000c550
        0x01004c96:    e01f        ..      B        0x1004cd8 ; ll_aon_gpio_init + 76
        0x01004c98:    fa90f1a0    ....    RBIT     r1,r0
        0x01004c9c:    fab1f281    ....    CLZ      r2,r1
        0x01004ca0:    2101        .!      MOVS     r1,#1
        0x01004ca2:    4091        .@      LSLS     r1,r1,r2
        0x01004ca4:    1e42        B.      SUBS     r2,r0,#1
        0x01004ca6:    4010        .@      ANDS     r0,r0,r2
        0x01004ca8:    68e2        .h      LDR      r2,[r4,#0xc]
        0x01004caa:    fa91f3a1    ....    RBIT     r3,r1
        0x01004cae:    fab3f383    ....    CLZ      r3,r3
        0x01004cb2:    009b        ..      LSLS     r3,r3,#2
        0x01004cb4:    f8dfc0d0    ....    LDR      r12,[pc,#208] ; [0x1004d88] = 0xa000e000
        0x01004cb8:    f8dc7290    ...r    LDR      r7,[r12,#0x290]
        0x01004cbc:    260f        .&      MOVS     r6,#0xf
        0x01004cbe:    409e        .@      LSLS     r6,r6,r3
        0x01004cc0:    43b7        .C      BICS     r7,r7,r6
        0x01004cc2:    fa02f303    ....    LSL      r3,r2,r3
        0x01004cc6:    431f        .C      ORRS     r7,r7,r3
        0x01004cc8:    f8cc7290    ...r    STR      r7,[r12,#0x290]
        0x01004ccc:    2a07        .*      CMP      r2,#7
        0x01004cce:    d025        %.      BEQ      0x1004d1c ; ll_aon_gpio_init + 144
        0x01004cd0:    682a        *h      LDR      r2,[r5,#0]
        0x01004cd2:    ea424101    B..A    ORR      r1,r2,r1,LSL #16
        0x01004cd6:    6029        )`      STR      r1,[r5,#0]
        0x01004cd8:    2800        .(      CMP      r0,#0
        0x01004cda:    d1dd        ..      BNE      0x1004c98 ; ll_aon_gpio_init + 12
        0x01004cdc:    6821        !h      LDR      r1,[r4,#0]
        0x01004cde:    68a0        .h      LDR      r0,[r4,#8]
        0x01004ce0:    f64f72ff    O..r    MOV      r2,#0xffff
        0x01004ce4:    ea022201    ..."    AND      r2,r2,r1,LSL #8
        0x01004ce8:    b2c9        ..      UXTB     r1,r1
        0x01004cea:    f5b07f80    ....    CMP      r0,#0x100
        0x01004cee:    d01a        ..      BEQ      0x1004d26 ; ll_aon_gpio_init + 154
        0x01004cf0:    2300        .#      MOVS     r3,#0
        0x01004cf2:    2801        .(      CMP      r0,#1
        0x01004cf4:    d019        ..      BEQ      0x1004d2a ; ll_aon_gpio_init + 158
        0x01004cf6:    2000        .       MOVS     r0,#0
        0x01004cf8:    682e        .h      LDR      r6,[r5,#0]
        0x01004cfa:    4311        .C      ORRS     r1,r1,r2
        0x01004cfc:    438e        .C      BICS     r6,r6,r1
        0x01004cfe:    4318        .C      ORRS     r0,r0,r3
        0x01004d00:    4306        .C      ORRS     r6,r6,r0
        0x01004d02:    602e        .`      STR      r6,[r5,#0]
        0x01004d04:    6861        ah      LDR      r1,[r4,#4]
        0x01004d06:    2902        .)      CMP      r1,#2
        0x01004d08:    d011        ..      BEQ      0x1004d2e ; ll_aon_gpio_init + 162
        0x01004d0a:    6820         h      LDR      r0,[r4,#0]
        0x01004d0c:    f000f84a    ..J.    BL       ll_aon_gpio_set_pin_mode ; 0x1004da4
        0x01004d10:    6820         h      LDR      r0,[r4,#0]
        0x01004d12:    491e        .I      LDR      r1,[pc,#120] ; [0x1004d8c] = 0xa0012000
        0x01004d14:    6248        Hb      STR      r0,[r1,#0x24]
        0x01004d16:    6860        `h      LDR      r0,[r4,#4]
        0x01004d18:    b170        p.      CBZ      r0,0x1004d38 ; ll_aon_gpio_init + 172
        0x01004d1a:    e030        0.      B        0x1004d7e ; ll_aon_gpio_init + 242
        0x01004d1c:    682a        *h      LDR      r2,[r5,#0]
        0x01004d1e:    ea224101    "..A    BIC      r1,r2,r1,LSL #16
        0x01004d22:    6029        )`      STR      r1,[r5,#0]
        0x01004d24:    e7d8        ..      B        0x1004cd8 ; ll_aon_gpio_init + 76
        0x01004d26:    4613        .F      MOV      r3,r2
        0x01004d28:    e7e3        ..      B        0x1004cf2 ; ll_aon_gpio_init + 102
        0x01004d2a:    4608        .F      MOV      r0,r1
        0x01004d2c:    e7e4        ..      B        0x1004cf8 ; ll_aon_gpio_init + 108
        0x01004d2e:    2100        .!      MOVS     r1,#0
        0x01004d30:    6820         h      LDR      r0,[r4,#0]
        0x01004d32:    f000f837    ..7.    BL       ll_aon_gpio_set_pin_mode ; 0x1004da4
        0x01004d36:    e7eb        ..      B        0x1004d10 ; ll_aon_gpio_init + 132
        0x01004d38:    6820         h      LDR      r0,[r4,#0]
        0x01004d3a:    6388        .c      STR      r0,[r1,#0x38]
        0x01004d3c:    6920         i      LDR      r0,[r4,#0x10]
        0x01004d3e:    2801        .(      CMP      r0,#1
        0x01004d40:    d00c        ..      BEQ      0x1004d5c ; ll_aon_gpio_init + 208
        0x01004d42:    2802        .(      CMP      r0,#2
        0x01004d44:    d004        ..      BEQ      0x1004d50 ; ll_aon_gpio_init + 196
        0x01004d46:    2803        .(      CMP      r0,#3
        0x01004d48:    d00e        ..      BEQ      0x1004d68 ; ll_aon_gpio_init + 220
        0x01004d4a:    2804        .(      CMP      r0,#4
        0x01004d4c:    d117        ..      BNE      0x1004d7e ; ll_aon_gpio_init + 242
        0x01004d4e:    e011        ..      B        0x1004d74 ; ll_aon_gpio_init + 232
        0x01004d50:    6820         h      LDR      r0,[r4,#0]
        0x01004d52:    6348        Hc      STR      r0,[r1,#0x34]
        0x01004d54:    6288        .b      STR      r0,[r1,#0x28]
        0x01004d56:    6820         h      LDR      r0,[r4,#0]
        0x01004d58:    6208        .b      STR      r0,[r1,#0x20]
        0x01004d5a:    e010        ..      B        0x1004d7e ; ll_aon_gpio_init + 242
        0x01004d5c:    6820         h      LDR      r0,[r4,#0]
        0x01004d5e:    6308        .c      STR      r0,[r1,#0x30]
        0x01004d60:    6288        .b      STR      r0,[r1,#0x28]
        0x01004d62:    6820         h      LDR      r0,[r4,#0]
        0x01004d64:    6208        .b      STR      r0,[r1,#0x20]
        0x01004d66:    e00a        ..      B        0x1004d7e ; ll_aon_gpio_init + 242
        0x01004d68:    6820         h      LDR      r0,[r4,#0]
        0x01004d6a:    6308        .c      STR      r0,[r1,#0x30]
        0x01004d6c:    62c8        .b      STR      r0,[r1,#0x2c]
        0x01004d6e:    6820         h      LDR      r0,[r4,#0]
        0x01004d70:    6208        .b      STR      r0,[r1,#0x20]
        0x01004d72:    e004        ..      B        0x1004d7e ; ll_aon_gpio_init + 242
        0x01004d74:    6820         h      LDR      r0,[r4,#0]
        0x01004d76:    6348        Hc      STR      r0,[r1,#0x34]
        0x01004d78:    62c8        .b      STR      r0,[r1,#0x2c]
        0x01004d7a:    6820         h      LDR      r0,[r4,#0]
        0x01004d7c:    6208        .b      STR      r0,[r1,#0x20]
        0x01004d7e:    2001        .       MOVS     r0,#1
        0x01004d80:    e8bd81f0    ....    POP      {r4-r8,pc}
    $d
        0x01004d84:    a000c550    P...    DCD    2684405072
        0x01004d88:    a000e000    ....    DCD    2684411904
        0x01004d8c:    a0012000    . ..    DCD    2684428288
    $t
    i.ll_aon_gpio_is_enabled_it
    ll_aon_gpio_is_enabled_it
        0x01004d90:    4903        .I      LDR      r1,[pc,#12] ; [0x1004da0] = 0xa0012000
        0x01004d92:    6a09        .j      LDR      r1,[r1,#0x20]
        0x01004d94:    4388        .C      BICS     r0,r0,r1
        0x01004d96:    d001        ..      BEQ      0x1004d9c ; ll_aon_gpio_is_enabled_it + 12
        0x01004d98:    2000        .       MOVS     r0,#0
        0x01004d9a:    4770        pG      BX       lr
        0x01004d9c:    2001        .       MOVS     r0,#1
        0x01004d9e:    4770        pG      BX       lr
    $d
        0x01004da0:    a0012000    . ..    DCD    2684428288
    $t
    i.ll_aon_gpio_set_pin_mode
    ll_aon_gpio_set_pin_mode
        0x01004da4:    b510        ..      PUSH     {r4,lr}
        0x01004da6:    b2c0        ..      UXTB     r0,r0
        0x01004da8:    f3ef8210    ....    MRS      r2,PRIMASK
        0x01004dac:    2301        .#      MOVS     r3,#1
        0x01004dae:    f3838810    ....    MSR      PRIMASK,r3
        0x01004db2:    4b05        .K      LDR      r3,[pc,#20] ; [0x1004dc8] = 0xa000c55c
        0x01004db4:    681c        .h      LDR      r4,[r3,#0]
        0x01004db6:    4384        .C      BICS     r4,r4,r0
        0x01004db8:    2900        .)      CMP      r1,#0
        0x01004dba:    d000        ..      BEQ      0x1004dbe ; ll_aon_gpio_set_pin_mode + 26
        0x01004dbc:    2000        .       MOVS     r0,#0
        0x01004dbe:    4304        .C      ORRS     r4,r4,r0
        0x01004dc0:    601c        .`      STR      r4,[r3,#0]
        0x01004dc2:    f3828810    ....    MSR      PRIMASK,r2
        0x01004dc6:    bd10        ..      POP      {r4,pc}
    $d
        0x01004dc8:    a000c55c    \...    DCD    2684405084
    $t
    i.ll_aon_wdt_get_counter
    ll_aon_wdt_get_counter
        0x01004dcc:    4805        .H      LDR      r0,[pc,#20] ; [0x1004de4] = 0xa000c55c
        0x01004dce:    6801        .h      LDR      r1,[r0,#0]
        0x01004dd0:    f0214140    !.@A    BIC      r1,r1,#0xc0000000
        0x01004dd4:    f0414180    A..A    ORR      r1,r1,#0x40000000
        0x01004dd8:    6001        .`      STR      r1,[r0,#0]
        0x01004dda:    4802        .H      LDR      r0,[pc,#8] ; [0x1004de4] = 0xa000c55c
        0x01004ddc:    3038        80      ADDS     r0,r0,#0x38
        0x01004dde:    6800        .h      LDR      r0,[r0,#0]
        0x01004de0:    4770        pG      BX       lr
    $d
        0x01004de2:    0000        ..      DCW    0
        0x01004de4:    a000c55c    \...    DCD    2684405084
    $t
    i.ll_calendar_clear_flag_alarm
    ll_calendar_clear_flag_alarm
        0x01004de8:    f3ef8010    ....    MRS      r0,PRIMASK
        0x01004dec:    2101        .!      MOVS     r1,#1
        0x01004dee:    f3818810    ....    MSR      PRIMASK,r1
        0x01004df2:    4a03        .J      LDR      r2,[pc,#12] ; [0x1004e00] = 0xa000c544
        0x01004df4:    f46f7180    o..q    MVN      r1,#0x100
        0x01004df8:    6011        .`      STR      r1,[r2,#0]
        0x01004dfa:    f3808810    ....    MSR      PRIMASK,r0
        0x01004dfe:    4770        pG      BX       lr
    $d
        0x01004e00:    a000c544    D...    DCD    2684405060
    $t
    i.ll_calendar_get_counter
    ll_calendar_get_counter
        0x01004e04:    f3ef8010    ....    MRS      r0,PRIMASK
        0x01004e08:    2101        .!      MOVS     r1,#1
        0x01004e0a:    f3818810    ....    MSR      PRIMASK,r1
        0x01004e0e:    4905        .I      LDR      r1,[pc,#20] ; [0x1004e24] = 0xa000c55c
        0x01004e10:    680a        .h      LDR      r2,[r1,#0]
        0x01004e12:    f0224240    ".@B    BIC      r2,r2,#0xc0000000
        0x01004e16:    600a        .`      STR      r2,[r1,#0]
        0x01004e18:    f3808810    ....    MSR      PRIMASK,r0
        0x01004e1c:    4801        .H      LDR      r0,[pc,#4] ; [0x1004e24] = 0xa000c55c
        0x01004e1e:    3038        80      ADDS     r0,r0,#0x38
        0x01004e20:    6800        .h      LDR      r0,[r0,#0]
        0x01004e22:    4770        pG      BX       lr
    $d
        0x01004e24:    a000c55c    \...    DCD    2684405084
    $t
    i.ll_calendar_set_clock_div
    ll_calendar_set_clock_div
        0x01004e28:    4903        .I      LDR      r1,[pc,#12] ; [0x1004e38] = 0xa000c518
        0x01004e2a:    680a        .h      LDR      r2,[r1,#0]
        0x01004e2c:    f42262e0    "..b    BIC      r2,r2,#0x700
        0x01004e30:    4302        .C      ORRS     r2,r2,r0
        0x01004e32:    600a        .`      STR      r2,[r1,#0]
        0x01004e34:    4770        pG      BX       lr
    $d
        0x01004e36:    0000        ..      DCW    0
        0x01004e38:    a000c518    ....    DCD    2684405016
    $t
    i.ll_gpio_set_pin_pull
    ll_gpio_set_pin_pull
        0x01004e3c:    b510        ..      PUSH     {r4,lr}
        0x01004e3e:    4b0e        .K      LDR      r3,[pc,#56] ; [0x1004e78] = 0xa0010000
        0x01004e40:    4298        .B      CMP      r0,r3
        0x01004e42:    d101        ..      BNE      0x1004e48 ; ll_gpio_set_pin_pull + 12
        0x01004e44:    2000        .       MOVS     r0,#0
        0x01004e46:    e000        ..      B        0x1004e4a ; ll_gpio_set_pin_pull + 14
        0x01004e48:    2010        .       MOVS     r0,#0x10
        0x01004e4a:    4081        .@      LSLS     r1,r1,r0
        0x01004e4c:    4b0b        .K      LDR      r3,[pc,#44] ; [0x1004e7c] = 0xa000e000
        0x01004e4e:    f8d34210    ...B    LDR      r4,[r3,#0x210]
        0x01004e52:    438c        .C      BICS     r4,r4,r1
        0x01004e54:    2a02        .*      CMP      r2,#2
        0x01004e56:    d00d        ..      BEQ      0x1004e74 ; ll_gpio_set_pin_pull + 56
        0x01004e58:    2000        .       MOVS     r0,#0
        0x01004e5a:    4304        .C      ORRS     r4,r4,r0
        0x01004e5c:    f8c34210    ...B    STR      r4,[r3,#0x210]
        0x01004e60:    f8d30208    ....    LDR      r0,[r3,#0x208]
        0x01004e64:    4388        .C      BICS     r0,r0,r1
        0x01004e66:    2a01        .*      CMP      r2,#1
        0x01004e68:    d000        ..      BEQ      0x1004e6c ; ll_gpio_set_pin_pull + 48
        0x01004e6a:    2100        .!      MOVS     r1,#0
        0x01004e6c:    4308        .C      ORRS     r0,r0,r1
        0x01004e6e:    f8c30208    ....    STR      r0,[r3,#0x208]
        0x01004e72:    bd10        ..      POP      {r4,pc}
        0x01004e74:    4608        .F      MOV      r0,r1
        0x01004e76:    e7f0        ..      B        0x1004e5a ; ll_gpio_set_pin_pull + 30
    $d
        0x01004e78:    a0010000    ....    DCD    2684420096
        0x01004e7c:    a000e000    ....    DCD    2684411904
    $t
    i.ll_msio_init
    ll_msio_init
        0x01004e80:    e92d41f0    -..A    PUSH     {r4-r8,lr}
        0x01004e84:    4604        .F      MOV      r4,r0
        0x01004e86:    6821        !h      LDR      r1,[r4,#0]
        0x01004e88:    4d40        @M      LDR      r5,[pc,#256] ; [0x1004f8c] = 0xa000c540
        0x01004e8a:    e026        &.      B        0x1004eda ; ll_msio_init + 90
        0x01004e8c:    fa91f0a1    ....    RBIT     r0,r1
        0x01004e90:    fab0f280    ....    CLZ      r2,r0
        0x01004e94:    2001        .       MOVS     r0,#1
        0x01004e96:    4090        .@      LSLS     r0,r0,r2
        0x01004e98:    1e4a        J.      SUBS     r2,r1,#1
        0x01004e9a:    4011        .@      ANDS     r1,r1,r2
        0x01004e9c:    6922        "i      LDR      r2,[r4,#0x10]
        0x01004e9e:    fa90f3a0    ....    RBIT     r3,r0
        0x01004ea2:    fab3f383    ....    CLZ      r3,r3
        0x01004ea6:    009b        ..      LSLS     r3,r3,#2
        0x01004ea8:    4f39        9O      LDR      r7,[pc,#228] ; [0x1004f90] = 0xa000e294
        0x01004eaa:    683e        >h      LDR      r6,[r7,#0]
        0x01004eac:    f04f0c0f    O...    MOV      r12,#0xf
        0x01004eb0:    fa0cfc03    ....    LSL      r12,r12,r3
        0x01004eb4:    ea26060c    &...    BIC      r6,r6,r12
        0x01004eb8:    fa02f303    ....    LSL      r3,r2,r3
        0x01004ebc:    431e        .C      ORRS     r6,r6,r3
        0x01004ebe:    603e        >`      STR      r6,[r7,#0]
        0x01004ec0:    2a07        .*      CMP      r2,#7
        0x01004ec2:    d019        ..      BEQ      0x1004ef8 ; ll_msio_init + 120
        0x01004ec4:    f3ef8210    ....    MRS      r2,PRIMASK
        0x01004ec8:    2301        .#      MOVS     r3,#1
        0x01004eca:    f3838810    ....    MSR      PRIMASK,r3
        0x01004ece:    682b        +h      LDR      r3,[r5,#0]
        0x01004ed0:    ea435080    C..P    ORR      r0,r3,r0,LSL #22
        0x01004ed4:    6028        (`      STR      r0,[r5,#0]
        0x01004ed6:    f3828810    ....    MSR      PRIMASK,r2
        0x01004eda:    2900        .)      CMP      r1,#0
        0x01004edc:    d1d6        ..      BNE      0x1004e8c ; ll_msio_init + 12
        0x01004ede:    68e1        .h      LDR      r1,[r4,#0xc]
        0x01004ee0:    6820         h      LDR      r0,[r4,#0]
        0x01004ee2:    4e2a        *N      LDR      r6,[pc,#168] ; [0x1004f8c] = 0xa000c540
        0x01004ee4:    1f36        6.      SUBS     r6,r6,#4
        0x01004ee6:    b329        ).      CBZ      r1,0x1004f34 ; ll_msio_init + 180
        0x01004ee8:    f44f52f8    O..R    MOV      r2,#0x1f00
        0x01004eec:    ea022200    ..."    AND      r2,r2,r0,LSL #8
        0x01004ef0:    2901        .)      CMP      r1,#1
        0x01004ef2:    d00d        ..      BEQ      0x1004f10 ; ll_msio_init + 144
        0x01004ef4:    2100        .!      MOVS     r1,#0
        0x01004ef6:    e00c        ..      B        0x1004f12 ; ll_msio_init + 146
        0x01004ef8:    f3ef8210    ....    MRS      r2,PRIMASK
        0x01004efc:    2301        .#      MOVS     r3,#1
        0x01004efe:    f3838810    ....    MSR      PRIMASK,r3
        0x01004f02:    682b        +h      LDR      r3,[r5,#0]
        0x01004f04:    ea235080    #..P    BIC      r0,r3,r0,LSL #22
        0x01004f08:    6028        (`      STR      r0,[r5,#0]
        0x01004f0a:    f3828810    ....    MSR      PRIMASK,r2
        0x01004f0e:    e7e4        ..      B        0x1004eda ; ll_msio_init + 90
        0x01004f10:    4611        .F      MOV      r1,r2
        0x01004f12:    6833        3h      LDR      r3,[r6,#0]
        0x01004f14:    f000001f    ....    AND      r0,r0,#0x1f
        0x01004f18:    4383        .C      BICS     r3,r3,r0
        0x01004f1a:    6033        3`      STR      r3,[r6,#0]
        0x01004f1c:    f3ef8010    ....    MRS      r0,PRIMASK
        0x01004f20:    2301        .#      MOVS     r3,#1
        0x01004f22:    f3838810    ....    MSR      PRIMASK,r3
        0x01004f26:    682b        +h      LDR      r3,[r5,#0]
        0x01004f28:    4393        .C      BICS     r3,r3,r2
        0x01004f2a:    430b        .C      ORRS     r3,r3,r1
        0x01004f2c:    602b        +`      STR      r3,[r5,#0]
        0x01004f2e:    f3808810    ....    MSR      PRIMASK,r0
        0x01004f32:    e004        ..      B        0x1004f3e ; ll_msio_init + 190
        0x01004f34:    6831        1h      LDR      r1,[r6,#0]
        0x01004f36:    f000001f    ....    AND      r0,r0,#0x1f
        0x01004f3a:    4301        .C      ORRS     r1,r1,r0
        0x01004f3c:    6031        1`      STR      r1,[r6,#0]
        0x01004f3e:    68a1        .h      LDR      r1,[r4,#8]
        0x01004f40:    6820         h      LDR      r0,[r4,#0]
        0x01004f42:    f000f827    ..'.    BL       ll_msio_set_pin_mode ; 0x1004f94
        0x01004f46:    8820         .      LDRH     r0,[r4,#0]
        0x01004f48:    6862        bh      LDR      r2,[r4,#4]
        0x01004f4a:    f04f51f8    O..Q    MOV      r1,#0x1f000000
        0x01004f4e:    ea016100    ...a    AND      r1,r1,r0,LSL #24
        0x01004f52:    f44f13f8    O...    MOV      r3,#0x1f0000
        0x01004f56:    ea034000    ...@    AND      r0,r3,r0,LSL #16
        0x01004f5a:    b182        ..      CBZ      r2,0x1004f7e ; ll_msio_init + 254
        0x01004f5c:    2a03        .*      CMP      r2,#3
        0x01004f5e:    d009        ..      BEQ      0x1004f74 ; ll_msio_init + 244
        0x01004f60:    6833        3h      LDR      r3,[r6,#0]
        0x01004f62:    ea400401    @...    ORR      r4,r0,r1
        0x01004f66:    43a3        .C      BICS     r3,r3,r4
        0x01004f68:    2a01        .*      CMP      r2,#1
        0x01004f6a:    d100        ..      BNE      0x1004f6e ; ll_msio_init + 238
        0x01004f6c:    4608        .F      MOV      r0,r1
        0x01004f6e:    4303        .C      ORRS     r3,r3,r0
        0x01004f70:    6033        3`      STR      r3,[r6,#0]
        0x01004f72:    e008        ..      B        0x1004f86 ; ll_msio_init + 262
        0x01004f74:    6832        2h      LDR      r2,[r6,#0]
        0x01004f76:    4308        .C      ORRS     r0,r0,r1
        0x01004f78:    4382        .C      BICS     r2,r2,r0
        0x01004f7a:    6032        2`      STR      r2,[r6,#0]
        0x01004f7c:    e003        ..      B        0x1004f86 ; ll_msio_init + 262
        0x01004f7e:    6832        2h      LDR      r2,[r6,#0]
        0x01004f80:    4308        .C      ORRS     r0,r0,r1
        0x01004f82:    4302        .C      ORRS     r2,r2,r0
        0x01004f84:    6032        2`      STR      r2,[r6,#0]
        0x01004f86:    2001        .       MOVS     r0,#1
        0x01004f88:    e8bd81f0    ....    POP      {r4-r8,pc}
    $d
        0x01004f8c:    a000c540    @...    DCD    2684405056
        0x01004f90:    a000e294    ....    DCD    2684412564
    $t
    i.ll_msio_set_pin_mode
    ll_msio_set_pin_mode
        0x01004f94:    b510        ..      PUSH     {r4,lr}
        0x01004f96:    f000001f    ....    AND      r0,r0,#0x1f
        0x01004f9a:    2901        .)      CMP      r1,#1
        0x01004f9c:    d001        ..      BEQ      0x1004fa2 ; ll_msio_set_pin_mode + 14
        0x01004f9e:    2100        .!      MOVS     r1,#0
        0x01004fa0:    e000        ..      B        0x1004fa4 ; ll_msio_set_pin_mode + 16
        0x01004fa2:    4601        .F      MOV      r1,r0
        0x01004fa4:    f3ef8210    ....    MRS      r2,PRIMASK
        0x01004fa8:    2301        .#      MOVS     r3,#1
        0x01004faa:    f3838810    ....    MSR      PRIMASK,r3
        0x01004fae:    4b04        .K      LDR      r3,[pc,#16] ; [0x1004fc0] = 0xa000c540
        0x01004fb0:    681c        .h      LDR      r4,[r3,#0]
        0x01004fb2:    4384        .C      BICS     r4,r4,r0
        0x01004fb4:    430c        .C      ORRS     r4,r4,r1
        0x01004fb6:    601c        .`      STR      r4,[r3,#0]
        0x01004fb8:    f3828810    ....    MSR      PRIMASK,r2
        0x01004fbc:    bd10        ..      POP      {r4,pc}
    $d
        0x01004fbe:    0000        ..      DCW    0
        0x01004fc0:    a000c540    @...    DCD    2684405056
    $t
    i.main
    main
        0x01004fc4:    b510        ..      PUSH     {r4,lr}
        0x01004fc6:    f7fdff79    ..y.    BL       app_uart_demo ; 0x1002ebc
        0x01004fca:    2000        .       MOVS     r0,#0
        0x01004fcc:    bd10        ..      POP      {r4,pc}
    i.main_init
    main_init
        0x01004fce:    b510        ..      PUSH     {r4,lr}
        0x01004fd0:    f473d58e    s...    BL       pwr_mgmt_get_wakeup_flag ; 0x78af0
        0x01004fd4:    b110        ..      CBZ      r0,0x1004fdc ; main_init + 14
        0x01004fd6:    f001fee1    ....    BL       warm_boot_process ; 0x1006d9c
        0x01004fda:    e7fe        ..      B        0x1004fda ; main_init + 12
        0x01004fdc:    e8bd4010    ...@    POP      {r4,lr}
        0x01004fe0:    f7fdb82e    ....    B        __main ; 0x1002040
    i.mem_low_power_auto_init
    mem_low_power_auto_init
        0x01004fe4:    e92d41ff    -..A    PUSH     {r0-r8,lr}
        0x01004fe8:    4604        .F      MOV      r4,r0
        0x01004fea:    2000        .       MOVS     r0,#0
        0x01004fec:    9000        ..      STR      r0,[sp,#0]
        0x01004fee:    9001        ..      STR      r0,[sp,#4]
        0x01004ff0:    9002        ..      STR      r0,[sp,#8]
        0x01004ff2:    9003        ..      STR      r0,[sp,#0xc]
        0x01004ff4:    4821        !H      LDR      r0,[pc,#132] ; [0x100507c] = 0x1002000
        0x01004ff6:    4922        "I      LDR      r1,[pc,#136] ; [0x1005080] = 0x1007cf4
        0x01004ff8:    f1b07f80    ....    CMP      r0,#0x1000000
        0x01004ffc:    d902        ..      BLS      0x1005004 ; mem_low_power_auto_init + 32
        0x01004ffe:    f1b07f88    ....    CMP      r0,#0x1100000
        0x01005002:    d308        ..      BCC      0x1005016 ; mem_low_power_auto_init + 50
        0x01005004:    f3c00013    ....    UBFX     r0,r0,#0,#20
        0x01005008:    f3c10113    ....    UBFX     r1,r1,#0,#20
        0x0100500c:    f000f860    ..`.    BL       mem_pwr_mgmt_trans_addr_to_section ; 0x10050d0
        0x01005010:    6821        !h      LDR      r1,[r4,#0]
        0x01005012:    4308        .C      ORRS     r0,r0,r1
        0x01005014:    6020         `      STR      r0,[r4,#0]
        0x01005016:    2500        .%      MOVS     r5,#0
        0x01005018:    4f1a        .O      LDR      r7,[pc,#104] ; [0x1005084] = 0x1007ca0
        0x0100501a:    481b        .H      LDR      r0,[pc,#108] ; [0x1005088] = 0x1007cf0
        0x0100501c:    1bc6        ..      SUBS     r6,r0,r7
        0x0100501e:    e010        ..      B        0x1005042 ; mem_low_power_auto_init + 94
        0x01005020:    eb071105    ....    ADD      r1,r7,r5,LSL #4
        0x01005024:    2210        ."      MOVS     r2,#0x10
        0x01005026:    4668        hF      MOV      r0,sp
        0x01005028:    f7fdfa44    ..D.    BL       __aeabi_memcpy ; 0x10024b4
        0x0100502c:    9801        ..      LDR      r0,[sp,#4]
        0x0100502e:    f3c00013    ....    UBFX     r0,r0,#0,#20
        0x01005032:    9902        ..      LDR      r1,[sp,#8]
        0x01005034:    4401        .D      ADD      r1,r1,r0
        0x01005036:    f000f84b    ..K.    BL       mem_pwr_mgmt_trans_addr_to_section ; 0x10050d0
        0x0100503a:    6821        !h      LDR      r1,[r4,#0]
        0x0100503c:    4308        .C      ORRS     r0,r0,r1
        0x0100503e:    6020         `      STR      r0,[r4,#0]
        0x01005040:    1c6d        m.      ADDS     r5,r5,#1
        0x01005042:    ebb51f16    ....    CMP      r5,r6,LSR #4
        0x01005046:    d3eb        ..      BCC      0x1005020 ; mem_low_power_auto_init + 60
        0x01005048:    4810        .H      LDR      r0,[pc,#64] ; [0x100508c] = 0x3003c000
        0x0100504a:    f3c00013    ....    UBFX     r0,r0,#0,#20
        0x0100504e:    4910        .I      LDR      r1,[pc,#64] ; [0x1005090] = 0x30040000
        0x01005050:    f3c10113    ....    UBFX     r1,r1,#0,#20
        0x01005054:    f000f83c    ..<.    BL       mem_pwr_mgmt_trans_addr_to_section ; 0x10050d0
        0x01005058:    6821        !h      LDR      r1,[r4,#0]
        0x0100505a:    4308        .C      ORRS     r0,r0,r1
        0x0100505c:    6020         `      STR      r0,[r4,#0]
        0x0100505e:    480d        .H      LDR      r0,[pc,#52] ; [0x1005094] = 0x3003b000
        0x01005060:    f3c00013    ....    UBFX     r0,r0,#0,#20
        0x01005064:    490c        .I      LDR      r1,[pc,#48] ; [0x1005098] = 0x3003c000
        0x01005066:    f3c10113    ....    UBFX     r1,r1,#0,#20
        0x0100506a:    4288        .B      CMP      r0,r1
        0x0100506c:    d004        ..      BEQ      0x1005078 ; mem_low_power_auto_init + 148
        0x0100506e:    f000f82f    ../.    BL       mem_pwr_mgmt_trans_addr_to_section ; 0x10050d0
        0x01005072:    6821        !h      LDR      r1,[r4,#0]
        0x01005074:    4308        .C      ORRS     r0,r0,r1
        0x01005076:    6020         `      STR      r0,[r4,#0]
        0x01005078:    e8bd81ff    ....    POP      {r0-r8,pc}
    $d
        0x0100507c:    01002000    . ..    DCD    16785408
        0x01005080:    01007cf4    .|..    DCD    16809204
        0x01005084:    01007ca0    .|..    DCD    16809120
        0x01005088:    01007cf0    .|..    DCD    16809200
        0x0100508c:    3003c000    ...0    DCD    805552128
        0x01005090:    30040000    ...0    DCD    805568512
        0x01005094:    3003b000    ...0    DCD    805548032
        0x01005098:    3003c000    ...0    DCD    805552128
    $t
    i.mem_pwr_mgmt_mode_set
    mem_pwr_mgmt_mode_set
        0x0100509c:    b538        8.      PUSH     {r3-r5,lr}
        0x0100509e:    490b        .I      LDR      r1,[pc,#44] ; [0x10050cc] = 0x3fc0000f
        0x010050a0:    9100        ..      STR      r1,[sp,#0]
        0x010050a2:    2801        .(      CMP      r0,#1
        0x010050a4:    d008        ..      BEQ      0x10050b8 ; mem_pwr_mgmt_mode_set + 28
        0x010050a6:    f04f34ff    O..4    MOV      r4,#0xffffffff
        0x010050aa:    4620         F      MOV      r0,r4
        0x010050ac:    f7ffdf8f    ....    BL       mem_pwr_mgmt_work_state_set ; 0x804fce
        0x010050b0:    4620         F      MOV      r0,r4
        0x010050b2:    f7ffdfae    ....    BL       mem_pwr_mgmt_sleep_state_set ; 0x805012
        0x010050b6:    bd38        8.      POP      {r3-r5,pc}
        0x010050b8:    4668        hF      MOV      r0,sp
        0x010050ba:    f7ffff93    ....    BL       mem_low_power_auto_init ; 0x1004fe4
        0x010050be:    9800        ..      LDR      r0,[sp,#0]
        0x010050c0:    f7ffdf85    ....    BL       mem_pwr_mgmt_work_state_set ; 0x804fce
        0x010050c4:    9800        ..      LDR      r0,[sp,#0]
        0x010050c6:    f7ffdfa4    ....    BL       mem_pwr_mgmt_sleep_state_set ; 0x805012
        0x010050ca:    bd38        8.      POP      {r3-r5,pc}
    $d
        0x010050cc:    3fc0000f    ...?    DCD    1069547535
    $t
    i.mem_pwr_mgmt_trans_addr_to_section
    mem_pwr_mgmt_trans_addr_to_section
        0x010050d0:    b5f0        ..      PUSH     {r4-r7,lr}
        0x010050d2:    4602        .F      MOV      r2,r0
        0x010050d4:    2000        .       MOVS     r0,#0
        0x010050d6:    2500        .%      MOVS     r5,#0
        0x010050d8:    2300        .#      MOVS     r3,#0
        0x010050da:    2600        .&      MOVS     r6,#0
        0x010050dc:    2400        .$      MOVS     r4,#0
        0x010050de:    4f12        .O      LDR      r7,[pc,#72] ; [0x1005128] = 0x1007c30
        0x010050e0:    f857c024    W.$.    LDR      r12,[r7,r4,LSL #2]
        0x010050e4:    4465        eD      ADD      r5,r5,r12
        0x010050e6:    42aa        .B      CMP      r2,r5
        0x010050e8:    d201        ..      BCS      0x10050ee ; mem_pwr_mgmt_trans_addr_to_section + 30
        0x010050ea:    4623        #F      MOV      r3,r4
        0x010050ec:    e003        ..      B        0x10050f6 ; mem_pwr_mgmt_trans_addr_to_section + 38
        0x010050ee:    1c64        d.      ADDS     r4,r4,#1
        0x010050f0:    b2e4        ..      UXTB     r4,r4
        0x010050f2:    2c0b        .,      CMP      r4,#0xb
        0x010050f4:    d3f4        ..      BCC      0x10050e0 ; mem_pwr_mgmt_trans_addr_to_section + 16
        0x010050f6:    2400        .$      MOVS     r4,#0
        0x010050f8:    2200        ."      MOVS     r2,#0
        0x010050fa:    f8575022    W."P    LDR      r5,[r7,r2,LSL #2]
        0x010050fe:    442c        ,D      ADD      r4,r4,r5
        0x01005100:    42a1        .B      CMP      r1,r4
        0x01005102:    d801        ..      BHI      0x1005108 ; mem_pwr_mgmt_trans_addr_to_section + 56
        0x01005104:    4616        .F      MOV      r6,r2
        0x01005106:    e003        ..      B        0x1005110 ; mem_pwr_mgmt_trans_addr_to_section + 64
        0x01005108:    1c52        R.      ADDS     r2,r2,#1
        0x0100510a:    b2d2        ..      UXTB     r2,r2
        0x0100510c:    2a0b        .*      CMP      r2,#0xb
        0x0100510e:    d3f4        ..      BCC      0x10050fa ; mem_pwr_mgmt_trans_addr_to_section + 42
        0x01005110:    2403        .$      MOVS     r4,#3
        0x01005112:    e005        ..      B        0x1005120 ; mem_pwr_mgmt_trans_addr_to_section + 80
        0x01005114:    005a        Z.      LSLS     r2,r3,#1
        0x01005116:    fa04f102    ....    LSL      r1,r4,r2
        0x0100511a:    4308        .C      ORRS     r0,r0,r1
        0x0100511c:    1c5b        [.      ADDS     r3,r3,#1
        0x0100511e:    b2db        ..      UXTB     r3,r3
        0x01005120:    42b3        .B      CMP      r3,r6
        0x01005122:    d9f7        ..      BLS      0x1005114 ; mem_pwr_mgmt_trans_addr_to_section + 68
        0x01005124:    bdf0        ..      POP      {r4-r7,pc}
    $d
        0x01005126:    0000        ..      DCW    0
        0x01005128:    01007c30    0|..    DCD    16809008
    $t
    i.nvds_deinit
    nvds_deinit
        0x0100512c:    b57c        |.      PUSH     {r2-r6,lr}
        0x0100512e:    4604        .F      MOV      r4,r0
        0x01005130:    460d        .F      MOV      r5,r1
        0x01005132:    2000        .       MOVS     r0,#0
        0x01005134:    9001        ..      STR      r0,[sp,#4]
        0x01005136:    9000        ..      STR      r0,[sp,#0]
        0x01005138:    4669        iF      MOV      r1,sp
        0x0100513a:    a801        ..      ADD      r0,sp,#4
        0x0100513c:    f470d656    p.V.    BL       hal_flash_get_info ; 0x75dec
        0x01005140:    f470d6aa    p...    BL       hal_flash_sector_size ; 0x75e98
        0x01005144:    fb05f100    ....    MUL      r1,r5,r0
        0x01005148:    b91c        ..      CBNZ     r4,0x1005152 ; nvds_deinit + 38
        0x0100514a:    9800        ..      LDR      r0,[sp,#0]
        0x0100514c:    1a44        D.      SUBS     r4,r0,r1
        0x0100514e:    f1047480    ...t    ADD      r4,r4,#0x1000000
        0x01005152:    4620         F      MOV      r0,r4
        0x01005154:    f7fff8f2    ....    BL       hal_flash_erase ; 0x100433c
        0x01005158:    b108        ..      CBZ      r0,0x100515e ; nvds_deinit + 50
        0x0100515a:    2000        .       MOVS     r0,#0
        0x0100515c:    bd7c        |.      POP      {r2-r6,pc}
        0x0100515e:    2009        .       MOVS     r0,#9
        0x01005160:    bd7c        |.      POP      {r2-r6,pc}
        0x01005162:    0000        ..      MOVS     r0,r0
    i.nvds_get
    nvds_get
        0x01005164:    e92d5fff    -.._    PUSH     {r0-r12,lr}
        0x01005168:    4607        .F      MOV      r7,r0
        0x0100516a:    460d        .F      MOV      r5,r1
        0x0100516c:    4616        .F      MOV      r6,r2
        0x0100516e:    484a        JH      LDR      r0,[pc,#296] ; [0x1005298] = 0x8023c8
        0x01005170:    7800        .x      LDRB     r0,[r0,#0]
        0x01005172:    2800        .(      CMP      r0,#0
        0x01005174:    d00c        ..      BEQ      0x1005190 ; nvds_get + 44
        0x01005176:    b13d        =.      CBZ      r5,0x1005188 ; nvds_get + 36
        0x01005178:    882c        ,.      LDRH     r4,[r5,#0]
        0x0100517a:    b12c        ,.      CBZ      r4,0x1005188 ; nvds_get + 36
        0x0100517c:    b126        &.      CBZ      r6,0x1005188 ; nvds_get + 36
        0x0100517e:    b11f        ..      CBZ      r7,0x1005188 ; nvds_get + 36
        0x01005180:    f64f7aff    O..z    MOV      r10,#0xffff
        0x01005184:    4557        WE      CMP      r7,r10
        0x01005186:    d105        ..      BNE      0x1005194 ; nvds_get + 48
        0x01005188:    2005        .       MOVS     r0,#5
        0x0100518a:    b004        ..      ADD      sp,sp,#0x10
        0x0100518c:    e8bd9ff0    ....    POP      {r4-r12,pc}
        0x01005190:    2001        .       MOVS     r0,#1
        0x01005192:    e7fa        ..      B        0x100518a ; nvds_get + 38
        0x01005194:    f04f0900    O...    MOV      r9,#0
        0x01005198:    f8a59000    ....    STRH     r9,[r5,#0]
        0x0100519c:    a903        ..      ADD      r1,sp,#0xc
        0x0100519e:    4638        8F      MOV      r0,r7
        0x010051a0:    f7fefcac    ....    BL       find_item ; 0x1003afc
        0x010051a4:    4680        .F      MOV      r8,r0
        0x010051a6:    ea5f0008    _...    MOVS     r0,r8
        0x010051aa:    d01f        ..      BEQ      0x10051ec ; nvds_get + 136
        0x010051ac:    f8bd200c    ...     LDRH     r2,[sp,#0xc]
        0x010051b0:    4294        .B      CMP      r4,r2
        0x010051b2:    d319        ..      BCC      0x10051e8 ; nvds_get + 132
        0x010051b4:    4631        1F      MOV      r1,r6
        0x010051b6:    f7fff901    ....    BL       hal_flash_read ; 0x10043bc
        0x010051ba:    4683        .F      MOV      r11,r0
        0x010051bc:    2409        .$      MOVS     r4,#9
        0x010051be:    2208        ."      MOVS     r2,#8
        0x010051c0:    a901        ..      ADD      r1,sp,#4
        0x010051c2:    f1a80008    ....    SUB      r0,r8,#8
        0x010051c6:    f7fefc39    ..9.    BL       dec_flash_read ; 0x1003a3c
        0x010051ca:    2808        .(      CMP      r0,#8
        0x010051cc:    d10f        ..      BNE      0x10051ee ; nvds_get + 138
        0x010051ce:    a801        ..      ADD      r0,sp,#4
        0x010051d0:    f001fdb6    ....    BL       verify_hdr_checksum ; 0x1006d40
        0x010051d4:    b158        X.      CBZ      r0,0x10051ee ; nvds_get + 138
        0x010051d6:    4631        1F      MOV      r1,r6
        0x010051d8:    a801        ..      ADD      r0,sp,#4
        0x010051da:    f001fdbc    ....    BL       verify_value_checksum ; 0x1006d56
        0x010051de:    b130        0.      CBZ      r0,0x10051ee ; nvds_get + 138
        0x010051e0:    f8a5b000    ....    STRH     r11,[r5,#0]
        0x010051e4:    2400        .$      MOVS     r4,#0
        0x010051e6:    e002        ..      B        0x10051ee ; nvds_get + 138
        0x010051e8:    2404        .$      MOVS     r4,#4
        0x010051ea:    e000        ..      B        0x10051ee ; nvds_get + 138
        0x010051ec:    2402        .$      MOVS     r4,#2
        0x010051ee:    2c02        .,      CMP      r4,#2
        0x010051f0:    d150        P.      BNE      0x1005294 ; nvds_get + 304
        0x010051f2:    f8cd9004    ....    STR      r9,[sp,#4]
        0x010051f6:    f8cd9008    ....    STR      r9,[sp,#8]
        0x010051fa:    f8cd9000    ....    STR      r9,[sp,#0]
        0x010051fe:    f46f4040    o.@@    MVN      r0,#0xc000
        0x01005202:    1838        8.      ADDS     r0,r7,r0
        0x01005204:    d002        ..      BEQ      0x100520c ; nvds_get + 168
        0x01005206:    28b0        .(      CMP      r0,#0xb0
        0x01005208:    d144        D.      BNE      0x1005294 ; nvds_get + 304
        0x0100520a:    e034        4.      B        0x1005276 ; nvds_get + 274
        0x0100520c:    a801        ..      ADD      r0,sp,#4
        0x0100520e:    f001f879    ..y.    BL       sys_device_addr_get ; 0x1006304
        0x01005212:    bb78        x.      CBNZ     r0,0x1005274 ; nvds_get + 272
        0x01005214:    f89d0004    ....    LDRB     r0,[sp,#4]
        0x01005218:    b970        p.      CBNZ     r0,0x1005238 ; nvds_get + 212
        0x0100521a:    f89d1005    ....    LDRB     r1,[sp,#5]
        0x0100521e:    b959        Y.      CBNZ     r1,0x1005238 ; nvds_get + 212
        0x01005220:    f89d1006    ....    LDRB     r1,[sp,#6]
        0x01005224:    b941        A.      CBNZ     r1,0x1005238 ; nvds_get + 212
        0x01005226:    f89d1007    ....    LDRB     r1,[sp,#7]
        0x0100522a:    b929        ).      CBNZ     r1,0x1005238 ; nvds_get + 212
        0x0100522c:    f89d1008    ....    LDRB     r1,[sp,#8]
        0x01005230:    b911        ..      CBNZ     r1,0x1005238 ; nvds_get + 212
        0x01005232:    f89d1009    ....    LDRB     r1,[sp,#9]
        0x01005236:    b1e9        ..      CBZ      r1,0x1005274 ; nvds_get + 272
        0x01005238:    28ff        .(      CMP      r0,#0xff
        0x0100523a:    d113        ..      BNE      0x1005264 ; nvds_get + 256
        0x0100523c:    f89d0005    ....    LDRB     r0,[sp,#5]
        0x01005240:    28ff        .(      CMP      r0,#0xff
        0x01005242:    d10f        ..      BNE      0x1005264 ; nvds_get + 256
        0x01005244:    f89d0006    ....    LDRB     r0,[sp,#6]
        0x01005248:    28ff        .(      CMP      r0,#0xff
        0x0100524a:    d10b        ..      BNE      0x1005264 ; nvds_get + 256
        0x0100524c:    f89d0007    ....    LDRB     r0,[sp,#7]
        0x01005250:    28ff        .(      CMP      r0,#0xff
        0x01005252:    d107        ..      BNE      0x1005264 ; nvds_get + 256
        0x01005254:    f89d0008    ....    LDRB     r0,[sp,#8]
        0x01005258:    28ff        .(      CMP      r0,#0xff
        0x0100525a:    d103        ..      BNE      0x1005264 ; nvds_get + 256
        0x0100525c:    f89d0009    ....    LDRB     r0,[sp,#9]
        0x01005260:    28ff        .(      CMP      r0,#0xff
        0x01005262:    d017        ..      BEQ      0x1005294 ; nvds_get + 304
        0x01005264:    9801        ..      LDR      r0,[sp,#4]
        0x01005266:    6030        0`      STR      r0,[r6,#0]
        0x01005268:    f8bd0008    ....    LDRH     r0,[sp,#8]
        0x0100526c:    80b0        ..      STRH     r0,[r6,#4]
        0x0100526e:    2006        .       MOVS     r0,#6
        0x01005270:    8028        (.      STRH     r0,[r5,#0]
        0x01005272:    2400        .$      MOVS     r4,#0
        0x01005274:    e00e        ..      B        0x1005294 ; nvds_get + 304
        0x01005276:    4668        hF      MOV      r0,sp
        0x01005278:    f001f834    ..4.    BL       sys_crystal_trim_get ; 0x10062e4
        0x0100527c:    b950        P.      CBNZ     r0,0x1005294 ; nvds_get + 304
        0x0100527e:    f8bd0000    ....    LDRH     r0,[sp,#0]
        0x01005282:    b138        8.      CBZ      r0,0x1005294 ; nvds_get + 304
        0x01005284:    4550        PE      CMP      r0,r10
        0x01005286:    d005        ..      BEQ      0x1005294 ; nvds_get + 304
        0x01005288:    f8bd0000    ....    LDRH     r0,[sp,#0]
        0x0100528c:    8030        0.      STRH     r0,[r6,#0]
        0x0100528e:    2002        .       MOVS     r0,#2
        0x01005290:    8028        (.      STRH     r0,[r5,#0]
        0x01005292:    2400        .$      MOVS     r4,#0
        0x01005294:    4620         F      MOV      r0,r4
        0x01005296:    e778        x.      B        0x100518a ; nvds_get + 38
    $d
        0x01005298:    008023c8    .#..    DCD    8397768
    $t
    i.nvds_init
    nvds_init
        0x0100529c:    b570        p.      PUSH     {r4-r6,lr}
        0x0100529e:    b088        ..      SUB      sp,sp,#0x20
        0x010052a0:    4605        .F      MOV      r5,r0
        0x010052a2:    460c        .F      MOV      r4,r1
        0x010052a4:    2c00        .,      CMP      r4,#0
        0x010052a6:    d00a        ..      BEQ      0x10052be ; nvds_init + 34
        0x010052a8:    a906        ..      ADD      r1,sp,#0x18
        0x010052aa:    a807        ..      ADD      r0,sp,#0x1c
        0x010052ac:    f470d59e    p...    BL       hal_flash_get_info ; 0x75dec
        0x010052b0:    4e2c        ,N      LDR      r6,[pc,#176] ; [0x1005364] = 0x8023cc
        0x010052b2:    b18d        ..      CBZ      r5,0x10052d8 ; nvds_init + 60
        0x010052b4:    0528        (.      LSLS     r0,r5,#20
        0x010052b6:    d004        ..      BEQ      0x10052c2 ; nvds_init + 38
        0x010052b8:    2006        .       MOVS     r0,#6
        0x010052ba:    b008        ..      ADD      sp,sp,#0x20
        0x010052bc:    bd70        p.      POP      {r4-r6,pc}
        0x010052be:    2007        .       MOVS     r0,#7
        0x010052c0:    e7fb        ..      B        0x10052ba ; nvds_init + 30
        0x010052c2:    9806        ..      LDR      r0,[sp,#0x18]
        0x010052c4:    eb053104    ...1    ADD      r1,r5,r4,LSL #12
        0x010052c8:    f1007080    ...p    ADD      r0,r0,#0x1000000
        0x010052cc:    4281        .B      CMP      r1,r0
        0x010052ce:    d801        ..      BHI      0x10052d4 ; nvds_init + 56
        0x010052d0:    6035        5`      STR      r5,[r6,#0]
        0x010052d2:    e008        ..      B        0x10052e6 ; nvds_init + 74
        0x010052d4:    2006        .       MOVS     r0,#6
        0x010052d6:    e7f0        ..      B        0x10052ba ; nvds_init + 30
        0x010052d8:    9906        ..      LDR      r1,[sp,#0x18]
        0x010052da:    4260        `B      RSBS     r0,r4,#0
        0x010052dc:    eb013000    ...0    ADD      r0,r1,r0,LSL #12
        0x010052e0:    f1007080    ...p    ADD      r0,r0,#0x1000000
        0x010052e4:    6030        0`      STR      r0,[r6,#0]
        0x010052e6:    f44f719e    O..q    MOV      r1,#0x13c
        0x010052ea:    481f        .H      LDR      r0,[pc,#124] ; [0x1005368] = 0x8032d8
        0x010052ec:    f7fdf97b    ..{.    BL       __aeabi_memclr4 ; 0x10025e6
        0x010052f0:    4d1e        .M      LDR      r5,[pc,#120] ; [0x100536c] = 0x8023c8
        0x010052f2:    2000        .       MOVS     r0,#0
        0x010052f4:    7028        (p      STRB     r0,[r5,#0]
        0x010052f6:    6830        0h      LDR      r0,[r6,#0]
        0x010052f8:    491d        .I      LDR      r1,[pc,#116] ; [0x1005370] = 0x8023d0
        0x010052fa:    eb003004    ...0    ADD      r0,r0,r4,LSL #12
        0x010052fe:    6008        .`      STR      r0,[r1,#0]
        0x01005300:    f470d580    p...    BL       hal_flash_get_security ; 0x75e04
        0x01005304:    491b        .I      LDR      r1,[pc,#108] ; [0x1005374] = 0x8023c9
        0x01005306:    7008        .p      STRB     r0,[r1,#0]
        0x01005308:    2208        ."      MOVS     r2,#8
        0x0100530a:    a904        ..      ADD      r1,sp,#0x10
        0x0100530c:    6830        0h      LDR      r0,[r6,#0]
        0x0100530e:    f7fefb95    ....    BL       dec_flash_read ; 0x1003a3c
        0x01005312:    2808        .(      CMP      r0,#8
        0x01005314:    d010        ..      BEQ      0x1005338 ; nvds_init + 156
        0x01005316:    4818        .H      LDR      r0,[pc,#96] ; [0x1005378] = 0x801f64
        0x01005318:    6981        .i      LDR      r1,[r0,#0x18]
        0x0100531a:    7a40        @z      LDRB     r0,[r0,#9]
        0x0100531c:    f44f7289    O..r    MOV      r2,#0x112
        0x01005320:    e9cd2000    ...     STRD     r2,r0,[sp,#0]
        0x01005324:    9102        ..      STR      r1,[sp,#8]
        0x01005326:    4b15        .K      LDR      r3,[pc,#84] ; [0x100537c] = 0x1007bd0
        0x01005328:    a215        ..      ADR      r2,{pc}+0x58 ; 0x1005380
        0x0100532a:    f44f4100    O..A    MOV      r1,#0x8000
        0x0100532e:    2000        .       MOVS     r0,#0
        0x01005330:    f407d534    ..4.    BL       dbg_log_printf ; 0xcd9c
        0x01005334:    2009        .       MOVS     r0,#9
        0x01005336:    e7c0        ..      B        0x10052ba ; nvds_init + 30
        0x01005338:    2208        ."      MOVS     r2,#8
        0x0100533a:    491d        .I      LDR      r1,[pc,#116] ; [0x10053b0] = 0x7d5ac
        0x0100533c:    a804        ..      ADD      r0,sp,#0x10
        0x0100533e:    f7fdf88d    ....    BL       memcmp ; 0x100245c
        0x01005342:    b128        (.      CBZ      r0,0x1005350 ; nvds_init + 180
        0x01005344:    4620         F      MOV      r0,r4
        0x01005346:    f7fffa59    ..Y.    BL       init_unused_nvds ; 0x10047fc
        0x0100534a:    2800        .(      CMP      r0,#0
        0x0100534c:    d1b5        ..      BNE      0x10052ba ; nvds_init + 30
        0x0100534e:    e004        ..      B        0x100535a ; nvds_init + 190
        0x01005350:    4620         F      MOV      r0,r4
        0x01005352:    f7fffad3    ....    BL       init_used_nvds ; 0x10048fc
        0x01005356:    2800        .(      CMP      r0,#0
        0x01005358:    d1af        ..      BNE      0x10052ba ; nvds_init + 30
        0x0100535a:    2001        .       MOVS     r0,#1
        0x0100535c:    7028        (p      STRB     r0,[r5,#0]
        0x0100535e:    2000        .       MOVS     r0,#0
        0x01005360:    e7ab        ..      B        0x10052ba ; nvds_init + 30
    $d
        0x01005362:    0000        ..      DCW    0
        0x01005364:    008023cc    .#..    DCD    8397772
        0x01005368:    008032d8    .2..    DCD    8401624
        0x0100536c:    008023c8    .#..    DCD    8397768
        0x01005370:    008023d0    .#..    DCD    8397776
        0x01005374:    008023c9    .#..    DCD    8397769
        0x01005378:    00801f64    d...    DCD    8396644
        0x0100537c:    01007bd0    .{..    DCD    16808912
        0x01005380:    3a353a52    R:5:    DCD    976566866
        0x01005384:    202c7325    %s,     DCD    539783973
        0x01005388:    2064254c    L%d     DCD    543434060
        0x0100538c:    73616c66    flas    DCD    1935764582
        0x01005390:    74732068    h st    DCD    1953701992
        0x01005394:    20657461    ate     DCD    543519841
        0x01005398:    30257830    0x%0    DCD    807761968
        0x0100539c:    202c5832    2X,     DCD    539777074
        0x010053a0:    6f727265    erro    DCD    1869771365
        0x010053a4:    78302072    r 0x    DCD    2016419954
        0x010053a8:    58383025    %08X    DCD    1480077349
        0x010053ac:    00000a0d    ....    DCD    2573
        0x010053b0:    0007d5ac    ....    DCD    513452
    $t
    i.nvds_init_error_handler
    nvds_init_error_handler
        0x010053b4:    b510        ..      PUSH     {r4,lr}
        0x010053b6:    4c05        .L      LDR      r4,[pc,#20] ; [0x10053cc] = 0x10ff000
        0x010053b8:    2101        .!      MOVS     r1,#1
        0x010053ba:    4620         F      MOV      r0,r4
        0x010053bc:    f7fffeb6    ....    BL       nvds_deinit ; 0x100512c
        0x010053c0:    4620         F      MOV      r0,r4
        0x010053c2:    e8bd4010    ...@    POP      {r4,lr}
        0x010053c6:    2101        .!      MOVS     r1,#1
        0x010053c8:    f7ffbf68    ..h.    B.W      nvds_init ; 0x100529c
    $d
        0x010053cc:    010ff000    ....    DCD    17821696
    $t
    i.nvds_put
    nvds_put
        0x010053d0:    e92d43fe    -..C    PUSH     {r1-r9,lr}
        0x010053d4:    4606        .F      MOV      r6,r0
        0x010053d6:    460c        .F      MOV      r4,r1
        0x010053d8:    4617        .F      MOV      r7,r2
        0x010053da:    f7fdffa5    ....    BL       ble_communication_core_init ; 0x1003328
        0x010053de:    482c        ,H      LDR      r0,[pc,#176] ; [0x1005490] = 0x8023c8
        0x010053e0:    7800        .x      LDRB     r0,[r0,#0]
        0x010053e2:    b378        x.      CBZ      r0,0x1005444 ; nvds_put + 116
        0x010053e4:    b37f        ..      CBZ      r7,0x1005446 ; nvds_put + 118
        0x010053e6:    b374        t.      CBZ      r4,0x1005446 ; nvds_put + 118
        0x010053e8:    f64070ec    @..p    MOV      r0,#0xfec
        0x010053ec:    4284        .B      CMP      r4,r0
        0x010053ee:    d82b        +.      BHI      0x1005448 ; nvds_put + 120
        0x010053f0:    b34e        N.      CBZ      r6,0x1005446 ; nvds_put + 118
        0x010053f2:    f5a6407f    ...@    SUB      r0,r6,#0xff00
        0x010053f6:    38ff        .8      SUBS     r0,r0,#0xff
        0x010053f8:    d026        &.      BEQ      0x1005448 ; nvds_put + 120
        0x010053fa:    a902        ..      ADD      r1,sp,#8
        0x010053fc:    4630        0F      MOV      r0,r6
        0x010053fe:    f7fefb7d    ..}.    BL       find_item ; 0x1003afc
        0x01005402:    4605        .F      MOV      r5,r0
        0x01005404:    2d00        .-      CMP      r5,#0
        0x01005406:    d03d        =.      BEQ      0x1005484 ; nvds_put + 180
        0x01005408:    2208        ."      MOVS     r2,#8
        0x0100540a:    4669        iF      MOV      r1,sp
        0x0100540c:    f1a50008    ....    SUB      r0,r5,#8
        0x01005410:    f7fefb14    ....    BL       dec_flash_read ; 0x1003a3c
        0x01005414:    4668        hF      MOV      r0,sp
        0x01005416:    f001fc93    ....    BL       verify_hdr_checksum ; 0x1006d40
        0x0100541a:    b1c8        ..      CBZ      r0,0x1005450 ; nvds_put + 128
        0x0100541c:    f8bd0008    ....    LDRH     r0,[sp,#8]
        0x01005420:    f44f4800    O..H    MOV      r8,#0x8000
        0x01005424:    42a0        .B      CMP      r0,r4
        0x01005426:    d121        !.      BNE      0x100546c ; nvds_put + 156
        0x01005428:    463a        :F      MOV      r2,r7
        0x0100542a:    4621        !F      MOV      r1,r4
        0x0100542c:    4628        (F      MOV      r0,r5
        0x0100542e:    f7fffb95    ....    BL       is_item_same ; 0x1004b5c
        0x01005432:    b178        x.      CBZ      r0,0x1005454 ; nvds_put + 132
        0x01005434:    a217        ..      ADR      r2,{pc}+0x60 ; 0x1005494
        0x01005436:    4641        AF      MOV      r1,r8
        0x01005438:    2000        .       MOVS     r0,#0
        0x0100543a:    f407d4af    ....    BL       dbg_log_printf ; 0xcd9c
        0x0100543e:    2000        .       MOVS     r0,#0
        0x01005440:    e8bd83fe    ....    POP      {r1-r9,pc}
        0x01005444:    e002        ..      B        0x100544c ; nvds_put + 124
        0x01005446:    e7ff        ..      B        0x1005448 ; nvds_put + 120
        0x01005448:    2005        .       MOVS     r0,#5
        0x0100544a:    e7f9        ..      B        0x1005440 ; nvds_put + 112
        0x0100544c:    2001        .       MOVS     r0,#1
        0x0100544e:    e7f7        ..      B        0x1005440 ; nvds_put + 112
        0x01005450:    2009        .       MOVS     r0,#9
        0x01005452:    e7f5        ..      B        0x1005440 ; nvds_put + 112
        0x01005454:    a216        ..      ADR      r2,{pc}+0x5c ; 0x10054b0
        0x01005456:    4641        AF      MOV      r1,r8
        0x01005458:    2000        .       MOVS     r0,#0
        0x0100545a:    f407d49f    ....    BL       dbg_log_printf ; 0xcd9c
        0x0100545e:    463b        ;F      MOV      r3,r7
        0x01005460:    4622        "F      MOV      r2,r4
        0x01005462:    4631        1F      MOV      r1,r6
        0x01005464:    4628        (F      MOV      r0,r5
        0x01005466:    f000fb81    ....    BL       replace_item ; 0x1005b6c
        0x0100546a:    e7e9        ..      B        0x1005440 ; nvds_put + 112
        0x0100546c:    a21b        ..      ADR      r2,{pc}+0x70 ; 0x10054dc
        0x0100546e:    4641        AF      MOV      r1,r8
        0x01005470:    2000        .       MOVS     r0,#0
        0x01005472:    f407d493    ....    BL       dbg_log_printf ; 0xcd9c
        0x01005476:    463b        ;F      MOV      r3,r7
        0x01005478:    4622        "F      MOV      r2,r4
        0x0100547a:    4631        1F      MOV      r1,r6
        0x0100547c:    4628        (F      MOV      r0,r5
        0x0100547e:    f000fb75    ..u.    BL       replace_item ; 0x1005b6c
        0x01005482:    e7dd        ..      B        0x1005440 ; nvds_put + 112
        0x01005484:    463a        :F      MOV      r2,r7
        0x01005486:    4621        !F      MOV      r1,r4
        0x01005488:    4630        0F      MOV      r0,r6
        0x0100548a:    f7fdfed1    ....    BL       append_item ; 0x1003230
        0x0100548e:    e7d7        ..      B        0x1005440 ; nvds_put + 112
    $d
        0x01005490:    008023c8    .#..    DCD    8397768
        0x01005494:    3a353a52    R:5:    DCD    976566866
        0x01005498:    7364766e    nvds    DCD    1935963758
        0x0100549c:    7475705f    _put    DCD    1953853535
        0x010054a0:    73202928    () s    DCD    1931487528
        0x010054a4:    20656d61    ame     DCD    543518049
        0x010054a8:    61746164    data    DCD    1635017060
        0x010054ac:    00000a0d    ....    DCD    2573
        0x010054b0:    3a353a52    R:5:    DCD    976566866
        0x010054b4:    7364766e    nvds    DCD    1935963758
        0x010054b8:    7475705f    _put    DCD    1953853535
        0x010054bc:    72202928    () r    DCD    1914710312
        0x010054c0:    616c7065    epla    DCD    1634496613
        0x010054c4:    64206563    ce d    DCD    1679844707
        0x010054c8:    20617461    ata     DCD    543257697
        0x010054cc:    68746977    with    DCD    1752459639
        0x010054d0:    6d617320     sam    DCD    1835103008
        0x010054d4:    656c2065    e le    DCD    1701584997
        0x010054d8:    000a0d6e    n...    DCD    658798
        0x010054dc:    3a353a52    R:5:    DCD    976566866
        0x010054e0:    7364766e    nvds    DCD    1935963758
        0x010054e4:    7475705f    _put    DCD    1953853535
        0x010054e8:    72202928    () r    DCD    1914710312
        0x010054ec:    616c7065    epla    DCD    1634496613
        0x010054f0:    64206563    ce d    DCD    1679844707
        0x010054f4:    20617461    ata     DCD    543257697
        0x010054f8:    68746977    with    DCD    1752459639
        0x010054fc:    66696420     dif    DCD    1718182944
        0x01005500:    656c2066    f le    DCD    1701584998
        0x01005504:    000a0d6e    n...    DCD    658798
    $t
    i.nvds_setup
    nvds_setup
        0x01005508:    b510        ..      PUSH     {r4,lr}
        0x0100550a:    2101        .!      MOVS     r1,#1
        0x0100550c:    4803        .H      LDR      r0,[pc,#12] ; [0x100551c] = 0x10ff000
        0x0100550e:    f7fffec5    ....    BL       nvds_init ; 0x100529c
        0x01005512:    2800        .(      CMP      r0,#0
        0x01005514:    d001        ..      BEQ      0x100551a ; nvds_setup + 18
        0x01005516:    f7ffff4d    ..M.    BL       nvds_init_error_handler ; 0x10053b4
        0x0100551a:    bd10        ..      POP      {r4,pc}
    $d
        0x0100551c:    010ff000    ....    DCD    17821696
    $t
    i.patch_init
    patch_init
        0x01005520:    2002        .       MOVS     r0,#2
        0x01005522:    f7febd65    ..e.    B        gr5xx_fpb_init ; 0x1003ff0
        0x01005526:    0000        ..      MOVS     r0,r0
    i.platform_clock_init
    platform_clock_init
        0x01005528:    e92d41f0    -..A    PUSH     {r4-r8,lr}
        0x0100552c:    4604        .F      MOV      r4,r0
        0x0100552e:    460d        .F      MOV      r5,r1
        0x01005530:    4616        .F      MOV      r6,r2
        0x01005532:    461f        .F      MOV      r7,r3
        0x01005534:    f001f83a    ..:.    BL       system_clk_mgmt_init ; 0x10065ac
        0x01005538:    4638        8F      MOV      r0,r7
        0x0100553a:    f000fc31    ..1.    BL       rf_xo_offset_init ; 0x1005da0
        0x0100553e:    4631        1F      MOV      r1,r6
        0x01005540:    4628        (F      MOV      r0,r5
        0x01005542:    f000f973    ..s.    BL       platform_set_ble_rtc_clk ; 0x100582c
        0x01005546:    4628        (F      MOV      r0,r5
        0x01005548:    f000f9c0    ....    BL       platform_set_psc_clk ; 0x10058cc
        0x0100554c:    f000f814    ....    BL       platform_disable_sleep_timer ; 0x1005578
        0x01005550:    4806        .H      LDR      r0,[pc,#24] ; [0x100556c] = 0x1007b00
        0x01005552:    4907        .I      LDR      r1,[pc,#28] ; [0x1005570] = 0x801f10
        0x01005554:    f8102024    ..$     LDRB     r2,[r0,r4,LSL #2]
        0x01005558:    6948        Hi      LDR      r0,[r1,#0x14]
        0x0100555a:    f3620003    b...    BFI      r0,r2,#0,#4
        0x0100555e:    f3641047    d.G.    BFI      r0,r4,#5,#3
        0x01005562:    6148        Ha      STR      r0,[r1,#0x14]
        0x01005564:    4803        .H      LDR      r0,[pc,#12] ; [0x1005574] = 0x30006808
        0x01005566:    7004        .p      STRB     r4,[r0,#0]
        0x01005568:    e8bd81f0    ....    POP      {r4-r8,pc}
    $d
        0x0100556c:    01007b00    .{..    DCD    16808704
        0x01005570:    00801f10    ....    DCD    8396560
        0x01005574:    30006808    .h.0    DCD    805333000
    $t
    i.platform_disable_sleep_timer
    platform_disable_sleep_timer
        0x01005578:    b510        ..      PUSH     {r4,lr}
        0x0100557a:    f7ffd9d0    ....    BL       ll_pwr_is_active_flag_psc_cmd_busy ; 0x80491e
        0x0100557e:    2801        .(      CMP      r0,#1
        0x01005580:    d0fb        ..      BEQ      0x100557a ; platform_disable_sleep_timer + 2
        0x01005582:    e8bd4010    ...@    POP      {r4,lr}
        0x01005586:    2013        .       MOVS     r0,#0x13
        0x01005588:    f7ff99c0    ....    B        ll_pwr_req_excute_psc_command ; 0x80490c
    i.platform_flash_enable_quad
    platform_flash_enable_quad
        0x0100558c:    b510        ..      PUSH     {r4,lr}
        0x0100558e:    4905        .I      LDR      r1,[pc,#20] ; [0x10055a4] = 0x801f10
        0x01005590:    20eb        .       MOVS     r0,#0xeb
        0x01005592:    6108        .a      STR      r0,[r1,#0x10]
        0x01005594:    4904        .I      LDR      r1,[pc,#16] ; [0x10055a8] = 0x801f64
        0x01005596:    6809        .h      LDR      r1,[r1,#0]
        0x01005598:    60c8        .`      STR      r0,[r1,#0xc]
        0x0100559a:    4803        .H      LDR      r0,[pc,#12] ; [0x10055a8] = 0x801f64
        0x0100559c:    f7ffdab5    ....    BL       platform_exflash_enable_quad ; 0x804b0a
        0x010055a0:    bd10        ..      POP      {r4,pc}
    $d
        0x010055a2:    0000        ..      DCW    0
        0x010055a4:    00801f10    ....    DCD    8396560
        0x010055a8:    00801f64    d...    DCD    8396644
    $t
    i.platform_init
    platform_init
        0x010055ac:    b57c        |.      PUSH     {r2-r6,lr}
        0x010055ae:    4c46        FL      LDR      r4,[pc,#280] ; [0x10056c8] = 0xa000c504
        0x010055b0:    6820         h      LDR      r0,[r4,#0]
        0x010055b2:    0600        ..      LSLS     r0,r0,#24
        0x010055b4:    d402        ..      BMI      0x10055bc ; platform_init + 16
        0x010055b6:    6820         h      LDR      r0,[r4,#0]
        0x010055b8:    0640        @.      LSLS     r0,r0,#25
        0x010055ba:    d51f        ..      BPL      0x10055fc ; platform_init + 80
        0x010055bc:    6820         h      LDR      r0,[r4,#0]
        0x010055be:    f4205080     ..P    BIC      r0,r0,#0x1000
        0x010055c2:    6020         `      STR      r0,[r4,#0]
        0x010055c4:    6820         h      LDR      r0,[r4,#0]
        0x010055c6:    f4206000     ..`    BIC      r0,r0,#0x800
        0x010055ca:    6020         `      STR      r0,[r4,#0]
        0x010055cc:    6820         h      LDR      r0,[r4,#0]
        0x010055ce:    f0400040    @.@.    ORR      r0,r0,#0x40
        0x010055d2:    6020         `      STR      r0,[r4,#0]
        0x010055d4:    6820         h      LDR      r0,[r4,#0]
        0x010055d6:    f4407080    @..p    ORR      r0,r0,#0x100
        0x010055da:    6020         `      STR      r0,[r4,#0]
        0x010055dc:    6820         h      LDR      r0,[r4,#0]
        0x010055de:    f0200040     .@.    BIC      r0,r0,#0x40
        0x010055e2:    6020         `      STR      r0,[r4,#0]
        0x010055e4:    6820         h      LDR      r0,[r4,#0]
        0x010055e6:    f0400080    @...    ORR      r0,r0,#0x80
        0x010055ea:    6020         `      STR      r0,[r4,#0]
        0x010055ec:    6820         h      LDR      r0,[r4,#0]
        0x010055ee:    f4407000    @..p    ORR      r0,r0,#0x200
        0x010055f2:    6020         `      STR      r0,[r4,#0]
        0x010055f4:    6820         h      LDR      r0,[r4,#0]
        0x010055f6:    f0200080     ...    BIC      r0,r0,#0x80
        0x010055fa:    6020         `      STR      r0,[r4,#0]
        0x010055fc:    4832        2H      LDR      r0,[pc,#200] ; [0x10056c8] = 0xa000c504
        0x010055fe:    3040        @0      ADDS     r0,r0,#0x40
        0x01005600:    6801        .h      LDR      r1,[r0,#0]
        0x01005602:    f3c11180    ....    UBFX     r1,r1,#6,#1
        0x01005606:    b121        !.      CBZ      r1,0x1005612 ; platform_init + 102
        0x01005608:    4930        0I      LDR      r1,[pc,#192] ; [0x10056cc] = 0x30006400
        0x0100560a:    780a        .x      LDRB     r2,[r1,#0]
        0x0100560c:    f0420204    B...    ORR      r2,r2,#4
        0x01005610:    700a        .p      STRB     r2,[r1,#0]
        0x01005612:    492f        /I      LDR      r1,[pc,#188] ; [0x10056d0] = 0xfffffea0
        0x01005614:    6001        .`      STR      r1,[r0,#0]
        0x01005616:    2000        .       MOVS     r0,#0
        0x01005618:    2301        .#      MOVS     r3,#1
        0x0100561a:    b241        A.      SXTB     r1,r0
        0x0100561c:    2900        .)      CMP      r1,#0
        0x0100561e:    db09        ..      BLT      0x1005634 ; platform_init + 136
        0x01005620:    f001051f    ....    AND      r5,r1,#0x1f
        0x01005624:    fa03f205    ....    LSL      r2,r3,r5
        0x01005628:    0949        I.      LSRS     r1,r1,#5
        0x0100562a:    0089        ..      LSLS     r1,r1,#2
        0x0100562c:    f10121e0    ...!    ADD      r1,r1,#0xe000e000
        0x01005630:    f8c12280    ..."    STR      r2,[r1,#0x280]
        0x01005634:    1c40        @.      ADDS     r0,r0,#1
        0x01005636:    b2c0        ..      UXTB     r0,r0
        0x01005638:    2822        "(      CMP      r0,#0x22
        0x0100563a:    d3ee        ..      BCC      0x100561a ; platform_init + 110
        0x0100563c:    2000        .       MOVS     r0,#0
        0x0100563e:    f001fbb5    ....    BL       warm_boot_set_exflash_readid_delay ; 0x1006dac
        0x01005642:    2500        .%      MOVS     r5,#0
        0x01005644:    4628        (F      MOV      r0,r5
        0x01005646:    f7fdfefb    ....    BL       ble_wakeup_osc_time_get ; 0x1003440
        0x0100564a:    4601        .F      MOV      r1,r0
        0x0100564c:    4628        (F      MOV      r0,r5
        0x0100564e:    f7fdff01    ....    BL       ble_wakeup_osc_time_set ; 0x1003454
        0x01005652:    2001        .       MOVS     r0,#1
        0x01005654:    f7fffd22    ..".    BL       mem_pwr_mgmt_mode_set ; 0x100509c
        0x01005658:    f7ffff56    ..V.    BL       nvds_setup ; 0x1005508
        0x0100565c:    2064        d       MOVS     r0,#0x64
        0x0100565e:    f000f95d    ..].    BL       platform_set_rtc_crystal_delay ; 0x100591c
        0x01005662:    2300        .#      MOVS     r3,#0
        0x01005664:    f44f72fa    O..r    MOV      r2,#0x1f4
        0x01005668:    2101        .!      MOVS     r1,#1
        0x0100566a:    4618        .F      MOV      r0,r3
        0x0100566c:    f7ffff5c    ..\.    BL       platform_clock_init ; 0x1005528
        0x01005670:    f000f892    ....    BL       platform_sdk_init ; 0x1005798
        0x01005674:    f001f84d    ..M.    BL       system_pmu_deinit ; 0x1006712
        0x01005678:    2000        .       MOVS     r0,#0
        0x0100567a:    f7fdf917    ....    BL       SystemCoreSetClock ; 0x10028ac
        0x0100567e:    2000        .       MOVS     r0,#0
        0x01005680:    f001f84c    ..L.    BL       system_pmu_init ; 0x100671c
        0x01005684:    a013        ..      ADR      r0,{pc}+0x50 ; 0x10056d4
        0x01005686:    c803        ..      LDM      r0,{r0,r1}
        0x01005688:    e9cd0100    ....    STRD     r0,r1,[sp,#0]
        0x0100568c:    6820         h      LDR      r0,[r4,#0]
        0x0100568e:    f0000007    ....    AND      r0,r0,#7
        0x01005692:    f81d4000    ...@    LDRB     r4,[sp,r0]
        0x01005696:    4811        .H      LDR      r0,[pc,#68] ; [0x10056dc] = 0x186a0
        0x01005698:    4344        DC      MULS     r4,r0,r4
        0x0100569a:    f7fefd8f    ....    BL       hal_dwt_enable ; 0x10041bc
        0x0100569e:    4810        .H      LDR      r0,[pc,#64] ; [0x10056e0] = 0xe0001000
        0x010056a0:    6841        Ah      LDR      r1,[r0,#4]
        0x010056a2:    6842        Bh      LDR      r2,[r0,#4]
        0x010056a4:    1a52        R.      SUBS     r2,r2,r1
        0x010056a6:    42a2        .B      CMP      r2,r4
        0x010056a8:    d3fb        ..      BCC      0x10056a2 ; platform_init + 246
        0x010056aa:    f7fefd6b    ..k.    BL       hal_dwt_disable ; 0x1004184
        0x010056ae:    f7fedeeb    ....    BL       rtc_calibration ; 0x804488
        0x010056b2:    f000fc5b    ..[.    BL       rng_calibration ; 0x1005f6c
        0x010056b6:    f7fef9fd    ....    BL       exflash_io_pull_config ; 0x1003ab4
        0x010056ba:    2000        .       MOVS     r0,#0
        0x010056bc:    f000f936    ..6.    BL       pmu_calibration_handler ; 0x100592c
        0x010056c0:    e8bd407c    ..|@    POP      {r2-r6,lr}
        0x010056c4:    f7fdbbc4    ....    B        app_pwr_mgmt_init ; 0x1002e50
    $d
        0x010056c8:    a000c504    ....    DCD    2684404996
        0x010056cc:    30006400    .d.0    DCD    805331968
        0x010056d0:    fffffea0    ....    DCD    4294966944
        0x010056d4:    18103040    @0..    DCD    403714112
        0x010056d8:    00002010    . ..    DCD    8208
        0x010056dc:    000186a0    ....    DCD    100000
        0x010056e0:    e0001000    ....    DCD    3758100480
    $t
    i.platform_param_adjust
    platform_param_adjust
        0x010056e4:    e92d41f0    -..A    PUSH     {r4-r8,lr}
        0x010056e8:    2400        .$      MOVS     r4,#0
        0x010056ea:    4e2a        *N      LDR      r6,[pc,#168] ; [0x1005794] = 0x30006814
        0x010056ec:    f8df80a0    ....    LDR      r8,[pc,#160] ; [0x1005790] = 0xa000c550
        0x010056f0:    4f27        'O      LDR      r7,[pc,#156] ; [0x1005790] = 0xa000c550
        0x010056f2:    f108087c    ..|.    ADD      r8,r8,#0x7c
        0x010056f6:    f1060550    ..P.    ADD      r5,r6,#0x50
        0x010056fa:    6838        8h      LDR      r0,[r7,#0]
        0x010056fc:    f3c07001    ...p    UBFX     r0,r0,#28,#2
        0x01005700:    2801        .(      CMP      r0,#1
        0x01005702:    d033        3.      BEQ      0x100576c ; platform_param_adjust + 136
        0x01005704:    eb040084    ....    ADD      r0,r4,r4,LSL #2
        0x01005708:    7971        qy      LDRB     r1,[r6,#5]
        0x0100570a:    79b3        .y      LDRB     r3,[r6,#6]
        0x0100570c:    eb050080    ....    ADD      r0,r5,r0,LSL #2
        0x01005710:    4419        .D      ADD      r1,r1,r3
        0x01005712:    eb0103c1    ....    ADD      r3,r1,r1,LSL #3
        0x01005716:    68c2        .h      LDR      r2,[r0,#0xc]
        0x01005718:    eb031101    ....    ADD      r1,r3,r1,LSL #4
        0x0100571c:    eb020281    ....    ADD      r2,r2,r1,LSL #2
        0x01005720:    60c2        .`      STR      r2,[r0,#0xc]
        0x01005722:    6902        .i      LDR      r2,[r0,#0x10]
        0x01005724:    eb020141    ..A.    ADD      r1,r2,r1,LSL #1
        0x01005728:    6101        .a      STR      r1,[r0,#0x10]
        0x0100572a:    f8d80000    ....    LDR      r0,[r8,#0]
        0x0100572e:    06c0        ..      LSLS     r0,r0,#27
        0x01005730:    d516        ..      BPL      0x1005760 ; platform_param_adjust + 124
        0x01005732:    f6472012    G..     MOV      r0,#0x7a12
        0x01005736:    f476d373    v.s.    BL       sys_lpclk_set ; 0x7be20
        0x0100573a:    eb040084    ....    ADD      r0,r4,r4,LSL #2
        0x0100573e:    eb050080    ....    ADD      r0,r5,r0,LSL #2
        0x01005742:    f44f617a    O.za    MOV      r1,#0xfa0
        0x01005746:    6101        .a      STR      r1,[r0,#0x10]
        0x01005748:    0049        I.      LSLS     r1,r1,#1
        0x0100574a:    60c1        .`      STR      r1,[r0,#0xc]
        0x0100574c:    2102        .!      MOVS     r1,#2
        0x0100574e:    7181        .q      STRB     r1,[r0,#6]
        0x01005750:    8841        A.      LDRH     r1,[r0,#2]
        0x01005752:    f501717a    ..zq    ADD      r1,r1,#0x3e8
        0x01005756:    8041        A.      STRH     r1,[r0,#2]
        0x01005758:    8881        ..      LDRH     r1,[r0,#4]
        0x0100575a:    f501717a    ..zq    ADD      r1,r1,#0x3e8
        0x0100575e:    8081        ..      STRH     r1,[r0,#4]
        0x01005760:    1c64        d.      ADDS     r4,r4,#1
        0x01005762:    b2e4        ..      UXTB     r4,r4
        0x01005764:    2c0c        .,      CMP      r4,#0xc
        0x01005766:    d3c8        ..      BCC      0x10056fa ; platform_param_adjust + 22
        0x01005768:    e8bd81f0    ....    POP      {r4-r8,pc}
        0x0100576c:    eb040084    ....    ADD      r0,r4,r4,LSL #2
        0x01005770:    eb050080    ....    ADD      r0,r5,r0,LSL #2
        0x01005774:    7971        qy      LDRB     r1,[r6,#5]
        0x01005776:    79b3        .y      LDRB     r3,[r6,#6]
        0x01005778:    68c2        .h      LDR      r2,[r0,#0xc]
        0x0100577a:    4419        .D      ADD      r1,r1,r3
        0x0100577c:    ebc11141    ..A.    RSB      r1,r1,r1,LSL #5
        0x01005780:    eb020241    ..A.    ADD      r2,r2,r1,LSL #1
        0x01005784:    60c2        .`      STR      r2,[r0,#0xc]
        0x01005786:    6902        .i      LDR      r2,[r0,#0x10]
        0x01005788:    4411        .D      ADD      r1,r1,r2
        0x0100578a:    6101        .a      STR      r1,[r0,#0x10]
        0x0100578c:    e7cd        ..      B        0x100572a ; platform_param_adjust + 70
    $d
        0x0100578e:    0000        ..      DCW    0
        0x01005790:    a000c550    P...    DCD    2684405072
        0x01005794:    30006814    .h.0    DCD    805333012
    $t
    i.platform_sdk_init
    platform_sdk_init
        0x01005798:    b508        ..      PUSH     {r3,lr}
        0x0100579a:    491a        .I      LDR      r1,[pc,#104] ; [0x1005804] = 0x637d1
        0x0100579c:    2019        .       MOVS     r0,#0x19
        0x0100579e:    f000fd21    ..!.    BL       soc_register_nvic ; 0x10061e4
        0x010057a2:    f001f82b    ..+.    BL       system_priority_init ; 0x10067fc
        0x010057a6:    f7fdfe7f    ....    BL       cold_patch_apply ; 0x10034a8
        0x010057aa:    4918        .I      LDR      r1,[pc,#96] ; [0x100580c] = 0x30006814
        0x010057ac:    4816        .H      LDR      r0,[pc,#88] ; [0x1005808] = 0x805bc9
        0x010057ae:    6288        .b      STR      r0,[r1,#0x28]
        0x010057b0:    4817        .H      LDR      r0,[pc,#92] ; [0x1005810] = 0x805c0f
        0x010057b2:    62c8        .b      STR      r0,[r1,#0x2c]
        0x010057b4:    4917        .I      LDR      r1,[pc,#92] ; [0x1005814] = 0x80076c
        0x010057b6:    6008        .`      STR      r0,[r1,#0]
        0x010057b8:    f000ff2a    ..*.    BL       system_low_power_set ; 0x1006610
        0x010057bc:    f7ffff92    ....    BL       platform_param_adjust ; 0x10056e4
        0x010057c0:    f46ad594    j...    BL       fpb_save_state ; 0x702ec
        0x010057c4:    4814        .H      LDR      r0,[pc,#80] ; [0x1005818] = 0x30006808
        0x010057c6:    7801        .x      LDRB     r1,[r0,#0]
        0x010057c8:    4810        .H      LDR      r0,[pc,#64] ; [0x100580c] = 0x30006814
        0x010057ca:    3050        P0      ADDS     r0,r0,#0x50
        0x010057cc:    f473d19a    s...    BL       pwr_mgmt_init ; 0x78b04
        0x010057d0:    2000        .       MOVS     r0,#0
        0x010057d2:    f46ad555    j.U.    BL       fpb_load_state ; 0x70280
        0x010057d6:    4911        .I      LDR      r1,[pc,#68] ; [0x100581c] = 0x802446
        0x010057d8:    f44f707a    O.zp    MOV      r0,#0x3e8
        0x010057dc:    8008        ..      STRH     r0,[r1,#0]
        0x010057de:    4911        .I      LDR      r1,[pc,#68] ; [0x1005824] = 0x8026a8
        0x010057e0:    480f        .H      LDR      r0,[pc,#60] ; [0x1005820] = 0x7c345
        0x010057e2:    6008        .`      STR      r0,[r1,#0]
        0x010057e4:    2000        .       MOVS     r0,#0
        0x010057e6:    9000        ..      STR      r0,[sp,#0]
        0x010057e8:    466a        jF      MOV      r2,sp
        0x010057ea:    2101        .!      MOVS     r1,#1
        0x010057ec:    f24c0015    L...    MOV      r0,#0xc015
        0x010057f0:    f7fffdee    ....    BL       nvds_put ; 0x10053d0
        0x010057f4:    f7fdffa2    ....    BL       cpll_calibration_init ; 0x100373c
        0x010057f8:    e8bd4008    ...@    POP      {r3,lr}
        0x010057fc:    480a        .H      LDR      r0,[pc,#40] ; [0x1005828] = 0x1003721
        0x010057fe:    f47491cf    t...    B        rf_recalibration_handler_register ; 0x79ba0
    $d
        0x01005802:    0000        ..      DCW    0
        0x01005804:    000637d1    .7..    DCD    407505
        0x01005808:    00805bc9    .[..    DCD    8412105
        0x0100580c:    30006814    .h.0    DCD    805333012
        0x01005810:    00805c0f    .\..    DCD    8412175
        0x01005814:    0080076c    l...    DCD    8390508
        0x01005818:    30006808    .h.0    DCD    805333000
        0x0100581c:    00802446    F$..    DCD    8397894
        0x01005820:    0007c345    E...    DCD    508741
        0x01005824:    008026a8    .&..    DCD    8398504
        0x01005828:    01003721    !7..    DCD    16791329
    $t
    i.platform_set_ble_rtc_clk
    platform_set_ble_rtc_clk
        0x0100582c:    b5fe        ..      PUSH     {r1-r7,lr}
        0x0100582e:    460d        .F      MOV      r5,r1
        0x01005830:    2602        .&      MOVS     r6,#2
        0x01005832:    f44f71fa    O..q    MOV      r1,#0x1f4
        0x01005836:    9102        ..      STR      r1,[sp,#8]
        0x01005838:    4a1f        .J      LDR      r2,[pc,#124] ; [0x10058b8] = 0xa000c550
        0x0100583a:    6811        .h      LDR      r1,[r2,#0]
        0x0100583c:    f0215140    !.@Q    BIC      r1,r1,#0x30000000
        0x01005840:    2801        .(      CMP      r0,#1
        0x01005842:    d00b        ..      BEQ      0x100585c ; platform_set_ble_rtc_clk + 48
        0x01005844:    6810        .h      LDR      r0,[r2,#0]
        0x01005846:    4308        .C      ORRS     r0,r0,r1
        0x01005848:    6010        .`      STR      r0,[r2,#0]
        0x0100584a:    2d00        .-      CMP      r5,#0
        0x0100584c:    d005        ..      BEQ      0x100585a ; platform_set_ble_rtc_clk + 46
        0x0100584e:    aa02        ..      ADD      r2,sp,#8
        0x01005850:    4631        1F      MOV      r1,r6
        0x01005852:    f24c0007    L...    MOV      r0,#0xc007
        0x01005856:    f7fffdbb    ....    BL       nvds_put ; 0x10053d0
        0x0100585a:    bdfe        ..      POP      {r1-r7,pc}
        0x0100585c:    9502        ..      STR      r5,[sp,#8]
        0x0100585e:    4816        .H      LDR      r0,[pc,#88] ; [0x10058b8] = 0xa000c550
        0x01005860:    3830        08      SUBS     r0,r0,#0x30
        0x01005862:    6803        .h      LDR      r3,[r0,#0]
        0x01005864:    f0430380    C...    ORR      r3,r3,#0x80
        0x01005868:    6003        .`      STR      r3,[r0,#0]
        0x0100586a:    f0415080    A..P    ORR      r0,r1,#0x10000000
        0x0100586e:    6010        .`      STR      r0,[r2,#0]
        0x01005870:    4811        .H      LDR      r0,[pc,#68] ; [0x10058b8] = 0xa000c550
        0x01005872:    3828        (8      SUBS     r0,r0,#0x28
        0x01005874:    6801        .h      LDR      r1,[r0,#0]
        0x01005876:    f0410180    A...    ORR      r1,r1,#0x80
        0x0100587a:    6001        .`      STR      r1,[r0,#0]
        0x0100587c:    480f        .H      LDR      r0,[pc,#60] ; [0x10058bc] = 0x30006808
        0x0100587e:    8840        @.      LDRH     r0,[r0,#2]
        0x01005880:    f44f717a    O.zq    MOV      r1,#0x3e8
        0x01005884:    4348        HC      MULS     r0,r1,r0
        0x01005886:    a10e        ..      ADR      r1,{pc}+0x3a ; 0x10058c0
        0x01005888:    c906        ..      LDM      r1,{r1,r2}
        0x0100588a:    e9cd1200    ....    STRD     r1,r2,[sp,#0]
        0x0100588e:    490a        .I      LDR      r1,[pc,#40] ; [0x10058b8] = 0xa000c550
        0x01005890:    394c        L9      SUBS     r1,r1,#0x4c
        0x01005892:    6809        .h      LDR      r1,[r1,#0]
        0x01005894:    f0010107    ....    AND      r1,r1,#7
        0x01005898:    f81d4001    ...@    LDRB     r4,[sp,r1]
        0x0100589c:    4344        DC      MULS     r4,r0,r4
        0x0100589e:    2800        .(      CMP      r0,#0
        0x010058a0:    d0d3        ..      BEQ      0x100584a ; platform_set_ble_rtc_clk + 30
        0x010058a2:    f7fefc8b    ....    BL       hal_dwt_enable ; 0x10041bc
        0x010058a6:    4808        .H      LDR      r0,[pc,#32] ; [0x10058c8] = 0xe0001000
        0x010058a8:    6842        Bh      LDR      r2,[r0,#4]
        0x010058aa:    6843        Ch      LDR      r3,[r0,#4]
        0x010058ac:    1a9b        ..      SUBS     r3,r3,r2
        0x010058ae:    42a3        .B      CMP      r3,r4
        0x010058b0:    d3fb        ..      BCC      0x10058aa ; platform_set_ble_rtc_clk + 126
        0x010058b2:    f7fefc67    ..g.    BL       hal_dwt_disable ; 0x1004184
        0x010058b6:    e7c8        ..      B        0x100584a ; platform_set_ble_rtc_clk + 30
    $d
        0x010058b8:    a000c550    P...    DCD    2684405072
        0x010058bc:    30006808    .h.0    DCD    805333000
        0x010058c0:    18103040    @0..    DCD    403714112
        0x010058c4:    00002010    . ..    DCD    8208
        0x010058c8:    e0001000    ....    DCD    3758100480
    $t
    i.platform_set_psc_clk
    platform_set_psc_clk
        0x010058cc:    b510        ..      PUSH     {r4,lr}
        0x010058ce:    4912        .I      LDR      r1,[pc,#72] ; [0x1005918] = 0xa000c550
        0x010058d0:    6809        .h      LDR      r1,[r1,#0]
        0x010058d2:    2801        .(      CMP      r0,#1
        0x010058d4:    d00a        ..      BEQ      0x10058ec ; platform_set_psc_clk + 32
        0x010058d6:    2802        .(      CMP      r0,#2
        0x010058d8:    d011        ..      BEQ      0x10058fe ; platform_set_psc_clk + 50
        0x010058da:    f7ffd820    .. .    BL       ll_pwr_is_active_flag_psc_cmd_busy ; 0x80491e
        0x010058de:    2801        .(      CMP      r0,#1
        0x010058e0:    d0fb        ..      BEQ      0x10058da ; platform_set_psc_clk + 14
        0x010058e2:    e8bd4010    ...@    POP      {r4,lr}
        0x010058e6:    2006        .       MOVS     r0,#6
        0x010058e8:    f7ff9810    ....    B        ll_pwr_req_excute_psc_command ; 0x80490c
        0x010058ec:    f7ffd817    ....    BL       ll_pwr_is_active_flag_psc_cmd_busy ; 0x80491e
        0x010058f0:    2801        .(      CMP      r0,#1
        0x010058f2:    d0fb        ..      BEQ      0x10058ec ; platform_set_psc_clk + 32
        0x010058f4:    e8bd4010    ...@    POP      {r4,lr}
        0x010058f8:    2007        .       MOVS     r0,#7
        0x010058fa:    f7ff9807    ....    B        ll_pwr_req_excute_psc_command ; 0x80490c
        0x010058fe:    f7ffd80e    ....    BL       ll_pwr_is_active_flag_psc_cmd_busy ; 0x80491e
        0x01005902:    2801        .(      CMP      r0,#1
        0x01005904:    d0fb        ..      BEQ      0x10058fe ; platform_set_psc_clk + 50
        0x01005906:    2008        .       MOVS     r0,#8
        0x01005908:    f7ffd800    ....    BL       ll_pwr_req_excute_psc_command ; 0x80490c
        0x0100590c:    e8bd4010    ...@    POP      {r4,lr}
        0x01005910:    f2465090    F..P    MOV      r0,#0x6590
        0x01005914:    f4769284    v...    B        sys_lpclk_set ; 0x7be20
    $d
        0x01005918:    a000c550    P...    DCD    2684405072
    $t
    i.platform_set_rtc_crystal_delay
    platform_set_rtc_crystal_delay
        0x0100591c:    2864        d(      CMP      r0,#0x64
        0x0100591e:    d301        ..      BCC      0x1005924 ; platform_set_rtc_crystal_delay + 8
        0x01005920:    4901        .I      LDR      r1,[pc,#4] ; [0x1005928] = 0x30006808
        0x01005922:    8048        H.      STRH     r0,[r1,#2]
        0x01005924:    4770        pG      BX       lr
    $d
        0x01005926:    0000        ..      DCW    0
        0x01005928:    30006808    .h.0    DCD    805333000
    $t
    i.pmu_calibration_handler
    pmu_calibration_handler
        0x0100592c:    e92d4ff0    -..O    PUSH     {r4-r11,lr}
        0x01005930:    b087        ..      SUB      sp,sp,#0x1c
        0x01005932:    2118        .!      MOVS     r1,#0x18
        0x01005934:    a801        ..      ADD      r0,sp,#4
        0x01005936:    f7fcfe56    ..V.    BL       __aeabi_memclr4 ; 0x10025e6
        0x0100593a:    f3ef8511    ....    MRS      r5,BASEPRI
        0x0100593e:    483c        <H      LDR      r0,[pc,#240] ; [0x1005a30] = 0xe000e402
        0x01005940:    7801        .x      LDRB     r1,[r0,#0]
        0x01005942:    483c        <H      LDR      r0,[pc,#240] ; [0x1005a34] = 0xe000ed0c
        0x01005944:    6800        .h      LDR      r0,[r0,#0]
        0x01005946:    f3c02002    ...     UBFX     r0,r0,#8,#3
        0x0100594a:    1c40        @.      ADDS     r0,r0,#1
        0x0100594c:    2201        ."      MOVS     r2,#1
        0x0100594e:    4082        .@      LSLS     r2,r2,r0
        0x01005950:    1888        ..      ADDS     r0,r1,r2
        0x01005952:    b2c0        ..      UXTB     r0,r0
        0x01005954:    f3808811    ....    MSR      BASEPRI,r0
        0x01005958:    f7fefb90    ....    BL       hal_adc_is_using ; 0x100407c
        0x0100595c:    2800        .(      CMP      r0,#0
        0x0100595e:    d160        `.      BNE      0x1005a22 ; pmu_calibration_handler + 246
        0x01005960:    f8dfa0d4    ....    LDR      r10,[pc,#212] ; [0x1005a38] = 0xa000c508
        0x01005964:    f8da6000    ...`    LDR      r6,[r10,#0]
        0x01005968:    f8dfb0cc    ....    LDR      r11,[pc,#204] ; [0x1005a38] = 0xa000c508
        0x0100596c:    f10b0b38    ..8.    ADD      r11,r11,#0x38
        0x01005970:    f8db0000    ....    LDR      r0,[r11,#0]
        0x01005974:    f0004770    ..pG    AND      r7,r0,#0xf0000000
        0x01005978:    f8df90c0    ....    LDR      r9,[pc,#192] ; [0x1005a3c] = 0xa000e000
        0x0100597c:    f8d98100    ....    LDR      r8,[r9,#0x100]
        0x01005980:    a801        ..      ADD      r0,sp,#4
        0x01005982:    f000fc3f    ..?.    BL       sys_adc_trim_get ; 0x1006204
        0x01005986:    bb98        ..      CBNZ     r0,0x10059f0 ; pmu_calibration_handler + 196
        0x01005988:    f8bd0004    ....    LDRH     r0,[sp,#4]
        0x0100598c:    b380        ..      CBZ      r0,0x10059f0 ; pmu_calibration_handler + 196
        0x0100598e:    f473d7d3    s...    BL       rf_get_recalibration_flag ; 0x79938
        0x01005992:    b108        ..      CBZ      r0,0x1005998 ; pmu_calibration_handler + 108
        0x01005994:    f7fdff14    ....    BL       cpll_lock_check_recover ; 0x10037c0
        0x01005998:    f000f97a    ..z.    BL       rf_calibration_set ; 0x1005c90
        0x0100599c:    a901        ..      ADD      r1,sp,#4
        0x0100599e:    2005        .       MOVS     r0,#5
        0x010059a0:    f7fef970    ..p.    BL       get_data_from_adc ; 0x1003c84
        0x010059a4:    ec510b10    Q...    VMOV     r0,r1,d0
        0x010059a8:    f001fde6    ....    BL       __aeabi_d2iz ; 0x1007578
        0x010059ac:    4c24        $L      LDR      r4,[pc,#144] ; [0x1005a40] = 0x30006814
        0x010059ae:    6320         c      STR      r0,[r4,#0x30]
        0x010059b0:    f1000136    ..6.    ADD      r1,r0,#0x36
        0x010059b4:    299a        .)      CMP      r1,#0x9a
        0x010059b6:    d202        ..      BCS      0x10059be ; pmu_calibration_handler + 146
        0x010059b8:    f001f8c4    ....    BL       temperature_calibrations ; 0x1006b44
        0x010059bc:    e002        ..      B        0x10059c4 ; pmu_calibration_handler + 152
        0x010059be:    7b60        `{      LDRB     r0,[r4,#0xd]
        0x010059c0:    1c40        @.      ADDS     r0,r0,#1
        0x010059c2:    7360        `s      STRB     r0,[r4,#0xd]
        0x010059c4:    a901        ..      ADD      r1,sp,#4
        0x010059c6:    2006        .       MOVS     r0,#6
        0x010059c8:    f7fef95c    ..\.    BL       get_data_from_adc ; 0x1003c84
        0x010059cc:    ed9f1b1d    ....    VLDR     d1,[pc,#116] ; [0x1005a44] = 0
        0x010059d0:    ec510b10    Q...    VMOV     r0,r1,d0
        0x010059d4:    ec532b11    S..+    VMOV     r2,r3,d1
        0x010059d8:    f001fe84    ....    BL       __aeabi_dmul ; 0x10076e4
        0x010059dc:    f001fdcc    ....    BL       __aeabi_d2iz ; 0x1007578
        0x010059e0:    6360        `c      STR      r0,[r4,#0x34]
        0x010059e2:    f1a001ab    ....    SUB      r1,r0,#0xab
        0x010059e6:    29e5        .)      CMP      r1,#0xe5
        0x010059e8:    d203        ..      BCS      0x10059f2 ; pmu_calibration_handler + 198
        0x010059ea:    f001f98f    ....    BL       vbatt_calibrations ; 0x1006d0c
        0x010059ee:    e003        ..      B        0x10059f8 ; pmu_calibration_handler + 204
        0x010059f0:    e005        ..      B        0x10059fe ; pmu_calibration_handler + 210
        0x010059f2:    7b60        `{      LDRB     r0,[r4,#0xd]
        0x010059f4:    1c40        @.      ADDS     r0,r0,#1
        0x010059f6:    7360        `s      STRB     r0,[r4,#0xd]
        0x010059f8:    6ba0        .k      LDR      r0,[r4,#0x38]
        0x010059fa:    1c40        @.      ADDS     r0,r0,#1
        0x010059fc:    63a0        .c      STR      r0,[r4,#0x38]
        0x010059fe:    f8c98100    ....    STR      r8,[r9,#0x100]
        0x01005a02:    f8ca6000    ...`    STR      r6,[r10,#0]
        0x01005a06:    f3ef8010    ....    MRS      r0,PRIMASK
        0x01005a0a:    2101        .!      MOVS     r1,#1
        0x01005a0c:    f3818810    ....    MSR      PRIMASK,r1
        0x01005a10:    f8db1000    ....    LDR      r1,[r11,#0]
        0x01005a14:    f0214170    !.pA    BIC      r1,r1,#0xf0000000
        0x01005a18:    4339        9C      ORRS     r1,r1,r7
        0x01005a1a:    f8cb1000    ....    STR      r1,[r11,#0]
        0x01005a1e:    f3808810    ....    MSR      PRIMASK,r0
        0x01005a22:    b2e8        ..      UXTB     r0,r5
        0x01005a24:    f3808811    ....    MSR      BASEPRI,r0
        0x01005a28:    b007        ..      ADD      sp,sp,#0x1c
        0x01005a2a:    e8bd8ff0    ....    POP      {r4-r11,pc}
    $d
        0x01005a2e:    0000        ..      DCW    0
        0x01005a30:    e000e402    ....    DCD    3758154754
        0x01005a34:    e000ed0c    ....    DCD    3758157068
        0x01005a38:    a000c508    ....    DCD    2684405000
        0x01005a3c:    a000e000    ....    DCD    2684411904
        0x01005a40:    30006814    .h.0    DCD    805333012
        0x01005a44:    00000000    ....    DCD    0
        0x01005a48:    40590000    ..Y@    DCD    1079574528
    $t
    i.pwr_enter_sleep_check
    pwr_enter_sleep_check
        0x01005a4c:    b570        p.      PUSH     {r4-r6,lr}
        0x01005a4e:    2501        .%      MOVS     r5,#1
        0x01005a50:    2400        .$      MOVS     r4,#0
        0x01005a52:    4e07        .N      LDR      r6,[pc,#28] ; [0x1005a70] = 0x30006a80
        0x01005a54:    f8561024    V.$.    LDR      r1,[r6,r4,LSL #2]
        0x01005a58:    b119        ..      CBZ      r1,0x1005a62 ; pwr_enter_sleep_check + 22
        0x01005a5a:    6809        .h      LDR      r1,[r1,#0]
        0x01005a5c:    b109        ..      CBZ      r1,0x1005a62 ; pwr_enter_sleep_check + 22
        0x01005a5e:    4788        .G      BLX      r1
        0x01005a60:    b120         .      CBZ      r0,0x1005a6c ; pwr_enter_sleep_check + 32
        0x01005a62:    1c64        d.      ADDS     r4,r4,#1
        0x01005a64:    2c10        .,      CMP      r4,#0x10
        0x01005a66:    d3f5        ..      BCC      0x1005a54 ; pwr_enter_sleep_check + 8
        0x01005a68:    4628        (F      MOV      r0,r5
        0x01005a6a:    bd70        p.      POP      {r4-r6,pc}
        0x01005a6c:    2500        .%      MOVS     r5,#0
        0x01005a6e:    e7fb        ..      B        0x1005a68 ; pwr_enter_sleep_check + 28
    $d
        0x01005a70:    30006a80    .j.0    DCD    805333632
    $t
    i.pwr_mgmt_shutdown_replace
    pwr_mgmt_shutdown_replace
        0x01005a74:    4902        .I      LDR      r1,[pc,#8] ; [0x1005a80] = 0x8026a0
        0x01005a76:    4801        .H      LDR      r0,[pc,#4] ; [0x1005a7c] = 0x30003759
        0x01005a78:    6008        .`      STR      r0,[r1,#0]
        0x01005a7a:    4770        pG      BX       lr
    $d
        0x01005a7c:    30003759    Y7.0    DCD    805320537
        0x01005a80:    008026a0    .&..    DCD    8398496
    $t
    i.pwr_mgmt_warm_boot
    pwr_mgmt_warm_boot
        0x01005a84:    b510        ..      PUSH     {r4,lr}
        0x01005a86:    4805        .H      LDR      r0,[pc,#20] ; [0x1005a9c] = 0x3000698c
        0x01005a88:    7800        .x      LDRB     r0,[r0,#0]
        0x01005a8a:    2800        .(      CMP      r0,#0
        0x01005a8c:    d002        ..      BEQ      0x1005a94 ; pwr_mgmt_warm_boot + 16
        0x01005a8e:    f7ffd9f8    ....    BL       warm_boot ; 0x804e82
        0x01005a92:    bd10        ..      POP      {r4,pc}
        0x01005a94:    f7ffd9df    ....    BL       warm_boot_first ; 0x804e56
        0x01005a98:    bd10        ..      POP      {r4,pc}
    $d
        0x01005a9a:    0000        ..      DCW    0
        0x01005a9c:    3000698c    .i.0    DCD    805333388
    $t
    i.pwr_register_sleep_cb
    pwr_register_sleep_cb
        0x01005aa0:    b570        p.      PUSH     {r4-r6,lr}
        0x01005aa2:    4606        .F      MOV      r6,r0
        0x01005aa4:    460d        .F      MOV      r5,r1
        0x01005aa6:    4614        .F      MOV      r4,r2
        0x01005aa8:    f7fdf9d2    ....    BL       app_pwr_mgmt_init ; 0x1002e50
        0x01005aac:    2c10        .,      CMP      r4,#0x10
        0x01005aae:    d202        ..      BCS      0x1005ab6 ; pwr_register_sleep_cb + 22
        0x01005ab0:    1e68        h.      SUBS     r0,r5,#1
        0x01005ab2:    2802        .(      CMP      r0,#2
        0x01005ab4:    d901        ..      BLS      0x1005aba ; pwr_register_sleep_cb + 26
        0x01005ab6:    2010        .       MOVS     r0,#0x10
        0x01005ab8:    bd70        p.      POP      {r4-r6,pc}
        0x01005aba:    4804        .H      LDR      r0,[pc,#16] ; [0x1005acc] = 0x30006a80
        0x01005abc:    f8406024    @.$`    STR      r6,[r0,r4,LSL #2]
        0x01005ac0:    4420         D      ADD      r0,r0,r4
        0x01005ac2:    f8805040    ..@P    STRB     r5,[r0,#0x40]
        0x01005ac6:    4620         F      MOV      r0,r4
        0x01005ac8:    bd70        p.      POP      {r4-r6,pc}
    $d
        0x01005aca:    0000        ..      DCW    0
        0x01005acc:    30006a80    .j.0    DCD    805333632
    $t
    i.read_adc_value
    read_adc_value
        0x01005ad0:    e92d47fc    -..G    PUSH     {r2-r10,lr}
        0x01005ad4:    2500        .%      MOVS     r5,#0
        0x01005ad6:    2400        .$      MOVS     r4,#0
        0x01005ad8:    f8df8050    ..P.    LDR      r8,[pc,#80] ; [0x1005b2c] = 0xa000e000
        0x01005adc:    f8dfa050    ..P.    LDR      r10,[pc,#80] ; [0x1005b30] = 0xa000c504
        0x01005ae0:    4e14        .N      LDR      r6,[pc,#80] ; [0x1005b34] = 0xe0001000
        0x01005ae2:    46e9        .F      MOV      r9,sp
        0x01005ae4:    f8d80234    ..4.    LDR      r0,[r8,#0x234]
        0x01005ae8:    eb056510    ...e    ADD      r5,r5,r0,LSR #24
        0x01005aec:    a012        ..      ADR      r0,{pc}+0x4c ; 0x1005b38
        0x01005aee:    c803        ..      LDM      r0,{r0,r1}
        0x01005af0:    e9cd0100    ....    STRD     r0,r1,[sp,#0]
        0x01005af4:    f8da0000    ....    LDR      r0,[r10,#0]
        0x01005af8:    f0000007    ....    AND      r0,r0,#7
        0x01005afc:    f8190000    ....    LDRB     r0,[r9,r0]
        0x01005b00:    eb000080    ....    ADD      r0,r0,r0,LSL #2
        0x01005b04:    0047        G.      LSLS     r7,r0,#1
        0x01005b06:    f7fefb59    ..Y.    BL       hal_dwt_enable ; 0x10041bc
        0x01005b0a:    6870        ph      LDR      r0,[r6,#4]
        0x01005b0c:    6871        qh      LDR      r1,[r6,#4]
        0x01005b0e:    1a09        ..      SUBS     r1,r1,r0
        0x01005b10:    42b9        .B      CMP      r1,r7
        0x01005b12:    d3fb        ..      BCC      0x1005b0c ; read_adc_value + 60
        0x01005b14:    f7fefb36    ..6.    BL       hal_dwt_disable ; 0x1004184
        0x01005b18:    1c64        d.      ADDS     r4,r4,#1
        0x01005b1a:    2c0a        .,      CMP      r4,#0xa
        0x01005b1c:    dbe2        ..      BLT      0x1005ae4 ; read_adc_value + 20
        0x01005b1e:    200a        .       MOVS     r0,#0xa
        0x01005b20:    fbb5f0f0    ....    UDIV     r0,r5,r0
        0x01005b24:    b2c0        ..      UXTB     r0,r0
        0x01005b26:    e8bd87fc    ....    POP      {r2-r10,pc}
    $d
        0x01005b2a:    0000        ..      DCW    0
        0x01005b2c:    a000e000    ....    DCD    2684411904
        0x01005b30:    a000c504    ....    DCD    2684404996
        0x01005b34:    e0001000    ....    DCD    3758100480
        0x01005b38:    18103040    @0..    DCD    403714112
        0x01005b3c:    00002010    . ..    DCD    8208
    $t
    i.read_incr
    read_incr
        0x01005b40:    b570        p.      PUSH     {r4-r6,lr}
        0x01005b42:    4604        .F      MOV      r4,r0
        0x01005b44:    460d        .F      MOV      r5,r1
        0x01005b46:    4616        .F      MOV      r6,r2
        0x01005b48:    6828        (h      LDR      r0,[r5,#0]
        0x01005b4a:    6821        !h      LDR      r1,[r4,#0]
        0x01005b4c:    2b00        .+      CMP      r3,#0
        0x01005b4e:    d003        ..      BEQ      0x1005b58 ; read_incr + 24
        0x01005b50:    4632        2F      MOV      r2,r6
        0x01005b52:    f7fdff73    ..s.    BL       dec_flash_read ; 0x1003a3c
        0x01005b56:    e002        ..      B        0x1005b5e ; read_incr + 30
        0x01005b58:    4632        2F      MOV      r2,r6
        0x01005b5a:    f7fefc2f    ../.    BL       hal_flash_read ; 0x10043bc
        0x01005b5e:    6828        (h      LDR      r0,[r5,#0]
        0x01005b60:    4430        0D      ADD      r0,r0,r6
        0x01005b62:    6028        (`      STR      r0,[r5,#0]
        0x01005b64:    6820         h      LDR      r0,[r4,#0]
        0x01005b66:    4430        0D      ADD      r0,r0,r6
        0x01005b68:    6020         `      STR      r0,[r4,#0]
        0x01005b6a:    bd70        p.      POP      {r4-r6,pc}
    i.replace_item
    replace_item
        0x01005b6c:    e92d43f0    -..C    PUSH     {r4-r9,lr}
        0x01005b70:    b087        ..      SUB      sp,sp,#0x1c
        0x01005b72:    460f        .F      MOV      r7,r1
        0x01005b74:    4690        .F      MOV      r8,r2
        0x01005b76:    4699        .F      MOV      r9,r3
        0x01005b78:    2500        .%      MOVS     r5,#0
        0x01005b7a:    9506        ..      STR      r5,[sp,#0x18]
        0x01005b7c:    f1a00608    ....    SUB      r6,r0,#8
        0x01005b80:    2403        .$      MOVS     r4,#3
        0x01005b82:    2202        ."      MOVS     r2,#2
        0x01005b84:    a906        ..      ADD      r1,sp,#0x18
        0x01005b86:    4630        0F      MOV      r0,r6
        0x01005b88:    f7fdff72    ..r.    BL       dec_flash_write ; 0x1003a70
        0x01005b8c:    2802        .(      CMP      r0,#2
        0x01005b8e:    d003        ..      BEQ      0x1005b98 ; replace_item + 44
        0x01005b90:    1e64        d.      SUBS     r4,r4,#1
        0x01005b92:    f01404ff    ....    ANDS     r4,r4,#0xff
        0x01005b96:    d1f4        ..      BNE      0x1005b82 ; replace_item + 22
        0x01005b98:    2802        .(      CMP      r0,#2
        0x01005b9a:    d012        ..      BEQ      0x1005bc2 ; replace_item + 86
        0x01005b9c:    481b        .H      LDR      r0,[pc,#108] ; [0x1005c0c] = 0x801f64
        0x01005b9e:    6981        .i      LDR      r1,[r0,#0x18]
        0x01005ba0:    7a40        @z      LDRB     r0,[r0,#9]
        0x01005ba2:    f2403269    @.i2    MOV      r2,#0x369
        0x01005ba6:    e9cd2000    ...     STRD     r2,r0,[sp,#0]
        0x01005baa:    9102        ..      STR      r1,[sp,#8]
        0x01005bac:    4b18        .K      LDR      r3,[pc,#96] ; [0x1005c10] = 0x1007bf4
        0x01005bae:    a219        ..      ADR      r2,{pc}+0x66 ; 0x1005c14
        0x01005bb0:    f44f4100    O..A    MOV      r1,#0x8000
        0x01005bb4:    2000        .       MOVS     r0,#0
        0x01005bb6:    f407d0f1    ....    BL       dbg_log_printf ; 0xcd9c
        0x01005bba:    2009        .       MOVS     r0,#9
        0x01005bbc:    b007        ..      ADD      sp,sp,#0x1c
        0x01005bbe:    e8bd83f0    ....    POP      {r4-r9,pc}
        0x01005bc2:    2208        ."      MOVS     r2,#8
        0x01005bc4:    a904        ..      ADD      r1,sp,#0x10
        0x01005bc6:    4630        0F      MOV      r0,r6
        0x01005bc8:    f7fdff38    ..8.    BL       dec_flash_read ; 0x1003a3c
        0x01005bcc:    f8bd0012    ....    LDRH     r0,[sp,#0x12]
        0x01005bd0:    f46fd5f2    o...    BL       get_align_bytes ; 0x757b8
        0x01005bd4:    b2c0        ..      UXTB     r0,r0
        0x01005bd6:    4a1b        .J      LDR      r2,[pc,#108] ; [0x1005c44] = 0x8032d8
        0x01005bd8:    6851        Qh      LDR      r1,[r2,#4]
        0x01005bda:    b171        q.      CBZ      r1,0x1005bfa ; replace_item + 142
        0x01005bdc:    f8bd3012    ...0    LDRH     r3,[sp,#0x12]
        0x01005be0:    3008        .0      ADDS     r0,r0,#8
        0x01005be2:    4419        .D      ADD      r1,r1,r3
        0x01005be4:    4408        .D      ADD      r0,r0,r1
        0x01005be6:    6050        P`      STR      r0,[r2,#4]
        0x01005be8:    4638        8F      MOV      r0,r7
        0x01005bea:    f000fec7    ....    BL       tags_cache_rec_del ; 0x100697c
        0x01005bee:    464a        JF      MOV      r2,r9
        0x01005bf0:    4641        AF      MOV      r1,r8
        0x01005bf2:    4638        8F      MOV      r0,r7
        0x01005bf4:    f7fdfb1c    ....    BL       append_item ; 0x1003230
        0x01005bf8:    e7e0        ..      B        0x1005bbc ; replace_item + 80
        0x01005bfa:    7a11        .z      LDRB     r1,[r2,#8]
        0x01005bfc:    f8bd3012    ...0    LDRH     r3,[sp,#0x12]
        0x01005c00:    4419        .D      ADD      r1,r1,r3
        0x01005c02:    4408        .D      ADD      r0,r0,r1
        0x01005c04:    6050        P`      STR      r0,[r2,#4]
        0x01005c06:    7215        .r      STRB     r5,[r2,#8]
        0x01005c08:    e7ee        ..      B        0x1005be8 ; replace_item + 124
    $d
        0x01005c0a:    0000        ..      DCW    0
        0x01005c0c:    00801f64    d...    DCD    8396644
        0x01005c10:    01007bf4    .{..    DCD    16808948
        0x01005c14:    3a353a52    R:5:    DCD    976566866
        0x01005c18:    202c7325    %s,     DCD    539783973
        0x01005c1c:    2064254c    L%d     DCD    543434060
        0x01005c20:    73616c66    flas    DCD    1935764582
        0x01005c24:    74732068    h st    DCD    1953701992
        0x01005c28:    20657461    ate     DCD    543519841
        0x01005c2c:    30257830    0x%0    DCD    807761968
        0x01005c30:    202c5832    2X,     DCD    539777074
        0x01005c34:    6f727265    erro    DCD    1869771365
        0x01005c38:    78302072    r 0x    DCD    2016419954
        0x01005c3c:    58383025    %08X    DCD    1480077349
        0x01005c40:    00000a0d    ....    DCD    2573
        0x01005c44:    008032d8    .2..    DCD    8401624
    $t
    i.retention_mem_set
    retention_mem_set
        0x01005c48:    4a10        .J      LDR      r2,[pc,#64] ; [0x1005c8c] = 0xa000c50c
        0x01005c4a:    4910        .I      LDR      r1,[pc,#64] ; [0x1005c8c] = 0xa000c50c
        0x01005c4c:    3248        H2      ADDS     r2,r2,#0x48
        0x01005c4e:    2828        ((      CMP      r0,#0x28
        0x01005c50:    dd08        ..      BLE      0x1005c64 ; retention_mem_set + 28
        0x01005c52:    6808        .h      LDR      r0,[r1,#0]
        0x01005c54:    f44050c0    @..P    ORR      r0,r0,#0x1800
        0x01005c58:    6008        .`      STR      r0,[r1,#0]
        0x01005c5a:    6810        .h      LDR      r0,[r2,#0]
        0x01005c5c:    f4406070    @.p`    ORR      r0,r0,#0xf00
        0x01005c60:    6010        .`      STR      r0,[r2,#0]
        0x01005c62:    4770        pG      BX       lr
        0x01005c64:    2800        .(      CMP      r0,#0
        0x01005c66:    dd08        ..      BLE      0x1005c7a ; retention_mem_set + 50
        0x01005c68:    6808        .h      LDR      r0,[r1,#0]
        0x01005c6a:    f42050c0     ..P    BIC      r0,r0,#0x1800
        0x01005c6e:    6008        .`      STR      r0,[r1,#0]
        0x01005c70:    6810        .h      LDR      r0,[r2,#0]
        0x01005c72:    f4406070    @.p`    ORR      r0,r0,#0xf00
        0x01005c76:    6010        .`      STR      r0,[r2,#0]
        0x01005c78:    4770        pG      BX       lr
        0x01005c7a:    6808        .h      LDR      r0,[r1,#0]
        0x01005c7c:    f44050c0    @..P    ORR      r0,r0,#0x1800
        0x01005c80:    6008        .`      STR      r0,[r1,#0]
        0x01005c82:    6810        .h      LDR      r0,[r2,#0]
        0x01005c84:    f4406070    @.p`    ORR      r0,r0,#0xf00
        0x01005c88:    6010        .`      STR      r0,[r2,#0]
        0x01005c8a:    4770        pG      BX       lr
    $d
        0x01005c8c:    a000c50c    ....    DCD    2684405004
    $t
    i.rf_calibration_set
    rf_calibration_set
        0x01005c90:    b510        ..      PUSH     {r4,lr}
        0x01005c92:    f472d7e1    r...    BL       pwr_mgmt_mode_get ; 0x78c58
        0x01005c96:    2802        .(      CMP      r0,#2
        0x01005c98:    d004        ..      BEQ      0x1005ca4 ; rf_calibration_set + 20
        0x01005c9a:    e8bd4010    ...@    POP      {r4,lr}
        0x01005c9e:    2001        .       MOVS     r0,#1
        0x01005ca0:    f47397a4    s...    B        rf_set_recalibration_flag ; 0x79bec
        0x01005ca4:    bd10        ..      POP      {r4,pc}
        0x01005ca6:    0000        ..      MOVS     r0,r0
    i.rf_communication_core_init_patch
    rf_communication_core_init_patch
        0x01005ca8:    b510        ..      PUSH     {r4,lr}
        0x01005caa:    483c        <H      LDR      r0,[pc,#240] ; [0x1005d9c] = 0xa000c504
        0x01005cac:    6801        .h      LDR      r1,[r0,#0]
        0x01005cae:    f3c11180    ....    UBFX     r1,r1,#6,#1
        0x01005cb2:    2900        .)      CMP      r1,#0
        0x01005cb4:    d004        ..      BEQ      0x1005cc0 ; rf_communication_core_init_patch + 24
        0x01005cb6:    6801        .h      LDR      r1,[r0,#0]
        0x01005cb8:    f3c111c0    ....    UBFX     r1,r1,#7,#1
        0x01005cbc:    2900        .)      CMP      r1,#0
        0x01005cbe:    d16c        l.      BNE      0x1005d9a ; rf_communication_core_init_patch + 242
        0x01005cc0:    6801        .h      LDR      r1,[r0,#0]
        0x01005cc2:    f4417100    A..q    ORR      r1,r1,#0x200
        0x01005cc6:    6001        .`      STR      r1,[r0,#0]
        0x01005cc8:    6801        .h      LDR      r1,[r0,#0]
        0x01005cca:    f0410180    A...    ORR      r1,r1,#0x80
        0x01005cce:    6001        .`      STR      r1,[r0,#0]
        0x01005cd0:    6801        .h      LDR      r1,[r0,#0]
        0x01005cd2:    f4217100    !..q    BIC      r1,r1,#0x200
        0x01005cd6:    6001        .`      STR      r1,[r0,#0]
        0x01005cd8:    6801        .h      LDR      r1,[r0,#0]
        0x01005cda:    f0410140    A.@.    ORR      r1,r1,#0x40
        0x01005cde:    6001        .`      STR      r1,[r0,#0]
        0x01005ce0:    6801        .h      LDR      r1,[r0,#0]
        0x01005ce2:    f4217180    !..q    BIC      r1,r1,#0x100
        0x01005ce6:    6001        .`      STR      r1,[r0,#0]
        0x01005ce8:    492c        ,I      LDR      r1,[pc,#176] ; [0x1005d9c] = 0xa000c504
        0x01005cea:    3160        `1      ADDS     r1,r1,#0x60
        0x01005cec:    680a        .h      LDR      r2,[r1,#0]
        0x01005cee:    f022624c    ".Lb    BIC      r2,r2,#0xcc00000
        0x01005cf2:    f042624c    B.Lb    ORR      r2,r2,#0xcc00000
        0x01005cf6:    600a        .`      STR      r2,[r1,#0]
        0x01005cf8:    1d09        ..      ADDS     r1,r1,#4
        0x01005cfa:    680a        .h      LDR      r2,[r1,#0]
        0x01005cfc:    f022624c    ".Lb    BIC      r2,r2,#0xcc00000
        0x01005d00:    f0426208    B..b    ORR      r2,r2,#0x8800000
        0x01005d04:    600a        .`      STR      r2,[r1,#0]
        0x01005d06:    4925        %I      LDR      r1,[pc,#148] ; [0x1005d9c] = 0xa000c504
        0x01005d08:    317c        |1      ADDS     r1,r1,#0x7c
        0x01005d0a:    680a        .h      LDR      r2,[r1,#0]
        0x01005d0c:    f3c20240    ..@.    UBFX     r2,r2,#1,#1
        0x01005d10:    2a00        .*      CMP      r2,#0
        0x01005d12:    d1fa        ..      BNE      0x1005d0a ; rf_communication_core_init_patch + 98
        0x01005d14:    4b21        !K      LDR      r3,[pc,#132] ; [0x1005d9c] = 0xa000c504
        0x01005d16:    220a        ."      MOVS     r2,#0xa
        0x01005d18:    3380        .3      ADDS     r3,r3,#0x80
        0x01005d1a:    601a        .`      STR      r2,[r3,#0]
        0x01005d1c:    680a        .h      LDR      r2,[r1,#0]
        0x01005d1e:    f0420201    B...    ORR      r2,r2,#1
        0x01005d22:    600a        .`      STR      r2,[r1,#0]
        0x01005d24:    680a        .h      LDR      r2,[r1,#0]
        0x01005d26:    f3c20240    ..@.    UBFX     r2,r2,#1,#1
        0x01005d2a:    2a00        .*      CMP      r2,#0
        0x01005d2c:    d1fa        ..      BNE      0x1005d24 ; rf_communication_core_init_patch + 124
        0x01005d2e:    6801        .h      LDR      r1,[r0,#0]
        0x01005d30:    f4216100    !..a    BIC      r1,r1,#0x800
        0x01005d34:    6001        .`      STR      r1,[r0,#0]
        0x01005d36:    6801        .h      LDR      r1,[r0,#0]
        0x01005d38:    f4215180    !..Q    BIC      r1,r1,#0x1000
        0x01005d3c:    6001        .`      STR      r1,[r0,#0]
        0x01005d3e:    6801        .h      LDR      r1,[r0,#0]
        0x01005d40:    f4416100    A..a    ORR      r1,r1,#0x800
        0x01005d44:    6001        .`      STR      r1,[r0,#0]
        0x01005d46:    6801        .h      LDR      r1,[r0,#0]
        0x01005d48:    f4415180    A..Q    ORR      r1,r1,#0x1000
        0x01005d4c:    6001        .`      STR      r1,[r0,#0]
        0x01005d4e:    2001        .       MOVS     r0,#1
        0x01005d50:    f475d755    u.U.    BL       sys_delay_us ; 0x7bbfe
        0x01005d54:    f3ef8110    ....    MRS      r1,PRIMASK
        0x01005d58:    2001        .       MOVS     r0,#1
        0x01005d5a:    f3808810    ....    MSR      PRIMASK,r0
        0x01005d5e:    480f        .H      LDR      r0,[pc,#60] ; [0x1005d9c] = 0xa000c504
        0x01005d60:    303c        <0      ADDS     r0,r0,#0x3c
        0x01005d62:    6802        .h      LDR      r2,[r0,#0]
        0x01005d64:    f4222280    ".."    BIC      r2,r2,#0x40000
        0x01005d68:    6002        .`      STR      r2,[r0,#0]
        0x01005d6a:    f3818810    ....    MSR      PRIMASK,r1
        0x01005d6e:    f3ef8110    ....    MRS      r1,PRIMASK
        0x01005d72:    2201        ."      MOVS     r2,#1
        0x01005d74:    f3828810    ....    MSR      PRIMASK,r2
        0x01005d78:    6802        .h      LDR      r2,[r0,#0]
        0x01005d7a:    f4223280    "..2    BIC      r2,r2,#0x10000
        0x01005d7e:    6002        .`      STR      r2,[r0,#0]
        0x01005d80:    f3818810    ....    MSR      PRIMASK,r1
        0x01005d84:    f3ef8110    ....    MRS      r1,PRIMASK
        0x01005d88:    2201        ."      MOVS     r2,#1
        0x01005d8a:    f3828810    ....    MSR      PRIMASK,r2
        0x01005d8e:    6802        .h      LDR      r2,[r0,#0]
        0x01005d90:    f4223200    "..2    BIC      r2,r2,#0x20000
        0x01005d94:    6002        .`      STR      r2,[r0,#0]
        0x01005d96:    f3818810    ....    MSR      PRIMASK,r1
        0x01005d9a:    bd10        ..      POP      {r4,pc}
    $d
        0x01005d9c:    a000c504    ....    DCD    2684404996
    $t
    i.rf_xo_offset_init
    rf_xo_offset_init
        0x01005da0:    b511        ..      PUSH     {r0,r4,lr}
        0x01005da2:    b083        ..      SUB      sp,sp,#0xc
        0x01005da4:    2000        .       MOVS     r0,#0
        0x01005da6:    9002        ..      STR      r0,[sp,#8]
        0x01005da8:    2102        .!      MOVS     r1,#2
        0x01005daa:    9101        ..      STR      r1,[sp,#4]
        0x01005dac:    f8bd200c    ...     LDRH     r2,[sp,#0xc]
        0x01005db0:    f24c04b1    L...    MOV      r4,#0xc0b1
        0x01005db4:    2a00        .*      CMP      r2,#0
        0x01005db6:    d003        ..      BEQ      0x1005dc0 ; rf_xo_offset_init + 32
        0x01005db8:    aa03        ..      ADD      r2,sp,#0xc
        0x01005dba:    4620         F      MOV      r0,r4
        0x01005dbc:    f7fffb08    ....    BL       nvds_put ; 0x10053d0
        0x01005dc0:    aa02        ..      ADD      r2,sp,#8
        0x01005dc2:    a901        ..      ADD      r1,sp,#4
        0x01005dc4:    4620         F      MOV      r0,r4
        0x01005dc6:    f7fff9cd    ....    BL       nvds_get ; 0x1005164
        0x01005dca:    b178        x.      CBZ      r0,0x1005dec ; rf_xo_offset_init + 76
        0x01005dcc:    f44f2080    O..     MOV      r0,#0x40000
        0x01005dd0:    490b        .I      LDR      r1,[pc,#44] ; [0x1005e00] = 0xa000c538
        0x01005dd2:    680a        .h      LDR      r2,[r1,#0]
        0x01005dd4:    4b0b        .K      LDR      r3,[pc,#44] ; [0x1005e04] = 0xfff803ff
        0x01005dd6:    401a        .@      ANDS     r2,r2,r3
        0x01005dd8:    4302        .C      ORRS     r2,r2,r0
        0x01005dda:    600a        .`      STR      r2,[r1,#0]
        0x01005ddc:    6808        .h      LDR      r0,[r1,#0]
        0x01005dde:    490a        .I      LDR      r1,[pc,#40] ; [0x1005e08] = 0x30006824
        0x01005de0:    f3c02088    ...     UBFX     r0,r0,#10,#9
        0x01005de4:    8008        ..      STRH     r0,[r1,#0]
        0x01005de6:    f7fedf43    ..C.    BL       work_xo_bias_set ; 0x804c70
        0x01005dea:    bd1f        ..      POP      {r0-r4,pc}
        0x01005dec:    f89d0008    ....    LDRB     r0,[sp,#8]
        0x01005df0:    f89d1009    ....    LDRB     r1,[sp,#9]
        0x01005df4:    ea402001    @..     ORR      r0,r0,r1,LSL #8
        0x01005df8:    4904        .I      LDR      r1,[pc,#16] ; [0x1005e0c] = 0x7ffff
        0x01005dfa:    ea012080    ...     AND      r0,r1,r0,LSL #10
        0x01005dfe:    e7e7        ..      B        0x1005dd0 ; rf_xo_offset_init + 48
    $d
        0x01005e00:    a000c538    8...    DCD    2684405048
        0x01005e04:    fff803ff    ....    DCD    4294444031
        0x01005e08:    30006824    $h.0    DCD    805333028
        0x01005e0c:    0007ffff    ....    DCD    524287
    $t
    i.ring_buffer_init
    ring_buffer_init
        0x01005e10:    b510        ..      PUSH     {r4,lr}
        0x01005e12:    2900        .)      CMP      r1,#0
        0x01005e14:    d00f        ..      BEQ      0x1005e36 ; ring_buffer_init + 38
        0x01005e16:    b170        p.      CBZ      r0,0x1005e36 ; ring_buffer_init + 38
        0x01005e18:    b16a        j.      CBZ      r2,0x1005e36 ; ring_buffer_init + 38
        0x01005e1a:    f3ef8310    ....    MRS      r3,PRIMASK
        0x01005e1e:    2401        .$      MOVS     r4,#1
        0x01005e20:    f3848810    ....    MSR      PRIMASK,r4
        0x01005e24:    6002        .`      STR      r2,[r0,#0]
        0x01005e26:    6041        A`      STR      r1,[r0,#4]
        0x01005e28:    2100        .!      MOVS     r1,#0
        0x01005e2a:    6081        .`      STR      r1,[r0,#8]
        0x01005e2c:    60c1        .`      STR      r1,[r0,#0xc]
        0x01005e2e:    f3838810    ....    MSR      PRIMASK,r3
        0x01005e32:    2001        .       MOVS     r0,#1
        0x01005e34:    bd10        ..      POP      {r4,pc}
        0x01005e36:    2000        .       MOVS     r0,#0
        0x01005e38:    bd10        ..      POP      {r4,pc}
    i.ring_buffer_items_count_get
    ring_buffer_items_count_get
        0x01005e3a:    2800        .(      CMP      r0,#0
        0x01005e3c:    d00a        ..      BEQ      0x1005e54 ; ring_buffer_items_count_get + 26
        0x01005e3e:    f3ef8310    ....    MRS      r3,PRIMASK
        0x01005e42:    2101        .!      MOVS     r1,#1
        0x01005e44:    f3818810    ....    MSR      PRIMASK,r1
        0x01005e48:    6881        .h      LDR      r1,[r0,#8]
        0x01005e4a:    68c2        .h      LDR      r2,[r0,#0xc]
        0x01005e4c:    428a        .B      CMP      r2,r1
        0x01005e4e:    d803        ..      BHI      0x1005e58 ; ring_buffer_items_count_get + 30
        0x01005e50:    1a88        ..      SUBS     r0,r1,r2
        0x01005e52:    e004        ..      B        0x1005e5e ; ring_buffer_items_count_get + 36
        0x01005e54:    2000        .       MOVS     r0,#0
        0x01005e56:    4770        pG      BX       lr
        0x01005e58:    6800        .h      LDR      r0,[r0,#0]
        0x01005e5a:    1a80        ..      SUBS     r0,r0,r2
        0x01005e5c:    4408        .D      ADD      r0,r0,r1
        0x01005e5e:    f3838810    ....    MSR      PRIMASK,r3
        0x01005e62:    4770        pG      BX       lr
    i.ring_buffer_read
    ring_buffer_read
        0x01005e64:    e92d47f0    -..G    PUSH     {r4-r10,lr}
        0x01005e68:    4605        .F      MOV      r5,r0
        0x01005e6a:    468a        .F      MOV      r10,r1
        0x01005e6c:    f04f0800    O...    MOV      r8,#0
        0x01005e70:    f3ef8910    ....    MRS      r9,PRIMASK
        0x01005e74:    2001        .       MOVS     r0,#1
        0x01005e76:    f3808810    ....    MSR      PRIMASK,r0
        0x01005e7a:    68af        .h      LDR      r7,[r5,#8]
        0x01005e7c:    68ee        .h      LDR      r6,[r5,#0xc]
        0x01005e7e:    2d00        .-      CMP      r5,#0
        0x01005e80:    d02e        ..      BEQ      0x1005ee0 ; ring_buffer_read + 124
        0x01005e82:    6869        ih      LDR      r1,[r5,#4]
        0x01005e84:    b361        a.      CBZ      r1,0x1005ee0 ; ring_buffer_read + 124
        0x01005e86:    f1ba0f00    ....    CMP      r10,#0
        0x01005e8a:    d029        ).      BEQ      0x1005ee0 ; ring_buffer_read + 124
        0x01005e8c:    42b7        .B      CMP      r7,r6
        0x01005e8e:    d304        ..      BCC      0x1005e9a ; ring_buffer_read + 54
        0x01005e90:    1bbc        ..      SUBS     r4,r7,r6
        0x01005e92:    42a2        .B      CMP      r2,r4
        0x01005e94:    d80d        ..      BHI      0x1005eb2 ; ring_buffer_read + 78
        0x01005e96:    4614        .F      MOV      r4,r2
        0x01005e98:    e00b        ..      B        0x1005eb2 ; ring_buffer_read + 78
        0x01005e9a:    6828        (h      LDR      r0,[r5,#0]
        0x01005e9c:    1b83        ..      SUBS     r3,r0,r6
        0x01005e9e:    19dc        ..      ADDS     r4,r3,r7
        0x01005ea0:    42a2        .B      CMP      r2,r4
        0x01005ea2:    d800        ..      BHI      0x1005ea6 ; ring_buffer_read + 66
        0x01005ea4:    4614        .F      MOV      r4,r2
        0x01005ea6:    1932        2.      ADDS     r2,r6,r4
        0x01005ea8:    4282        .B      CMP      r2,r0
        0x01005eaa:    d302        ..      BCC      0x1005eb2 ; ring_buffer_read + 78
        0x01005eac:    19a2        ..      ADDS     r2,r4,r6
        0x01005eae:    eba20800    ....    SUB      r8,r2,r0
        0x01005eb2:    eba40208    ....    SUB      r2,r4,r8
        0x01005eb6:    4431        1D      ADD      r1,r1,r6
        0x01005eb8:    4650        PF      MOV      r0,r10
        0x01005eba:    f7fcfafb    ....    BL       __aeabi_memcpy ; 0x10024b4
        0x01005ebe:    eb0a0004    ....    ADD      r0,r10,r4
        0x01005ec2:    eba00008    ....    SUB      r0,r0,r8
        0x01005ec6:    4642        BF      MOV      r2,r8
        0x01005ec8:    6869        ih      LDR      r1,[r5,#4]
        0x01005eca:    f7fcfaf3    ....    BL       __aeabi_memcpy ; 0x10024b4
        0x01005ece:    1930        0.      ADDS     r0,r6,r4
        0x01005ed0:    6829        )h      LDR      r1,[r5,#0]
        0x01005ed2:    4281        .B      CMP      r1,r0
        0x01005ed4:    d802        ..      BHI      0x1005edc ; ring_buffer_read + 120
        0x01005ed6:    42b8        .B      CMP      r0,r7
        0x01005ed8:    d900        ..      BLS      0x1005edc ; ring_buffer_read + 120
        0x01005eda:    1a40        @.      SUBS     r0,r0,r1
        0x01005edc:    60e8        .`      STR      r0,[r5,#0xc]
        0x01005ede:    e000        ..      B        0x1005ee2 ; ring_buffer_read + 126
        0x01005ee0:    2400        .$      MOVS     r4,#0
        0x01005ee2:    f3898810    ....    MSR      PRIMASK,r9
        0x01005ee6:    4620         F      MOV      r0,r4
        0x01005ee8:    e8bd87f0    ....    POP      {r4-r10,pc}
    i.ring_buffer_write
    ring_buffer_write
        0x01005eec:    e92d47f0    -..G    PUSH     {r4-r10,lr}
        0x01005ef0:    4604        .F      MOV      r4,r0
        0x01005ef2:    4689        .F      MOV      r9,r1
        0x01005ef4:    2700        .'      MOVS     r7,#0
        0x01005ef6:    f3ef8810    ....    MRS      r8,PRIMASK
        0x01005efa:    2001        .       MOVS     r0,#1
        0x01005efc:    f3808810    ....    MSR      PRIMASK,r0
        0x01005f00:    68a6        .h      LDR      r6,[r4,#8]
        0x01005f02:    68e0        .h      LDR      r0,[r4,#0xc]
        0x01005f04:    2c00        .,      CMP      r4,#0
        0x01005f06:    d02a        *.      BEQ      0x1005f5e ; ring_buffer_write + 114
        0x01005f08:    6863        ch      LDR      r3,[r4,#4]
        0x01005f0a:    b343        C.      CBZ      r3,0x1005f5e ; ring_buffer_write + 114
        0x01005f0c:    f1b90f00    ....    CMP      r9,#0
        0x01005f10:    d025        %.      BEQ      0x1005f5e ; ring_buffer_write + 114
        0x01005f12:    42b0        .B      CMP      r0,r6
        0x01005f14:    d905        ..      BLS      0x1005f22 ; ring_buffer_write + 54
        0x01005f16:    1b85        ..      SUBS     r5,r0,r6
        0x01005f18:    1e6d        m.      SUBS     r5,r5,#1
        0x01005f1a:    42aa        .B      CMP      r2,r5
        0x01005f1c:    d80c        ..      BHI      0x1005f38 ; ring_buffer_write + 76
        0x01005f1e:    4615        .F      MOV      r5,r2
        0x01005f20:    e00a        ..      B        0x1005f38 ; ring_buffer_write + 76
        0x01005f22:    6821        !h      LDR      r1,[r4,#0]
        0x01005f24:    1b8d        ..      SUBS     r5,r1,r6
        0x01005f26:    4405        .D      ADD      r5,r5,r0
        0x01005f28:    1e6d        m.      SUBS     r5,r5,#1
        0x01005f2a:    42aa        .B      CMP      r2,r5
        0x01005f2c:    d800        ..      BHI      0x1005f30 ; ring_buffer_write + 68
        0x01005f2e:    4615        .F      MOV      r5,r2
        0x01005f30:    1970        p.      ADDS     r0,r6,r5
        0x01005f32:    4288        .B      CMP      r0,r1
        0x01005f34:    d300        ..      BCC      0x1005f38 ; ring_buffer_write + 76
        0x01005f36:    1a47        G.      SUBS     r7,r0,r1
        0x01005f38:    1bea        ..      SUBS     r2,r5,r7
        0x01005f3a:    1998        ..      ADDS     r0,r3,r6
        0x01005f3c:    4649        IF      MOV      r1,r9
        0x01005f3e:    f7fcfab9    ....    BL       __aeabi_memcpy ; 0x10024b4
        0x01005f42:    eb090005    ....    ADD      r0,r9,r5
        0x01005f46:    1bc1        ..      SUBS     r1,r0,r7
        0x01005f48:    463a        :F      MOV      r2,r7
        0x01005f4a:    6860        `h      LDR      r0,[r4,#4]
        0x01005f4c:    f7fcfab2    ....    BL       __aeabi_memcpy ; 0x10024b4
        0x01005f50:    1970        p.      ADDS     r0,r6,r5
        0x01005f52:    6821        !h      LDR      r1,[r4,#0]
        0x01005f54:    4281        .B      CMP      r1,r0
        0x01005f56:    d800        ..      BHI      0x1005f5a ; ring_buffer_write + 110
        0x01005f58:    1a40        @.      SUBS     r0,r0,r1
        0x01005f5a:    60a0        .`      STR      r0,[r4,#8]
        0x01005f5c:    e000        ..      B        0x1005f60 ; ring_buffer_write + 116
        0x01005f5e:    2500        .%      MOVS     r5,#0
        0x01005f60:    f3888810    ....    MSR      PRIMASK,r8
        0x01005f64:    4628        (F      MOV      r0,r5
        0x01005f66:    e8bd87f0    ....    POP      {r4-r10,pc}
        0x01005f6a:    0000        ..      MOVS     r0,r0
    i.rng_calibration
    rng_calibration
        0x01005f6c:    e92d4ff0    -..O    PUSH     {r4-r11,lr}
        0x01005f70:    ed2d8b02    -...    VPUSH    {d8}
        0x01005f74:    b085        ..      SUB      sp,sp,#0x14
        0x01005f76:    2600        .&      MOVS     r6,#0
        0x01005f78:    46b1        .F      MOV      r9,r6
        0x01005f7a:    2700        .'      MOVS     r7,#0
        0x01005f7c:    4857        WH      LDR      r0,[pc,#348] ; [0x10060dc] = 0xa000c558
        0x01005f7e:    6800        .h      LDR      r0,[r0,#0]
        0x01005f80:    f3c06000    ...`    UBFX     r0,r0,#24,#1
        0x01005f84:    4c56        VL      LDR      r4,[pc,#344] ; [0x10060e0] = 0x30006798
        0x01005f86:    4d57        WM      LDR      r5,[pc,#348] ; [0x10060e4] = 0xe0001000
        0x01005f88:    2800        .(      CMP      r0,#0
        0x01005f8a:    d018        ..      BEQ      0x1005fbe ; rng_calibration + 82
        0x01005f8c:    f7feff1e    ....    BL       ll_aon_wdt_get_counter ; 0x1004dcc
        0x01005f90:    f5b07f96    ....    CMP      r0,#0x12c
        0x01005f94:    d37d        }.      BCC      0x1006092 ; rng_calibration + 294
        0x01005f96:    6820         h      LDR      r0,[r4,#0]
        0x01005f98:    b120         .      CBZ      r0,0x1005fa4 ; rng_calibration + 56
        0x01005f9a:    6868        hh      LDR      r0,[r5,#4]
        0x01005f9c:    4952        RI      LDR      r1,[pc,#328] ; [0x10060e8] = 0xc3500
        0x01005f9e:    43c0        .C      MVNS     r0,r0
        0x01005fa0:    4288        .B      CMP      r0,r1
        0x01005fa2:    d376        v.      BCC      0x1006092 ; rng_calibration + 294
        0x01005fa4:    f3ef8010    ....    MRS      r0,PRIMASK
        0x01005fa8:    9004        ..      STR      r0,[sp,#0x10]
        0x01005faa:    2001        .       MOVS     r0,#1
        0x01005fac:    f3808810    ....    MSR      PRIMASK,r0
        0x01005fb0:    f04f0a00    O...    MOV      r10,#0
        0x01005fb4:    2000        .       MOVS     r0,#0
        0x01005fb6:    9003        ..      STR      r0,[sp,#0xc]
        0x01005fb8:    6820         h      LDR      r0,[r4,#0]
        0x01005fba:    b118        ..      CBZ      r0,0x1005fc4 ; rng_calibration + 88
        0x01005fbc:    e00b        ..      B        0x1005fd6 ; rng_calibration + 106
        0x01005fbe:    f04f0901    O...    MOV      r9,#1
        0x01005fc2:    e7ef        ..      B        0x1005fa4 ; rng_calibration + 56
        0x01005fc4:    2601        .&      MOVS     r6,#1
        0x01005fc6:    4849        IH      LDR      r0,[pc,#292] ; [0x10060ec] = 0xe000edfc
        0x01005fc8:    f8d0a000    ....    LDR      r10,[r0,#0]
        0x01005fcc:    f04a7180    J..q    ORR      r1,r10,#0x1000000
        0x01005fd0:    6001        .`      STR      r1,[r0,#0]
        0x01005fd2:    6828        (h      LDR      r0,[r5,#0]
        0x01005fd4:    9003        ..      STR      r0,[sp,#0xc]
        0x01005fd6:    f1b90f00    ....    CMP      r9,#0
        0x01005fda:    d034        4.      BEQ      0x1006046 ; rng_calibration + 218
        0x01005fdc:    f44f787a    O.zx    MOV      r8,#0x3e8
        0x01005fe0:    483e        >H      LDR      r0,[pc,#248] ; [0x10060dc] = 0xa000c558
        0x01005fe2:    3038        80      ADDS     r0,r0,#0x38
        0x01005fe4:    f8c08000    ....    STR      r8,[r0,#0]
        0x01005fe8:    4c3c        <L      LDR      r4,[pc,#240] ; [0x10060dc] = 0xa000c558
        0x01005fea:    6820         h      LDR      r0,[r4,#0]
        0x01005fec:    f0407000    @..p    ORR      r0,r0,#0x2000000
        0x01005ff0:    6020         `      STR      r0,[r4,#0]
        0x01005ff2:    f7fefeeb    ....    BL       ll_aon_wdt_get_counter ; 0x1004dcc
        0x01005ff6:    4540        @E      CMP      r0,r8
        0x01005ff8:    d1fb        ..      BNE      0x1005ff2 ; rng_calibration + 134
        0x01005ffa:    6820         h      LDR      r0,[r4,#0]
        0x01005ffc:    f0407080    @..p    ORR      r0,r0,#0x1000000
        0x01006000:    6020         `      STR      r0,[r4,#0]
        0x01006002:    a03b        ;.      ADR      r0,{pc}+0xee ; 0x10060f0
        0x01006004:    c803        ..      LDM      r0,{r0,r1}
        0x01006006:    e9cd0101    ....    STRD     r0,r1,[sp,#4]
        0x0100600a:    4834        4H      LDR      r0,[pc,#208] ; [0x10060dc] = 0xa000c558
        0x0100600c:    3854        T8      SUBS     r0,r0,#0x54
        0x0100600e:    6800        .h      LDR      r0,[r0,#0]
        0x01006010:    a901        ..      ADD      r1,sp,#4
        0x01006012:    f0000007    ....    AND      r0,r0,#7
        0x01006016:    5c09        .\      LDRB     r1,[r1,r0]
        0x01006018:    2064        d       MOVS     r0,#0x64
        0x0100601a:    fb11f100    ....    SMULBB   r1,r1,r0
        0x0100601e:    f8dfc0cc    ....    LDR      r12,[pc,#204] ; [0x10060ec] = 0xe000edfc
        0x01006022:    f8dc3000    ...0    LDR      r3,[r12,#0]
        0x01006026:    f0437080    C..p    ORR      r0,r3,#0x1000000
        0x0100602a:    f8cc0000    ....    STR      r0,[r12,#0]
        0x0100602e:    682c        ,h      LDR      r4,[r5,#0]
        0x01006030:    f0440001    D...    ORR      r0,r4,#1
        0x01006034:    6028        (`      STR      r0,[r5,#0]
        0x01006036:    6868        hh      LDR      r0,[r5,#4]
        0x01006038:    686a        jh      LDR      r2,[r5,#4]
        0x0100603a:    1a12        ..      SUBS     r2,r2,r0
        0x0100603c:    428a        .B      CMP      r2,r1
        0x0100603e:    d3fb        ..      BCC      0x1006038 ; rng_calibration + 204
        0x01006040:    602c        ,`      STR      r4,[r5,#0]
        0x01006042:    f8cc3000    ...0    STR      r3,[r12,#0]
        0x01006046:    2400        .$      MOVS     r4,#0
        0x01006048:    b14e        N.      CBZ      r6,0x100605e ; rng_calibration + 242
        0x0100604a:    6828        (h      LDR      r0,[r5,#0]
        0x0100604c:    f0200001     ...    BIC      r0,r0,#1
        0x01006050:    6028        (`      STR      r0,[r5,#0]
        0x01006052:    2000        .       MOVS     r0,#0
        0x01006054:    6068        h`      STR      r0,[r5,#4]
        0x01006056:    6828        (h      LDR      r0,[r5,#0]
        0x01006058:    f0400001    @...    ORR      r0,r0,#1
        0x0100605c:    6028        (`      STR      r0,[r5,#0]
        0x0100605e:    f7fefeb5    ....    BL       ll_aon_wdt_get_counter ; 0x1004dcc
        0x01006062:    4680        .F      MOV      r8,r0
        0x01006064:    f8d5b004    ....    LDR      r11,[r5,#4]
        0x01006068:    f7fefeb0    ....    BL       ll_aon_wdt_get_counter ; 0x1004dcc
        0x0100606c:    eba80000    ....    SUB      r0,r8,r0
        0x01006070:    2864        d(      CMP      r0,#0x64
        0x01006072:    d9f9        ..      BLS      0x1006068 ; rng_calibration + 252
        0x01006074:    6868        hh      LDR      r0,[r5,#4]
        0x01006076:    eba0000b    ....    SUB      r0,r0,r11
        0x0100607a:    4407        .D      ADD      r7,r7,r0
        0x0100607c:    1c64        d.      ADDS     r4,r4,#1
        0x0100607e:    b2a4        ..      UXTH     r4,r4
        0x01006080:    2c00        .,      CMP      r4,#0
        0x01006082:    d0e1        ..      BEQ      0x1006048 ; rng_calibration + 220
        0x01006084:    b126        &.      CBZ      r6,0x1006090 ; rng_calibration + 292
        0x01006086:    9803        ..      LDR      r0,[sp,#0xc]
        0x01006088:    6028        (`      STR      r0,[r5,#0]
        0x0100608a:    4818        .H      LDR      r0,[pc,#96] ; [0x10060ec] = 0xe000edfc
        0x0100608c:    f8c0a000    ....    STR      r10,[r0,#0]
        0x01006090:    e000        ..      B        0x1006094 ; rng_calibration + 296
        0x01006092:    e01e        ..      B        0x10060d2 ; rng_calibration + 358
        0x01006094:    f1b90f00    ....    CMP      r9,#0
        0x01006098:    d004        ..      BEQ      0x10060a4 ; rng_calibration + 312
        0x0100609a:    4810        .H      LDR      r0,[pc,#64] ; [0x10060dc] = 0xa000c558
        0x0100609c:    6801        .h      LDR      r1,[r0,#0]
        0x0100609e:    f0217180    !..q    BIC      r1,r1,#0x1000000
        0x010060a2:    6001        .`      STR      r1,[r0,#0]
        0x010060a4:    9804        ..      LDR      r0,[sp,#0x10]
        0x010060a6:    f3808810    ....    MSR      PRIMASK,r0
        0x010060aa:    4638        8F      MOV      r0,r7
        0x010060ac:    f001fac1    ....    BL       __aeabi_ui2d ; 0x1007632
        0x010060b0:    ec410b18    A...    VMOV     d8,r0,r1
        0x010060b4:    4810        .H      LDR      r0,[pc,#64] ; [0x10060f8] = 0x30006408
        0x010060b6:    2164        d!      MOVS     r1,#0x64
        0x010060b8:    6800        .h      LDR      r0,[r0,#0]
        0x010060ba:    fba00101    ....    UMULL    r0,r1,r0,r1
        0x010060be:    f001facb    ....    BL       __aeabi_ul2d ; 0x1007658
        0x010060c2:    ec532b18    S..+    VMOV     r2,r3,d8
        0x010060c6:    f001f8ff    ....    BL       __aeabi_ddiv ; 0x10072c8
        0x010060ca:    f001fa85    ....    BL       __aeabi_d2uiz ; 0x10075d8
        0x010060ce:    490b        .I      LDR      r1,[pc,#44] ; [0x10060fc] = 0x300067a8
        0x010060d0:    6088        .`      STR      r0,[r1,#8]
        0x010060d2:    b005        ..      ADD      sp,sp,#0x14
        0x010060d4:    ecbd8b02    ....    VPOP     {d8}
        0x010060d8:    e8bd8ff0    ....    POP      {r4-r11,pc}
    $d
        0x010060dc:    a000c558    X...    DCD    2684405080
        0x010060e0:    30006798    .g.0    DCD    805332888
        0x010060e4:    e0001000    ....    DCD    3758100480
        0x010060e8:    000c3500    .5..    DCD    800000
        0x010060ec:    e000edfc    ....    DCD    3758157308
        0x010060f0:    18103040    @0..    DCD    403714112
        0x010060f4:    00002010    . ..    DCD    8208
        0x010060f8:    30006408    .d.0    DCD    805331976
        0x010060fc:    300067a8    .g.0    DCD    805332904
    $t
    i.rom_callback_replace
    rom_callback_replace
        0x01006100:    4902        .I      LDR      r1,[pc,#8] ; [0x100610c] = 0x800500
        0x01006102:    4801        .H      LDR      r0,[pc,#4] ; [0x1006108] = 0x805b21
        0x01006104:    6008        .`      STR      r0,[r1,#0]
        0x01006106:    4770        pG      BX       lr
    $d
        0x01006108:    00805b21    ![..    DCD    8411937
        0x0100610c:    00800500    ....    DCD    8389888
    $t
    i.rwip_sleep_without_stack_init_replace
    rwip_sleep_without_stack_init_replace
        0x01006110:    4907        .I      LDR      r1,[pc,#28] ; [0x1006130] = 0x802480
        0x01006112:    4806        .H      LDR      r0,[pc,#24] ; [0x100612c] = 0x10033e9
        0x01006114:    6008        .`      STR      r0,[r1,#0]
        0x01006116:    4908        .I      LDR      r1,[pc,#32] ; [0x1006138] = 0x802468
        0x01006118:    4806        .H      LDR      r0,[pc,#24] ; [0x1006134] = 0x805abf
        0x0100611a:    6008        .`      STR      r0,[r1,#0]
        0x0100611c:    4908        .I      LDR      r1,[pc,#32] ; [0x1006140] = 0x802380
        0x0100611e:    4807        .H      LDR      r0,[pc,#28] ; [0x100613c] = 0x805aeb
        0x01006120:    6008        .`      STR      r0,[r1,#0]
        0x01006122:    4909        .I      LDR      r1,[pc,#36] ; [0x1006148] = 0x80239c
        0x01006124:    4807        .H      LDR      r0,[pc,#28] ; [0x1006144] = 0x805ad5
        0x01006126:    6008        .`      STR      r0,[r1,#0]
        0x01006128:    f7fdb900    ....    B        ble_core_init_without_stack_init ; 0x100332c
    $d
        0x0100612c:    010033e9    .3..    DCD    16790505
        0x01006130:    00802480    .$..    DCD    8397952
        0x01006134:    00805abf    .Z..    DCD    8411839
        0x01006138:    00802468    h$..    DCD    8397928
        0x0100613c:    00805aeb    .Z..    DCD    8411883
        0x01006140:    00802380    .#..    DCD    8397696
        0x01006144:    00805ad5    .Z..    DCD    8411861
        0x01006148:    0080239c    .#..    DCD    8397724
    $t
    i.sdk_init
    sdk_init
        0x0100614c:    b57f        ..      PUSH     {r0-r6,lr}
        0x0100614e:    2000        .       MOVS     r0,#0
        0x01006150:    9000        ..      STR      r0,[sp,#0]
        0x01006152:    9001        ..      STR      r0,[sp,#4]
        0x01006154:    9002        ..      STR      r0,[sp,#8]
        0x01006156:    9003        ..      STR      r0,[sp,#0xc]
        0x01006158:    2400        .$      MOVS     r4,#0
        0x0100615a:    4d12        .M      LDR      r5,[pc,#72] ; [0x10061a4] = 0x7e980
        0x0100615c:    4e12        .N      LDR      r6,[pc,#72] ; [0x10061a8] = 0x804000
        0x0100615e:    eb051004    ....    ADD      r0,r5,r4,LSL #4
        0x01006162:    e9d02305    ...#    LDRD     r2,r3,[r0,#0x14]
        0x01006166:    6901        .i      LDR      r1,[r0,#0x10]
        0x01006168:    69c0        .i      LDR      r0,[r0,#0x1c]
        0x0100616a:    e88d000e    ....    STM      sp,{r1-r3}
        0x0100616e:    9003        ..      STR      r0,[sp,#0xc]
        0x01006170:    9801        ..      LDR      r0,[sp,#4]
        0x01006172:    42b0        .B      CMP      r0,r6
        0x01006174:    d212        ..      BCS      0x100619c ; sdk_init + 80
        0x01006176:    490d        .I      LDR      r1,[pc,#52] ; [0x10061ac] = 0x62d04
        0x01006178:    9803        ..      LDR      r0,[sp,#0xc]
        0x0100617a:    4288        .B      CMP      r0,r1
        0x0100617c:    d105        ..      BNE      0x100618a ; sdk_init + 62
        0x0100617e:    e9dd0201    ....    LDRD     r0,r2,[sp,#4]
        0x01006182:    9900        ..      LDR      r1,[sp,#0]
        0x01006184:    f7fcf996    ....    BL       __aeabi_memcpy ; 0x10024b4
        0x01006188:    e008        ..      B        0x100619c ; sdk_init + 80
        0x0100618a:    4908        .I      LDR      r1,[pc,#32] ; [0x10061ac] = 0x62d04
        0x0100618c:    9803        ..      LDR      r0,[sp,#0xc]
        0x0100618e:    311c        .1      ADDS     r1,r1,#0x1c
        0x01006190:    4288        .B      CMP      r0,r1
        0x01006192:    d103        ..      BNE      0x100619c ; sdk_init + 80
        0x01006194:    e9dd0101    ....    LDRD     r0,r1,[sp,#4]
        0x01006198:    f7fcfa03    ....    BL       __aeabi_memclr ; 0x10025a2
        0x0100619c:    1c64        d.      ADDS     r4,r4,#1
        0x0100619e:    2c03        .,      CMP      r4,#3
        0x010061a0:    d3dd        ..      BCC      0x100615e ; sdk_init + 18
        0x010061a2:    bd7f        ..      POP      {r0-r6,pc}
    $d
        0x010061a4:    0007e980    ....    DCD    518528
        0x010061a8:    00804000    .@..    DCD    8404992
        0x010061ac:    00062d04    .-..    DCD    404740
    $t
    i.soc_init
    soc_init
        0x010061b0:    b510        ..      PUSH     {r4,lr}
        0x010061b2:    f000fd83    ....    BL       ultra_deep_sleep_wakeup_handle ; 0x1006cbc
        0x010061b6:    f7fff9b3    ....    BL       patch_init ; 0x1005520
        0x010061ba:    f000fcd5    ....    BL       tiny_rw_section_init ; 0x1006b68
        0x010061be:    f7fef8cb    ....    BL       hal_flash_init ; 0x1004358
        0x010061c2:    b150        P.      CBZ      r0,0x10061da ; soc_init + 42
        0x010061c4:    f7fff9e2    ....    BL       platform_flash_enable_quad ; 0x100558c
        0x010061c8:    f7fff9f0    ....    BL       platform_init ; 0x10055ac
        0x010061cc:    f7fef98e    ....    BL       hal_init ; 0x10044ec
        0x010061d0:    4802        .H      LDR      r0,[pc,#8] ; [0x10061dc] = 0x1002000
        0x010061d2:    6800        .h      LDR      r0,[r0,#0]
        0x010061d4:    4902        .I      LDR      r1,[pc,#8] ; [0x10061e0] = 0x30006400
        0x010061d6:    60c8        .`      STR      r0,[r1,#0xc]
        0x010061d8:    bd10        ..      POP      {r4,pc}
        0x010061da:    e7fe        ..      B        0x10061da ; soc_init + 42
    $d
        0x010061dc:    01002000    . ..    DCD    16785408
        0x010061e0:    30006400    .d.0    DCD    805331968
    $t
    i.soc_register_nvic
    soc_register_nvic
        0x010061e4:    4a02        .J      LDR      r2,[pc,#8] ; [0x10061f0] = 0x30006500
        0x010061e6:    3010        .0      ADDS     r0,r0,#0x10
        0x010061e8:    f8421020    B. .    STR      r1,[r2,r0,LSL #2]
        0x010061ec:    4770        pG      BX       lr
    $d
        0x010061ee:    0000        ..      DCW    0
        0x010061f0:    30006500    .e.0    DCD    805332224
    $t
    i.svc_user_handler
    svc_user_handler
        0x010061f4:    4802        .H      LDR      r0,[pc,#8] ; [0x1006200] = 0x30006400
        0x010061f6:    6840        @h      LDR      r0,[r0,#4]
        0x010061f8:    2800        .(      CMP      r0,#0
        0x010061fa:    d000        ..      BEQ      0x10061fe ; svc_user_handler + 10
        0x010061fc:    4700        .G      BX       r0
        0x010061fe:    4770        pG      BX       lr
    $d
        0x01006200:    30006400    .d.0    DCD    805331968
    $t
    i.sys_adc_trim_get
    sys_adc_trim_get
        0x01006204:    b570        p.      PUSH     {r4-r6,lr}
        0x01006206:    4604        .F      MOV      r4,r0
        0x01006208:    2c00        .,      CMP      r4,#0
        0x0100620a:    d005        ..      BEQ      0x1006218 ; sys_adc_trim_get + 20
        0x0100620c:    f000f8b0    ....    BL       sys_efuse_info_sync ; 0x1006370
        0x01006210:    4606        .F      MOV      r6,r0
        0x01006212:    0030        0.      MOVS     r0,r6
        0x01006214:    d002        ..      BEQ      0x100621c ; sys_adc_trim_get + 24
        0x01006216:    e050        P.      B        0x10062ba ; sys_adc_trim_get + 182
        0x01006218:    2002        .       MOVS     r0,#2
        0x0100621a:    bd70        p.      POP      {r4-r6,pc}
        0x0100621c:    4d28        (M      LDR      r5,[pc,#160] ; [0x10062c0] = 0x803212
        0x0100621e:    8c68        h.      LDRH     r0,[r5,#0x22]
        0x01006220:    8020         .      STRH     r0,[r4,#0]
        0x01006222:    8ca8        ..      LDRH     r0,[r5,#0x24]
        0x01006224:    8060        `.      STRH     r0,[r4,#2]
        0x01006226:    8ce8        ..      LDRH     r0,[r5,#0x26]
        0x01006228:    80a0        ..      STRH     r0,[r4,#4]
        0x0100622a:    7828        (x      LDRB     r0,[r5,#0]
        0x0100622c:    2813        .(      CMP      r0,#0x13
        0x0100622e:    d82a        *.      BHI      0x1006286 ; sys_adc_trim_get + 130
        0x01006230:    8ca8        ..      LDRH     r0,[r5,#0x24]
        0x01006232:    f001f9fe    ....    BL       __aeabi_ui2d ; 0x1007632
        0x01006236:    ed9f1b23    ..#.    VLDR     d1,[pc,#140] ; [0x10062c4] = 0xc532a498
        0x0100623a:    ec532b11    S..+    VMOV     r2,r3,d1
        0x0100623e:    f001f843    ..C.    BL       __aeabi_ddiv ; 0x10072c8
        0x01006242:    f001f9c9    ....    BL       __aeabi_d2uiz ; 0x10075d8
        0x01006246:    80e0        ..      STRH     r0,[r4,#6]
        0x01006248:    8ce8        ..      LDRH     r0,[r5,#0x26]
        0x0100624a:    8120         .      STRH     r0,[r4,#8]
        0x0100624c:    8ca8        ..      LDRH     r0,[r5,#0x24]
        0x0100624e:    f001f9f0    ....    BL       __aeabi_ui2d ; 0x1007632
        0x01006252:    ed9f1b1e    ....    VLDR     d1,[pc,#120] ; [0x10062cc] = 0x600f3450
        0x01006256:    ec532b11    S..+    VMOV     r2,r3,d1
        0x0100625a:    f001f835    ..5.    BL       __aeabi_ddiv ; 0x10072c8
        0x0100625e:    f001f9bb    ....    BL       __aeabi_d2uiz ; 0x10075d8
        0x01006262:    8160        `.      STRH     r0,[r4,#0xa]
        0x01006264:    8ce8        ..      LDRH     r0,[r5,#0x26]
        0x01006266:    81a0        ..      STRH     r0,[r4,#0xc]
        0x01006268:    8ca8        ..      LDRH     r0,[r5,#0x24]
        0x0100626a:    f001f9e2    ....    BL       __aeabi_ui2d ; 0x1007632
        0x0100626e:    ed9f1b19    ....    VLDR     d1,[pc,#100] ; [0x10062d4] = 0x6b37867f
        0x01006272:    ec532b11    S..+    VMOV     r2,r3,d1
        0x01006276:    f001f827    ..'.    BL       __aeabi_ddiv ; 0x10072c8
        0x0100627a:    f001f9ad    ....    BL       __aeabi_d2uiz ; 0x10075d8
        0x0100627e:    81e0        ..      STRH     r0,[r4,#0xe]
        0x01006280:    8ce8        ..      LDRH     r0,[r5,#0x26]
        0x01006282:    8220         .      STRH     r0,[r4,#0x10]
        0x01006284:    e015        ..      B        0x10062b2 ; sys_adc_trim_get + 174
        0x01006286:    89a8        ..      LDRH     r0,[r5,#0xc]
        0x01006288:    80e0        ..      STRH     r0,[r4,#6]
        0x0100628a:    8968        h.      LDRH     r0,[r5,#0xa]
        0x0100628c:    8120         .      STRH     r0,[r4,#8]
        0x0100628e:    8928        (.      LDRH     r0,[r5,#8]
        0x01006290:    8160        `.      STRH     r0,[r4,#0xa]
        0x01006292:    88e8        ..      LDRH     r0,[r5,#6]
        0x01006294:    81a0        ..      STRH     r0,[r4,#0xc]
        0x01006296:    8928        (.      LDRH     r0,[r5,#8]
        0x01006298:    f001f9cb    ....    BL       __aeabi_ui2d ; 0x1007632
        0x0100629c:    ed9f1b0f    ....    VLDR     d1,[pc,#60] ; [0x10062dc] = 0x2435696e
        0x010062a0:    ec532b11    S..+    VMOV     r2,r3,d1
        0x010062a4:    f001f810    ....    BL       __aeabi_ddiv ; 0x10072c8
        0x010062a8:    f001f996    ....    BL       __aeabi_d2uiz ; 0x10075d8
        0x010062ac:    81e0        ..      STRH     r0,[r4,#0xe]
        0x010062ae:    88e8        ..      LDRH     r0,[r5,#6]
        0x010062b0:    8220         .      STRH     r0,[r4,#0x10]
        0x010062b2:    8a28        (.      LDRH     r0,[r5,#0x10]
        0x010062b4:    8260        `.      STRH     r0,[r4,#0x12]
        0x010062b6:    89e8        ..      LDRH     r0,[r5,#0xe]
        0x010062b8:    82a0        ..      STRH     r0,[r4,#0x14]
        0x010062ba:    4630        0F      MOV      r0,r6
        0x010062bc:    bd70        p.      POP      {r4-r6,pc}
    $d
        0x010062be:    0000        ..      DCW    0
        0x010062c0:    00803212    .2..    DCD    8401426
        0x010062c4:    c532a498    ..2.    DCD    3308430488
        0x010062c8:    3ff7c41c    ...?    DCD    1073202204
        0x010062cc:    600f3450    P4.`    DCD    1611609168
        0x010062d0:    3ffd9f91    ...?    DCD    1073586065
        0x010062d4:    6b37867f    ..7k    DCD    1798801023
        0x010062d8:    40039ef0    ...@    DCD    1073979120
        0x010062dc:    2435696e    ni5$    DCD    607480174
        0x010062e0:    3ff531ee    .1.?    DCD    1073033710
    $t
    i.sys_crystal_trim_get
    sys_crystal_trim_get
        0x010062e4:    b510        ..      PUSH     {r4,lr}
        0x010062e6:    4604        .F      MOV      r4,r0
        0x010062e8:    2c00        .,      CMP      r4,#0
        0x010062ea:    d007        ..      BEQ      0x10062fc ; sys_crystal_trim_get + 24
        0x010062ec:    f000f840    ..@.    BL       sys_efuse_info_sync ; 0x1006370
        0x010062f0:    2800        .(      CMP      r0,#0
        0x010062f2:    d102        ..      BNE      0x10062fa ; sys_crystal_trim_get + 22
        0x010062f4:    4902        .I      LDR      r1,[pc,#8] ; [0x1006300] = 0x803212
        0x010062f6:    8b49        I.      LDRH     r1,[r1,#0x1a]
        0x010062f8:    8021        !.      STRH     r1,[r4,#0]
        0x010062fa:    bd10        ..      POP      {r4,pc}
        0x010062fc:    2002        .       MOVS     r0,#2
        0x010062fe:    bd10        ..      POP      {r4,pc}
    $d
        0x01006300:    00803212    .2..    DCD    8401426
    $t
    i.sys_device_addr_get
    sys_device_addr_get
        0x01006304:    b510        ..      PUSH     {r4,lr}
        0x01006306:    4604        .F      MOV      r4,r0
        0x01006308:    2c00        .,      CMP      r4,#0
        0x0100630a:    d009        ..      BEQ      0x1006320 ; sys_device_addr_get + 28
        0x0100630c:    f000f830    ..0.    BL       sys_efuse_info_sync ; 0x1006370
        0x01006310:    2800        .(      CMP      r0,#0
        0x01006312:    d104        ..      BNE      0x100631e ; sys_device_addr_get + 26
        0x01006314:    4903        .I      LDR      r1,[pc,#12] ; [0x1006324] = 0x803212
        0x01006316:    694a        Ji      LDR      r2,[r1,#0x14]
        0x01006318:    6022        "`      STR      r2,[r4,#0]
        0x0100631a:    8b09        ..      LDRH     r1,[r1,#0x18]
        0x0100631c:    80a1        ..      STRH     r1,[r4,#4]
        0x0100631e:    bd10        ..      POP      {r4,pc}
        0x01006320:    2002        .       MOVS     r0,#2
        0x01006322:    bd10        ..      POP      {r4,pc}
    $d
        0x01006324:    00803212    .2..    DCD    8401426
    $t
    i.sys_device_package_get
    sys_device_package_get
        0x01006328:    b510        ..      PUSH     {r4,lr}
        0x0100632a:    4604        .F      MOV      r4,r0
        0x0100632c:    2c00        .,      CMP      r4,#0
        0x0100632e:    d009        ..      BEQ      0x1006344 ; sys_device_package_get + 28
        0x01006330:    f000f81e    ....    BL       sys_efuse_info_sync ; 0x1006370
        0x01006334:    2800        .(      CMP      r0,#0
        0x01006336:    d104        ..      BNE      0x1006342 ; sys_device_package_get + 26
        0x01006338:    4903        .I      LDR      r1,[pc,#12] ; [0x1006348] = 0x803212
        0x0100633a:    7889        .x      LDRB     r1,[r1,#2]
        0x0100633c:    f001011f    ....    AND      r1,r1,#0x1f
        0x01006340:    7021        !p      STRB     r1,[r4,#0]
        0x01006342:    bd10        ..      POP      {r4,pc}
        0x01006344:    2002        .       MOVS     r0,#2
        0x01006346:    bd10        ..      POP      {r4,pc}
    $d
        0x01006348:    00803212    .2..    DCD    8401426
    $t
    i.sys_device_sram_get
    sys_device_sram_get
        0x0100634c:    b510        ..      PUSH     {r4,lr}
        0x0100634e:    4604        .F      MOV      r4,r0
        0x01006350:    2c00        .,      CMP      r4,#0
        0x01006352:    d008        ..      BEQ      0x1006366 ; sys_device_sram_get + 26
        0x01006354:    f000f80c    ....    BL       sys_efuse_info_sync ; 0x1006370
        0x01006358:    2800        .(      CMP      r0,#0
        0x0100635a:    d103        ..      BNE      0x1006364 ; sys_device_sram_get + 24
        0x0100635c:    4903        .I      LDR      r1,[pc,#12] ; [0x100636c] = 0x802384
        0x0100635e:    6809        .h      LDR      r1,[r1,#0]
        0x01006360:    0f89        ..      LSRS     r1,r1,#30
        0x01006362:    7021        !p      STRB     r1,[r4,#0]
        0x01006364:    bd10        ..      POP      {r4,pc}
        0x01006366:    2002        .       MOVS     r0,#2
        0x01006368:    bd10        ..      POP      {r4,pc}
    $d
        0x0100636a:    0000        ..      DCW    0
        0x0100636c:    00802384    .#..    DCD    8397700
    $t
    i.sys_efuse_info_sync
    sys_efuse_info_sync
        0x01006370:    e92d41ff    -..A    PUSH     {r0-r8,lr}
        0x01006374:    2400        .$      MOVS     r4,#0
        0x01006376:    2500        .%      MOVS     r5,#0
        0x01006378:    9500        ..      STR      r5,[sp,#0]
        0x0100637a:    9501        ..      STR      r5,[sp,#4]
        0x0100637c:    9502        ..      STR      r5,[sp,#8]
        0x0100637e:    9503        ..      STR      r5,[sp,#0xc]
        0x01006380:    4f2f        /O      LDR      r7,[pc,#188] ; [0x1006440] = 0x803212
        0x01006382:    f2447844    D.Dx    MOV      r8,#0x4744
        0x01006386:    8bb8        ..      LDRH     r0,[r7,#0x1c]
        0x01006388:    2800        .(      CMP      r0,#0
        0x0100638a:    d14f        O.      BNE      0x100642c ; sys_efuse_info_sync + 188
        0x0100638c:    9500        ..      STR      r5,[sp,#0]
        0x0100638e:    9501        ..      STR      r5,[sp,#4]
        0x01006390:    9502        ..      STR      r5,[sp,#8]
        0x01006392:    9503        ..      STR      r5,[sp,#0xc]
        0x01006394:    482b        +H      LDR      r0,[pc,#172] ; [0x1006444] = 0xa0016400
        0x01006396:    9000        ..      STR      r0,[sp,#0]
        0x01006398:    2001        .       MOVS     r0,#1
        0x0100639a:    9001        ..      STR      r0,[sp,#4]
        0x0100639c:    4668        hF      MOV      r0,sp
        0x0100639e:    f7fdff31    ..1.    BL       hal_efuse_deinit_ext ; 0x1004204
        0x010063a2:    4668        hF      MOV      r0,sp
        0x010063a4:    f7fdff74    ..t.    BL       hal_efuse_init_ext ; 0x1004290
        0x010063a8:    230f        .#      MOVS     r3,#0xf
        0x010063aa:    463a        :F      MOV      r2,r7
        0x010063ac:    2144        D!      MOVS     r1,#0x44
        0x010063ae:    4668        hF      MOV      r0,sp
        0x010063b0:    f412d526    ..&.    BL       hal_efuse_read ; 0x18e00
        0x010063b4:    2301        .#      MOVS     r3,#1
        0x010063b6:    4a24        $J      LDR      r2,[pc,#144] ; [0x1006448] = 0x802384
        0x010063b8:    2153        S!      MOVS     r1,#0x53
        0x010063ba:    4668        hF      MOV      r0,sp
        0x010063bc:    f412d520    .. .    BL       hal_efuse_read ; 0x18e00
        0x010063c0:    4668        hF      MOV      r0,sp
        0x010063c2:    f7fdff1f    ....    BL       hal_efuse_deinit_ext ; 0x1004204
        0x010063c6:    7838        8x      LDRB     r0,[r7,#0]
        0x010063c8:    f64f72ff    O..r    MOV      r2,#0xffff
        0x010063cc:    b1e0        ..      CBZ      r0,0x1006408 ; sys_efuse_info_sync + 152
        0x010063ce:    8bb8        ..      LDRH     r0,[r7,#0x1c]
        0x010063d0:    4540        @E      CMP      r0,r8
        0x010063d2:    d12a        *.      BNE      0x100642a ; sys_efuse_info_sync + 186
        0x010063d4:    1cbe        ..      ADDS     r6,r7,#2
        0x010063d6:    2000        .       MOVS     r0,#0
        0x010063d8:    f8361010    6...    LDRH     r1,[r6,r0,LSL #1]
        0x010063dc:    4421        !D      ADD      r1,r1,r4
        0x010063de:    b28c        ..      UXTH     r4,r1
        0x010063e0:    1c40        @.      ADDS     r0,r0,#1
        0x010063e2:    b280        ..      UXTH     r0,r0
        0x010063e4:    2809        .(      CMP      r0,#9
        0x010063e6:    d3f7        ..      BCC      0x10063d8 ; sys_efuse_info_sync + 104
        0x010063e8:    4915        .I      LDR      r1,[pc,#84] ; [0x1006440] = 0x803212
        0x010063ea:    3120         1      ADDS     r1,r1,#0x20
        0x010063ec:    2000        .       MOVS     r0,#0
        0x010063ee:    f8313010    1..0    LDRH     r3,[r1,r0,LSL #1]
        0x010063f2:    4423        #D      ADD      r3,r3,r4
        0x010063f4:    b29c        ..      UXTH     r4,r3
        0x010063f6:    1c40        @.      ADDS     r0,r0,#1
        0x010063f8:    b280        ..      UXTH     r0,r0
        0x010063fa:    2806        .(      CMP      r0,#6
        0x010063fc:    d3f7        ..      BCC      0x10063ee ; sys_efuse_info_sync + 126
        0x010063fe:    8bf8        ..      LDRH     r0,[r7,#0x1e]
        0x01006400:    42a0        .B      CMP      r0,r4
        0x01006402:    d013        ..      BEQ      0x100642c ; sys_efuse_info_sync + 188
        0x01006404:    83ba        ..      STRH     r2,[r7,#0x1c]
        0x01006406:    e011        ..      B        0x100642c ; sys_efuse_info_sync + 188
        0x01006408:    f8970028    ..(.    LDRB     r0,[r7,#0x28]
        0x0100640c:    b940        @.      CBNZ     r0,0x1006420 ; sys_efuse_info_sync + 176
        0x0100640e:    f8970029    ..).    LDRB     r0,[r7,#0x29]
        0x01006412:    b928        (.      CBNZ     r0,0x1006420 ; sys_efuse_info_sync + 176
        0x01006414:    f897002a    ..*.    LDRB     r0,[r7,#0x2a]
        0x01006418:    b910        ..      CBNZ     r0,0x1006420 ; sys_efuse_info_sync + 176
        0x0100641a:    f897002b    ..+.    LDRB     r0,[r7,#0x2b]
        0x0100641e:    b110        ..      CBZ      r0,0x1006426 ; sys_efuse_info_sync + 182
        0x01006420:    f8a7801c    ....    STRH     r8,[r7,#0x1c]
        0x01006424:    e002        ..      B        0x100642c ; sys_efuse_info_sync + 188
        0x01006426:    83ba        ..      STRH     r2,[r7,#0x1c]
        0x01006428:    e000        ..      B        0x100642c ; sys_efuse_info_sync + 188
        0x0100642a:    83ba        ..      STRH     r2,[r7,#0x1c]
        0x0100642c:    8bb8        ..      LDRH     r0,[r7,#0x1c]
        0x0100642e:    4540        @E      CMP      r0,r8
        0x01006430:    d103        ..      BNE      0x100643a ; sys_efuse_info_sync + 202
        0x01006432:    2000        .       MOVS     r0,#0
        0x01006434:    b004        ..      ADD      sp,sp,#0x10
        0x01006436:    e8bd81f0    ....    POP      {r4-r8,pc}
        0x0100643a:    83bd        ..      STRH     r5,[r7,#0x1c]
        0x0100643c:    2010        .       MOVS     r0,#0x10
        0x0100643e:    e7f9        ..      B        0x1006434 ; sys_efuse_info_sync + 196
    $d
        0x01006440:    00803212    .2..    DCD    8401426
        0x01006444:    a0016400    .d..    DCD    2684445696
        0x01006448:    00802384    .#..    DCD    8397700
    $t
    i.sys_get_efuse_io_ldo
    sys_get_efuse_io_ldo
        0x0100644c:    b530        0.      PUSH     {r4,r5,lr}
        0x0100644e:    b087        ..      SUB      sp,sp,#0x1c
        0x01006450:    4605        .F      MOV      r5,r0
        0x01006452:    2d00        .-      CMP      r5,#0
        0x01006454:    d00c        ..      BEQ      0x1006470 ; sys_get_efuse_io_ldo + 36
        0x01006456:    2400        .$      MOVS     r4,#0
        0x01006458:    802c        ,.      STRH     r4,[r5,#0]
        0x0100645a:    f7ffff89    ....    BL       sys_efuse_info_sync ; 0x1006370
        0x0100645e:    2800        .(      CMP      r0,#0
        0x01006460:    d104        ..      BNE      0x100646c ; sys_get_efuse_io_ldo + 32
        0x01006462:    4815        .H      LDR      r0,[pc,#84] ; [0x10064b8] = 0x803212
        0x01006464:    7800        .x      LDRB     r0,[r0,#0]
        0x01006466:    2890        .(      CMP      r0,#0x90
        0x01006468:    d004        ..      BEQ      0x1006474 ; sys_get_efuse_io_ldo + 40
        0x0100646a:    2001        .       MOVS     r0,#1
        0x0100646c:    b007        ..      ADD      sp,sp,#0x1c
        0x0100646e:    bd30        0.      POP      {r4,r5,pc}
        0x01006470:    2002        .       MOVS     r0,#2
        0x01006472:    e7fb        ..      B        0x100646c ; sys_get_efuse_io_ldo + 32
        0x01006474:    9403        ..      STR      r4,[sp,#0xc]
        0x01006476:    9404        ..      STR      r4,[sp,#0x10]
        0x01006478:    9405        ..      STR      r4,[sp,#0x14]
        0x0100647a:    9406        ..      STR      r4,[sp,#0x18]
        0x0100647c:    9401        ..      STR      r4,[sp,#4]
        0x0100647e:    9402        ..      STR      r4,[sp,#8]
        0x01006480:    480e        .H      LDR      r0,[pc,#56] ; [0x10064bc] = 0xa0016400
        0x01006482:    9003        ..      STR      r0,[sp,#0xc]
        0x01006484:    2001        .       MOVS     r0,#1
        0x01006486:    9004        ..      STR      r0,[sp,#0x10]
        0x01006488:    a803        ..      ADD      r0,sp,#0xc
        0x0100648a:    f46fd45f    o._.    BL       hal_efuse_deinit ; 0x75d4c
        0x0100648e:    a803        ..      ADD      r0,sp,#0xc
        0x01006490:    f46fd468    o.h.    BL       hal_efuse_init ; 0x75d64
        0x01006494:    2302        .#      MOVS     r3,#2
        0x01006496:    aa01        ..      ADD      r2,sp,#4
        0x01006498:    2156        V!      MOVS     r1,#0x56
        0x0100649a:    a803        ..      ADD      r0,sp,#0xc
        0x0100649c:    f412d4b0    ....    BL       hal_efuse_read ; 0x18e00
        0x010064a0:    a803        ..      ADD      r0,sp,#0xc
        0x010064a2:    f46fd453    o.S.    BL       hal_efuse_deinit ; 0x75d4c
        0x010064a6:    f89d000a    ....    LDRB     r0,[sp,#0xa]
        0x010064aa:    f89d100b    ....    LDRB     r1,[sp,#0xb]
        0x010064ae:    ea402001    @..     ORR      r0,r0,r1,LSL #8
        0x010064b2:    8028        (.      STRH     r0,[r5,#0]
        0x010064b4:    4620         F      MOV      r0,r4
        0x010064b6:    e7d9        ..      B        0x100646c ; sys_get_efuse_io_ldo + 32
    $d
        0x010064b8:    00803212    .2..    DCD    8401426
        0x010064bc:    a0016400    .d..    DCD    2684445696
    $t
    i.sys_is_use_ext_flash
    sys_is_use_ext_flash
        0x010064c0:    b508        ..      PUSH     {r3,lr}
        0x010064c2:    2000        .       MOVS     r0,#0
        0x010064c4:    9000        ..      STR      r0,[sp,#0]
        0x010064c6:    4668        hF      MOV      r0,sp
        0x010064c8:    f7ffff2e    ....    BL       sys_device_package_get ; 0x1006328
        0x010064cc:    480b        .H      LDR      r0,[pc,#44] ; [0x10064fc] = 0x803212
        0x010064ce:    7841        Ax      LDRB     r1,[r0,#1]
        0x010064d0:    f0010201    ....    AND      r2,r1,#1
        0x010064d4:    7800        .x      LDRB     r0,[r0,#0]
        0x010064d6:    2891        .(      CMP      r0,#0x91
        0x010064d8:    d201        ..      BCS      0x10064de ; sys_is_use_ext_flash + 30
        0x010064da:    2101        .!      MOVS     r1,#1
        0x010064dc:    e000        ..      B        0x10064e0 ; sys_is_use_ext_flash + 32
        0x010064de:    2100        .!      MOVS     r1,#0
        0x010064e0:    f89d0000    ....    LDRB     r0,[sp,#0]
        0x010064e4:    2804        .(      CMP      r0,#4
        0x010064e6:    d005        ..      BEQ      0x10064f4 ; sys_is_use_ext_flash + 52
        0x010064e8:    2808        .(      CMP      r0,#8
        0x010064ea:    d003        ..      BEQ      0x10064f4 ; sys_is_use_ext_flash + 52
        0x010064ec:    4211        .B      TST      r1,r2
        0x010064ee:    d003        ..      BEQ      0x10064f8 ; sys_is_use_ext_flash + 56
        0x010064f0:    2807        .(      CMP      r0,#7
        0x010064f2:    d001        ..      BEQ      0x10064f8 ; sys_is_use_ext_flash + 56
        0x010064f4:    2001        .       MOVS     r0,#1
        0x010064f6:    bd08        ..      POP      {r3,pc}
        0x010064f8:    2000        .       MOVS     r0,#0
        0x010064fa:    bd08        ..      POP      {r3,pc}
    $d
        0x010064fc:    00803212    .2..    DCD    8401426
    $t
    i.sys_is_use_internal_3p3_ioldo
    sys_is_use_internal_3p3_ioldo
        0x01006500:    b508        ..      PUSH     {r3,lr}
        0x01006502:    2000        .       MOVS     r0,#0
        0x01006504:    9000        ..      STR      r0,[sp,#0]
        0x01006506:    4668        hF      MOV      r0,sp
        0x01006508:    f7ffff0e    ....    BL       sys_device_package_get ; 0x1006328
        0x0100650c:    4805        .H      LDR      r0,[pc,#20] ; [0x1006524] = 0x803212
        0x0100650e:    7840        @x      LDRB     r0,[r0,#1]
        0x01006510:    f0000101    ....    AND      r1,r0,#1
        0x01006514:    f3c000c0    ....    UBFX     r0,r0,#3,#1
        0x01006518:    b101        ..      CBZ      r1,0x100651c ; sys_is_use_internal_3p3_ioldo + 28
        0x0100651a:    b108        ..      CBZ      r0,0x1006520 ; sys_is_use_internal_3p3_ioldo + 32
        0x0100651c:    2000        .       MOVS     r0,#0
        0x0100651e:    bd08        ..      POP      {r3,pc}
        0x01006520:    2001        .       MOVS     r0,#1
        0x01006522:    bd08        ..      POP      {r3,pc}
    $d
        0x01006524:    00803212    .2..    DCD    8401426
    $t
    i.sys_pmu_trim_get
    sys_pmu_trim_get
        0x01006528:    b510        ..      PUSH     {r4,lr}
        0x0100652a:    4604        .F      MOV      r4,r0
        0x0100652c:    2c00        .,      CMP      r4,#0
        0x0100652e:    d004        ..      BEQ      0x100653a ; sys_pmu_trim_get + 18
        0x01006530:    f7ffff1e    ....    BL       sys_efuse_info_sync ; 0x1006370
        0x01006534:    4601        .F      MOV      r1,r0
        0x01006536:    b111        ..      CBZ      r1,0x100653e ; sys_pmu_trim_get + 22
        0x01006538:    e034        4.      B        0x10065a4 ; sys_pmu_trim_get + 124
        0x0100653a:    2002        .       MOVS     r0,#2
        0x0100653c:    bd10        ..      POP      {r4,pc}
        0x0100653e:    4a1a        .J      LDR      r2,[pc,#104] ; [0x10065a8] = 0x803212
        0x01006540:    7850        Px      LDRB     r0,[r2,#1]
        0x01006542:    f3c00040    ..@.    UBFX     r0,r0,#1,#1
        0x01006546:    7020         p      STRB     r0,[r4,#0]
        0x01006548:    7850        Px      LDRB     r0,[r2,#1]
        0x0100654a:    07c0        ..      LSLS     r0,r0,#31
        0x0100654c:    d002        ..      BEQ      0x1006554 ; sys_pmu_trim_get + 44
        0x0100654e:    7c90        .|      LDRB     r0,[r2,#0x12]
        0x01006550:    7060        `p      STRB     r0,[r4,#1]
        0x01006552:    e002        ..      B        0x100655a ; sys_pmu_trim_get + 50
        0x01006554:    f8920028    ..(.    LDRB     r0,[r2,#0x28]
        0x01006558:    7060        `p      STRB     r0,[r4,#1]
        0x0100655a:    f8920029    ..).    LDRB     r0,[r2,#0x29]
        0x0100655e:    0603        ..      LSLS     r3,r0,#24
        0x01006560:    d506        ..      BPL      0x1006570 ; sys_pmu_trim_get + 72
        0x01006562:    f000031f    ....    AND      r3,r0,#0x1f
        0x01006566:    f3c01041    ..A.    UBFX     r0,r0,#5,#2
        0x0100656a:    1a18        ..      SUBS     r0,r3,r0
        0x0100656c:    70a0        .p      STRB     r0,[r4,#2]
        0x0100656e:    e005        ..      B        0x100657c ; sys_pmu_trim_get + 84
        0x01006570:    f000031f    ....    AND      r3,r0,#0x1f
        0x01006574:    f3c01041    ..A.    UBFX     r0,r0,#5,#2
        0x01006578:    4418        .D      ADD      r0,r0,r3
        0x0100657a:    70a0        .p      STRB     r0,[r4,#2]
        0x0100657c:    f892002a    ..*.    LDRB     r0,[r2,#0x2a]
        0x01006580:    0603        ..      LSLS     r3,r0,#24
        0x01006582:    d506        ..      BPL      0x1006592 ; sys_pmu_trim_get + 106
        0x01006584:    f000031f    ....    AND      r3,r0,#0x1f
        0x01006588:    f3c01041    ..A.    UBFX     r0,r0,#5,#2
        0x0100658c:    1a18        ..      SUBS     r0,r3,r0
        0x0100658e:    70e0        .p      STRB     r0,[r4,#3]
        0x01006590:    e005        ..      B        0x100659e ; sys_pmu_trim_get + 118
        0x01006592:    f000031f    ....    AND      r3,r0,#0x1f
        0x01006596:    f3c01041    ..A.    UBFX     r0,r0,#5,#2
        0x0100659a:    4418        .D      ADD      r0,r0,r3
        0x0100659c:    70e0        .p      STRB     r0,[r4,#3]
        0x0100659e:    f892002b    ..+.    LDRB     r0,[r2,#0x2b]
        0x010065a2:    7120         q      STRB     r0,[r4,#4]
        0x010065a4:    4608        .F      MOV      r0,r1
        0x010065a6:    bd10        ..      POP      {r4,pc}
    $d
        0x010065a8:    00803212    .2..    DCD    8401426
    $t
    i.system_clk_mgmt_init
    system_clk_mgmt_init
        0x010065ac:    480a        .H      LDR      r0,[pc,#40] ; [0x10065d8] = 0xa000e280
        0x010065ae:    2100        .!      MOVS     r1,#0
        0x010065b0:    6001        .`      STR      r1,[r0,#0]
        0x010065b2:    f64052eb    @..R    MOV      r2,#0xdeb
        0x010065b6:    6202        .b      STR      r2,[r0,#0x20]
        0x010065b8:    f64042ab    @..B    MOV      r2,#0xcab
        0x010065bc:    6242        Bb      STR      r2,[r0,#0x24]
        0x010065be:    2207        ."      MOVS     r2,#7
        0x010065c0:    6282        .b      STR      r2,[r0,#0x28]
        0x010065c2:    4a06        .J      LDR      r2,[pc,#24] ; [0x10065dc] = 0x701ff04
        0x010065c4:    62c2        .b      STR      r2,[r0,#0x2c]
        0x010065c6:    6301        .c      STR      r1,[r0,#0x30]
        0x010065c8:    4905        .I      LDR      r1,[pc,#20] ; [0x10065e0] = 0xa000d000
        0x010065ca:    680a        .h      LDR      r2,[r1,#0]
        0x010065cc:    f44262f0    B..b    ORR      r2,r2,#0x780
        0x010065d0:    600a        .`      STR      r2,[r1,#0]
        0x010065d2:    2102        .!      MOVS     r1,#2
        0x010065d4:    6401        .d      STR      r1,[r0,#0x40]
        0x010065d6:    4770        pG      BX       lr
    $d
        0x010065d8:    a000e280    ....    DCD    2684412544
        0x010065dc:    0701ff04    ....    DCD    117571332
        0x010065e0:    a000d000    ....    DCD    2684407808
    $t
    i.system_conf_correction
    system_conf_correction
        0x010065e4:    f000bbca    ....    B.W      warm_boot_cfg_patch ; 0x1006d7c
    i.system_driver_patch_enable
    system_driver_patch_enable
        0x010065e8:    b510        ..      PUSH     {r4,lr}
        0x010065ea:    4905        .I      LDR      r1,[pc,#20] ; [0x1006600] = 0x8052ff
        0x010065ec:    4805        .H      LDR      r0,[pc,#20] ; [0x1006604] = 0x190f9
        0x010065ee:    f7fdfc85    ....    BL       gr5xx_fpb_func_register ; 0x1003efc
        0x010065f2:    e8bd4010    ...@    POP      {r4,lr}
        0x010065f6:    4904        .I      LDR      r1,[pc,#16] ; [0x1006608] = 0x8050eb
        0x010065f8:    4804        .H      LDR      r0,[pc,#16] ; [0x100660c] = 0x1976d
        0x010065fa:    f7fdbc7f    ....    B        gr5xx_fpb_func_register ; 0x1003efc
    $d
        0x010065fe:    0000        ..      DCW    0
        0x01006600:    008052ff    .R..    DCD    8409855
        0x01006604:    000190f9    ....    DCD    102649
        0x01006608:    008050eb    .P..    DCD    8409323
        0x0100660c:    0001976d    m...    DCD    104301
    $t
    i.system_low_power_set
    system_low_power_set
        0x01006610:    b570        p.      PUSH     {r4-r6,lr}
        0x01006612:    f04f5040    O.@P    MOV      r0,#0x30000000
        0x01006616:    6a41        Aj      LDR      r1,[r0,#0x24]
        0x01006618:    f0410110    A...    ORR      r1,r1,#0x10
        0x0100661c:    6241        Ab      STR      r1,[r0,#0x24]
        0x0100661e:    4831        1H      LDR      r0,[pc,#196] ; [0x10066e4] = 0xa000c558
        0x01006620:    6801        .h      LDR      r1,[r0,#0]
        0x01006622:    f001417f    ...A    AND      r1,r1,#0xff000000
        0x01006626:    6001        .`      STR      r1,[r0,#0]
        0x01006628:    492e        .I      LDR      r1,[pc,#184] ; [0x10066e4] = 0xa000c558
        0x0100662a:    2000        .       MOVS     r0,#0
        0x0100662c:    3914        .9      SUBS     r1,r1,#0x14
        0x0100662e:    6008        .`      STR      r0,[r1,#0]
        0x01006630:    4d2c        ,M      LDR      r5,[pc,#176] ; [0x10066e4] = 0xa000c558
        0x01006632:    1f2d        -.      SUBS     r5,r5,#4
        0x01006634:    6828        (h      LDR      r0,[r5,#0]
        0x01006636:    f42000fe     ...    BIC      r0,r0,#0x7f0000
        0x0100663a:    f440107c    @.|.    ORR      r0,r0,#0x3f0000
        0x0100663e:    6028        (`      STR      r0,[r5,#0]
        0x01006640:    4c28        (L      LDR      r4,[pc,#160] ; [0x10066e4] = 0xa000c558
        0x01006642:    3c4c        L<      SUBS     r4,r4,#0x4c
        0x01006644:    6820         h      LDR      r0,[r4,#0]
        0x01006646:    4e28        (N      LDR      r6,[pc,#160] ; [0x10066e8] = 0xff0000ff
        0x01006648:    4928        (I      LDR      r1,[pc,#160] ; [0x10066ec] = 0xbf700
        0x0100664a:    4030        0@      ANDS     r0,r0,r6
        0x0100664c:    4308        .C      ORRS     r0,r0,r1
        0x0100664e:    6020         `      STR      r0,[r4,#0]
        0x01006650:    2064        d       MOVS     r0,#0x64
        0x01006652:    f475d2d4    u...    BL       sys_delay_us ; 0x7bbfe
        0x01006656:    6820         h      LDR      r0,[r4,#0]
        0x01006658:    4925        %I      LDR      r1,[pc,#148] ; [0x10066f0] = 0xbef00
        0x0100665a:    4030        0@      ANDS     r0,r0,r6
        0x0100665c:    4308        .C      ORRS     r0,r0,r1
        0x0100665e:    6020         `      STR      r0,[r4,#0]
        0x01006660:    2064        d       MOVS     r0,#0x64
        0x01006662:    f475d2cc    u...    BL       sys_delay_us ; 0x7bbfe
        0x01006666:    6820         h      LDR      r0,[r4,#0]
        0x01006668:    4922        "I      LDR      r1,[pc,#136] ; [0x10066f4] = 0xbfa00
        0x0100666a:    4030        0@      ANDS     r0,r0,r6
        0x0100666c:    4308        .C      ORRS     r0,r0,r1
        0x0100666e:    6020         `      STR      r0,[r4,#0]
        0x01006670:    481c        .H      LDR      r0,[pc,#112] ; [0x10066e4] = 0xa000c558
        0x01006672:    3838        88      SUBS     r0,r0,#0x38
        0x01006674:    6801        .h      LDR      r1,[r0,#0]
        0x01006676:    f0417140    A.@q    ORR      r1,r1,#0x3000000
        0x0100667a:    6001        .`      STR      r1,[r0,#0]
        0x0100667c:    2064        d       MOVS     r0,#0x64
        0x0100667e:    f475d2be    u...    BL       sys_delay_us ; 0x7bbfe
        0x01006682:    6820         h      LDR      r0,[r4,#0]
        0x01006684:    491c        .I      LDR      r1,[pc,#112] ; [0x10066f8] = 0x3fa00
        0x01006686:    4030        0@      ANDS     r0,r0,r6
        0x01006688:    4308        .C      ORRS     r0,r0,r1
        0x0100668a:    6020         `      STR      r0,[r4,#0]
        0x0100668c:    6820         h      LDR      r0,[r4,#0]
        0x0100668e:    f04000f0    @...    ORR      r0,r0,#0xf0
        0x01006692:    6020         `      STR      r0,[r4,#0]
        0x01006694:    6828        (h      LDR      r0,[r5,#0]
        0x01006696:    f4406070    @.p`    ORR      r0,r0,#0xf00
        0x0100669a:    6028        (`      STR      r0,[r5,#0]
        0x0100669c:    4911        .I      LDR      r1,[pc,#68] ; [0x10066e4] = 0xa000c558
        0x0100669e:    3934        49      SUBS     r1,r1,#0x34
        0x010066a0:    6808        .h      LDR      r0,[r1,#0]
        0x010066a2:    f4204270     .pB    BIC      r2,r0,#0xf000
        0x010066a6:    4815        .H      LDR      r0,[pc,#84] ; [0x10066fc] = 0x30006814
        0x010066a8:    7a43        Cz      LDRB     r3,[r0,#9]
        0x010066aa:    ea423203    B..2    ORR      r2,r2,r3,LSL #12
        0x010066ae:    600a        .`      STR      r2,[r1,#0]
        0x010066b0:    1d21        !.      ADDS     r1,r4,#4
        0x010066b2:    680a        .h      LDR      r2,[r1,#0]
        0x010066b4:    f4424280    B..B    ORR      r2,r2,#0x4000
        0x010066b8:    600a        .`      STR      r2,[r1,#0]
        0x010066ba:    7a01        .z      LDRB     r1,[r0,#8]
        0x010066bc:    79c2        .y      LDRB     r2,[r0,#7]
        0x010066be:    0609        ..      LSLS     r1,r1,#24
        0x010066c0:    ea414102    A..A    ORR      r1,r1,r2,LSL #16
        0x010066c4:    7982        .y      LDRB     r2,[r0,#6]
        0x010066c6:    7940        @y      LDRB     r0,[r0,#5]
        0x010066c8:    ea412102    A..!    ORR      r1,r1,r2,LSL #8
        0x010066cc:    4301        .C      ORRS     r1,r1,r0
        0x010066ce:    4805        .H      LDR      r0,[pc,#20] ; [0x10066e4] = 0xa000c558
        0x010066d0:    3810        .8      SUBS     r0,r0,#0x10
        0x010066d2:    6001        .`      STR      r1,[r0,#0]
        0x010066d4:    4803        .H      LDR      r0,[pc,#12] ; [0x10066e4] = 0xa000c558
        0x010066d6:    3854        T8      SUBS     r0,r0,#0x54
        0x010066d8:    6801        .h      LDR      r1,[r0,#0]
        0x010066da:    f4411100    A...    ORR      r1,r1,#0x200000
        0x010066de:    6001        .`      STR      r1,[r0,#0]
        0x010066e0:    bd70        p.      POP      {r4-r6,pc}
    $d
        0x010066e2:    0000        ..      DCW    0
        0x010066e4:    a000c558    X...    DCD    2684405080
        0x010066e8:    ff0000ff    ....    DCD    4278190335
        0x010066ec:    000bf700    ....    DCD    784128
        0x010066f0:    000bef00    ....    DCD    782080
        0x010066f4:    000bfa00    ....    DCD    784896
        0x010066f8:    0003fa00    ....    DCD    260608
        0x010066fc:    30006814    .h.0    DCD    805333012
    $t
    i.system_platform_init
    system_platform_init
        0x01006700:    b510        ..      PUSH     {r4,lr}
        0x01006702:    f000fb0d    ....    BL       vector_table_init ; 0x1006d20
        0x01006706:    f7fffd21    ..!.    BL       sdk_init ; 0x100614c
        0x0100670a:    e8bd4010    ...@    POP      {r4,lr}
        0x0100670e:    f7ffbd4f    ..O.    B.W      soc_init ; 0x10061b0
    i.system_pmu_deinit
    system_pmu_deinit
        0x01006712:    b510        ..      PUSH     {r4,lr}
        0x01006714:    2000        .       MOVS     r0,#0
        0x01006716:    f000f801    ....    BL       system_pmu_init ; 0x100671c
        0x0100671a:    bd10        ..      POP      {r4,pc}
    i.system_pmu_init
    system_pmu_init
        0x0100671c:    e92d41fc    -..A    PUSH     {r2-r8,lr}
        0x01006720:    2415        .$      MOVS     r4,#0x15
        0x01006722:    260e        .&      MOVS     r6,#0xe
        0x01006724:    2507        .%      MOVS     r5,#7
        0x01006726:    4831        1H      LDR      r0,[pc,#196] ; [0x10067ec] = 0xa000e220
        0x01006728:    6801        .h      LDR      r1,[r0,#0]
        0x0100672a:    f4216170    !.pa    BIC      r1,r1,#0xf00
        0x0100672e:    f4417140    A.@q    ORR      r1,r1,#0x300
        0x01006732:    6001        .`      STR      r1,[r0,#0]
        0x01006734:    2000        .       MOVS     r0,#0
        0x01006736:    9000        ..      STR      r0,[sp,#0]
        0x01006738:    9001        ..      STR      r0,[sp,#4]
        0x0100673a:    4668        hF      MOV      r0,sp
        0x0100673c:    f7fffef4    ....    BL       sys_pmu_trim_get ; 0x1006528
        0x01006740:    4f2b        +O      LDR      r7,[pc,#172] ; [0x10067f0] = 0x803212
        0x01006742:    b9a8        ..      CBNZ     r0,0x1006770 ; system_pmu_init + 84
        0x01006744:    f7fffedc    ....    BL       sys_is_use_internal_3p3_ioldo ; 0x1006500
        0x01006748:    b118        ..      CBZ      r0,0x1006752 ; system_pmu_init + 54
        0x0100674a:    f7fef82d    ..-.    BL       i0nd_ioldo_3v_get ; 0x10047a8
        0x0100674e:    4605        .F      MOV      r5,r0
        0x01006750:    e004        ..      B        0x100675c ; system_pmu_init + 64
        0x01006752:    f8970028    ..(.    LDRB     r0,[r7,#0x28]
        0x01006756:    f000057f    ....    AND      r5,r0,#0x7f
        0x0100675a:    3508        .5      ADDS     r5,r5,#8
        0x0100675c:    f89d0004    ....    LDRB     r0,[sp,#4]
        0x01006760:    b130        0.      CBZ      r0,0x1006770 ; system_pmu_init + 84
        0x01006762:    f89d1002    ....    LDRB     r1,[sp,#2]
        0x01006766:    b119        ..      CBZ      r1,0x1006770 ; system_pmu_init + 84
        0x01006768:    f000041f    ....    AND      r4,r0,#0x1f
        0x0100676c:    f001061f    ....    AND      r6,r1,#0x1f
        0x01006770:    7878        xx      LDRB     r0,[r7,#1]
        0x01006772:    f3c000c0    ....    UBFX     r0,r0,#3,#1
        0x01006776:    b140        @.      CBZ      r0,0x100678a ; system_pmu_init + 110
        0x01006778:    481e        .H      LDR      r0,[pc,#120] ; [0x10067f4] = 0xa000c554
        0x0100677a:    6801        .h      LDR      r1,[r0,#0]
        0x0100677c:    f4410180    A...    ORR      r1,r1,#0x400000
        0x01006780:    6001        .`      STR      r1,[r0,#0]
        0x01006782:    f8970028    ..(.    LDRB     r0,[r7,#0x28]
        0x01006786:    f000057f    ....    AND      r5,r0,#0x7f
        0x0100678a:    481a        .H      LDR      r0,[pc,#104] ; [0x10067f4] = 0xa000c554
        0x0100678c:    3848        H8      SUBS     r0,r0,#0x48
        0x0100678e:    6801        .h      LDR      r1,[r0,#0]
        0x01006790:    f02141fe    !..A    BIC      r1,r1,#0x7f000000
        0x01006794:    ea416105    A..a    ORR      r1,r1,r5,LSL #24
        0x01006798:    6001        .`      STR      r1,[r0,#0]
        0x0100679a:    4816        .H      LDR      r0,[pc,#88] ; [0x10067f4] = 0xa000c554
        0x0100679c:    3834        48      SUBS     r0,r0,#0x34
        0x0100679e:    6801        .h      LDR      r1,[r0,#0]
        0x010067a0:    f0216180    !..a    BIC      r1,r1,#0x4000000
        0x010067a4:    6001        .`      STR      r1,[r0,#0]
        0x010067a6:    1d36        6.      ADDS     r6,r6,#4
        0x010067a8:    2e1f        ..      CMP      r6,#0x1f
        0x010067aa:    d300        ..      BCC      0x10067ae ; system_pmu_init + 146
        0x010067ac:    261f        .&      MOVS     r6,#0x1f
        0x010067ae:    2c06        .,      CMP      r4,#6
        0x010067b0:    d901        ..      BLS      0x10067b6 ; system_pmu_init + 154
        0x010067b2:    1fa4        ..      SUBS     r4,r4,#6
        0x010067b4:    e000        ..      B        0x10067b8 ; system_pmu_init + 156
        0x010067b6:    2400        .$      MOVS     r4,#0
        0x010067b8:    480f        .H      LDR      r0,[pc,#60] ; [0x10067f8] = 0x30006814
        0x010067ba:    72c4        .r      STRB     r4,[r0,#0xb]
        0x010067bc:    480d        .H      LDR      r0,[pc,#52] ; [0x10067f4] = 0xa000c554
        0x010067be:    3844        D8      SUBS     r0,r0,#0x44
        0x010067c0:    6801        .h      LDR      r1,[r0,#0]
        0x010067c2:    f4210178    !.x.    BIC      r1,r1,#0xf80000
        0x010067c6:    ea4141c4    A..A    ORR      r1,r1,r4,LSL #19
        0x010067ca:    6001        .`      STR      r1,[r0,#0]
        0x010067cc:    4809        .H      LDR      r0,[pc,#36] ; [0x10067f4] = 0xa000c554
        0x010067ce:    3830        08      SUBS     r0,r0,#0x30
        0x010067d0:    6801        .h      LDR      r1,[r0,#0]
        0x010067d2:    f421011f    !...    BIC      r1,r1,#0x9f0000
        0x010067d6:    ea414106    A..A    ORR      r1,r1,r6,LSL #16
        0x010067da:    6001        .`      STR      r1,[r0,#0]
        0x010067dc:    4805        .H      LDR      r0,[pc,#20] ; [0x10067f4] = 0xa000c554
        0x010067de:    3840        @8      SUBS     r0,r0,#0x40
        0x010067e0:    6801        .h      LDR      r1,[r0,#0]
        0x010067e2:    f4413100    A..1    ORR      r1,r1,#0x20000
        0x010067e6:    6001        .`      STR      r1,[r0,#0]
        0x010067e8:    e8bd81fc    ....    POP      {r2-r8,pc}
    $d
        0x010067ec:    a000e220     ...    DCD    2684412448
        0x010067f0:    00803212    .2..    DCD    8401426
        0x010067f4:    a000c554    T...    DCD    2684405076
        0x010067f8:    30006814    .h.0    DCD    805333012
    $t
    i.system_priority_init
    system_priority_init
        0x010067fc:    b510        ..      PUSH     {r4,lr}
        0x010067fe:    4948        HI      LDR      r1,[pc,#288] ; [0x1006920] = 0xe000ed0c
        0x01006800:    6808        .h      LDR      r0,[r1,#0]
        0x01006802:    f64f02ff    O...    MOV      r2,#0xf8ff
        0x01006806:    4010        .@      ANDS     r0,r0,r2
        0x01006808:    4a46        FJ      LDR      r2,[pc,#280] ; [0x1006924] = 0x5fa0000
        0x0100680a:    f4407040    @.@p    ORR      r0,r0,#0x300
        0x0100680e:    4310        .C      ORRS     r0,r0,r2
        0x01006810:    6008        .`      STR      r0,[r1,#0]
        0x01006812:    2400        .$      MOVS     r4,#0
        0x01006814:    2200        ."      MOVS     r2,#0
        0x01006816:    2108        .!      MOVS     r1,#8
        0x01006818:    2003        .       MOVS     r0,#3
        0x0100681a:    f7fcf825    ..%.    BL       NVIC_EncodePriority ; 0x1002868
        0x0100681e:    4601        .F      MOV      r1,r0
        0x01006820:    b260        `.      SXTB     r0,r4
        0x01006822:    f7fcf92c    ..,.    BL       __NVIC_SetPriority ; 0x1002a7e
        0x01006826:    1c64        d.      ADDS     r4,r4,#1
        0x01006828:    2c22        ",      CMP      r4,#0x22
        0x0100682a:    d3f3        ..      BCC      0x1006814 ; system_priority_init + 24
        0x0100682c:    2200        ."      MOVS     r2,#0
        0x0100682e:    4611        .F      MOV      r1,r2
        0x01006830:    2003        .       MOVS     r0,#3
        0x01006832:    f7fcf819    ....    BL       NVIC_EncodePriority ; 0x1002868
        0x01006836:    4601        .F      MOV      r1,r0
        0x01006838:    f06f0004    o...    MVN      r0,#4
        0x0100683c:    f7fcf91f    ....    BL       __NVIC_SetPriority ; 0x1002a7e
        0x01006840:    2200        ."      MOVS     r2,#0
        0x01006842:    2102        .!      MOVS     r1,#2
        0x01006844:    2003        .       MOVS     r0,#3
        0x01006846:    f7fcf80f    ....    BL       NVIC_EncodePriority ; 0x1002868
        0x0100684a:    4601        .F      MOV      r1,r0
        0x0100684c:    2002        .       MOVS     r0,#2
        0x0100684e:    f7fcf916    ....    BL       __NVIC_SetPriority ; 0x1002a7e
        0x01006852:    2200        ."      MOVS     r2,#0
        0x01006854:    2102        .!      MOVS     r1,#2
        0x01006856:    2003        .       MOVS     r0,#3
        0x01006858:    f7fcf806    ....    BL       NVIC_EncodePriority ; 0x1002868
        0x0100685c:    4601        .F      MOV      r1,r0
        0x0100685e:    2019        .       MOVS     r0,#0x19
        0x01006860:    f7fcf90d    ....    BL       __NVIC_SetPriority ; 0x1002a7e
        0x01006864:    2200        ."      MOVS     r2,#0
        0x01006866:    2106        .!      MOVS     r1,#6
        0x01006868:    2003        .       MOVS     r0,#3
        0x0100686a:    f7fbfffd    ....    BL       NVIC_EncodePriority ; 0x1002868
        0x0100686e:    4601        .F      MOV      r1,r0
        0x01006870:    2003        .       MOVS     r0,#3
        0x01006872:    f7fcf904    ....    BL       __NVIC_SetPriority ; 0x1002a7e
        0x01006876:    2200        ."      MOVS     r2,#0
        0x01006878:    210a        .!      MOVS     r1,#0xa
        0x0100687a:    2003        .       MOVS     r0,#3
        0x0100687c:    f7fbfff4    ....    BL       NVIC_EncodePriority ; 0x1002868
        0x01006880:    4601        .F      MOV      r1,r0
        0x01006882:    200c        .       MOVS     r0,#0xc
        0x01006884:    f7fcf8fb    ....    BL       __NVIC_SetPriority ; 0x1002a7e
        0x01006888:    2200        ."      MOVS     r2,#0
        0x0100688a:    210a        .!      MOVS     r1,#0xa
        0x0100688c:    2003        .       MOVS     r0,#3
        0x0100688e:    f7fbffeb    ....    BL       NVIC_EncodePriority ; 0x1002868
        0x01006892:    4601        .F      MOV      r1,r0
        0x01006894:    200d        .       MOVS     r0,#0xd
        0x01006896:    f7fcf8f2    ....    BL       __NVIC_SetPriority ; 0x1002a7e
        0x0100689a:    2200        ."      MOVS     r2,#0
        0x0100689c:    210c        .!      MOVS     r1,#0xc
        0x0100689e:    2003        .       MOVS     r0,#3
        0x010068a0:    f7fbffe2    ....    BL       NVIC_EncodePriority ; 0x1002868
        0x010068a4:    4601        .F      MOV      r1,r0
        0x010068a6:    2008        .       MOVS     r0,#8
        0x010068a8:    f7fcf8e9    ....    BL       __NVIC_SetPriority ; 0x1002a7e
        0x010068ac:    2200        ."      MOVS     r2,#0
        0x010068ae:    210c        .!      MOVS     r1,#0xc
        0x010068b0:    2003        .       MOVS     r0,#3
        0x010068b2:    f7fbffd9    ....    BL       NVIC_EncodePriority ; 0x1002868
        0x010068b6:    4601        .F      MOV      r1,r0
        0x010068b8:    2009        .       MOVS     r0,#9
        0x010068ba:    f7fcf8e0    ....    BL       __NVIC_SetPriority ; 0x1002a7e
        0x010068be:    2200        ."      MOVS     r2,#0
        0x010068c0:    210c        .!      MOVS     r1,#0xc
        0x010068c2:    2003        .       MOVS     r0,#3
        0x010068c4:    f7fbffd0    ....    BL       NVIC_EncodePriority ; 0x1002868
        0x010068c8:    4601        .F      MOV      r1,r0
        0x010068ca:    200a        .       MOVS     r0,#0xa
        0x010068cc:    f7fcf8d7    ....    BL       __NVIC_SetPriority ; 0x1002a7e
        0x010068d0:    2200        ."      MOVS     r2,#0
        0x010068d2:    210c        .!      MOVS     r1,#0xc
        0x010068d4:    2003        .       MOVS     r0,#3
        0x010068d6:    f7fbffc7    ....    BL       NVIC_EncodePriority ; 0x1002868
        0x010068da:    4601        .F      MOV      r1,r0
        0x010068dc:    201a        .       MOVS     r0,#0x1a
        0x010068de:    f7fcf8ce    ....    BL       __NVIC_SetPriority ; 0x1002a7e
        0x010068e2:    220f        ."      MOVS     r2,#0xf
        0x010068e4:    4611        .F      MOV      r1,r2
        0x010068e6:    2003        .       MOVS     r0,#3
        0x010068e8:    f7fbffbe    ....    BL       NVIC_EncodePriority ; 0x1002868
        0x010068ec:    4601        .F      MOV      r1,r0
        0x010068ee:    f06f0001    o...    MVN      r0,#1
        0x010068f2:    f7fcf8c4    ....    BL       __NVIC_SetPriority ; 0x1002a7e
        0x010068f6:    220f        ."      MOVS     r2,#0xf
        0x010068f8:    4611        .F      MOV      r1,r2
        0x010068fa:    2003        .       MOVS     r0,#3
        0x010068fc:    f7fbffb4    ....    BL       NVIC_EncodePriority ; 0x1002868
        0x01006900:    4601        .F      MOV      r1,r0
        0x01006902:    f04f30ff    O..0    MOV      r0,#0xffffffff
        0x01006906:    f7fcf8ba    ....    BL       __NVIC_SetPriority ; 0x1002a7e
        0x0100690a:    220f        ."      MOVS     r2,#0xf
        0x0100690c:    4611        .F      MOV      r1,r2
        0x0100690e:    2003        .       MOVS     r0,#3
        0x01006910:    f7fbffaa    ....    BL       NVIC_EncodePriority ; 0x1002868
        0x01006914:    4601        .F      MOV      r1,r0
        0x01006916:    e8bd4010    ...@    POP      {r4,lr}
        0x0100691a:    2001        .       MOVS     r0,#1
        0x0100691c:    f7fcb8af    ....    B        __NVIC_SetPriority ; 0x1002a7e
    $d
        0x01006920:    e000ed0c    ....    DCD    3758157068
        0x01006924:    05fa0000    ....    DCD    100270080
    $t
    i.tags_cache_clean
    tags_cache_clean
        0x01006928:    b510        ..      PUSH     {r4,lr}
        0x0100692a:    f44f7196    O..q    MOV      r1,#0x12c
        0x0100692e:    4804        .H      LDR      r0,[pc,#16] ; [0x1006940] = 0x8032e4
        0x01006930:    f7fbfe59    ..Y.    BL       __aeabi_memclr4 ; 0x10025e6
        0x01006934:    4902        .I      LDR      r1,[pc,#8] ; [0x1006940] = 0x8032e4
        0x01006936:    2000        .       MOVS     r0,#0
        0x01006938:    390c        .9      SUBS     r1,r1,#0xc
        0x0100693a:    f8810138    ..8.    STRB     r0,[r1,#0x138]
        0x0100693e:    bd10        ..      POP      {r4,pc}
    $d
        0x01006940:    008032e4    .2..    DCD    8401636
    $t
    i.tags_cache_rec_add
    tags_cache_rec_add
        0x01006944:    b510        ..      PUSH     {r4,lr}
        0x01006946:    4b0b        .K      LDR      r3,[pc,#44] ; [0x1006974] = 0x8032d8
        0x01006948:    f8932138    ..8!    LDRB     r2,[r3,#0x138]
        0x0100694c:    2a1e        .*      CMP      r2,#0x1e
        0x0100694e:    d210        ..      BCS      0x1006972 ; tags_cache_rec_add + 46
        0x01006950:    eb020282    ....    ADD      r2,r2,r2,LSL #2
        0x01006954:    eb030242    ..B.    ADD      r2,r3,r2,LSL #1
        0x01006958:    6804        .h      LDR      r4,[r0,#0]
        0x0100695a:    60d4        .`      STR      r4,[r2,#0xc]
        0x0100695c:    6840        @h      LDR      r0,[r0,#4]
        0x0100695e:    6110        .a      STR      r0,[r2,#0x10]
        0x01006960:    4805        .H      LDR      r0,[pc,#20] ; [0x1006978] = 0x8023cc
        0x01006962:    8800        ..      LDRH     r0,[r0,#0]
        0x01006964:    1a08        ..      SUBS     r0,r1,r0
        0x01006966:    8290        ..      STRH     r0,[r2,#0x14]
        0x01006968:    f8930138    ..8.    LDRB     r0,[r3,#0x138]
        0x0100696c:    1c40        @.      ADDS     r0,r0,#1
        0x0100696e:    f8830138    ..8.    STRB     r0,[r3,#0x138]
        0x01006972:    bd10        ..      POP      {r4,pc}
    $d
        0x01006974:    008032d8    .2..    DCD    8401624
        0x01006978:    008023cc    .#..    DCD    8397772
    $t
    i.tags_cache_rec_del
    tags_cache_rec_del
        0x0100697c:    e92d47f0    -..G    PUSH     {r4-r10,lr}
        0x01006980:    b0ca        ..      SUB      sp,sp,#0x128
        0x01006982:    4d4a        JM      LDR      r5,[pc,#296] ; [0x1006aac] = 0x8032e4
        0x01006984:    f1a5070c    ....    SUB      r7,r5,#0xc
        0x01006988:    f8976138    ..8a    LDRB     r6,[r7,#0x138]
        0x0100698c:    2400        .$      MOVS     r4,#0
        0x0100698e:    e088        ..      B        0x1006aa2 ; tags_cache_rec_del + 294
        0x01006990:    eb040184    ....    ADD      r1,r4,r4,LSL #2
        0x01006994:    f8351011    5...    LDRH     r1,[r5,r1,LSL #1]
        0x01006998:    4281        .B      CMP      r1,r0
        0x0100699a:    d17d        }.      BNE      0x1006a98 ; tags_cache_rec_del + 284
        0x0100699c:    1e70        p.      SUBS     r0,r6,#1
        0x0100699e:    4681        .F      MOV      r9,r0
        0x010069a0:    f64f78ff    O..x    MOV      r8,#0xffff
        0x010069a4:    4284        .B      CMP      r4,r0
        0x010069a6:    da16        ..      BGE      0x10069d6 ; tags_cache_rec_del + 90
        0x010069a8:    1b30        0.      SUBS     r0,r6,r4
        0x010069aa:    1e40        @.      SUBS     r0,r0,#1
        0x010069ac:    eb000080    ....    ADD      r0,r0,r0,LSL #2
        0x010069b0:    ea080a40    ..@.    AND      r10,r8,r0,LSL #1
        0x010069b4:    1c60        `.      ADDS     r0,r4,#1
        0x010069b6:    eb000080    ....    ADD      r0,r0,r0,LSL #2
        0x010069ba:    eb050140    ..@.    ADD      r1,r5,r0,LSL #1
        0x010069be:    4652        RF      MOV      r2,r10
        0x010069c0:    a801        ..      ADD      r0,sp,#4
        0x010069c2:    f7fbfd77    ..w.    BL       __aeabi_memcpy ; 0x10024b4
        0x010069c6:    eb040084    ....    ADD      r0,r4,r4,LSL #2
        0x010069ca:    eb050040    ..@.    ADD      r0,r5,r0,LSL #1
        0x010069ce:    4652        RF      MOV      r2,r10
        0x010069d0:    a901        ..      ADD      r1,sp,#4
        0x010069d2:    f7fbfd6f    ..o.    BL       __aeabi_memcpy ; 0x10024b4
        0x010069d6:    eb090089    ....    ADD      r0,r9,r9,LSL #2
        0x010069da:    eb050040    ..@.    ADD      r0,r5,r0,LSL #1
        0x010069de:    2100        .!      MOVS     r1,#0
        0x010069e0:    6001        .`      STR      r1,[r0,#0]
        0x010069e2:    6041        A`      STR      r1,[r0,#4]
        0x010069e4:    8101        ..      STRH     r1,[r0,#8]
        0x010069e6:    f8970138    ..8.    LDRB     r0,[r7,#0x138]
        0x010069ea:    1e40        @.      SUBS     r0,r0,#1
        0x010069ec:    f8870138    ..8.    STRB     r0,[r7,#0x138]
        0x010069f0:    2e1e        ..      CMP      r6,#0x1e
        0x010069f2:    d14f        O.      BNE      0x1006a94 ; tags_cache_rec_del + 280
        0x010069f4:    f8d50118    ....    LDR      r0,[r5,#0x118]
        0x010069f8:    9047        G.      STR      r0,[sp,#0x11c]
        0x010069fa:    f8d5011c    ....    LDR      r0,[r5,#0x11c]
        0x010069fe:    9048        H.      STR      r0,[sp,#0x120]
        0x01006a00:    f8b50120    .. .    LDRH     r0,[r5,#0x120]
        0x01006a04:    f8ad0124    ..$.    STRH     r0,[sp,#0x124]
        0x01006a08:    9948        H.      LDR      r1,[sp,#0x120]
        0x01006a0a:    9847        G.      LDR      r0,[sp,#0x11c]
        0x01006a0c:    9146        F.      STR      r1,[sp,#0x118]
        0x01006a0e:    9045        E.      STR      r0,[sp,#0x114]
        0x01006a10:    f8bd0116    ....    LDRH     r0,[sp,#0x116]
        0x01006a14:    f46ed6d0    n...    BL       get_align_bytes ; 0x757b8
        0x01006a18:    4e25        %N      LDR      r6,[pc,#148] ; [0x1006ab0] = 0x8023cc
        0x01006a1a:    f8bd2116    ...!    LDRH     r2,[sp,#0x116]
        0x01006a1e:    6831        1h      LDR      r1,[r6,#0]
        0x01006a20:    4408        .D      ADD      r0,r0,r1
        0x01006a22:    f8bd1124    ..$.    LDRH     r1,[sp,#0x124]
        0x01006a26:    4411        .D      ADD      r1,r1,r2
        0x01006a28:    1844        D.      ADDS     r4,r0,r1
        0x01006a2a:    3408        .4      ADDS     r4,r4,#8
        0x01006a2c:    f8df9084    ....    LDR      r9,[pc,#132] ; [0x1006ab4] = 0x8023c9
        0x01006a30:    f8990000    ....    LDRB     r0,[r9,#0]
        0x01006a34:    b110        ..      CBZ      r0,0x1006a3c ; tags_cache_rec_del + 192
        0x01006a36:    2000        .       MOVS     r0,#0
        0x01006a38:    f46fd232    o.2.    BL       hal_flash_set_security ; 0x75ea0
        0x01006a3c:    f8dfa078    ..x.    LDR      r10,[pc,#120] ; [0x1006ab8] = 0x8023d0
        0x01006a40:    2208        ."      MOVS     r2,#8
        0x01006a42:    a945        E.      ADD      r1,sp,#0x114
        0x01006a44:    4620         F      MOV      r0,r4
        0x01006a46:    f7fdfcb9    ....    BL       hal_flash_read ; 0x10043bc
        0x01006a4a:    f8bd0114    ....    LDRH     r0,[sp,#0x114]
        0x01006a4e:    4540        @E      CMP      r0,r8
        0x01006a50:    d01c        ..      BEQ      0x1006a8c ; tags_cache_rec_del + 272
        0x01006a52:    b170        p.      CBZ      r0,0x1006a72 ; tags_cache_rec_del + 246
        0x01006a54:    f5057591    ...u    ADD      r5,r5,#0x122
        0x01006a58:    9845        E.      LDR      r0,[sp,#0x114]
        0x01006a5a:    6028        (`      STR      r0,[r5,#0]
        0x01006a5c:    9846        F.      LDR      r0,[sp,#0x118]
        0x01006a5e:    6068        h`      STR      r0,[r5,#4]
        0x01006a60:    8830        0.      LDRH     r0,[r6,#0]
        0x01006a62:    1a20         .      SUBS     r0,r4,r0
        0x01006a64:    8128        (.      STRH     r0,[r5,#8]
        0x01006a66:    f8970138    ..8.    LDRB     r0,[r7,#0x138]
        0x01006a6a:    1c40        @.      ADDS     r0,r0,#1
        0x01006a6c:    f8870138    ..8.    STRB     r0,[r7,#0x138]
        0x01006a70:    e00c        ..      B        0x1006a8c ; tags_cache_rec_del + 272
        0x01006a72:    f8bd0116    ....    LDRH     r0,[sp,#0x116]
        0x01006a76:    f46ed69f    n...    BL       get_align_bytes ; 0x757b8
        0x01006a7a:    f8bd1116    ....    LDRH     r1,[sp,#0x116]
        0x01006a7e:    3008        .0      ADDS     r0,r0,#8
        0x01006a80:    4421        !D      ADD      r1,r1,r4
        0x01006a82:    1844        D.      ADDS     r4,r0,r1
        0x01006a84:    f8da0000    ....    LDR      r0,[r10,#0]
        0x01006a88:    4284        .B      CMP      r4,r0
        0x01006a8a:    d3d9        ..      BCC      0x1006a40 ; tags_cache_rec_del + 196
        0x01006a8c:    f8990000    ....    LDRB     r0,[r9,#0]
        0x01006a90:    f46fd206    o...    BL       hal_flash_set_security ; 0x75ea0
        0x01006a94:    b04a        J.      ADD      sp,sp,#0x128
        0x01006a96:    e000        ..      B        0x1006a9a ; tags_cache_rec_del + 286
        0x01006a98:    e001        ..      B        0x1006a9e ; tags_cache_rec_del + 290
        0x01006a9a:    e8bd87f0    ....    POP      {r4-r10,pc}
        0x01006a9e:    1c64        d.      ADDS     r4,r4,#1
        0x01006aa0:    b2e4        ..      UXTB     r4,r4
        0x01006aa2:    42b4        .B      CMP      r4,r6
        0x01006aa4:    f4ffaf74    ..t.    BCC      0x1006990 ; tags_cache_rec_del + 20
        0x01006aa8:    e7f4        ..      B        0x1006a94 ; tags_cache_rec_del + 280
    $d
        0x01006aaa:    0000        ..      DCW    0
        0x01006aac:    008032e4    .2..    DCD    8401636
        0x01006ab0:    008023cc    .#..    DCD    8397772
        0x01006ab4:    008023c9    .#..    DCD    8397769
        0x01006ab8:    008023d0    .#..    DCD    8397776
    $t
    i.tags_cache_rec_find
    tags_cache_rec_find
        0x01006abc:    e92d41f0    -..A    PUSH     {r4-r8,lr}
        0x01006ac0:    4616        .F      MOV      r6,r2
        0x01006ac2:    4c1e        .L      LDR      r4,[pc,#120] ; [0x1006b3c] = 0x8032e4
        0x01006ac4:    f1a4020c    ....    SUB      r2,r4,#0xc
        0x01006ac8:    f8925138    ..8Q    LDRB     r5,[r2,#0x138]
        0x01006acc:    2200        ."      MOVS     r2,#0
        0x01006ace:    2d00        .-      CMP      r5,#0
        0x01006ad0:    d002        ..      BEQ      0x1006ad8 ; tags_cache_rec_find + 28
        0x01006ad2:    2300        .#      MOVS     r3,#0
        0x01006ad4:    4f1a        .O      LDR      r7,[pc,#104] ; [0x1006b40] = 0x8023cc
        0x01006ad6:    e019        ..      B        0x1006b0c ; tags_cache_rec_find + 80
        0x01006ad8:    800a        ..      STRH     r2,[r1,#0]
        0x01006ada:    6032        2`      STR      r2,[r6,#0]
        0x01006adc:    2001        .       MOVS     r0,#1
        0x01006ade:    e8bd81f0    ....    POP      {r4-r8,pc}
        0x01006ae2:    eb030c83    ....    ADD      r12,r3,r3,LSL #2
        0x01006ae6:    f834c01c    4...    LDRH     r12,[r4,r12,LSL #1]
        0x01006aea:    4584        .E      CMP      r12,r0
        0x01006aec:    d10c        ..      BNE      0x1006b08 ; tags_cache_rec_find + 76
        0x01006aee:    eb030083    ....    ADD      r0,r3,r3,LSL #2
        0x01006af2:    eb040040    ..@.    ADD      r0,r4,r0,LSL #1
        0x01006af6:    8842        B.      LDRH     r2,[r0,#2]
        0x01006af8:    800a        ..      STRH     r2,[r1,#0]
        0x01006afa:    8901        ..      LDRH     r1,[r0,#8]
        0x01006afc:    6838        8h      LDR      r0,[r7,#0]
        0x01006afe:    3008        .0      ADDS     r0,r0,#8
        0x01006b00:    4408        .D      ADD      r0,r0,r1
        0x01006b02:    6030        0`      STR      r0,[r6,#0]
        0x01006b04:    2001        .       MOVS     r0,#1
        0x01006b06:    e7ea        ..      B        0x1006ade ; tags_cache_rec_find + 34
        0x01006b08:    1c5b        [.      ADDS     r3,r3,#1
        0x01006b0a:    b2db        ..      UXTB     r3,r3
        0x01006b0c:    42ab        .B      CMP      r3,r5
        0x01006b0e:    d3e8        ..      BCC      0x1006ae2 ; tags_cache_rec_find + 38
        0x01006b10:    2d1e        .-      CMP      r5,#0x1e
        0x01006b12:    d203        ..      BCS      0x1006b1c ; tags_cache_rec_find + 96
        0x01006b14:    800a        ..      STRH     r2,[r1,#0]
        0x01006b16:    6032        2`      STR      r2,[r6,#0]
        0x01006b18:    2001        .       MOVS     r0,#1
        0x01006b1a:    e7e0        ..      B        0x1006ade ; tags_cache_rec_find + 34
        0x01006b1c:    f5047491    ...t    ADD      r4,r4,#0x122
        0x01006b20:    8860        `.      LDRH     r0,[r4,#2]
        0x01006b22:    f46ed649    n.I.    BL       get_align_bytes ; 0x757b8
        0x01006b26:    6839        9h      LDR      r1,[r7,#0]
        0x01006b28:    8862        b.      LDRH     r2,[r4,#2]
        0x01006b2a:    4408        .D      ADD      r0,r0,r1
        0x01006b2c:    8921        !.      LDRH     r1,[r4,#8]
        0x01006b2e:    4411        .D      ADD      r1,r1,r2
        0x01006b30:    4408        .D      ADD      r0,r0,r1
        0x01006b32:    3008        .0      ADDS     r0,r0,#8
        0x01006b34:    6030        0`      STR      r0,[r6,#0]
        0x01006b36:    2000        .       MOVS     r0,#0
        0x01006b38:    e7d1        ..      B        0x1006ade ; tags_cache_rec_find + 34
    $d
        0x01006b3a:    0000        ..      DCW    0
        0x01006b3c:    008032e4    .2..    DCD    8401636
        0x01006b40:    008023cc    .#..    DCD    8397772
    $t
    i.temperature_calibrations
    temperature_calibrations
        0x01006b44:    b510        ..      PUSH     {r4,lr}
        0x01006b46:    4604        .F      MOV      r4,r0
        0x01006b48:    4620         F      MOV      r0,r4
        0x01006b4a:    f7fcf893    ....    BL       aon_voltage_set ; 0x1002c74
        0x01006b4e:    4620         F      MOV      r0,r4
        0x01006b50:    f7fef81c    ....    BL       ldo_voltage_set ; 0x1004b8c
        0x01006b54:    4620         F      MOV      r0,r4
        0x01006b56:    f7fff877    ..w.    BL       retention_mem_set ; 0x1005c48
        0x01006b5a:    4620         F      MOV      r0,r4
        0x01006b5c:    f7fcff56    ..V.    BL       current_shape_set ; 0x1003a0c
        0x01006b60:    4620         F      MOV      r0,r4
        0x01006b62:    f7fcfc81    ....    BL       clk_period_1V_set ; 0x1003468
        0x01006b66:    bd10        ..      POP      {r4,pc}
    i.tiny_rw_section_init
    tiny_rw_section_init
        0x01006b68:    4902        .I      LDR      r1,[pc,#8] ; [0x1006b74] = 0x100a190
        0x01006b6a:    4803        .H      LDR      r0,[pc,#12] ; [0x1006b78] = 0x300035cc
        0x01006b6c:    4a03        .J      LDR      r2,[pc,#12] ; [0x1006b7c] = 0x5cc
        0x01006b6e:    f7fbbce6    ....    B        __aeabi_memcpy4 ; 0x100253e
    $d
        0x01006b72:    0000        ..      DCW    0
        0x01006b74:    0100a190    ....    DCD    16818576
        0x01006b78:    300035cc    .5.0    DCD    805320140
        0x01006b7c:    000005cc    ....    DCD    1484
    $t
    i.ton_value_set
    ton_value_set
        0x01006b80:    b510        ..      PUSH     {r4,lr}
        0x01006b82:    490c        .I      LDR      r1,[pc,#48] ; [0x1006bb4] = 0x803212
        0x01006b84:    7849        Ix      LDRB     r1,[r1,#1]
        0x01006b86:    f3c10180    ....    UBFX     r1,r1,#2,#1
        0x01006b8a:    2900        .)      CMP      r1,#0
        0x01006b8c:    d002        ..      BEQ      0x1006b94 ; ton_value_set + 20
        0x01006b8e:    f7fdf943    ..C.    BL       get_ton_value_for_1p5uH ; 0x1003e18
        0x01006b92:    e001        ..      B        0x1006b98 ; ton_value_set + 24
        0x01006b94:    f7fdf972    ..r.    BL       get_ton_value_for_2p2uH ; 0x1003e7c
        0x01006b98:    4907        .I      LDR      r1,[pc,#28] ; [0x1006bb8] = 0xa000c510
        0x01006b9a:    680a        .h      LDR      r2,[r1,#0]
        0x01006b9c:    f4225260    ".`R    BIC      r2,r2,#0x3800
        0x01006ba0:    ea4220c0    B..     ORR      r0,r2,r0,LSL #11
        0x01006ba4:    6008        .`      STR      r0,[r1,#0]
        0x01006ba6:    1d08        ..      ADDS     r0,r1,#4
        0x01006ba8:    6801        .h      LDR      r1,[r0,#0]
        0x01006baa:    f4413100    A..1    ORR      r1,r1,#0x20000
        0x01006bae:    6001        .`      STR      r1,[r0,#0]
        0x01006bb0:    bd10        ..      POP      {r4,pc}
    $d
        0x01006bb2:    0000        ..      DCW    0
        0x01006bb4:    00803212    .2..    DCD    8401426
        0x01006bb8:    a000c510    ....    DCD    2684405008
    $t
    i.uart_get_id
    uart_get_id
        0x01006bbc:    2100        .!      MOVS     r1,#0
        0x01006bbe:    4a07        .J      LDR      r2,[pc,#28] ; [0x1006bdc] = 0x1007bc0
        0x01006bc0:    6800        .h      LDR      r0,[r0,#0]
        0x01006bc2:    eb0203c1    ....    ADD      r3,r2,r1,LSL #3
        0x01006bc6:    685b        [h      LDR      r3,[r3,#4]
        0x01006bc8:    4298        .B      CMP      r0,r3
        0x01006bca:    d102        ..      BNE      0x1006bd2 ; uart_get_id + 22
        0x01006bcc:    f8120031    ..1.    LDRB     r0,[r2,r1,LSL #3]
        0x01006bd0:    4770        pG      BX       lr
        0x01006bd2:    1c49        I.      ADDS     r1,r1,#1
        0x01006bd4:    2902        .)      CMP      r1,#2
        0x01006bd6:    d3f4        ..      BCC      0x1006bc2 ; uart_get_id + 6
        0x01006bd8:    2002        .       MOVS     r0,#2
        0x01006bda:    4770        pG      BX       lr
    $d
        0x01006bdc:    01007bc0    .{..    DCD    16808896
    $t
    i.uart_gpio_config
    uart_gpio_config
        0x01006be0:    b57c        |.      PUSH     {r2-r6,lr}
        0x01006be2:    4605        .F      MOV      r5,r0
        0x01006be4:    460c        .F      MOV      r4,r1
        0x01006be6:    4821        !H      LDR      r0,[pc,#132] ; [0x1006c6c] = 0x1007bb0
        0x01006be8:    68c1        .h      LDR      r1,[r0,#0xc]
        0x01006bea:    6880        .h      LDR      r0,[r0,#8]
        0x01006bec:    e9cd0100    ....    STRD     r0,r1,[sp,#0]
        0x01006bf0:    7a20         z      LDRB     r0,[r4,#8]
        0x01006bf2:    f88d0005    ....    STRB     r0,[sp,#5]
        0x01006bf6:    2003        .       MOVS     r0,#3
        0x01006bf8:    f88d0004    ....    STRB     r0,[sp,#4]
        0x01006bfc:    6860        `h      LDR      r0,[r4,#4]
        0x01006bfe:    9000        ..      STR      r0,[sp,#0]
        0x01006c00:    7860        `x      LDRB     r0,[r4,#1]
        0x01006c02:    f88d0006    ....    STRB     r0,[sp,#6]
        0x01006c06:    7820         x      LDRB     r0,[r4,#0]
        0x01006c08:    4669        iF      MOV      r1,sp
        0x01006c0a:    f7fcf84f    ..O.    BL       app_io_init ; 0x1002cac
        0x01006c0e:    2800        .(      CMP      r0,#0
        0x01006c10:    d12b        +.      BNE      0x1006c6a ; uart_gpio_config + 138
        0x01006c12:    7d20         }      LDRB     r0,[r4,#0x14]
        0x01006c14:    f88d0005    ....    STRB     r0,[sp,#5]
        0x01006c18:    6920         i      LDR      r0,[r4,#0x10]
        0x01006c1a:    9000        ..      STR      r0,[sp,#0]
        0x01006c1c:    7b60        `{      LDRB     r0,[r4,#0xd]
        0x01006c1e:    f88d0006    ....    STRB     r0,[sp,#6]
        0x01006c22:    7b20         {      LDRB     r0,[r4,#0xc]
        0x01006c24:    4669        iF      MOV      r1,sp
        0x01006c26:    f7fcf841    ..A.    BL       app_io_init ; 0x1002cac
        0x01006c2a:    2800        .(      CMP      r0,#0
        0x01006c2c:    d11d        ..      BNE      0x1006c6a ; uart_gpio_config + 138
        0x01006c2e:    2d22        "-      CMP      r5,#0x22
        0x01006c30:    d11b        ..      BNE      0x1006c6a ; uart_gpio_config + 138
        0x01006c32:    f8940020    .. .    LDRB     r0,[r4,#0x20]
        0x01006c36:    f88d0005    ....    STRB     r0,[sp,#5]
        0x01006c3a:    69e0        .i      LDR      r0,[r4,#0x1c]
        0x01006c3c:    9000        ..      STR      r0,[sp,#0]
        0x01006c3e:    7e60        `~      LDRB     r0,[r4,#0x19]
        0x01006c40:    f88d0006    ....    STRB     r0,[sp,#6]
        0x01006c44:    7e20         ~      LDRB     r0,[r4,#0x18]
        0x01006c46:    4669        iF      MOV      r1,sp
        0x01006c48:    f7fcf830    ..0.    BL       app_io_init ; 0x1002cac
        0x01006c4c:    2800        .(      CMP      r0,#0
        0x01006c4e:    d10c        ..      BNE      0x1006c6a ; uart_gpio_config + 138
        0x01006c50:    3424        $4      ADDS     r4,r4,#0x24
        0x01006c52:    7a20         z      LDRB     r0,[r4,#8]
        0x01006c54:    f88d0005    ....    STRB     r0,[sp,#5]
        0x01006c58:    6860        `h      LDR      r0,[r4,#4]
        0x01006c5a:    9000        ..      STR      r0,[sp,#0]
        0x01006c5c:    7860        `x      LDRB     r0,[r4,#1]
        0x01006c5e:    f88d0006    ....    STRB     r0,[sp,#6]
        0x01006c62:    7820         x      LDRB     r0,[r4,#0]
        0x01006c64:    4669        iF      MOV      r1,sp
        0x01006c66:    f7fcf821    ..!.    BL       app_io_init ; 0x1002cac
        0x01006c6a:    bd7c        |.      POP      {r2-r6,pc}
    $d
        0x01006c6c:    01007bb0    .{..    DCD    16808880
    $t
    i.uart_prepare_for_sleep
    uart_prepare_for_sleep
        0x01006c70:    b570        p.      PUSH     {r4-r6,lr}
        0x01006c72:    2400        .$      MOVS     r4,#0
        0x01006c74:    4e10        .N      LDR      r6,[pc,#64] ; [0x1006cb8] = 0x300065cc
        0x01006c76:    f8560024    V.$.    LDR      r0,[r6,r4,LSL #2]
        0x01006c7a:    b1b8        ..      CBZ      r0,0x1006cac ; uart_prepare_for_sleep + 60
        0x01006c7c:    f890106c    ..l.    LDRB     r1,[r0,#0x6c]
        0x01006c80:    2901        .)      CMP      r1,#1
        0x01006c82:    d113        ..      BNE      0x1006cac ; uart_prepare_for_sleep + 60
        0x01006c84:    1d00        ..      ADDS     r0,r0,#4
        0x01006c86:    f7fdfd01    ....    BL       hal_uart_get_state ; 0x100468c
        0x01006c8a:    b118        ..      CBZ      r0,0x1006c94 ; uart_prepare_for_sleep + 36
        0x01006c8c:    2810        .(      CMP      r0,#0x10
        0x01006c8e:    d001        ..      BEQ      0x1006c94 ; uart_prepare_for_sleep + 36
        0x01006c90:    2000        .       MOVS     r0,#0
        0x01006c92:    bd70        p.      POP      {r4-r6,pc}
        0x01006c94:    f3ef8510    ....    MRS      r5,PRIMASK
        0x01006c98:    2001        .       MOVS     r0,#1
        0x01006c9a:    f3808810    ....    MSR      PRIMASK,r0
        0x01006c9e:    f8560024    V.$.    LDR      r0,[r6,r4,LSL #2]
        0x01006ca2:    1d00        ..      ADDS     r0,r0,#4
        0x01006ca4:    f41ad66c    ..l.    BL       hal_uart_suspend_reg ; 0x21980
        0x01006ca8:    f3858810    ....    MSR      PRIMASK,r5
        0x01006cac:    1c64        d.      ADDS     r4,r4,#1
        0x01006cae:    2c02        .,      CMP      r4,#2
        0x01006cb0:    d3e1        ..      BCC      0x1006c76 ; uart_prepare_for_sleep + 6
        0x01006cb2:    2001        .       MOVS     r0,#1
        0x01006cb4:    bd70        p.      POP      {r4-r6,pc}
    $d
        0x01006cb6:    0000        ..      DCW    0
        0x01006cb8:    300065cc    .e.0    DCD    805332428
    $t
    i.ultra_deep_sleep_wakeup_handle
    ultra_deep_sleep_wakeup_handle
        0x01006cbc:    b510        ..      PUSH     {r4,lr}
        0x01006cbe:    4805        .H      LDR      r0,[pc,#20] ; [0x1006cd4] = 0xa000c560
        0x01006cc0:    6800        .h      LDR      r0,[r0,#0]
        0x01006cc2:    b280        ..      UXTH     r0,r0
        0x01006cc4:    f5a04171    ..qA    SUB      r1,r0,#0xf100
        0x01006cc8:    3975        u9      SUBS     r1,r1,#0x75
        0x01006cca:    d102        ..      BNE      0x1006cd2 ; ultra_deep_sleep_wakeup_handle + 22
        0x01006ccc:    f7fdfc24    ..$.    BL       hal_nvic_system_reset ; 0x1004518
        0x01006cd0:    e7fe        ..      B        0x1006cd0 ; ultra_deep_sleep_wakeup_handle + 20
        0x01006cd2:    bd10        ..      POP      {r4,pc}
    $d
        0x01006cd4:    a000c560    `...    DCD    2684405088
    $t
    i.update_io_ldo_to_prevent_leakage
    update_io_ldo_to_prevent_leakage
        0x01006cd8:    b51c        ..      PUSH     {r2-r4,lr}
        0x01006cda:    4604        .F      MOV      r4,r0
        0x01006cdc:    2000        .       MOVS     r0,#0
        0x01006cde:    9000        ..      STR      r0,[sp,#0]
        0x01006ce0:    9001        ..      STR      r0,[sp,#4]
        0x01006ce2:    4668        hF      MOV      r0,sp
        0x01006ce4:    f7fffc20    .. .    BL       sys_pmu_trim_get ; 0x1006528
        0x01006ce8:    2800        .(      CMP      r0,#0
        0x01006cea:    d10c        ..      BNE      0x1006d06 ; update_io_ldo_to_prevent_leakage + 46
        0x01006cec:    4806        .H      LDR      r0,[pc,#24] ; [0x1006d08] = 0x803212
        0x01006cee:    7840        @x      LDRB     r0,[r0,#1]
        0x01006cf0:    f3c000c0    ....    UBFX     r0,r0,#3,#1
        0x01006cf4:    2800        .(      CMP      r0,#0
        0x01006cf6:    d106        ..      BNE      0x1006d06 ; update_io_ldo_to_prevent_leakage + 46
        0x01006cf8:    f7fffc02    ....    BL       sys_is_use_internal_3p3_ioldo ; 0x1006500
        0x01006cfc:    2800        .(      CMP      r0,#0
        0x01006cfe:    d002        ..      BEQ      0x1006d06 ; update_io_ldo_to_prevent_leakage + 46
        0x01006d00:    4620         F      MOV      r0,r4
        0x01006d02:    f7fdff09    ....    BL       internal_3p3_ioldo_update ; 0x1004b18
        0x01006d06:    bd1c        ..      POP      {r2-r4,pc}
    $d
        0x01006d08:    00803212    .2..    DCD    8401426
    $t
    i.vbatt_calibrations
    vbatt_calibrations
        0x01006d0c:    b510        ..      PUSH     {r4,lr}
        0x01006d0e:    4604        .F      MOV      r4,r0
        0x01006d10:    4620         F      MOV      r0,r4
        0x01006d12:    f7ffffe1    ....    BL       update_io_ldo_to_prevent_leakage ; 0x1006cd8
        0x01006d16:    4620         F      MOV      r0,r4
        0x01006d18:    f7ffff32    ..2.    BL       ton_value_set ; 0x1006b80
        0x01006d1c:    bd10        ..      POP      {r4,pc}
        0x01006d1e:    0000        ..      MOVS     r0,r0
    i.vector_table_init
    vector_table_init
        0x01006d20:    f3bf8f5f    .._.    DMB      
        0x01006d24:    4804        .H      LDR      r0,[pc,#16] ; [0x1006d38] = 0xe000ed08
        0x01006d26:    6801        .h      LDR      r1,[r0,#0]
        0x01006d28:    680a        .h      LDR      r2,[r1,#0]
        0x01006d2a:    4904        .I      LDR      r1,[pc,#16] ; [0x1006d3c] = 0x30006500
        0x01006d2c:    600a        .`      STR      r2,[r1,#0]
        0x01006d2e:    6001        .`      STR      r1,[r0,#0]
        0x01006d30:    f3bf8f4f    ..O.    DSB      
        0x01006d34:    4770        pG      BX       lr
    $d
        0x01006d36:    0000        ..      DCW    0
        0x01006d38:    e000ed08    ....    DCD    3758157064
        0x01006d3c:    30006500    .e.0    DCD    805332224
    $t
    i.verify_hdr_checksum
    verify_hdr_checksum
        0x01006d40:    7801        .x      LDRB     r1,[r0,#0]
        0x01006d42:    7882        .x      LDRB     r2,[r0,#2]
        0x01006d44:    4411        .D      ADD      r1,r1,r2
        0x01006d46:    b2c9        ..      UXTB     r1,r1
        0x01006d48:    7900        .y      LDRB     r0,[r0,#4]
        0x01006d4a:    4288        .B      CMP      r0,r1
        0x01006d4c:    d101        ..      BNE      0x1006d52 ; verify_hdr_checksum + 18
        0x01006d4e:    2001        .       MOVS     r0,#1
        0x01006d50:    4770        pG      BX       lr
        0x01006d52:    2000        .       MOVS     r0,#0
        0x01006d54:    4770        pG      BX       lr
    i.verify_value_checksum
    verify_value_checksum
        0x01006d56:    b530        0.      PUSH     {r4,r5,lr}
        0x01006d58:    2300        .#      MOVS     r3,#0
        0x01006d5a:    2200        ."      MOVS     r2,#0
        0x01006d5c:    8844        D.      LDRH     r4,[r0,#2]
        0x01006d5e:    e004        ..      B        0x1006d6a ; verify_value_checksum + 20
        0x01006d60:    5c8d        .\      LDRB     r5,[r1,r2]
        0x01006d62:    442b        +D      ADD      r3,r3,r5
        0x01006d64:    b2db        ..      UXTB     r3,r3
        0x01006d66:    1c52        R.      ADDS     r2,r2,#1
        0x01006d68:    b292        ..      UXTH     r2,r2
        0x01006d6a:    4294        .B      CMP      r4,r2
        0x01006d6c:    d8f8        ..      BHI      0x1006d60 ; verify_value_checksum + 10
        0x01006d6e:    7940        @y      LDRB     r0,[r0,#5]
        0x01006d70:    4298        .B      CMP      r0,r3
        0x01006d72:    d101        ..      BNE      0x1006d78 ; verify_value_checksum + 34
        0x01006d74:    2001        .       MOVS     r0,#1
        0x01006d76:    bd30        0.      POP      {r4,r5,pc}
        0x01006d78:    2000        .       MOVS     r0,#0
        0x01006d7a:    bd30        0.      POP      {r4,r5,pc}
    i.warm_boot_cfg_patch
    warm_boot_cfg_patch
        0x01006d7c:    f44f208a    O..     MOV      r0,#0x45000
        0x01006d80:    6840        @h      LDR      r0,[r0,#4]
        0x01006d82:    f5a06130    ..0a    SUB      r1,r0,#0xb00
        0x01006d86:    3988        .9      SUBS     r1,r1,#0x88
        0x01006d88:    d104        ..      BNE      0x1006d94 ; warm_boot_cfg_patch + 24
        0x01006d8a:    4903        .I      LDR      r1,[pc,#12] ; [0x1006d98] = 0x801f24
        0x01006d8c:    6808        .h      LDR      r0,[r1,#0]
        0x01006d8e:    f4207000     ..p    BIC      r0,r0,#0x200
        0x01006d92:    6008        .`      STR      r0,[r1,#0]
        0x01006d94:    4770        pG      BX       lr
    $d
        0x01006d96:    0000        ..      DCW    0
        0x01006d98:    00801f24    $...    DCD    8396580
    $t
    i.warm_boot_process
    warm_boot_process
        0x01006d9c:    b510        ..      PUSH     {r4,lr}
        0x01006d9e:    f7ffffbf    ....    BL       vector_table_init ; 0x1006d20
        0x01006da2:    e8bd4010    ...@    POP      {r4,lr}
        0x01006da6:    f7febe6d    ..m.    B        pwr_mgmt_warm_boot ; 0x1005a84
        0x01006daa:    0000        ..      MOVS     r0,r0
    i.warm_boot_set_exflash_readid_delay
    warm_boot_set_exflash_readid_delay
        0x01006dac:    4901        .I      LDR      r1,[pc,#4] ; [0x1006db4] = 0x300067b4
        0x01006dae:    6048        H`      STR      r0,[r1,#4]
        0x01006db0:    4770        pG      BX       lr
    $d
        0x01006db2:    0000        ..      DCW    0
        0x01006db4:    300067b4    .g.0    DCD    805332916
    $t
    i.write_compacted_items
    write_compacted_items
        0x01006db8:    e92d43f0    -..C    PUSH     {r4-r9,lr}
        0x01006dbc:    b085        ..      SUB      sp,sp,#0x14
        0x01006dbe:    4604        .F      MOV      r4,r0
        0x01006dc0:    e9dd590c    ...Y    LDRD     r5,r9,[sp,#0x30]
        0x01006dc4:    460f        .F      MOV      r7,r1
        0x01006dc6:    4690        .F      MOV      r8,r2
        0x01006dc8:    461e        .F      MOV      r6,r3
        0x01006dca:    f8cd8010    ....    STR      r8,[sp,#0x10]
        0x01006dce:    484e        NH      LDR      r0,[pc,#312] ; [0x1006f08] = 0x8023cc
        0x01006dd0:    6800        .h      LDR      r0,[r0,#0]
        0x01006dd2:    eb003004    ...0    ADD      r0,r0,r4,LSL #12
        0x01006dd6:    9003        ..      STR      r0,[sp,#0xc]
        0x01006dd8:    f44f5180    O..Q    MOV      r1,#0x1000
        0x01006ddc:    f7fdfaae    ....    BL       hal_flash_erase ; 0x100433c
        0x01006de0:    b108        ..      CBZ      r0,0x1006de6 ; write_compacted_items + 46
        0x01006de2:    b19c        ..      CBZ      r4,0x1006e0c ; write_compacted_items + 84
        0x01006de4:    e01d        ..      B        0x1006e22 ; write_compacted_items + 106
        0x01006de6:    4849        IH      LDR      r0,[pc,#292] ; [0x1006f0c] = 0x801f64
        0x01006de8:    6981        .i      LDR      r1,[r0,#0x18]
        0x01006dea:    7a40        @z      LDRB     r0,[r0,#9]
        0x01006dec:    f24032e9    @..2    MOV      r2,#0x3e9
        0x01006df0:    e9cd2000    ...     STRD     r2,r0,[sp,#0]
        0x01006df4:    9102        ..      STR      r1,[sp,#8]
        0x01006df6:    4b46        FK      LDR      r3,[pc,#280] ; [0x1006f10] = 0x1007c0c
        0x01006df8:    a246        F.      ADR      r2,{pc}+0x11c ; 0x1006f14
        0x01006dfa:    f44f4100    O..A    MOV      r1,#0x8000
        0x01006dfe:    2000        .       MOVS     r0,#0
        0x01006e00:    f405d7cc    ....    BL       dbg_log_printf ; 0xcd9c
        0x01006e04:    2009        .       MOVS     r0,#9
        0x01006e06:    b005        ..      ADD      sp,sp,#0x14
        0x01006e08:    e8bd83f0    ....    POP      {r4-r9,pc}
        0x01006e0c:    494d        MI      LDR      r1,[pc,#308] ; [0x1006f44] = 0x8032d8
        0x01006e0e:    2000        .       MOVS     r0,#0
        0x01006e10:    6008        .`      STR      r0,[r1,#0]
        0x01006e12:    2301        .#      MOVS     r3,#1
        0x01006e14:    2208        ."      MOVS     r2,#8
        0x01006e16:    a904        ..      ADD      r1,sp,#0x10
        0x01006e18:    a803        ..      ADD      r0,sp,#0xc
        0x01006e1a:    f000f895    ....    BL       write_incr ; 0x1006f48
        0x01006e1e:    2800        .(      CMP      r0,#0
        0x01006e20:    d1f1        ..      BNE      0x1006e06 ; write_compacted_items + 78
        0x01006e22:    b13e        >.      CBZ      r6,0x1006e34 ; write_compacted_items + 124
        0x01006e24:    2301        .#      MOVS     r3,#1
        0x01006e26:    4632        2F      MOV      r2,r6
        0x01006e28:    a904        ..      ADD      r1,sp,#0x10
        0x01006e2a:    a803        ..      ADD      r0,sp,#0xc
        0x01006e2c:    f000f88c    ....    BL       write_incr ; 0x1006f48
        0x01006e30:    2800        .(      CMP      r0,#0
        0x01006e32:    d1e8        ..      BNE      0x1006e06 ; write_compacted_items + 78
        0x01006e34:    b13d        =.      CBZ      r5,0x1006e46 ; write_compacted_items + 142
        0x01006e36:    2300        .#      MOVS     r3,#0
        0x01006e38:    462a        *F      MOV      r2,r5
        0x01006e3a:    a904        ..      ADD      r1,sp,#0x10
        0x01006e3c:    a803        ..      ADD      r0,sp,#0xc
        0x01006e3e:    f000f883    ....    BL       write_incr ; 0x1006f48
        0x01006e42:    2800        .(      CMP      r0,#0
        0x01006e44:    d1df        ..      BNE      0x1006e06 ; write_compacted_items + 78
        0x01006e46:    2f00        ./      CMP      r7,#0
        0x01006e48:    d05c        \.      BEQ      0x1006f04 ; write_compacted_items + 332
        0x01006e4a:    2400        .$      MOVS     r4,#0
        0x01006e4c:    1e7f        ..      SUBS     r7,r7,#1
        0x01006e4e:    e01c        ..      B        0x1006e8a ; write_compacted_items + 210
        0x01006e50:    9d04        ..      LDR      r5,[sp,#0x10]
        0x01006e52:    8868        h.      LDRH     r0,[r5,#2]
        0x01006e54:    f46ed4b0    n...    BL       get_align_bytes ; 0x757b8
        0x01006e58:    8869        i.      LDRH     r1,[r5,#2]
        0x01006e5a:    1846        F.      ADDS     r6,r0,r1
        0x01006e5c:    2301        .#      MOVS     r3,#1
        0x01006e5e:    2208        ."      MOVS     r2,#8
        0x01006e60:    a904        ..      ADD      r1,sp,#0x10
        0x01006e62:    a803        ..      ADD      r0,sp,#0xc
        0x01006e64:    f000f870    ..p.    BL       write_incr ; 0x1006f48
        0x01006e68:    2800        .(      CMP      r0,#0
        0x01006e6a:    d1cc        ..      BNE      0x1006e06 ; write_compacted_items + 78
        0x01006e6c:    2300        .#      MOVS     r3,#0
        0x01006e6e:    4632        2F      MOV      r2,r6
        0x01006e70:    a904        ..      ADD      r1,sp,#0x10
        0x01006e72:    a803        ..      ADD      r0,sp,#0xc
        0x01006e74:    f000f868    ..h.    BL       write_incr ; 0x1006f48
        0x01006e78:    2800        .(      CMP      r0,#0
        0x01006e7a:    d1c4        ..      BNE      0x1006e06 ; write_compacted_items + 78
        0x01006e7c:    9803        ..      LDR      r0,[sp,#0xc]
        0x01006e7e:    1b81        ..      SUBS     r1,r0,r6
        0x01006e80:    3908        .9      SUBS     r1,r1,#8
        0x01006e82:    4628        (F      MOV      r0,r5
        0x01006e84:    f7fffd5e    ..^.    BL       tags_cache_rec_add ; 0x1006944
        0x01006e88:    1c64        d.      ADDS     r4,r4,#1
        0x01006e8a:    42bc        .B      CMP      r4,r7
        0x01006e8c:    d3e0        ..      BCC      0x1006e50 ; write_compacted_items + 152
        0x01006e8e:    f1b90f00    ....    CMP      r9,#0
        0x01006e92:    d012        ..      BEQ      0x1006eba ; write_compacted_items + 258
        0x01006e94:    9804        ..      LDR      r0,[sp,#0x10]
        0x01006e96:    eba80400    ....    SUB      r4,r8,r0
        0x01006e9a:    f5045480    ...T    ADD      r4,r4,#0x1000
        0x01006e9e:    2301        .#      MOVS     r3,#1
        0x01006ea0:    4622        "F      MOV      r2,r4
        0x01006ea2:    a904        ..      ADD      r1,sp,#0x10
        0x01006ea4:    a803        ..      ADD      r0,sp,#0xc
        0x01006ea6:    f000f84f    ..O.    BL       write_incr ; 0x1006f48
        0x01006eaa:    2800        .(      CMP      r0,#0
        0x01006eac:    d1ab        ..      BNE      0x1006e06 ; write_compacted_items + 78
        0x01006eae:    9803        ..      LDR      r0,[sp,#0xc]
        0x01006eb0:    1b01        ..      SUBS     r1,r0,r4
        0x01006eb2:    4648        HF      MOV      r0,r9
        0x01006eb4:    f7fffd46    ..F.    BL       tags_cache_rec_add ; 0x1006944
        0x01006eb8:    e024        $.      B        0x1006f04 ; write_compacted_items + 332
        0x01006eba:    9d04        ..      LDR      r5,[sp,#0x10]
        0x01006ebc:    8868        h.      LDRH     r0,[r5,#2]
        0x01006ebe:    f46ed47b    n.{.    BL       get_align_bytes ; 0x757b8
        0x01006ec2:    8869        i.      LDRH     r1,[r5,#2]
        0x01006ec4:    1846        F.      ADDS     r6,r0,r1
        0x01006ec6:    2301        .#      MOVS     r3,#1
        0x01006ec8:    2208        ."      MOVS     r2,#8
        0x01006eca:    a904        ..      ADD      r1,sp,#0x10
        0x01006ecc:    a803        ..      ADD      r0,sp,#0xc
        0x01006ece:    f000f83b    ..;.    BL       write_incr ; 0x1006f48
        0x01006ed2:    2800        .(      CMP      r0,#0
        0x01006ed4:    d197        ..      BNE      0x1006e06 ; write_compacted_items + 78
        0x01006ed6:    9804        ..      LDR      r0,[sp,#0x10]
        0x01006ed8:    eba80400    ....    SUB      r4,r8,r0
        0x01006edc:    f5045480    ...T    ADD      r4,r4,#0x1000
        0x01006ee0:    42b4        .B      CMP      r4,r6
        0x01006ee2:    d300        ..      BCC      0x1006ee6 ; write_compacted_items + 302
        0x01006ee4:    4634        4F      MOV      r4,r6
        0x01006ee6:    b13c        <.      CBZ      r4,0x1006ef8 ; write_compacted_items + 320
        0x01006ee8:    2300        .#      MOVS     r3,#0
        0x01006eea:    4622        "F      MOV      r2,r4
        0x01006eec:    a904        ..      ADD      r1,sp,#0x10
        0x01006eee:    a803        ..      ADD      r0,sp,#0xc
        0x01006ef0:    f000f82a    ..*.    BL       write_incr ; 0x1006f48
        0x01006ef4:    2800        .(      CMP      r0,#0
        0x01006ef6:    d186        ..      BNE      0x1006e06 ; write_compacted_items + 78
        0x01006ef8:    9803        ..      LDR      r0,[sp,#0xc]
        0x01006efa:    1b01        ..      SUBS     r1,r0,r4
        0x01006efc:    3908        .9      SUBS     r1,r1,#8
        0x01006efe:    4628        (F      MOV      r0,r5
        0x01006f00:    f7fffd20    .. .    BL       tags_cache_rec_add ; 0x1006944
        0x01006f04:    2000        .       MOVS     r0,#0
        0x01006f06:    e77e        ~.      B        0x1006e06 ; write_compacted_items + 78
    $d
        0x01006f08:    008023cc    .#..    DCD    8397772
        0x01006f0c:    00801f64    d...    DCD    8396644
        0x01006f10:    01007c0c    .|..    DCD    16808972
        0x01006f14:    3a353a52    R:5:    DCD    976566866
        0x01006f18:    202c7325    %s,     DCD    539783973
        0x01006f1c:    2064254c    L%d     DCD    543434060
        0x01006f20:    73616c66    flas    DCD    1935764582
        0x01006f24:    74732068    h st    DCD    1953701992
        0x01006f28:    20657461    ate     DCD    543519841
        0x01006f2c:    30257830    0x%0    DCD    807761968
        0x01006f30:    202c5832    2X,     DCD    539777074
        0x01006f34:    6f727265    erro    DCD    1869771365
        0x01006f38:    78302072    r 0x    DCD    2016419954
        0x01006f3c:    58383025    %08X    DCD    1480077349
        0x01006f40:    00000a0d    ....    DCD    2573
        0x01006f44:    008032d8    .2..    DCD    8401624
    $t
    i.write_incr
    write_incr
        0x01006f48:    b570        p.      PUSH     {r4-r6,lr}
        0x01006f4a:    4605        .F      MOV      r5,r0
        0x01006f4c:    460e        .F      MOV      r6,r1
        0x01006f4e:    4614        .F      MOV      r4,r2
        0x01006f50:    6828        (h      LDR      r0,[r5,#0]
        0x01006f52:    6831        1h      LDR      r1,[r6,#0]
        0x01006f54:    2b00        .+      CMP      r3,#0
        0x01006f56:    d003        ..      BEQ      0x1006f60 ; write_incr + 24
        0x01006f58:    4622        "F      MOV      r2,r4
        0x01006f5a:    f7fcfd89    ....    BL       dec_flash_write ; 0x1003a70
        0x01006f5e:    e002        ..      B        0x1006f66 ; write_incr + 30
        0x01006f60:    4622        "F      MOV      r2,r4
        0x01006f62:    f7fdfa3b    ..;.    BL       hal_flash_write_r ; 0x10043dc
        0x01006f66:    42a0        .B      CMP      r0,r4
        0x01006f68:    d001        ..      BEQ      0x1006f6e ; write_incr + 38
        0x01006f6a:    2008        .       MOVS     r0,#8
        0x01006f6c:    bd70        p.      POP      {r4-r6,pc}
        0x01006f6e:    6828        (h      LDR      r0,[r5,#0]
        0x01006f70:    4420         D      ADD      r0,r0,r4
        0x01006f72:    6028        (`      STR      r0,[r5,#0]
        0x01006f74:    6830        0h      LDR      r0,[r6,#0]
        0x01006f76:    4420         D      ADD      r0,r0,r4
        0x01006f78:    6030        0`      STR      r0,[r6,#0]
        0x01006f7a:    4803        .H      LDR      r0,[pc,#12] ; [0x1006f88] = 0x8032d8
        0x01006f7c:    6801        .h      LDR      r1,[r0,#0]
        0x01006f7e:    4421        !D      ADD      r1,r1,r4
        0x01006f80:    6001        .`      STR      r1,[r0,#0]
        0x01006f82:    2000        .       MOVS     r0,#0
        0x01006f84:    bd70        p.      POP      {r4-r6,pc}
    $d
        0x01006f86:    0000        ..      DCW    0
        0x01006f88:    008032d8    .2..    DCD    8401624
    $t
    i.write_item
    write_item
        0x01006f8c:    e92d4ff7    -..O    PUSH     {r0-r2,r4-r11,lr}
        0x01006f90:    b086        ..      SUB      sp,sp,#0x18
        0x01006f92:    4604        .F      MOV      r4,r0
        0x01006f94:    460d        .F      MOV      r5,r1
        0x01006f96:    4628        (F      MOV      r0,r5
        0x01006f98:    f46ed40e    n...    BL       get_align_bytes ; 0x757b8
        0x01006f9c:    b2c6        ..      UXTB     r6,r0
        0x01006f9e:    f8ad4010    ...@    STRH     r4,[sp,#0x10]
        0x01006fa2:    f8ad5012    ...P    STRH     r5,[sp,#0x12]
        0x01006fa6:    a804        ..      ADD      r0,sp,#0x10
        0x01006fa8:    f7fcfe55    ..U.    BL       gen_hdr_checksum ; 0x1003c56
        0x01006fac:    a804        ..      ADD      r0,sp,#0x10
        0x01006fae:    9908        ..      LDR      r1,[sp,#0x20]
        0x01006fb0:    f7fcfe58    ..X.    BL       gen_value_checksum ; 0x1003c64
        0x01006fb4:    f04f0800    O...    MOV      r8,#0
        0x01006fb8:    f8ad8016    ....    STRH     r8,[sp,#0x16]
        0x01006fbc:    2403        .$      MOVS     r4,#3
        0x01006fbe:    f8df90fc    ....    LDR      r9,[pc,#252] ; [0x10070bc] = 0x8023cc
        0x01006fc2:    4f3f        ?O      LDR      r7,[pc,#252] ; [0x10070c0] = 0x8032d8
        0x01006fc4:    2208        ."      MOVS     r2,#8
        0x01006fc6:    f8d91000    ....    LDR      r1,[r9,#0]
        0x01006fca:    6838        8h      LDR      r0,[r7,#0]
        0x01006fcc:    4408        .D      ADD      r0,r0,r1
        0x01006fce:    a904        ..      ADD      r1,sp,#0x10
        0x01006fd0:    f7fcfd4e    ..N.    BL       dec_flash_write ; 0x1003a70
        0x01006fd4:    2808        .(      CMP      r0,#8
        0x01006fd6:    d003        ..      BEQ      0x1006fe0 ; write_item + 84
        0x01006fd8:    1e64        d.      SUBS     r4,r4,#1
        0x01006fda:    f01404ff    ....    ANDS     r4,r4,#0xff
        0x01006fde:    d1f1        ..      BNE      0x1006fc4 ; write_item + 56
        0x01006fe0:    4c38        8L      LDR      r4,[pc,#224] ; [0x10070c4] = 0x801f64
        0x01006fe2:    f44f4a00    O..J    MOV      r10,#0x8000
        0x01006fe6:    2808        .(      CMP      r0,#8
        0x01006fe8:    d026        &.      BEQ      0x1007038 ; write_item + 172
        0x01006fea:    69a1        .i      LDR      r1,[r4,#0x18]
        0x01006fec:    7a60        `z      LDRB     r0,[r4,#9]
        0x01006fee:    f2403292    @..2    MOV      r2,#0x392
        0x01006ff2:    e9cd2000    ...     STRD     r2,r0,[sp,#0]
        0x01006ff6:    9102        ..      STR      r1,[sp,#8]
        0x01006ff8:    4b33        3K      LDR      r3,[pc,#204] ; [0x10070c8] = 0x1007c01
        0x01006ffa:    a234        4.      ADR      r2,{pc}+0xd2 ; 0x10070cc
        0x01006ffc:    4651        QF      MOV      r1,r10
        0x01006ffe:    2000        .       MOVS     r0,#0
        0x01007000:    f405d6cc    ....    BL       dbg_log_printf ; 0xcd9c
        0x01007004:    f8ad8010    ....    STRH     r8,[sp,#0x10]
        0x01007008:    f8ad8012    ....    STRH     r8,[sp,#0x12]
        0x0100700c:    f88d8014    ....    STRB     r8,[sp,#0x14]
        0x01007010:    f88d8015    ....    STRB     r8,[sp,#0x15]
        0x01007014:    6838        8h      LDR      r0,[r7,#0]
        0x01007016:    f8d91000    ....    LDR      r1,[r9,#0]
        0x0100701a:    2208        ."      MOVS     r2,#8
        0x0100701c:    4408        .D      ADD      r0,r0,r1
        0x0100701e:    a904        ..      ADD      r1,sp,#0x10
        0x01007020:    f7fcfd26    ..&.    BL       dec_flash_write ; 0x1003a70
        0x01007024:    6838        8h      LDR      r0,[r7,#0]
        0x01007026:    3008        .0      ADDS     r0,r0,#8
        0x01007028:    6038        8`      STR      r0,[r7,#0]
        0x0100702a:    6878        xh      LDR      r0,[r7,#4]
        0x0100702c:    3808        .8      SUBS     r0,r0,#8
        0x0100702e:    6078        x`      STR      r0,[r7,#4]
        0x01007030:    2009        .       MOVS     r0,#9
        0x01007032:    b009        ..      ADD      sp,sp,#0x24
        0x01007034:    e8bd8ff0    ....    POP      {r4-r11,pc}
        0x01007038:    f1050008    ....    ADD      r0,r5,#8
        0x0100703c:    fa1ffb80    ....    UXTH     r11,r0
        0x01007040:    f8d90000    ....    LDR      r0,[r9,#0]
        0x01007044:    6839        9h      LDR      r1,[r7,#0]
        0x01007046:    3008        .0      ADDS     r0,r0,#8
        0x01007048:    4435        5D      ADD      r5,r5,r6
        0x0100704a:    4408        .D      ADD      r0,r0,r1
        0x0100704c:    462a        *F      MOV      r2,r5
        0x0100704e:    9908        ..      LDR      r1,[sp,#0x20]
        0x01007050:    f7fdf9c4    ....    BL       hal_flash_write_r ; 0x10043dc
        0x01007054:    42a8        .B      CMP      r0,r5
        0x01007056:    d108        ..      BNE      0x100706a ; write_item + 222
        0x01007058:    6838        8h      LDR      r0,[r7,#0]
        0x0100705a:    f8d91000    ....    LDR      r1,[r9,#0]
        0x0100705e:    4401        .D      ADD      r1,r1,r0
        0x01007060:    a804        ..      ADD      r0,sp,#0x10
        0x01007062:    f7fffc6f    ..o.    BL       tags_cache_rec_add ; 0x1006944
        0x01007066:    2000        .       MOVS     r0,#0
        0x01007068:    e017        ..      B        0x100709a ; write_item + 270
        0x0100706a:    69a0        .i      LDR      r0,[r4,#0x18]
        0x0100706c:    7a61        az      LDRB     r1,[r4,#9]
        0x0100706e:    f44f726c    O.lr    MOV      r2,#0x3b0
        0x01007072:    e9cd2100    ...!    STRD     r2,r1,[sp,#0]
        0x01007076:    9002        ..      STR      r0,[sp,#8]
        0x01007078:    4b13        .K      LDR      r3,[pc,#76] ; [0x10070c8] = 0x1007c01
        0x0100707a:    a214        ..      ADR      r2,{pc}+0x52 ; 0x10070cc
        0x0100707c:    4651        QF      MOV      r1,r10
        0x0100707e:    2000        .       MOVS     r0,#0
        0x01007080:    f405d68c    ....    BL       dbg_log_printf ; 0xcd9c
        0x01007084:    f8ad8010    ....    STRH     r8,[sp,#0x10]
        0x01007088:    6838        8h      LDR      r0,[r7,#0]
        0x0100708a:    f8d91000    ....    LDR      r1,[r9,#0]
        0x0100708e:    2208        ."      MOVS     r2,#8
        0x01007090:    4408        .D      ADD      r0,r0,r1
        0x01007092:    a904        ..      ADD      r1,sp,#0x10
        0x01007094:    f7fcfcec    ....    BL       dec_flash_write ; 0x1003a70
        0x01007098:    2009        .       MOVS     r0,#9
        0x0100709a:    683a        :h      LDR      r2,[r7,#0]
        0x0100709c:    eb0b0106    ....    ADD      r1,r11,r6
        0x010070a0:    440a        .D      ADD      r2,r2,r1
        0x010070a2:    603a        :`      STR      r2,[r7,#0]
        0x010070a4:    687a        zh      LDR      r2,[r7,#4]
        0x010070a6:    3208        .2      ADDS     r2,r2,#8
        0x010070a8:    1a51        Q.      SUBS     r1,r2,r1
        0x010070aa:    2908        .)      CMP      r1,#8
        0x010070ac:    d902        ..      BLS      0x10070b4 ; write_item + 296
        0x010070ae:    3908        .9      SUBS     r1,r1,#8
        0x010070b0:    6079        y`      STR      r1,[r7,#4]
        0x010070b2:    e7be        ..      B        0x1007032 ; write_item + 166
        0x010070b4:    7239        9r      STRB     r1,[r7,#8]
        0x010070b6:    f8c78004    ....    STR      r8,[r7,#4]
        0x010070ba:    e7ba        ..      B        0x1007032 ; write_item + 166
    $d
        0x010070bc:    008023cc    .#..    DCD    8397772
        0x010070c0:    008032d8    .2..    DCD    8401624
        0x010070c4:    00801f64    d...    DCD    8396644
        0x010070c8:    01007c01    .|..    DCD    16808961
        0x010070cc:    3a353a52    R:5:    DCD    976566866
        0x010070d0:    202c7325    %s,     DCD    539783973
        0x010070d4:    2064254c    L%d     DCD    543434060
        0x010070d8:    73616c66    flas    DCD    1935764582
        0x010070dc:    74732068    h st    DCD    1953701992
        0x010070e0:    20657461    ate     DCD    543519841
        0x010070e4:    30257830    0x%0    DCD    807761968
        0x010070e8:    202c5832    2X,     DCD    539777074
        0x010070ec:    6f727265    erro    DCD    1869771365
        0x010070f0:    78302072    r 0x    DCD    2016419954
        0x010070f4:    58383025    %08X    DCD    1480077349
        0x010070f8:    00000a0d    ....    DCD    2573
    $t
    x$fpl$basic
    $v0
    __aeabi_dneg
    _dneg
        0x010070fc:    f0814100    ...A    EOR      r1,r1,#0x80000000
        0x01007100:    4770        pG      BX       lr
    __aeabi_fneg
    _fneg
        0x01007102:    f0804000    ...@    EOR      r0,r0,#0x80000000
        0x01007106:    4770        pG      BX       lr
    _dabs
        0x01007108:    f0214100    !..A    BIC      r1,r1,#0x80000000
        0x0100710c:    4770        pG      BX       lr
    _fabs
        0x0100710e:    f0204000     ..@    BIC      r0,r0,#0x80000000
        0x01007112:    4770        pG      BX       lr
    x$fpl$d2f
    $v0
    __aeabi_d2f
    _d2f
        0x01007114:    f0214200    !..B    BIC      r2,r1,#0x80000000
        0x01007118:    f1a25260    ..`R    SUB      r2,r2,#0x38000000
        0x0100711c:    f5b21f80    ....    CMP      r2,#0x100000
        0x01007120:    f0014300    ...C    AND      r3,r1,#0x80000000
        0x01007124:    bf28        (.      IT       CS
        0x01007126:    f1d26c7f    ...l    RSBSCS   r12,r2,#0xff00000
        0x0100712a:    d90b        ..      BLS      0x1007144 ; __aeabi_d2f + 48
        0x0100712c:    ea5f1c00    _...    LSLS     r12,r0,#4
        0x01007130:    ea4302c2    C...    ORR      r2,r3,r2,LSL #3
        0x01007134:    eb427050    B.Pp    ADC      r0,r2,r0,LSR #29
        0x01007138:    bf18        ..      IT       NE
        0x0100713a:    4770        pG      BXNE     lr
        0x0100713c:    bf28        (.      IT       CS
        0x0100713e:    f0200001     ...    BICCS    r0,r0,#1
        0x01007142:    4770        pG      BX       lr
        0x01007144:    f5b21f80    ....    CMP      r2,#0x100000
        0x01007148:    bfbc        ..      ITT      LT
        0x0100714a:    4618        .F      MOVLT    r0,r3
        0x0100714c:    4770        pG      BXLT     lr
        0x0100714e:    ea4f0c41    O.A.    LSL      r12,r1,#1
        0x01007152:    f51c1f00    ....    CMN      r12,#0x200000
        0x01007156:    d202        ..      BCS      0x100715e ; __aeabi_d2f + 74
        0x01007158:    4608        .F      MOV      r0,r1
        0x0100715a:    f000bcbc    ....    B.W      __fpl_fretinf ; 0x1007ad6
        0x0100715e:    b570        p.      PUSH     {r4-r6,lr}
        0x01007160:    f000fb6a    ..j.    BL       __fpl_dnaninf ; 0x1007838
    $d
        0x01007164:    89000000    ....    DCD    2298478592
    $t
        0x01007168:    f7ffbff6    ....    B.W      0x1007158 ; __aeabi_d2f + 68
        0x0100716c:    f04f4000    O..@    MOV      r0,#0x80000000
        0x01007170:    f5a00080    ....    SUB      r0,r0,#0x400000
        0x01007174:    4770        pG      BX       lr
        0x01007176:    0000        ..      MOVS     r0,r0
    x$fpl$dadd
    $v0
    __aeabi_dadd
    _dadd
        0x01007178:    b510        ..      PUSH     {r4,lr}
        0x0100717a:    ea910f03    ....    TEQ      r1,r3
        0x0100717e:    bf48        H.      IT       MI
        0x01007180:    f0834300    ...C    EORMI    r3,r3,#0x80000000
        0x01007184:    f10083c0    ....    BMI.W    _dsub1 ; 0x1007908
    _dadd1
        0x01007188:    1a84        ..      SUBS     r4,r0,r2
        0x0100718a:    eb710c03    q...    SBCS     r12,r1,r3
        0x0100718e:    d205        ..      BCS      0x100719c ; _dadd1 + 20
        0x01007190:    1912        ..      ADDS     r2,r2,r4
        0x01007192:    eb43030c    C...    ADC      r3,r3,r12
        0x01007196:    1b00        ..      SUBS     r0,r0,r4
        0x01007198:    eb61010c    a...    SBC      r1,r1,r12
        0x0100719c:    f8dfe124    ..$.    LDR      lr,[pc,#292] ; [0x10072c4] = 0xffe00000
        0x010071a0:    ea4f5411    O..T    LSR      r4,r1,#20
        0x010071a4:    eba45c13    ...\    SUB      r12,r4,r3,LSR #20
        0x010071a8:    ea1e0f43    ..C.    TST      lr,r3,LSL #1
        0x010071ac:    bf18        ..      IT       NE
        0x010071ae:    ea9e5f44    ..D_    TEQNE    lr,r4,LSL #21
        0x010071b2:    d073        s.      BEQ      0x100729c ; _dadd1 + 276
        0x010071b4:    ea23030e    #...    BIC      r3,r3,lr
        0x010071b8:    f1dc0e20    .. .    RSBS     lr,r12,#0x20
        0x010071bc:    ea215104    !..Q    BIC      r1,r1,r4,LSL #20
        0x010071c0:    f4431380    C...    ORR      r3,r3,#0x100000
        0x010071c4:    d332        2.      BCC      0x100722c ; _dadd1 + 164
        0x010071c6:    fa22fe0c    "...    LSR      lr,r2,r12
        0x010071ca:    eb10000e    ....    ADDS     r0,r0,lr
        0x010071ce:    fa23fe0c    #...    LSR      lr,r3,r12
        0x010071d2:    eb41010e    A...    ADC      r1,r1,lr
        0x010071d6:    f1cc0e20    .. .    RSB      lr,r12,#0x20
        0x010071da:    fa03fe0e    ....    LSL      lr,r3,lr
        0x010071de:    eb10000e    ....    ADDS     r0,r0,lr
        0x010071e2:    f1510100    Q...    ADCS     r1,r1,#0
        0x010071e6:    f5b11f80    ....    CMP      r1,#0x100000
        0x010071ea:    f1cc0e20    .. .    RSB      lr,r12,#0x20
        0x010071ee:    d232        2.      BCS      0x1007256 ; _dadd1 + 206
        0x010071f0:    eb015104    ...Q    ADD      r1,r1,r4,LSL #20
        0x010071f4:    fa12f20e    ....    LSLS     r2,r2,lr
        0x010071f8:    e8bd4010    ...@    POP      {r4,lr}
        0x010071fc:    bf58        X.      IT       PL
        0x010071fe:    4770        pG      BXPL     lr
        0x01007200:    1c40        @.      ADDS     r0,r0,#1
        0x01007202:    bf38        8.      IT       CC
        0x01007204:    ea5f0242    _.B.    LSLSCC   r2,r2,#1
        0x01007208:    bf18        ..      IT       NE
        0x0100720a:    4770        pG      BXNE     lr
        0x0100720c:    2800        .(      CMP      r0,#0
        0x0100720e:    bf14        ..      ITE      NE
        0x01007210:    f0200001     ...    BICNE    r0,r0,#1
        0x01007214:    f1410100    A...    ADCEQ    r1,r1,#0
        0x01007218:    ea4f0341    O.A.    LSL      r3,r1,#1
        0x0100721c:    f5131f00    ....    CMN      r3,#0x200000
        0x01007220:    bf38        8.      IT       CC
        0x01007222:    4770        pG      BXCC     lr
        0x01007224:    f1a141c0    ...A    SUB      r1,r1,#0x60000000
        0x01007228:    f000bb54    ..T.    B.W      __fpl_dretinf ; 0x10078d4
        0x0100722c:    2a01        .*      CMP      r2,#1
        0x0100722e:    eb430203    C...    ADC      r2,r3,r3
        0x01007232:    f1ac0c20    .. .    SUB      r12,r12,#0x20
        0x01007236:    f1dc0e1f    ....    RSBS     lr,r12,#0x1f
        0x0100723a:    bf32        2.      ITEE     CC
        0x0100723c:    f04f0e00    O...    MOVCC    lr,#0
        0x01007240:    fa23f30c    #...    LSRCS    r3,r3,r12
        0x01007244:    eb100003    ....    ADDSCS   r0,r0,r3
        0x01007248:    eb415104    A..Q    ADC      r1,r1,r4,LSL #20
        0x0100724c:    ebb45f11    ..._    CMP      r4,r1,LSR #20
        0x01007250:    d0d0        ..      BEQ      0x10071f4 ; _dadd1 + 108
        0x01007252:    eba15104    ...Q    SUB      r1,r1,r4,LSL #20
        0x01007256:    f5011180    ....    ADD      r1,r1,#0x100000
        0x0100725a:    0849        I.      LSRS     r1,r1,#1
        0x0100725c:    ea5f0030    _.0.    RRXS     r0,r0
        0x01007260:    eb015104    ...Q    ADD      r1,r1,r4,LSL #20
        0x01007264:    d30e        ..      BCC      0x1007284 ; _dadd1 + 252
        0x01007266:    f1500000    P...    ADCS     r0,r0,#0
        0x0100726a:    bf38        8.      IT       CC
        0x0100726c:    fa12fe0e    ....    LSLSCC   lr,r2,lr
        0x01007270:    d108        ..      BNE      0x1007284 ; _dadd1 + 252
        0x01007272:    e8bd4010    ...@    POP      {r4,lr}
        0x01007276:    e7c9        ..      B        0x100720c ; _dadd1 + 132
        0x01007278:    1c40        @.      ADDS     r0,r0,#1
        0x0100727a:    bf38        8.      IT       CC
        0x0100727c:    ea5f0242    _.B.    LSLSCC   r2,r2,#1
        0x01007280:    d1ca        ..      BNE      0x1007218 ; _dadd1 + 144
        0x01007282:    e7c3        ..      B        0x100720c ; _dadd1 + 132
        0x01007284:    e8bd4010    ...@    POP      {r4,lr}
        0x01007288:    ea4f0341    O.A.    LSL      r3,r1,#1
        0x0100728c:    f5131f00    ....    CMN      r3,#0x200000
        0x01007290:    bf38        8.      IT       CC
        0x01007292:    4770        pG      BXCC     lr
        0x01007294:    f1a141c0    ...A    SUB      r1,r1,#0x60000000
        0x01007298:    f000bb1c    ....    B.W      __fpl_dretinf ; 0x10078d4
        0x0100729c:    ea9e5f44    ..D_    TEQ      lr,r4,LSL #21
        0x010072a0:    d008        ..      BEQ      0x10072b4 ; _dadd1 + 300
        0x010072a2:    ea110f5e    ..^.    TST      r1,lr,LSR #1
        0x010072a6:    e8bd4010    ...@    POP      {r4,lr}
        0x010072aa:    bf04        ..      ITT      EQ
        0x010072ac:    f0014100    ...A    ANDEQ    r1,r1,#0x80000000
        0x010072b0:    2000        .       MOVEQ    r0,#0
        0x010072b2:    4770        pG      BX       lr
        0x010072b4:    e8bd4010    ...@    POP      {r4,lr}
        0x010072b8:    b570        p.      PUSH     {r4-r6,lr}
        0x010072ba:    f000fabd    ....    BL       __fpl_dnaninf ; 0x1007838
        0x010072be:    bf00        ..      NOP      
    $d
        0x010072c0:    3ebefb64    d..>    DCD    1052703588
        0x010072c4:    ffe00000    ....    DCD    4292870144
    $t
    x$fpl$ddiv
    $v0
    __aeabi_ddiv
    _ddiv
        0x010072c8:    e92d41c0    -..A    PUSH     {r6-r8,lr}
        0x010072cc:    b430        0.      PUSH     {r4,r5}
    ddiv_entry
        0x010072ce:    f8dfc2a0    ....    LDR      r12,[pc,#672] ; [0x1007570] = 0x7ff0000
        0x010072d2:    ea3c1411    <...    BICS     r4,r12,r1,LSR #4
        0x010072d6:    bf18        ..      IT       NE
        0x010072d8:    ea3c1413    <...    BICSNE   r4,r12,r3,LSR #4
        0x010072dc:    f00080ec    ....    BEQ.W    0x10074b8 ; ddiv_entry + 490
        0x010072e0:    ea810503    ....    EOR      r5,r1,r3
        0x010072e4:    ea1c1411    ....    ANDS     r4,r12,r1,LSR #4
        0x010072e8:    ea4474d5    D..t    ORR      r4,r4,r5,LSR #31
        0x010072ec:    bf18        ..      IT       NE
        0x010072ee:    ea1c1513    ....    ANDSNE   r5,r12,r3,LSR #4
        0x010072f2:    f00080c7    ....    BEQ.W    0x1007484 ; ddiv_entry + 438
        0x010072f6:    eba40405    ....    SUB      r4,r4,r5
        0x010072fa:    f04f4500    O..E    MOV      r5,#0x80000000
        0x010072fe:    ea4521c1    E..!    ORR      r1,r5,r1,LSL #11
        0x01007302:    ea4523c3    E..#    ORR      r3,r5,r3,LSL #11
        0x01007306:    ea415150    A.PQ    ORR      r1,r1,r0,LSR #21
        0x0100730a:    ea435352    C.RS    ORR      r3,r3,r2,LSR #21
        0x0100730e:    f104747f    ...t    ADD      r4,r4,#0x3fc0000
        0x01007312:    4299        .B      CMP      r1,r3
        0x01007314:    f5043400    ...4    ADD      r4,r4,#0x20000
        0x01007318:    ea4f20c0    O..     LSL      r0,r0,#11
        0x0100731c:    ea4f22c2    O.."    LSL      r2,r2,#11
        0x01007320:    bf08        ..      IT       EQ
        0x01007322:    4290        .B      CMPEQ    r0,r2
        0x01007324:    f000809c    ....    BEQ.W    0x1007460 ; ddiv_entry + 402
        0x01007328:    ea4f6513    O..e    LSR      r5,r3,#24
        0x0100732c:    f20f1640    ..@.    ADR.W    r6,{pc}+0x144 ; 0x1007470
        0x01007330:    5d76        v]      LDRB     r6,[r6,r5]
        0x01007332:    ea4f4513    O..E    LSR      r5,r3,#16
        0x01007336:    fb06f705    ....    MUL      r7,r6,r5
        0x0100733a:    f1c77780    ...w    RSB      r7,r7,#0x1000000
        0x0100733e:    fb06f707    ....    MUL      r7,r6,r7
        0x01007342:    ea4f37d7    O..7    LSR      r7,r7,#15
        0x01007346:    fba76803    ...h    UMULL    r6,r8,r7,r3
        0x0100734a:    4276        vB      RSBS     r6,r6,#0
        0x0100734c:    f5c83880    ...8    RSB      r8,r8,#0x10000
        0x01007350:    fba7ce06    ....    UMULL    r12,lr,r7,r6
        0x01007354:    bf38        8.      IT       CC
        0x01007356:    f1a80801    ....    SUBCC    r8,r8,#1
        0x0100735a:    fb07e608    ....    MLA      r6,r7,r8,lr
        0x0100735e:    f04f0e00    O...    MOV      lr,#0
        0x01007362:    fba68c02    ....    UMULL    r8,r12,r6,r2
        0x01007366:    fbe6ce03    ....    UMLAL    r12,lr,r6,r3
        0x0100736a:    f1dc0c00    ....    RSBS     r12,r12,#0
        0x0100736e:    f1ce4e00    ...N    RSB      lr,lr,#0x80000000
        0x01007372:    bf38        8.      IT       CC
        0x01007374:    f1ae0e01    ....    SUBCC    lr,lr,#1
        0x01007378:    fba6580c    ...X    UMULL    r5,r8,r6,r12
        0x0100737c:    f04f0700    O...    MOV      r7,#0
        0x01007380:    f04f0500    O...    MOV      r5,#0
        0x01007384:    fbe6870e    ....    UMLAL    r8,r7,r6,lr
        0x01007388:    fba1c608    ....    UMULL    r12,r6,r1,r8
        0x0100738c:    fba0ce07    ....    UMULL    r12,lr,r0,r7
        0x01007390:    eb16060e    ....    ADDS     r6,r6,lr
        0x01007394:    f1450500    E...    ADC      r5,r5,#0
        0x01007398:    fbe16507    ...e    UMLAL    r6,r5,r1,r7
        0x0100739c:    f1154ee0    ...N    ADDS     lr,r5,#0x70000000
        0x010073a0:    bf7e        ~.      ITTT     VC
        0x010073a2:    f5a43480    ...4    SUBVC    r4,r4,#0x10000
        0x010073a6:    ea5f0646    _.F.    LSLSVC   r6,r6,#1
        0x010073aa:    416d        mA      ADCVC    r5,r5,r5
        0x010073ac:    f1160780    ....    ADDS     r7,r6,#0x80
        0x010073b0:    f1450500    E...    ADC      r5,r5,#0
        0x010073b4:    ea4f2717    O..'    LSR      r7,r7,#8
        0x010073b8:    ea4f6606    O..f    LSL      r6,r6,#24
        0x010073bc:    ea476705    G..g    ORR      r7,r7,r5,LSL #24
        0x010073c0:    f1a646de    ...F    SUB      r6,r6,#0x6f000000
        0x010073c4:    f1b65f80    ..._    CMP      r6,#0x10000000
        0x010073c8:    ea4f2515    O..%    LSR      r5,r5,#8
        0x010073cc:    d91f        ..      BLS      0x100740e ; ddiv_entry + 320
        0x010073ce:    4638        8F      MOV      r0,r7
        0x010073d0:    f0240c01    $...    BIC      r12,r4,#1
        0x010073d4:    eb0571c4    ...q    ADD      r1,r5,r4,LSL #31
        0x010073d8:    f1bc6ffe    ...o    CMP      r12,#0x7f00000
        0x010073dc:    eb01110c    ....    ADD      r1,r1,r12,LSL #4
        0x010073e0:    d802        ..      BHI      0x10073e8 ; ddiv_entry + 282
        0x010073e2:    bcf0        ..      POP      {r4-r7}
        0x010073e4:    e8bd8100    ....    POP      {r8,pc}
        0x010073e8:    4224        $B      TST      r4,r4
        0x010073ea:    bf5c        \.      ITT      PL
        0x010073ec:    f5011e80    ....    ADDPL    lr,r1,#0x100000
        0x010073f0:    ea9e7fc4    ....    TEQPL    lr,r4,LSL #31
        0x010073f4:    d402        ..      BMI      0x10073fc ; ddiv_entry + 302
        0x010073f6:    bcf0        ..      POP      {r4-r7}
        0x010073f8:    e8bd8100    ....    POP      {r8,pc}
        0x010073fc:    4224        $B      TST      r4,r4
        0x010073fe:    d438        8.      BMI      0x1007472 ; ddiv_entry + 420
        0x01007400:    bcf0        ..      POP      {r4-r7}
        0x01007402:    f1a141c0    ...A    SUB      r1,r1,#0x60000000
        0x01007406:    e8bd4100    ...A    POP      {r8,lr}
        0x0100740a:    f000ba63    ..c.    B.W      __fpl_dretinf ; 0x10078d4
        0x0100740e:    ea4f22d2    O.."    LSR      r2,r2,#11
        0x01007412:    ea425243    B.CR    ORR      r2,r2,r3,LSL #21
        0x01007416:    ea4f23d3    O..#    LSR      r3,r3,#11
        0x0100741a:    fba78602    ....    UMULL    r8,r6,r7,r2
        0x0100741e:    ea4f20d0    O..     LSR      r0,r0,#11
        0x01007422:    ea405041    @.AP    ORR      r0,r0,r1,LSL #21
        0x01007426:    fb076603    ...f    MLA      r6,r7,r3,r6
        0x0100742a:    ea1e0f0e    ....    TST      lr,lr
        0x0100742e:    ea4f21d1    O..!    LSR      r1,r1,#11
        0x01007432:    fb056602    ...f    MLA      r6,r5,r2,r6
        0x01007436:    bf58        X.      IT       PL
        0x01007438:    eba65600    ...V    SUBPL    r6,r6,r0,LSL #20
        0x0100743c:    ebb65600    ...V    SUBS     r6,r6,r0,LSL #20
        0x01007440:    ea4f0e52    O.R.    LSR      lr,r2,#1
        0x01007444:    ea4e7ec3    N..~    ORR      lr,lr,r3,LSL #31
        0x01007448:    eb180e0e    ....    ADDS     lr,r8,lr
        0x0100744c:    eb560e53    V.S.    ADCS     lr,r6,r3,LSR #1
        0x01007450:    d5bd        ..      BPL      0x10073ce ; ddiv_entry + 256
        0x01007452:    eb180802    ....    ADDS     r8,r8,r2
        0x01007456:    415e        ^A      ADCS     r6,r6,r3
        0x01007458:    1c7f        ..      ADDS     r7,r7,#1
        0x0100745a:    f1550500    U...    ADCS     r5,r5,#0
        0x0100745e:    e7b6        ..      B        0x10073ce ; ddiv_entry + 256
        0x01007460:    f44f1580    O...    MOV      r5,#0x100000
        0x01007464:    f04f0700    O...    MOV      r7,#0
        0x01007468:    f04f0600    O...    MOV      r6,#0
        0x0100746c:    f04f0800    O...    MOV      r8,#0
        0x01007470:    e7ad        ..      B        0x10073ce ; ddiv_entry + 256
        0x01007472:    bcf0        ..      POP      {r4-r7}
        0x01007474:    f04f0000    O...    MOV      r0,#0
        0x01007478:    f10141c0    ...A    ADD      r1,r1,#0x60000000
        0x0100747c:    f0014100    ...A    AND      r1,r1,#0x80000000
        0x01007480:    e8bd8100    ....    POP      {r8,pc}
        0x01007484:    ea111f0c    ....    TST      r1,r12,LSL #4
        0x01007488:    ea0c1513    ....    AND      r5,r12,r3,LSR #4
        0x0100748c:    d000        ..      BEQ      0x1007490 ; ddiv_entry + 450
        0x0100748e:    e00c        ..      B        0x10074aa ; ddiv_entry + 476
        0x01007490:    ea131f0c    ....    TST      r3,r12,LSL #4
        0x01007494:    f0008025    ..%.    BEQ.W    0x10074e2 ; ddiv_entry + 532
        0x01007498:    f04f0000    O...    MOV      r0,#0
        0x0100749c:    bcf0        ..      POP      {r4-r7}
        0x0100749e:    ea810103    ....    EOR      r1,r1,r3
        0x010074a2:    f0014100    ...A    AND      r1,r1,#0x80000000
        0x010074a6:    e8bd8100    ....    POP      {r8,pc}
        0x010074aa:    bcf0        ..      POP      {r4-r7}
        0x010074ac:    e8bd4100    ...A    POP      {r8,lr}
        0x010074b0:    ea810103    ....    EOR      r1,r1,r3
        0x010074b4:    f000ba0e    ....    B.W      __fpl_dretinf ; 0x10078d4
        0x010074b8:    bcf0        ..      POP      {r4-r7}
        0x010074ba:    e8bd4100    ...A    POP      {r8,lr}
        0x010074be:    b570        p.      PUSH     {r4-r6,lr}
        0x010074c0:    f000f9ba    ....    BL       __fpl_dnaninf ; 0x1007838
    $d
        0x010074c4:    3efc7e09    .~.>    DCD    1056734729
    $t
        0x010074c8:    f000b807    ....    B.W      0x10074da ; ddiv_entry + 524
        0x010074cc:    ea810103    ....    EOR      r1,r1,r3
        0x010074d0:    f04f0000    O...    MOV      r0,#0
        0x010074d4:    f0014100    ...A    AND      r1,r1,#0x80000000
        0x010074d8:    4770        pG      BX       lr
        0x010074da:    ea810103    ....    EOR      r1,r1,r3
        0x010074de:    f000b9f9    ....    B.W      __fpl_dretinf ; 0x10078d4
        0x010074e2:    bcf0        ..      POP      {r4-r7}
        0x010074e4:    e8bd4100    ...A    POP      {r8,lr}
        0x010074e8:    f04f0000    O...    MOV      r0,#0
        0x010074ec:    4921        !I      LDR      r1,[pc,#132] ; [0x1007574] = 0x7ff80000
        0x010074ee:    4770        pG      BX       lr
    $d
        0x010074f0:    f9fbfdff    ....    DCD    4194041343
        0x010074f4:    f2f4f5f7    ....    DCD    4076140023
        0x010074f8:    ebedeef0    ....    DCD    3958238960
        0x010074fc:    e4e6e8e9    ....    DCD    3840338153
        0x01007500:    dee0e1e3    ....    DCD    3739279843
        0x01007504:    d8dadbdd    ....    DCD    3638221789
        0x01007508:    d3d4d5d7    ....    DCD    3553940951
        0x0100750c:    cdcfd0d1    ....    DCD    3452948689
        0x01007510:    c8cacbcc    ....    DCD    3368733644
        0x01007514:    c4c5c6c7    ....    DCD    3301295815
        0x01007518:    bfc0c1c2    ....    DCD    3217080770
        0x0100751c:    bbbcbdbe    ....    DCD    3149708734
        0x01007520:    b7b8b9ba    ....    DCD    3082336698
        0x01007524:    b3b4b5b6    ....    DCD    3014964662
        0x01007528:    afb0b1b2    ....    DCD    2947592626
        0x0100752c:    abacadae    ....    DCD    2880220590
        0x01007530:    a8a8a9aa    ....    DCD    2829625770
        0x01007534:    a4a5a6a7    ....    DCD    2762319527
        0x01007538:    a1a2a3a3    ....    DCD    2711790499
        0x0100753c:    9e9f9fa0    ....    DCD    2661261216
        0x01007540:    9b9c9c9d    ....    DCD    2610732189
        0x01007544:    9899999a    ....    DCD    2560203162
        0x01007548:    95969797    ....    DCD    2509674391
        0x0100754c:    93939495    ....    DCD    2475922581
        0x01007550:    90919192    ....    DCD    2425459090
        0x01007554:    8e8e8f8f    ....    DCD    2391707535
        0x01007558:    8b8c8c8d    ....    DCD    2341244045
        0x0100755c:    89898a8b    ....    DCD    2307492491
        0x01007560:    87878888    ....    DCD    2273806472
        0x01007564:    84858586    ....    DCD    2223342982
        0x01007568:    82838384    ....    DCD    2189656964
        0x0100756c:    80818182    ....    DCD    2155970946
        0x01007570:    07ff0000    ....    DCD    134152192
        0x01007574:    7ff80000    ....    DCD    2146959360
    $t
    x$fpl$dfix
    $v0
    __aeabi_d2iz
    _dfix
        0x01007578:    ea4f0341    O.A.    LSL      r3,r1,#1
        0x0100757c:    ea4f5353    O.SS    LSR      r3,r3,#21
        0x01007580:    f5a36380    ...c    SUB      r3,r3,#0x400
        0x01007584:    f1d3031e    ....    RSBS     r3,r3,#0x1e
        0x01007588:    bfc8        ..      IT       GT
        0x0100758a:    f1d30c21    ..!.    RSBSGT   r12,r3,#0x21
        0x0100758e:    dd0c        ..      BLE      0x10075aa ; __aeabi_d2iz + 50
        0x01007590:    f04f4200    O..B    MOV      r2,#0x80000000
        0x01007594:    ea4222c1    B.."    ORR      r2,r2,r1,LSL #11
        0x01007598:    ea425250    B.PR    ORR      r2,r2,r0,LSR #21
        0x0100759c:    fa32fc03    2...    LSRS     r12,r2,r3
        0x010075a0:    ea8c7ce1    ...|    EOR      r12,r12,r1,ASR #31
        0x010075a4:    ebac70e1    ...p    SUB      r0,r12,r1,ASR #31
        0x010075a8:    4770        pG      BX       lr
        0x010075aa:    2b10        .+      CMP      r3,#0x10
        0x010075ac:    bfc4        ..      ITT      GT
        0x010075ae:    2000        .       MOVGT    r0,#0
        0x010075b0:    4770        pG      BXGT     lr
        0x010075b2:    f5037c78    ..x|    ADD      r12,r3,#0x3e0
        0x010075b6:    f1bc3fff    ...?    CMP      r12,#0xffffffff
        0x010075ba:    d004        ..      BEQ      0x10075c6 ; __aeabi_d2iz + 78
        0x010075bc:    f06f4200    o..B    MVN      r2,#0x80000000
        0x010075c0:    ea820021    ..!.    EOR      r0,r2,r1,ASR #32
        0x010075c4:    4770        pG      BX       lr
        0x010075c6:    b570        p.      PUSH     {r4-r6,lr}
        0x010075c8:    f000f936    ..6.    BL       __fpl_dnaninf ; 0x1007838
    $d
        0x010075cc:    80249249    I.$.    DCD    2149880393
    $t
        0x010075d0:    2000        .       MOVS     r0,#0
        0x010075d2:    4770        pG      BX       lr
        0x010075d4:    e7f2        ..      B        0x10075bc ; __aeabi_d2iz + 68
        0x010075d6:    0000        ..      MOVS     r0,r0
    x$fpl$dfixu
    $v0
    __aeabi_d2uiz
    _dfixu
        0x010075d8:    ea4f5311    O..S    LSR      r3,r1,#20
        0x010075dc:    f5a36380    ...c    SUB      r3,r3,#0x400
        0x010075e0:    f1d3031e    ....    RSBS     r3,r3,#0x1e
        0x010075e4:    bfa8        ..      IT       GE
        0x010075e6:    f1d30c20    .. .    RSBSGE   r12,r3,#0x20
        0x010075ea:    db08        ..      BLT      0x10075fe ; __aeabi_d2uiz + 38
        0x010075ec:    f04f4200    O..B    MOV      r2,#0x80000000
        0x010075f0:    ea4222c1    B.."    ORR      r2,r2,r1,LSL #11
        0x010075f4:    ea525250    R.PR    ORRS     r2,r2,r0,LSR #21
        0x010075f8:    fa32f003    2...    LSRS     r0,r2,r3
        0x010075fc:    4770        pG      BX       lr
        0x010075fe:    4209        .B      TST      r1,r1
        0x01007600:    d40b        ..      BMI      0x100761a ; __aeabi_d2uiz + 66
        0x01007602:    2b10        .+      CMP      r3,#0x10
        0x01007604:    bfc4        ..      ITT      GT
        0x01007606:    2000        .       MOVGT    r0,#0
        0x01007608:    4770        pG      BXGT     lr
        0x0100760a:    f5037c78    ..x|    ADD      r12,r3,#0x3e0
        0x0100760e:    f1bc3fff    ...?    CMP      r12,#0xffffffff
        0x01007612:    d005        ..      BEQ      0x1007620 ; __aeabi_d2uiz + 72
        0x01007614:    f04f30ff    O..0    MOV      r0,#0xffffffff
        0x01007618:    4770        pG      BX       lr
        0x0100761a:    f04f0000    O...    MOV      r0,#0
        0x0100761e:    4770        pG      BX       lr
        0x01007620:    b570        p.      PUSH     {r4-r6,lr}
        0x01007622:    f000f909    ....    BL       __fpl_dnaninf ; 0x1007838
        0x01007626:    bf00        ..      NOP      
    $d
        0x01007628:    80249249    I.$.    DCD    2149880393
    $t
        0x0100762c:    2000        .       MOVS     r0,#0
        0x0100762e:    4770        pG      BX       lr
        0x01007630:    e7f0        ..      B        0x1007614 ; __aeabi_d2uiz + 60
    x$fpl$dfltu
    $v0
    __aeabi_ui2d
    _dfltu
        0x01007632:    fab0f380    ....    CLZ      r3,r0
        0x01007636:    fa10f103    ....    LSLS     r1,r0,r3
        0x0100763a:    d00a        ..      BEQ      0x1007652 ; __aeabi_ui2d + 32
        0x0100763c:    f1c3031d    ....    RSB      r3,r3,#0x1d
        0x01007640:    f5036380    ...c    ADD      r3,r3,#0x400
        0x01007644:    ea4f5041    O.AP    LSL      r0,r1,#21
        0x01007648:    ea4f5203    O..R    LSL      r2,r3,#20
        0x0100764c:    eb0221d1    ...!    ADD      r1,r2,r1,LSR #11
        0x01007650:    4770        pG      BX       lr
        0x01007652:    f04f0000    O...    MOV      r0,#0
        0x01007656:    4770        pG      BX       lr
    x$fpl$dfltull
    $v0
    __aeabi_ul2d
    _ll_uto_d
        0x01007658:    fab1f381    ....    CLZ      r3,r1
        0x0100765c:    3b0b        .;      SUBS     r3,r3,#0xb
        0x0100765e:    d320         .      BCC      0x10076a2 ; __aeabi_ul2d + 74
        0x01007660:    4099        .@      LSLS     r1,r1,r3
        0x01007662:    d110        ..      BNE      0x1007686 ; __aeabi_ul2d + 46
        0x01007664:    fab0f380    ....    CLZ      r3,r0
        0x01007668:    fa10f103    ....    LSLS     r1,r0,r3
        0x0100766c:    bf08        ..      IT       EQ
        0x0100766e:    4770        pG      BXEQ     lr
        0x01007670:    f1c3031d    ....    RSB      r3,r3,#0x1d
        0x01007674:    f5036380    ...c    ADD      r3,r3,#0x400
        0x01007678:    ea4f22d1    O.."    LSR      r2,r1,#11
        0x0100767c:    ea4f5041    O.AP    LSL      r0,r1,#21
        0x01007680:    eb025103    ...Q    ADD      r1,r2,r3,LSL #20
        0x01007684:    4770        pG      BX       lr
        0x01007686:    f1c30c20    .. .    RSB      r12,r3,#0x20
        0x0100768a:    fa20fc0c     ...    LSR      r12,r0,r12
        0x0100768e:    4098        .@      LSLS     r0,r0,r3
        0x01007690:    f1c30332    ..2.    RSB      r3,r3,#0x32
        0x01007694:    f5036380    ...c    ADD      r3,r3,#0x400
        0x01007698:    ea41010c    A...    ORR      r1,r1,r12
        0x0100769c:    eb015103    ...Q    ADD      r1,r1,r3,LSL #20
        0x010076a0:    4770        pG      BX       lr
        0x010076a2:    b510        ..      PUSH     {r4,lr}
        0x010076a4:    f1c30400    ....    RSB      r4,r3,#0
        0x010076a8:    f1c30c32    ..2.    RSB      r12,r3,#0x32
        0x010076ac:    f1c40e20    .. .    RSB      lr,r4,#0x20
        0x010076b0:    f50c6280    ...b    ADD      r2,r12,#0x400
        0x010076b4:    fa01fc0e    ....    LSL      r12,r1,lr
        0x010076b8:    fa21f104    !...    LSR      r1,r1,r4
        0x010076bc:    fa00f30e    ....    LSL      r3,r0,lr
        0x010076c0:    40e0        .@      LSRS     r0,r0,r4
        0x010076c2:    e8bd4010    ...@    POP      {r4,lr}
        0x010076c6:    ea40000c    @...    ORR      r0,r0,r12
        0x010076ca:    eb015102    ...Q    ADD      r1,r1,r2,LSL #20
        0x010076ce:    bf38        8.      IT       CC
        0x010076d0:    4770        pG      BXCC     lr
        0x010076d2:    1c40        @.      ADDS     r0,r0,#1
        0x010076d4:    f1410100    A...    ADC      r1,r1,#0
        0x010076d8:    005b        [.      LSLS     r3,r3,#1
        0x010076da:    bf08        ..      IT       EQ
        0x010076dc:    f0200001     ...    BICEQ    r0,r0,#1
        0x010076e0:    4770        pG      BX       lr
        0x010076e2:    0000        ..      MOVS     r0,r0
    x$fpl$dmul
    $v0
    __aeabi_dmul
    _dmul
        0x010076e4:    f8dfc148    ..H.    LDR      r12,[pc,#328] ; [0x1007830] = 0x7ff0000
        0x010076e8:    b570        p.      PUSH     {r4-r6,lr}
        0x010076ea:    ea1c1e11    ....    ANDS     lr,r12,r1,LSR #4
        0x010076ee:    bf1e        ..      ITTT     NE
        0x010076f0:    ea1c1513    ....    ANDSNE   r5,r12,r3,LSR #4
        0x010076f4:    ea9e0f0c    ....    TEQNE    lr,r12
        0x010076f8:    ea950f0c    ....    TEQNE    r5,r12
        0x010076fc:    f000806f    ..o.    BEQ.W    0x10077de ; __aeabi_dmul + 250
        0x01007700:    ea810403    ....    EOR      r4,r1,r3
        0x01007704:    ea23134c    #.L.    BIC      r3,r3,r12,LSL #5
        0x01007708:    ea4e7ed4    N..~    ORR      lr,lr,r4,LSR #31
        0x0100770c:    ea21114c    !.L.    BIC      r1,r1,r12,LSL #5
        0x01007710:    f4411180    A...    ORR      r1,r1,#0x100000
        0x01007714:    f4431380    C...    ORR      r3,r3,#0x100000
        0x01007718:    44ae        .D      ADD      lr,lr,r5
        0x0100771a:    fba14c02    ...L    UMULL    r4,r12,r1,r2
        0x0100771e:    fba06503    ...e    UMULL    r6,r5,r0,r3
        0x01007722:    f1ae7e7f    ...~    SUB      lr,lr,#0x3fc0000
        0x01007726:    1936        6.      ADDS     r6,r6,r4
        0x01007728:    eb55050c    U...    ADCS     r5,r5,r12
        0x0100772c:    fba14c03    ...L    UMULL    r4,r12,r1,r3
        0x01007730:    f14c0300    L...    ADC      r3,r12,#0
        0x01007734:    fba01c02    ....    UMULL    r1,r12,r0,r2
        0x01007738:    eb16060c    ....    ADDS     r6,r6,r12
        0x0100773c:    4165        eA      ADCS     r5,r5,r4
        0x0100773e:    f1530300    S...    ADCS     r3,r3,#0
        0x01007742:    4209        .B      TST      r1,r1
        0x01007744:    bf18        ..      IT       NE
        0x01007746:    f0460601    F...    ORRNE    r6,r6,#1
        0x0100774a:    f4137f00    ....    TST      r3,#0x200
        0x0100774e:    d10b        ..      BNE      0x1007768 ; __aeabi_dmul + 132
        0x01007750:    ea4f3103    O..1    LSL      r1,r3,#12
        0x01007754:    ea4f3005    O..0    LSL      r0,r5,#12
        0x01007758:    0334        4.      LSLS     r4,r6,#12
        0x0100775a:    ea415115    A..Q    ORR      r1,r1,r5,LSR #20
        0x0100775e:    ea405016    @..P    ORR      r0,r0,r6,LSR #20
        0x01007762:    f06f0203    o...    MVN      r2,#3
        0x01007766:    e00a        ..      B        0x100777e ; __aeabi_dmul + 154
        0x01007768:    ea4f21c3    O..!    LSL      r1,r3,#11
        0x0100776c:    ea4f20c5    O..     LSL      r0,r5,#11
        0x01007770:    02f4        ..      LSLS     r4,r6,#11
        0x01007772:    ea415155    A.UQ    ORR      r1,r1,r5,LSR #21
        0x01007776:    ea405056    @.VP    ORR      r0,r0,r6,LSR #21
        0x0100777a:    f06f0202    o...    MVN      r2,#2
        0x0100777e:    eb02422e    ...B    ADD      r2,r2,lr,ASR #16
        0x01007782:    eb015502    ...U    ADD      r5,r1,r2,LSL #20
        0x01007786:    ea8571ce    ...q    EOR      r1,r5,lr,LSL #31
        0x0100778a:    d00a        ..      BEQ      0x10077a2 ; __aeabi_dmul + 190
        0x0100778c:    ea5f0c44    _.D.    LSLS     r12,r4,#1
        0x01007790:    bf18        ..      IT       NE
        0x01007792:    f0244400    $..D    BICNE    r4,r4,#0x80000000
        0x01007796:    f1500000    P...    ADCS     r0,r0,#0
        0x0100779a:    f1410100    A...    ADC      r1,r1,#0
        0x0100779e:    ea2070d4     ..p    BIC      r0,r0,r4,LSR #31
        0x010077a2:    f2407cfe    @..|    MOV      r12,#0x7fe
        0x010077a6:    4562        bE      CMP      r2,r12
        0x010077a8:    d200        ..      BCS      0x10077ac ; __aeabi_dmul + 200
        0x010077aa:    bd70        p.      POP      {r4-r6,pc}
        0x010077ac:    42a8        .B      CMP      r0,r5
        0x010077ae:    bf14        ..      ITE      NE
        0x010077b0:    f04f4480    O..D    MOVNE    r4,#0x40000000
        0x010077b4:    f04f4440    O.@D    MOVEQ    r4,#0xc0000000
        0x010077b8:    2e00        ..      CMP      r6,#0
        0x010077ba:    bf08        ..      IT       EQ
        0x010077bc:    2400        .$      MOVEQ    r4,#0
        0x010077be:    f1be6f80    ...o    CMP      lr,#0x4000000
        0x010077c2:    bfa8        ..      IT       GE
        0x010077c4:    f1a141c0    ...A    SUBGE    r1,r1,#0x60000000
        0x010077c8:    e8bd4070    ..p@    POP      {r4-r6,lr}
        0x010077cc:    f2808082    ....    BGE.W    __fpl_dretinf ; 0x10078d4
        0x010077d0:    f04f0000    O...    MOV      r0,#0
        0x010077d4:    f10141c0    ...A    ADD      r1,r1,#0x60000000
        0x010077d8:    f0014100    ...A    AND      r1,r1,#0x80000000
        0x010077dc:    4770        pG      BX       lr
        0x010077de:    ea9e0f0c    ....    TEQ      lr,r12
        0x010077e2:    ea0c1513    ....    AND      r5,r12,r3,LSR #4
        0x010077e6:    bf18        ..      IT       NE
        0x010077e8:    ea950f0c    ....    TEQNE    r5,r12
        0x010077ec:    d006        ..      BEQ      0x10077fc ; __aeabi_dmul + 280
        0x010077ee:    f04f0000    O...    MOV      r0,#0
        0x010077f2:    ea810e03    ....    EOR      lr,r1,r3
        0x010077f6:    f00e4100    ...A    AND      r1,lr,#0x80000000
        0x010077fa:    bd70        p.      POP      {r4-r6,pc}
        0x010077fc:    f000f81c    ....    BL       __fpl_dnaninf ; 0x1007838
    $d
        0x01007800:    3e010089    ...>    DCD    1040253065
    $t
        0x01007804:    f000b807    ....    B.W      0x1007816 ; __aeabi_dmul + 306
        0x01007808:    f000b809    ....    B.W      0x100781e ; __aeabi_dmul + 314
        0x0100780c:    ea4f0c43    O.C.    LSL      r12,r3,#1
        0x01007810:    ea5f5c5c    _.\\    LSRS     r12,r12,#21
        0x01007814:    d008        ..      BEQ      0x1007828 ; __aeabi_dmul + 324
        0x01007816:    ea810103    ....    EOR      r1,r1,r3
        0x0100781a:    f000b85b    ..[.    B.W      __fpl_dretinf ; 0x10078d4
        0x0100781e:    ea4f0c41    O.A.    LSL      r12,r1,#1
        0x01007822:    ea5f5c5c    _.\\    LSRS     r12,r12,#21
        0x01007826:    d1f6        ..      BNE      0x1007816 ; __aeabi_dmul + 306
        0x01007828:    f04f0000    O...    MOV      r0,#0
        0x0100782c:    4901        .I      LDR      r1,[pc,#4] ; [0x1007834] = 0x7ff80000
        0x0100782e:    4770        pG      BX       lr
    $d
        0x01007830:    07ff0000    ....    DCD    134152192
        0x01007834:    7ff80000    ....    DCD    2146959360
    $t
    x$fpl$dnaninf
    $v0
    __fpl_dnaninf
        0x01007838:    f10e0e02    ....    ADD      lr,lr,#2
        0x0100783c:    f02e0e03    ....    BIC      lr,lr,#3
        0x01007840:    f85e6b04    ^..k    LDR      r6,[lr],#4
        0x01007844:    4236        6B      TST      r6,r6
        0x01007846:    d405        ..      BMI      0x1007854 ; __fpl_dnaninf + 28
        0x01007848:    2a01        .*      CMP      r2,#1
        0x0100784a:    eb430503    C...    ADC      r5,r3,r3
        0x0100784e:    f5151f00    ....    CMN      r5,#0x200000
        0x01007852:    d812        ..      BHI      0x100787a ; __fpl_dnaninf + 66
        0x01007854:    2801        .(      CMP      r0,#1
        0x01007856:    eb410c01    A...    ADC      r12,r1,r1
        0x0100785a:    f51c1f00    ....    CMN      r12,#0x200000
        0x0100785e:    d80c        ..      BHI      0x100787a ; __fpl_dnaninf + 66
        0x01007860:    d10e        ..      BNE      0x1007880 ; __fpl_dnaninf + 72
        0x01007862:    ea4f7cd1    O..|    LSR      r12,r1,#31
        0x01007866:    f5151f00    ....    CMN      r5,#0x200000
        0x0100786a:    eb0c0c4c    ..L.    ADD      r12,r12,r12,LSL #1
        0x0100786e:    f10c0c02    ....    ADD      r12,r12,#2
        0x01007872:    bf08        ..      IT       EQ
        0x01007874:    eb4c7cd3    L..|    ADCEQ    r12,r12,r3,LSR #31
        0x01007878:    e004        ..      B        0x1007884 ; __fpl_dnaninf + 76
        0x0100787a:    f04f0c08    O...    MOV      r12,#8
        0x0100787e:    e001        ..      B        0x1007884 ; __fpl_dnaninf + 76
        0x01007880:    ea4f7cd3    O..|    LSR      r12,r3,#31
        0x01007884:    eb0c054c    ..L.    ADD      r5,r12,r12,LSL #1
        0x01007888:    fa26f605    &...    LSR      r6,r6,r5
        0x0100788c:    f0060607    ....    AND      r6,r6,#7
        0x01007890:    f1b60c04    ....    SUBS     r12,r6,#4
        0x01007894:    d206        ..      BCS      0x10078a4 ; __fpl_dnaninf + 108
        0x01007896:    eb0e0c86    ....    ADD      r12,lr,r6,LSL #2
        0x0100789a:    e8bd4070    ..p@    POP      {r4-r6,lr}
        0x0100789e:    f04c0c01    L...    ORR      r12,r12,#1
        0x010078a2:    4760        `G      BX       r12
        0x010078a4:    e8dff00c    ....    TBB      [pc,r12]
    $d
        0x010078a8:    02020b09    ....    DCD    33688329
    $t
        0x010078ac:    f04f4100    O..A    MOV      r1,#0x80000000
        0x010078b0:    f04f0000    O...    MOV      r0,#0
        0x010078b4:    f5a12100    ...!    SUB      r1,r1,#0x80000
        0x010078b8:    bd70        p.      POP      {r4-r6,pc}
        0x010078ba:    4619        .F      MOV      r1,r3
        0x010078bc:    4610        .F      MOV      r0,r2
        0x010078be:    2801        .(      CMP      r0,#1
        0x010078c0:    eb510401    Q...    ADCS     r4,r1,r1
        0x010078c4:    bf18        ..      IT       NE
        0x010078c6:    f5d41400    ....    RSBSNE   r4,r4,#0x200000
        0x010078ca:    bf84        ..      ITT      HI
        0x010078cc:    2000        .       MOVHI    r0,#0
        0x010078ce:    f0014100    ...A    ANDHI    r1,r1,#0x80000000
        0x010078d2:    bd70        p.      POP      {r4-r6,pc}
    x$fpl$dretinf
    $v0
    __fpl_dretinf
        0x010078d4:    0808        ..      LSRS     r0,r1,#32
        0x010078d6:    f5a01100    ....    SUB      r1,r0,#0x200000
        0x010078da:    ea4f0131    O.1.    RRX      r1,r1
        0x010078de:    4770        pG      BX       lr
    x$fpl$drsb
    $v0
    __aeabi_drsub
    _drsb
        0x010078e0:    ea910f03    ....    TEQ      r1,r3
        0x010078e4:    b510        ..      PUSH     {r4,lr}
        0x010078e6:    f0814100    ...A    EOR      r1,r1,#0x80000000
        0x010078ea:    f53fac4d    ?.M.    BMI      _dadd1 ; 0x1007188
        0x010078ee:    f0834300    ...C    EOR      r3,r3,#0x80000000
        0x010078f2:    f000b809    ....    B.W      _dsub1 ; 0x1007908
        0x010078f6:    0000        ..      MOVS     r0,r0
    x$fpl$dsub
    $v0
    __aeabi_dsub
    _dsub
        0x010078f8:    b510        ..      PUSH     {r4,lr}
        0x010078fa:    ea910f03    ....    TEQ      r1,r3
        0x010078fe:    bf48        H.      IT       MI
        0x01007900:    f0834300    ...C    EORMI    r3,r3,#0x80000000
        0x01007904:    f53fac40    ?.@.    BMI      _dadd1 ; 0x1007188
    _dsub1
        0x01007908:    1a84        ..      SUBS     r4,r0,r2
        0x0100790a:    eb710c03    q...    SBCS     r12,r1,r3
        0x0100790e:    d207        ..      BCS      0x1007920 ; _dsub1 + 24
        0x01007910:    1912        ..      ADDS     r2,r2,r4
        0x01007912:    f08c4c00    ...L    EOR      r12,r12,#0x80000000
        0x01007916:    eb43030c    C...    ADC      r3,r3,r12
        0x0100791a:    1b00        ..      SUBS     r0,r0,r4
        0x0100791c:    eb61010c    a...    SBC      r1,r1,r12
        0x01007920:    f8dfe1a4    ....    LDR      lr,[pc,#420] ; [0x1007ac8] = 0xffe00000
        0x01007924:    ea4f5411    O..T    LSR      r4,r1,#20
        0x01007928:    eba45c13    ...\    SUB      r12,r4,r3,LSR #20
        0x0100792c:    ea1e0f43    ..C.    TST      lr,r3,LSL #1
        0x01007930:    bf18        ..      IT       NE
        0x01007932:    ea9e5f44    ..D_    TEQNE    lr,r4,LSL #21
        0x01007936:    f00080b0    ....    BEQ.W    0x1007a9a ; _dsub1 + 402
        0x0100793a:    ea23036e    #.n.    BIC      r3,r3,lr,ASR #1
        0x0100793e:    4252        RB      RSBS     r2,r2,#0
        0x01007940:    ea215104    !..Q    BIC      r1,r1,r4,LSL #20
        0x01007944:    ebc3036e    ..n.    RSB      r3,r3,lr,ASR #1
        0x01007948:    bf38        8.      IT       CC
        0x0100794a:    1e5b        [.      SUBCC    r3,r3,#1
        0x0100794c:    f1dc0e20    .. .    RSBS     lr,r12,#0x20
        0x01007950:    d325        %.      BCC      0x100799e ; _dsub1 + 150
        0x01007952:    fa22fe0c    "...    LSR      lr,r2,r12
        0x01007956:    eb10000e    ....    ADDS     r0,r0,lr
        0x0100795a:    fa43fe0c    C...    ASR      lr,r3,r12
        0x0100795e:    eb41010e    A...    ADC      r1,r1,lr
        0x01007962:    f1cc0e20    .. .    RSB      lr,r12,#0x20
        0x01007966:    fa03fe0e    ....    LSL      lr,r3,lr
        0x0100796a:    eb10000e    ....    ADDS     r0,r0,lr
        0x0100796e:    f1510100    Q...    ADCS     r1,r1,#0
        0x01007972:    f1cc0e20    .. .    RSB      lr,r12,#0x20
        0x01007976:    d429        ).      BMI      0x10079cc ; _dsub1 + 196
        0x01007978:    fa12f20e    ....    LSLS     r2,r2,lr
        0x0100797c:    eb015104    ...Q    ADD      r1,r1,r4,LSL #20
        0x01007980:    e8bd4010    ...@    POP      {r4,lr}
        0x01007984:    bf58        X.      IT       PL
        0x01007986:    4770        pG      BXPL     lr
        0x01007988:    1c40        @.      ADDS     r0,r0,#1
        0x0100798a:    bf1c        ..      ITT      NE
        0x0100798c:    f1b24f00    ...O    CMPNE    r2,#0x80000000
        0x01007990:    4770        pG      BXNE     lr
        0x01007992:    2800        .(      CMP      r0,#0
        0x01007994:    bf0c        ..      ITE      EQ
        0x01007996:    1c49        I.      ADDEQ    r1,r1,#1
        0x01007998:    f0200001     ...    BICNE    r0,r0,#1
        0x0100799c:    4770        pG      BX       lr
        0x0100799e:    eb120e02    ....    ADDS     lr,r2,r2
        0x010079a2:    eb430203    C...    ADC      r2,r3,r3
        0x010079a6:    bf18        ..      IT       NE
        0x010079a8:    f04f0e01    O...    MOVNE    lr,#1
        0x010079ac:    ea4e0242    N.B.    ORR      r2,lr,r2,LSL #1
        0x010079b0:    f1ac0c20    .. .    SUB      r12,r12,#0x20
        0x010079b4:    f1dc0e1e    ....    RSBS     lr,r12,#0x1e
        0x010079b8:    d954        T.      BLS      0x1007a64 ; _dsub1 + 348
        0x010079ba:    fa43fe0c    C...    ASR      lr,r3,r12
        0x010079be:    eb10000e    ....    ADDS     r0,r0,lr
        0x010079c2:    f15131ff    Q..1    ADCS     r1,r1,#0xffffffff
        0x010079c6:    f1cc0e1e    ....    RSB      lr,r12,#0x1e
        0x010079ca:    d5d5        ..      BPL      0x1007978 ; _dsub1 + 112
        0x010079cc:    f10e0e01    ....    ADD      lr,lr,#1
        0x010079d0:    fa12fe0e    ....    LSLS     lr,r2,lr
        0x010079d4:    4140        @A      ADCS     r0,r0,r0
        0x010079d6:    eb410101    A...    ADC      r1,r1,r1
        0x010079da:    eb015c44    ..D\    ADD      r12,r1,r4,LSL #21
        0x010079de:    ea5f5c5c    _.\\    LSRS     r12,r12,#21
        0x010079e2:    d910        ..      BLS      0x1007a06 ; _dsub1 + 254
        0x010079e4:    eb1070de    ...p    ADDS     r0,r0,lr,LSR #31
        0x010079e8:    eb015104    ...Q    ADD      r1,r1,r4,LSL #20
        0x010079ec:    bf38        8.      IT       CC
        0x010079ee:    f1be4f00    ...O    CMPCC    lr,#0x80000000
        0x010079f2:    e8bd4010    ...@    POP      {r4,lr}
        0x010079f6:    bf18        ..      IT       NE
        0x010079f8:    4770        pG      BXNE     lr
        0x010079fa:    2800        .(      CMP      r0,#0
        0x010079fc:    bf0c        ..      ITE      EQ
        0x010079fe:    1c49        I.      ADDEQ    r1,r1,#1
        0x01007a00:    f0200001     ...    BICNE    r0,r0,#1
        0x01007a04:    4770        pG      BX       lr
        0x01007a06:    d230        0.      BCS      0x1007a6a ; _dsub1 + 354
        0x01007a08:    ea4f2cd4    O..,    LSR      r12,r4,#11
        0x01007a0c:    f5111100    ....    ADDS     r1,r1,#0x200000
        0x01007a10:    f4246400    $..d    BIC      r4,r4,#0x800
        0x01007a14:    d01b        ..      BEQ      0x1007a4e ; _dsub1 + 326
        0x01007a16:    fab1f281    ....    CLZ      r2,r1
        0x01007a1a:    3a0b        .:      SUBS     r2,r2,#0xb
        0x01007a1c:    1aa4        ..      SUBS     r4,r4,r2
        0x01007a1e:    1ea4        ..      SUBS     r4,r4,#2
        0x01007a20:    f1d20320    .. .    RSBS     r3,r2,#0x20
        0x01007a24:    4091        .@      LSLS     r1,r1,r2
        0x01007a26:    fa30f303    0...    LSRS     r3,r0,r3
        0x01007a2a:    4319        .C      ORRS     r1,r1,r3
        0x01007a2c:    4090        .@      LSLS     r0,r0,r2
        0x01007a2e:    eb0171cc    ...q    ADD      r1,r1,r12,LSL #31
        0x01007a32:    2c00        .,      CMP      r4,#0
        0x01007a34:    eb015104    ...Q    ADD      r1,r1,r4,LSL #20
        0x01007a38:    e8bd4010    ...@    POP      {r4,lr}
        0x01007a3c:    bfa8        ..      IT       GE
        0x01007a3e:    4770        pG      BXGE     lr
        0x01007a40:    f10141c0    ...A    ADD      r1,r1,#0x60000000
        0x01007a44:    f04f0000    O...    MOV      r0,#0
        0x01007a48:    f0014100    ...A    AND      r1,r1,#0x80000000
        0x01007a4c:    4770        pG      BX       lr
        0x01007a4e:    fab0f380    ....    CLZ      r3,r0
        0x01007a52:    fa10f103    ....    LSLS     r1,r0,r3
        0x01007a56:    d100        ..      BNE      0x1007a5a ; _dsub1 + 338
        0x01007a58:    bd10        ..      POP      {r4,pc}
        0x01007a5a:    1ae4        ..      SUBS     r4,r4,r3
        0x01007a5c:    3c17        .<      SUBS     r4,r4,#0x17
        0x01007a5e:    0548        H.      LSLS     r0,r1,#21
        0x01007a60:    0ac9        ..      LSRS     r1,r1,#11
        0x01007a62:    e7e4        ..      B        0x1007a2e ; _dsub1 + 294
        0x01007a64:    eb015104    ...Q    ADD      r1,r1,r4,LSL #20
        0x01007a68:    bd10        ..      POP      {r4,pc}
        0x01007a6a:    1049        I.      ASRS     r1,r1,#1
        0x01007a6c:    eb015104    ...Q    ADD      r1,r1,r4,LSL #20
        0x01007a70:    e8bd4010    ...@    POP      {r4,lr}
        0x01007a74:    ea4f0030    O.0.    RRX      r0,r0
        0x01007a78:    e002        ..      B        0x1007a80 ; _dsub1 + 376
        0x01007a7a:    f04f0100    O...    MOV      r1,#0
        0x01007a7e:    4770        pG      BX       lr
        0x01007a80:    004a        J.      LSLS     r2,r1,#1
        0x01007a82:    bf08        ..      IT       EQ
        0x01007a84:    4200        .B      TSTEQ    r0,r0
        0x01007a86:    d0f8        ..      BEQ      0x1007a7a ; _dsub1 + 370
        0x01007a88:    f5b21f00    ....    CMP      r2,#0x200000
        0x01007a8c:    bf28        (.      IT       CS
        0x01007a8e:    4770        pG      BXCS     lr
        0x01007a90:    f0014100    ...A    AND      r1,r1,#0x80000000
        0x01007a94:    f04f0000    O...    MOV      r0,#0
        0x01007a98:    4770        pG      BX       lr
        0x01007a9a:    ea9e5f44    ..D_    TEQ      lr,r4,LSL #21
        0x01007a9e:    d007        ..      BEQ      0x1007ab0 ; _dsub1 + 424
        0x01007aa0:    ea110f5e    ..^.    TST      r1,lr,LSR #1
        0x01007aa4:    e8bd4010    ...@    POP      {r4,lr}
        0x01007aa8:    bf04        ..      ITT      EQ
        0x01007aaa:    2100        .!      MOVEQ    r1,#0
        0x01007aac:    2000        .       MOVEQ    r0,#0
        0x01007aae:    4770        pG      BX       lr
        0x01007ab0:    e8bd4010    ...@    POP      {r4,lr}
        0x01007ab4:    b570        p.      PUSH     {r4-r6,lr}
        0x01007ab6:    f7fffebf    ....    BL       __fpl_dnaninf ; 0x1007838
        0x01007aba:    bf00        ..      NOP      
    $d
        0x01007abc:    3ef6df40    @..>    DCD    1056366400
    $t
        0x01007ac0:    f0834100    ...A    EOR      r1,r3,#0x80000000
        0x01007ac4:    4610        .F      MOV      r0,r2
        0x01007ac6:    4770        pG      BX       lr
    $d
        0x01007ac8:    ffe00000    ....    DCD    4292870144
    $t
    x$fpl$fpinit
    $v0
    _fp_init
        0x01007acc:    f04f7040    O.@p    MOV      r0,#0x3000000
        0x01007ad0:    eee10a10    ....    VMSR     FPSCR,r0
    __fplib_config_fpu_vfp
    __fplib_config_pureend_doubles
        0x01007ad4:    4770        pG      BX       lr
    x$fpl$fretinf
    $v0
    __fpl_fretinf
        0x01007ad6:    21ff        .!      MOVS     r1,#0xff
        0x01007ad8:    ea4150d0    A..P    ORR      r0,r1,r0,LSR #23
        0x01007adc:    05c0        ..      LSLS     r0,r0,#23
        0x01007ade:    4770        pG      BX       lr
    $d.realdata
    .constdata
    sdk_version
    x$fpl$usenofp
    __I$use$fp
        0x01007ae0:    00000102    ....    DCD    258
        0x01007ae4:    02ee0ce7    ....    DCD    49155303
    systemClock
        0x01007ae8:    03d09000    ....    DCD    64000000
        0x01007aec:    02dc6c00    .l..    DCD    48000000
        0x01007af0:    00f42400    .$..    DCD    16000000
        0x01007af4:    016e3600    .6n.    DCD    24000000
        0x01007af8:    00f42400    .$..    DCD    16000000
        0x01007afc:    01e84800    .H..    DCD    32000000
    mcu_clk_2_qspi_clk
        0x01007b00:    00000000    ....    DCD    0
        0x01007b04:    00000001    ....    DCD    1
        0x01007b08:    00000004    ....    DCD    4
        0x01007b0c:    00000003    ....    DCD    3
        0x01007b10:    00000004    ....    DCD    4
        0x01007b14:    00000002    ....    DCD    2
    .constdata
    s_io_pull
        0x01007b18:    00020001    ....    DCD    131073
        0x01007b1c:    00010000    ....    DCD    65536
        0x01007b20:    00000100    ....    DCD    256
        0x01007b24:    00010000    ....    DCD    65536
        0x01007b28:    00000002    ....    DCD    2
    io_info
        0x01007b2c:    a0010000    ....    DCD    2684420096
        0x01007b30:    00000006    ....    DCD    6
        0x01007b34:    a0011000    ....    DCD    2684424192
        0x01007b38:    00000007    ....    DCD    7
        0x01007b3c:    00000000    ....    DCD    0
        0x01007b40:    00000000    ....    DCD    0
    s_io_mode
        0x01007b44:    00000000    ....    DCD    0
        0x01007b48:    00020001    ....    DCD    131073
        0x01007b4c:    00200010    .. .    DCD    2097168
        0x01007b50:    00400030    0.@.    DCD    4194352
        0x01007b54:    00000000    ....    DCD    0
        0x01007b58:    00010000    ....    DCD    65536
        0x01007b5c:    00100002    ....    DCD    1048578
        0x01007b60:    00300020     .0.    DCD    3145760
        0x01007b64:    00000040    @...    DCD    64
        0x01007b68:    00010001    ....    DCD    65537
        0x01007b6c:    00010001    ....    DCD    65537
        0x01007b70:    00010001    ....    DCD    65537
        0x01007b74:    00010001    ....    DCD    65537
        0x01007b78:    00000000    ....    DCD    0
        0x01007b7c:    0000ffff    ....    DCD    65535
        0x01007b80:    00000000    ....    DCD    0
        0x01007b84:    00000000    ....    DCD    0
        0x01007b88:    00000007    ....    DCD    7
        0x01007b8c:    000000ff    ....    DCD    255
        0x01007b90:    00000000    ....    DCD    0
        0x01007b94:    00000000    ....    DCD    0
        0x01007b98:    00000007    ....    DCD    7
        0x01007b9c:    0000001f    ....    DCD    31
        0x01007ba0:    00000001    ....    DCD    1
        0x01007ba4:    00000001    ....    DCD    1
        0x01007ba8:    00000002    ....    DCD    2
        0x01007bac:    00000007    ....    DCD    7
    .constdata
    uart_sleep_cb
        0x01007bb0:    01006c71    ql..    DCD    16804977
        0x01007bb4:    00804305    .C..    DCD    8405765
        0x01007bb8:    0000ffff    ....    DCD    65535
        0x01007bbc:    00000201    ....    DCD    513
    s_uart_info
        0x01007bc0:    00000c00    ....    DCD    3072
        0x01007bc4:    a000c600    ....    DCD    2684405248
        0x01007bc8:    00000d01    ....    DCD    3329
        0x01007bcc:    a000c700    ....    DCD    2684405504
    .constdata
    __FUNCTION__
        0x01007bd0:    7364766e    nvds    DCD    1935963758
        0x01007bd4:    696e695f    _ini    DCD    1768843615
        0x01007bd8:    0074        t.      DCW    116
    __FUNCTION__
        0x01007bda:    766e        nv      DCW    30318
        0x01007bdc:    645f7364    ds_d    DCD    1683977060
        0x01007be0:    6c65        el      DCW    27749
        0x01007be2:    00          .       DCB    0
    __FUNCTION__
        0x01007be3:    69          i       DCB    105
        0x01007be4:    5f74696e    nit_    DCD    1601464686
        0x01007be8:    73756e75    unus    DCD    1937075829
        0x01007bec:    6e5f6465    ed_n    DCD    1851745381
        0x01007bf0:    00736476    vds.    DCD    7562358
    __FUNCTION__
        0x01007bf4:    6c706572    repl    DCD    1819305330
        0x01007bf8:    5f656361    ace_    DCD    1600480097
        0x01007bfc:    6d657469    item    DCD    1835365481
        0x01007c00:    00          .       DCB    0
    __FUNCTION__
        0x01007c01:    777269      wri     DCB    119,114,105
        0x01007c04:    695f6574    te_i    DCD    1767859572
        0x01007c08:    006d6574    tem.    DCD    7169396
    __FUNCTION__
        0x01007c0c:    74697277    writ    DCD    1953067639
        0x01007c10:    6f635f65    e_co    DCD    1868783461
        0x01007c14:    6361706d    mpac    DCD    1667330157
        0x01007c18:    5f646574    ted_    DCD    1600415092
        0x01007c1c:    6d657469    item    DCD    1835365481
        0x01007c20:    0073        s.      DCW    115
    __FUNCTION__
        0x01007c22:    6f63        co      DCW    28515
        0x01007c24:    6361706d    mpac    DCD    1667330157
        0x01007c28:    766e5f74    t_nv    DCD    1986944884
        0x01007c2c:    00007364    ds..    DCD    29540
    .constdata
    g_addr_table
        0x01007c30:    00002000    . ..    DCD    8192
        0x01007c34:    00002000    . ..    DCD    8192
        0x01007c38:    00002000    . ..    DCD    8192
        0x01007c3c:    00002000    . ..    DCD    8192
        0x01007c40:    00008000    ....    DCD    32768
        0x01007c44:    00008000    ....    DCD    32768
        0x01007c48:    00008000    ....    DCD    32768
        0x01007c4c:    00008000    ....    DCD    32768
        0x01007c50:    00008000    ....    DCD    32768
        0x01007c54:    00008000    ....    DCD    32768
        0x01007c58:    00008000    ....    DCD    32768
    .constdata
    s_sdk_version
        0x01007c5c:    00080601    ....    DCD    525825
        0x01007c60:    00003081    .0..    DCD    12417
    .constdata
    uc_hextab
        0x01007c64:    33323130    0123    DCD    858927408
        0x01007c68:    37363534    4567    DCD    926299444
        0x01007c6c:    42413938    89AB    DCD    1111570744
        0x01007c70:    46454443    CDEF    DCD    1178944579
        0x01007c74:    00583040    @0X.    DCD    5779520
    lc_hextab
        0x01007c78:    33323130    0123    DCD    858927408
        0x01007c7c:    37363534    4567    DCD    926299444
        0x01007c80:    62613938    89ab    DCD    1650538808
        0x01007c84:    66656463    cdef    DCD    1717920867
        0x01007c88:    00783040    @0x.    DCD    7876672
    .constdata
    maptable
        0x01007c8c:    08000004    ....    DCD    134217732
        0x01007c90:    00000000    ....    DCD    0
        0x01007c94:    02000000    ....    DCD    33554432
        0x01007c98:    00000100    ....    DCD    256
        0x01007c9c:    00000010    ....    DCD    16
    Region$$Table$$Base
        0x01007ca0:    01007cf4    .|..    DCD    16809204
        0x01007ca4:    00804100    .A..    DCD    8405248
        0x01007ca8:    000022ac    ."..    DCD    8876
        0x01007cac:    010020d8    . ..    DCD    16785624
        0x01007cb0:    01009fa0    ....    DCD    16818080
        0x01007cb4:    300063ac    .c.0    DCD    805331884
        0x01007cb8:    000006b4    ....    DCD    1716
        0x01007cbc:    0100207c    | ..    DCD    16785532
        0x01007cc0:    0100a150    P...    DCD    16818512
        0x01007cc4:    30007600    .v.0    DCD    805336576
        0x01007cc8:    00000040    @...    DCD    64
        0x01007ccc:    010020d8    . ..    DCD    16785624
        0x01007cd0:    0100a190    ....    DCD    16818576
        0x01007cd4:    300035cc    .5.0    DCD    805320140
        0x01007cd8:    000005cc    ....    DCD    1484
        0x01007cdc:    010020d8    . ..    DCD    16785624
        0x01007ce0:    0100a150    P...    DCD    16818512
        0x01007ce4:    30006a60    `j.0    DCD    805333600
        0x01007ce8:    00000b50    P...    DCD    2896
        0x01007cec:    010020f4    . ..    DCD    16785652
    .init_array
    Region$$Table$$Limit
    SHT$$INIT_ARRAY$$Base
        0x01007cf0:    ffffea11    ....    DCD    4294961681
    .init_array
    SHT$$INIT_ARRAY$$Limit

** Section #2 'RAM_CODE' (SHT_PROGBITS) [SHF_ALLOC + SHF_EXECINSTR]
    Size   : 8876 bytes (alignment 4)
    Address: 0x00804100

    $t
    RAM_CODE
    $v0
    HardFault_Handler
        0x00804100:    4803        .H      LDR      r0,[pc,#12] ; [0x804110] = 0x30006a60
        0x00804102:    e8a00ff0    ....    STM      r0!,{r4-r11}
        0x00804106:    4668        hF      MOV      r0,sp
        0x00804108:    f000f808    ....    BL       hardfault_trace_handler ; 0x80411c
        0x0080410c:    f7fffffe    ....    BL       0x80410c ; HardFault_Handler + 12
    $d
        0x00804110:    30006a60    `j.0    DCD    805333600
    $t
    SVC_Handler
        0x00804114:    4800        .H      LDR      r0,[pc,#0] ; [0x804118] = 0x804351
        0x00804116:    4700        .G      BX       r0
    $d
        0x00804118:    00804351    QC..    DCD    8405841
    $t
    RAM_CODE
    hardfault_trace_handler
        0x0080411c:    b570        p.      PUSH     {r4-r6,lr}
        0x0080411e:    4604        .F      MOV      r4,r0
        0x00804120:    a01a        ..      ADR      r0,{pc}+0x6c ; 0x80418c
        0x00804122:    f3fef01b    ....    BL       __2printf ; 0x100215c
        0x00804126:    a020         .      ADR      r0,{pc}+0x82 ; 0x8041a8
        0x00804128:    f3fef018    ....    BL       __2printf ; 0x100215c
        0x0080412c:    e9d41200    ....    LDRD     r1,r2,[r4,#0]
        0x00804130:    a026        &.      ADR      r0,{pc}+0x9c ; 0x8041cc
        0x00804132:    f3fef013    ....    BL       __2printf ; 0x100215c
        0x00804136:    e9d41202    ....    LDRD     r1,r2,[r4,#8]
        0x0080413a:    a02b        +.      ADR      r0,{pc}+0xae ; 0x8041e8
        0x0080413c:    f3fef00e    ....    BL       __2printf ; 0x100215c
        0x00804140:    4d30        0M      LDR      r5,[pc,#192] ; [0x804204] = 0x30006a60
        0x00804142:    a031        1.      ADR      r0,{pc}+0xc6 ; 0x804208
        0x00804144:    e9d51200    ....    LDRD     r1,r2,[r5,#0]
        0x00804148:    f3fef008    ....    BL       __2printf ; 0x100215c
        0x0080414c:    e9d51202    ....    LDRD     r1,r2,[r5,#8]
        0x00804150:    a034        4.      ADR      r0,{pc}+0xd4 ; 0x804224
        0x00804152:    f3fef003    ....    BL       __2printf ; 0x100215c
        0x00804156:    e9d51204    ....    LDRD     r1,r2,[r5,#0x10]
        0x0080415a:    a039        9.      ADR      r0,{pc}+0xe6 ; 0x804240
        0x0080415c:    f3fdf7fe    ....    BL       __2printf ; 0x100215c
        0x00804160:    e9d51206    ....    LDRD     r1,r2,[r5,#0x18]
        0x00804164:    a03d        =.      ADR      r0,{pc}+0xf8 ; 0x80425c
        0x00804166:    f3fdf7f9    ....    BL       __2printf ; 0x100215c
        0x0080416a:    e9d41204    ....    LDRD     r1,r2,[r4,#0x10]
        0x0080416e:    a042        B.      ADR      r0,{pc}+0x10a ; 0x804278
        0x00804170:    f3fdf7f4    ....    BL       __2printf ; 0x100215c
        0x00804174:    e9d41206    ....    LDRD     r1,r2,[r4,#0x18]
        0x00804178:    a046        F.      ADR      r0,{pc}+0x11c ; 0x804294
        0x0080417a:    f3fdf7ef    ....    BL       __2printf ; 0x100215c
        0x0080417e:    a00a        ..      ADR      r0,{pc}+0x2a ; 0x8041a8
        0x00804180:    f3fdf7ec    ....    BL       __2printf ; 0x100215c
        0x00804184:    f3fef65c    ..\.    BL       app_log_flush ; 0x1002e40
        0x00804188:    e7fe        ..      B        0x804188 ; hardfault_trace_handler + 108
    cortex_backtrace_fault_handler
        0x0080418a:    4770        pG      BX       lr
    $d
        0x0080418c:    44524148    HARD    DCD    1146241352
        0x00804190:    4c554146    FAUL    DCD    1280655686
        0x00804194:    41432054    T CA    DCD    1094918228
        0x00804198:    54534c4c    LLST    DCD    1414745164
        0x0080419c:    204b4341    ACK     DCD    541803329
        0x008041a0:    4f464e49    INFO    DCD    1330007625
        0x008041a4:    000a0d3a    :...    DCD    658746
        0x008041a8:    3d3d3d3d    ====    DCD    1027423549
        0x008041ac:    3d3d3d3d    ====    DCD    1027423549
        0x008041b0:    3d3d3d3d    ====    DCD    1027423549
        0x008041b4:    3d3d3d3d    ====    DCD    1027423549
        0x008041b8:    3d3d3d3d    ====    DCD    1027423549
        0x008041bc:    3d3d3d3d    ====    DCD    1027423549
        0x008041c0:    3d3d3d3d    ====    DCD    1027423549
        0x008041c4:    3d3d3d3d    ====    DCD    1027423549
        0x008041c8:    00000a0d    ....    DCD    2573
        0x008041cc:    30722020      r0    DCD    812785696
        0x008041d0:    3025203a    : %0    DCD    807739450
        0x008041d4:    20207838    8x      DCD    538998840
        0x008041d8:    72202020       r    DCD    1914708000
        0x008041dc:    25203a31    1: %    DCD    622869041
        0x008041e0:    0d783830    08x.    DCD    225982512
        0x008041e4:    0000000a    ....    DCD    10
        0x008041e8:    32722020      r2    DCD    846340128
        0x008041ec:    3025203a    : %0    DCD    807739450
        0x008041f0:    20207838    8x      DCD    538998840
        0x008041f4:    72202020       r    DCD    1914708000
        0x008041f8:    25203a33    3: %    DCD    622869043
        0x008041fc:    0d783830    08x.    DCD    225982512
        0x00804200:    0000000a    ....    DCD    10
        0x00804204:    30006a60    `j.0    DCD    805333600
        0x00804208:    34722020      r4    DCD    879894560
        0x0080420c:    3025203a    : %0    DCD    807739450
        0x00804210:    20207838    8x      DCD    538998840
        0x00804214:    72202020       r    DCD    1914708000
        0x00804218:    25203a35    5: %    DCD    622869045
        0x0080421c:    0d783830    08x.    DCD    225982512
        0x00804220:    0000000a    ....    DCD    10
        0x00804224:    36722020      r6    DCD    913448992
        0x00804228:    3025203a    : %0    DCD    807739450
        0x0080422c:    20207838    8x      DCD    538998840
        0x00804230:    72202020       r    DCD    1914708000
        0x00804234:    25203a37    7: %    DCD    622869047
        0x00804238:    0d783830    08x.    DCD    225982512
        0x0080423c:    0000000a    ....    DCD    10
        0x00804240:    38722020      r8    DCD    947003424
        0x00804244:    3025203a    : %0    DCD    807739450
        0x00804248:    20207838    8x      DCD    538998840
        0x0080424c:    72202020       r    DCD    1914708000
        0x00804250:    25203a39    9: %    DCD    622869049
        0x00804254:    0d783830    08x.    DCD    225982512
        0x00804258:    0000000a    ....    DCD    10
        0x0080425c:    31722020      r1    DCD    829562912
        0x00804260:    30253a30    0:%0    DCD    807746096
        0x00804264:    20207838    8x      DCD    538998840
        0x00804268:    72202020       r    DCD    1914708000
        0x0080426c:    253a3131    11:%    DCD    624570673
        0x00804270:    0d783830    08x.    DCD    225982512
        0x00804274:    0000000a    ....    DCD    10
        0x00804278:    31722020      r1    DCD    829562912
        0x0080427c:    30253a32    2:%0    DCD    807746098
        0x00804280:    20207838    8x      DCD    538998840
        0x00804284:    6c202020       l    DCD    1814044704
        0x00804288:    25203a72    r: %    DCD    622869106
        0x0080428c:    0d783830    08x.    DCD    225982512
        0x00804290:    0000000a    ....    DCD    10
        0x00804294:    63702020      pc    DCD    1668292640
        0x00804298:    3025203a    : %0    DCD    807739450
        0x0080429c:    20207838    8x      DCD    538998840
        0x008042a0:    78202020       x    DCD    2015371296
        0x008042a4:    3a727370    psr:    DCD    980579184
        0x008042a8:    38302520     %08    DCD    942679328
        0x008042ac:    000a0d78    x...    DCD    658808
    $t
    RAM_CODE
    pwr_wake_up_ind
        0x008042b0:    b570        p.      PUSH     {r4-r6,lr}
        0x008042b2:    f000d91b    ....    BL       hal_init ; 0x10044ec
        0x008042b6:    2503        .%      MOVS     r5,#3
        0x008042b8:    4e09        .N      LDR      r6,[pc,#36] ; [0x8042e0] = 0x30006a80
        0x008042ba:    2400        .$      MOVS     r4,#0
        0x008042bc:    f8560024    V.$.    LDR      r0,[r6,r4,LSL #2]
        0x008042c0:    b138        8.      CBZ      r0,0x8042d2 ; pwr_wake_up_ind + 34
        0x008042c2:    6840        @h      LDR      r0,[r0,#4]
        0x008042c4:    b128        (.      CBZ      r0,0x8042d2 ; pwr_wake_up_ind + 34
        0x008042c6:    1931        1.      ADDS     r1,r6,r4
        0x008042c8:    f8911040    ..@.    LDRB     r1,[r1,#0x40]
        0x008042cc:    42a9        .B      CMP      r1,r5
        0x008042ce:    d100        ..      BNE      0x8042d2 ; pwr_wake_up_ind + 34
        0x008042d0:    4780        .G      BLX      r0
        0x008042d2:    1c64        d.      ADDS     r4,r4,#1
        0x008042d4:    2c10        .,      CMP      r4,#0x10
        0x008042d6:    d3f1        ..      BCC      0x8042bc ; pwr_wake_up_ind + 12
        0x008042d8:    1e6d        m.      SUBS     r5,r5,#1
        0x008042da:    2d00        .-      CMP      r5,#0
        0x008042dc:    d1ed        ..      BNE      0x8042ba ; pwr_wake_up_ind + 10
        0x008042de:    bd70        p.      POP      {r4-r6,pc}
    $d
        0x008042e0:    30006a80    .j.0    DCD    805333632
    $t
    RAM_CODE
    AON_EXT_IRQHandler
        0x008042e4:    f3ffb720    .. .    B.W      hal_aon_gpio_irq_handler ; 0x1004128
    EXT1_IRQHandler
        0x008042e8:    4804        .H      LDR      r0,[pc,#16] ; [0x8042fc] = 0xa0011000
        0x008042ea:    f415b3d1    ....    B        hal_gpio_exti_irq_handler ; 0x19a90
    EXT0_IRQHandler
        0x008042ee:    4804        .H      LDR      r0,[pc,#16] ; [0x804300] = 0xa0010000
        0x008042f0:    f415b3ce    ....    B        hal_gpio_exti_irq_handler ; 0x19a90
    EXT2_IRQHandler
        0x008042f4:    2000        .       MOVS     r0,#0
        0x008042f6:    f415b3cb    ....    B        hal_gpio_exti_irq_handler ; 0x19a90
    $d
        0x008042fa:    0000        ..      DCW    0
        0x008042fc:    a0011000    ....    DCD    2684424192
        0x00804300:    a0010000    ....    DCD    2684420096
    $t
    RAM_CODE
    uart_wake_up_ind
        0x00804304:    b570        p.      PUSH     {r4-r6,lr}
        0x00804306:    2400        .$      MOVS     r4,#0
        0x00804308:    4e0f        .N      LDR      r6,[pc,#60] ; [0x804348] = 0x300065cc
        0x0080430a:    f8560024    V.$.    LDR      r0,[r6,r4,LSL #2]
        0x0080430e:    b1b8        ..      CBZ      r0,0x804340 ; uart_wake_up_ind + 60
        0x00804310:    f890106c    ..l.    LDRB     r1,[r0,#0x6c]
        0x00804314:    2901        .)      CMP      r1,#1
        0x00804316:    d113        ..      BNE      0x804340 ; uart_wake_up_ind + 60
        0x00804318:    f3ef8510    ....    MRS      r5,PRIMASK
        0x0080431c:    f3818810    ....    MSR      PRIMASK,r1
        0x00804320:    1d00        ..      ADDS     r0,r0,#4
        0x00804322:    f41df2fb    ....    BL       hal_uart_resume_reg ; 0x2191c
        0x00804326:    f3858810    ....    MSR      PRIMASK,r5
        0x0080432a:    4808        .H      LDR      r0,[pc,#32] ; [0x80434c] = 0x1007bc0
        0x0080432c:    eb0005c4    ....    ADD      r5,r0,r4,LSL #3
        0x00804330:    f9950001    ....    LDRSB    r0,[r5,#1]
        0x00804334:    f417f770    ..p.    BL       hal_nvic_clear_pending_irq ; 0x1c218
        0x00804338:    f9950001    ....    LDRSB    r0,[r5,#1]
        0x0080433c:    f417f78a    ....    BL       hal_nvic_enable_irq ; 0x1c254
        0x00804340:    1c64        d.      ADDS     r4,r4,#1
        0x00804342:    2c02        .,      CMP      r4,#2
        0x00804344:    d3e1        ..      BCC      0x80430a ; uart_wake_up_ind + 6
        0x00804346:    bd70        p.      POP      {r4-r6,pc}
    $d
        0x00804348:    300065cc    .e.0    DCD    805332428
        0x0080434c:    01007bc0    .{..    DCD    16808896
    $t
    RAM_CODE
    gr5xx_svc_process
        0x00804350:    f01e0f04    ....    TST      lr,#4
        0x00804354:    bf14        ..      ITE      NE
        0x00804356:    f3ef8c09    ....    MRSNE    r12,PSP
        0x0080435a:    46ec        .F      MOVEQ    r12,sp
        0x0080435c:    b57f        ..      PUSH     {r0-r6,lr}
        0x0080435e:    4660        `F      MOV      r0,r12
        0x00804360:    f000f804    ....    BL       SVC_handler_proc ; 0x80436c
        0x00804364:    e8bd407f    ...@    POP      {r0-r6,lr}
        0x00804368:    4770        pG      BX       lr
    $d
        0x0080436a:    0000        ..      DCW    0
    $t
    RAM_CODE
    SVC_handler_proc
        0x0080436c:    b570        p.      PUSH     {r4-r6,lr}
        0x0080436e:    4604        .F      MOV      r4,r0
        0x00804370:    69a6        .i      LDR      r6,[r4,#0x18]
        0x00804372:    f8365c02    6..\    LDRH     r5,[r6,#-2]
        0x00804376:    2000        .       MOVS     r0,#0
        0x00804378:    f46bf782    k...    BL       fpb_load_state ; 0x70280
        0x0080437c:    f5b54f60    ..`O    CMP      r5,#0xe000
        0x00804380:    da06        ..      BGE      0x804390 ; SVC_handler_proc + 36
        0x00804382:    f5b54f5f    .._O    CMP      r5,#0xdf00
        0x00804386:    db03        ..      BLT      0x804390 ; SVC_handler_proc + 36
        0x00804388:    b2e8        ..      UXTB     r0,r5
        0x0080438a:    f001df33    ..3.    BL       svc_user_handler ; 0x10061f4
        0x0080438e:    e003        ..      B        0x804398 ; SVC_handler_proc + 44
        0x00804390:    4630        0F      MOV      r0,r6
        0x00804392:    f3fff523    ..#.    BL       get_patch_rep_addr ; 0x1003ddc
        0x00804396:    61a0        .a      STR      r0,[r4,#0x18]
        0x00804398:    f46bf7a8    k...    BL       fpb_save_state ; 0x702ec
        0x0080439c:    bd70        p.      POP      {r4-r6,pc}
        0x0080439e:    0000        ..      MOVS     r0,r0
    RAM_CODE
    hal_pwr_disable_ext_wakeup
        0x008043a0:    b510        ..      PUSH     {r4,lr}
        0x008043a2:    4604        .F      MOV      r4,r0
        0x008043a4:    4620         F      MOV      r0,r4
        0x008043a6:    f000f85d    ..].    BL       ll_pwr_clear_ext_wakeup_status ; 0x804464
        0x008043aa:    f3ef8110    ....    MRS      r1,PRIMASK
        0x008043ae:    2001        .       MOVS     r0,#1
        0x008043b0:    f3808810    ....    MSR      PRIMASK,r0
        0x008043b4:    4a32        2J      LDR      r2,[pc,#200] ; [0x804480] = 0xa000c558
        0x008043b6:    6810        .h      LDR      r0,[r2,#0]
        0x008043b8:    43a0        .C      BICS     r0,r0,r4
        0x008043ba:    6010        .`      STR      r0,[r2,#0]
        0x008043bc:    f3818810    ....    MSR      PRIMASK,r1
        0x008043c0:    bd10        ..      POP      {r4,pc}
    hal_pwr_config_ext_wakeup
        0x008043c2:    b570        p.      PUSH     {r4-r6,lr}
        0x008043c4:    4604        .F      MOV      r4,r0
        0x008043c6:    460d        .F      MOV      r5,r1
        0x008043c8:    4620         F      MOV      r0,r4
        0x008043ca:    f000f84b    ..K.    BL       ll_pwr_clear_ext_wakeup_status ; 0x804464
        0x008043ce:    05e9        ..      LSLS     r1,r5,#23
        0x008043d0:    ea4f2004    O..     LSL      r0,r4,#8
        0x008043d4:    d501        ..      BPL      0x8043da ; hal_pwr_config_ext_wakeup + 24
        0x008043d6:    4601        .F      MOV      r1,r0
        0x008043d8:    e000        ..      B        0x8043dc ; hal_pwr_config_ext_wakeup + 26
        0x008043da:    2100        .!      MOVS     r1,#0
        0x008043dc:    460b        .F      MOV      r3,r1
        0x008043de:    03e9        ..      LSLS     r1,r5,#15
        0x008043e0:    d501        ..      BPL      0x8043e6 ; hal_pwr_config_ext_wakeup + 36
        0x008043e2:    0421        !.      LSLS     r1,r4,#16
        0x008043e4:    e000        ..      B        0x8043e8 ; hal_pwr_config_ext_wakeup + 38
        0x008043e6:    2100        .!      MOVS     r1,#0
        0x008043e8:    f3ef8210    ....    MRS      r2,PRIMASK
        0x008043ec:    2501        .%      MOVS     r5,#1
        0x008043ee:    f3858810    ....    MSR      PRIMASK,r5
        0x008043f2:    ea404604    @..F    ORR      r6,r0,r4,LSL #16
        0x008043f6:    4822        "H      LDR      r0,[pc,#136] ; [0x804480] = 0xa000c558
        0x008043f8:    6805        .h      LDR      r5,[r0,#0]
        0x008043fa:    430b        .C      ORRS     r3,r3,r1
        0x008043fc:    43b5        .C      BICS     r5,r5,r6
        0x008043fe:    431d        .C      ORRS     r5,r5,r3
        0x00804400:    6005        .`      STR      r5,[r0,#0]
        0x00804402:    f3828810    ....    MSR      PRIMASK,r2
        0x00804406:    f3ef8110    ....    MRS      r1,PRIMASK
        0x0080440a:    2201        ."      MOVS     r2,#1
        0x0080440c:    f3828810    ....    MSR      PRIMASK,r2
        0x00804410:    6802        .h      LDR      r2,[r0,#0]
        0x00804412:    4322        "C      ORRS     r2,r2,r4
        0x00804414:    6002        .`      STR      r2,[r0,#0]
        0x00804416:    f3818810    ....    MSR      PRIMASK,r1
        0x0080441a:    bd70        p.      POP      {r4-r6,pc}
    hal_pwr_get_timer_current_value
        0x0080441c:    b570        p.      PUSH     {r4-r6,lr}
        0x0080441e:    2200        ."      MOVS     r2,#0
        0x00804420:    2301        .#      MOVS     r3,#1
        0x00804422:    2900        .)      CMP      r1,#0
        0x00804424:    d011        ..      BEQ      0x80444a ; hal_pwr_get_timer_current_value + 46
        0x00804426:    f3ef8410    ....    MRS      r4,PRIMASK
        0x0080442a:    2501        .%      MOVS     r5,#1
        0x0080442c:    f3858810    ....    MSR      PRIMASK,r5
        0x00804430:    4d13        .M      LDR      r5,[pc,#76] ; [0x804480] = 0xa000c558
        0x00804432:    1d2d        -.      ADDS     r5,r5,#4
        0x00804434:    682e        .h      LDR      r6,[r5,#0]
        0x00804436:    f0264640    &.@F    BIC      r6,r6,#0xc0000000
        0x0080443a:    4306        .C      ORRS     r6,r6,r0
        0x0080443c:    602e        .`      STR      r6,[r5,#0]
        0x0080443e:    f3848810    ....    MSR      PRIMASK,r4
        0x00804442:    4810        .H      LDR      r0,[pc,#64] ; [0x804484] = 0x3e7ffc18
        0x00804444:    4c0e        .L      LDR      r4,[pc,#56] ; [0x804480] = 0xa000c558
        0x00804446:    343c        <4      ADDS     r4,r4,#0x3c
        0x00804448:    e005        ..      B        0x804456 ; hal_pwr_get_timer_current_value + 58
        0x0080444a:    2001        .       MOVS     r0,#1
        0x0080444c:    bd70        p.      POP      {r4-r6,pc}
        0x0080444e:    b138        8.      CBZ      r0,0x804460 ; hal_pwr_get_timer_current_value + 68
        0x00804450:    1e40        @.      SUBS     r0,r0,#1
        0x00804452:    6822        "h      LDR      r2,[r4,#0]
        0x00804454:    6823        #h      LDR      r3,[r4,#0]
        0x00804456:    429a        .B      CMP      r2,r3
        0x00804458:    d1f9        ..      BNE      0x80444e ; hal_pwr_get_timer_current_value + 50
        0x0080445a:    600a        .`      STR      r2,[r1,#0]
        0x0080445c:    2000        .       MOVS     r0,#0
        0x0080445e:    bd70        p.      POP      {r4-r6,pc}
        0x00804460:    2003        .       MOVS     r0,#3
        0x00804462:    bd70        p.      POP      {r4-r6,pc}
    ll_pwr_clear_ext_wakeup_status
        0x00804464:    f3ef8110    ....    MRS      r1,PRIMASK
        0x00804468:    2201        ."      MOVS     r2,#1
        0x0080446a:    f3828810    ....    MSR      PRIMASK,r2
        0x0080446e:    4a04        .J      LDR      r2,[pc,#16] ; [0x804480] = 0xa000c558
        0x00804470:    ea6f4000    o..@    MVN      r0,r0,LSL #16
        0x00804474:    3a14        .:      SUBS     r2,r2,#0x14
        0x00804476:    6010        .`      STR      r0,[r2,#0]
        0x00804478:    f3818810    ....    MSR      PRIMASK,r1
        0x0080447c:    4770        pG      BX       lr
    $d
        0x0080447e:    0000        ..      DCW    0
        0x00804480:    a000c558    X...    DCD    2684405080
        0x00804484:    3e7ffc18    ...>    DCD    1048575000
    $t
    RAM_CODE
    rtc_calibration
        0x00804488:    e92d4ff0    -..O    PUSH     {r4-r11,lr}
        0x0080448c:    ed2d8b04    -...    VPUSH    {d8-d9}
        0x00804490:    b083        ..      SUB      sp,sp,#0xc
        0x00804492:    489c        .H      LDR      r0,[pc,#624] ; [0x804704] = 0xe000edfc
        0x00804494:    6801        .h      LDR      r1,[r0,#0]
        0x00804496:    9102        ..      STR      r1,[sp,#8]
        0x00804498:    9902        ..      LDR      r1,[sp,#8]
        0x0080449a:    f0417180    A..q    ORR      r1,r1,#0x1000000
        0x0080449e:    6001        .`      STR      r1,[r0,#0]
        0x008044a0:    4f99        .O      LDR      r7,[pc,#612] ; [0x804708] = 0xe0001000
        0x008044a2:    6838        8h      LDR      r0,[r7,#0]
        0x008044a4:    9001        ..      STR      r0,[sp,#4]
        0x008044a6:    2500        .%      MOVS     r5,#0
        0x008044a8:    f8df9260    ..`.    LDR      r9,[pc,#608] ; [0x80470c] = 0x300067a8
        0x008044ac:    f8b90002    ....    LDRH     r0,[r9,#2]
        0x008044b0:    300a        .0      ADDS     r0,r0,#0xa
        0x008044b2:    b286        ..      UXTH     r6,r0
        0x008044b4:    f8df8258    ..X.    LDR      r8,[pc,#600] ; [0x804710] = 0xa000c518
        0x008044b8:    f8d80000    ....    LDR      r0,[r8,#0]
        0x008044bc:    f0200001     ...    BIC      r0,r0,#1
        0x008044c0:    f8c80000    ....    STR      r0,[r8,#0]
        0x008044c4:    2000        .       MOVS     r0,#0
        0x008044c6:    f000dcaf    ....    BL       ll_calendar_set_clock_div ; 0x1004e28
        0x008044ca:    f000dc9b    ....    BL       ll_calendar_get_counter ; 0x1004e04
        0x008044ce:    b148        H.      CBZ      r0,0x8044e4 ; rtc_calibration + 92
        0x008044d0:    2000        .       MOVS     r0,#0
        0x008044d2:    498f        .I      LDR      r1,[pc,#572] ; [0x804710] = 0xa000c518
        0x008044d4:    3178        x1      ADDS     r1,r1,#0x78
        0x008044d6:    6008        .`      STR      r0,[r1,#0]
        0x008044d8:    f8d80000    ....    LDR      r0,[r8,#0]
        0x008044dc:    f0400002    @...    ORR      r0,r0,#2
        0x008044e0:    f8c80000    ....    STR      r0,[r8,#0]
        0x008044e4:    f000dc8e    ....    BL       ll_calendar_get_counter ; 0x1004e04
        0x008044e8:    2800        .(      CMP      r0,#0
        0x008044ea:    d1fb        ..      BNE      0x8044e4 ; rtc_calibration + 92
        0x008044ec:    f000dc7c    ..|.    BL       ll_calendar_clear_flag_alarm ; 0x1004de8
        0x008044f0:    f8d80000    ....    LDR      r0,[r8,#0]
        0x008044f4:    f4205080     ..P    BIC      r0,r0,#0x1000
        0x008044f8:    f8c80000    ....    STR      r0,[r8,#0]
        0x008044fc:    2021        !       MOVS     r0,#0x21
        0x008044fe:    f3fef246    ..F.    BL       __NVIC_DisableIRQ ; 0x100298e
        0x00804502:    2021        !       MOVS     r0,#0x21
        0x00804504:    f3fef21c    ....    BL       __NVIC_ClearPendingIRQ ; 0x1002940
        0x00804508:    f8d80000    ....    LDR      r0,[r8,#0]
        0x0080450c:    f0400001    @...    ORR      r0,r0,#1
        0x00804510:    f8c80000    ....    STR      r0,[r8,#0]
        0x00804514:    f000dc76    ..v.    BL       ll_calendar_get_counter ; 0x1004e04
        0x00804518:    2800        .(      CMP      r0,#0
        0x0080451a:    d0fb        ..      BEQ      0x804514 ; rtc_calibration + 140
        0x0080451c:    f3ef8010    ....    MRS      r0,PRIMASK
        0x00804520:    9000        ..      STR      r0,[sp,#0]
        0x00804522:    2001        .       MOVS     r0,#1
        0x00804524:    f3808810    ....    MSR      PRIMASK,r0
        0x00804528:    2200        ."      MOVS     r2,#0
        0x0080452a:    4c79        yL      LDR      r4,[pc,#484] ; [0x804710] = 0xa000c518
        0x0080452c:    4977        wI      LDR      r1,[pc,#476] ; [0x80470c] = 0x300067a8
        0x0080452e:    4878        xH      LDR      r0,[pc,#480] ; [0x804710] = 0xa000c518
        0x00804530:    3444        D4      ADDS     r4,r4,#0x44
        0x00804532:    f2427b10    B..{    MOV      r11,#0x2710
        0x00804536:    307c        |0      ADDS     r0,r0,#0x7c
        0x00804538:    f46f7a80    o..z    MVN      r10,#0x100
        0x0080453c:    f8918000    ....    LDRB     r8,[r1,#0]
        0x00804540:    e083        ..      B        0x80464a ; rtc_calibration + 450
        0x00804542:    4659        YF      MOV      r1,r11
        0x00804544:    683b        ;h      LDR      r3,[r7,#0]
        0x00804546:    f0230301    #...    BIC      r3,r3,#1
        0x0080454a:    603b        ;`      STR      r3,[r7,#0]
        0x0080454c:    2300        .#      MOVS     r3,#0
        0x0080454e:    607b        {`      STR      r3,[r7,#4]
        0x00804550:    f8df91bc    ....    LDR      r9,[pc,#444] ; [0x804710] = 0xa000c518
        0x00804554:    f8d9e000    ....    LDR      lr,[r9,#0]
        0x00804558:    f02e0e01    ....    BIC      lr,lr,#1
        0x0080455c:    f8c9e000    ....    STR      lr,[r9,#0]
        0x00804560:    f8d4e000    ....    LDR      lr,[r4,#0]
        0x00804564:    f02e4e40    ..@N    BIC      lr,lr,#0xc0000000
        0x00804568:    f8c4e000    ....    STR      lr,[r4,#0]
        0x0080456c:    f8d0e000    ....    LDR      lr,[r0,#0]
        0x00804570:    f1be0f00    ....    CMP      lr,#0
        0x00804574:    d00b        ..      BEQ      0x80458e ; rtc_calibration + 262
        0x00804576:    f8dfe198    ....    LDR      lr,[pc,#408] ; [0x804710] = 0xa000c518
        0x0080457a:    f10e0e78    ..x.    ADD      lr,lr,#0x78
        0x0080457e:    f8ce3000    ...0    STR      r3,[lr,#0]
        0x00804582:    f8d93000    ...0    LDR      r3,[r9,#0]
        0x00804586:    f0430302    C...    ORR      r3,r3,#2
        0x0080458a:    f8c93000    ...0    STR      r3,[r9,#0]
        0x0080458e:    6823        #h      LDR      r3,[r4,#0]
        0x00804590:    f0234340    #.@C    BIC      r3,r3,#0xc0000000
        0x00804594:    6023        #`      STR      r3,[r4,#0]
        0x00804596:    6803        .h      LDR      r3,[r0,#0]
        0x00804598:    2b00        .+      CMP      r3,#0
        0x0080459a:    d1fc        ..      BNE      0x804596 ; rtc_calibration + 270
        0x0080459c:    f8dfe170    ..p.    LDR      lr,[pc,#368] ; [0x804710] = 0xa000c518
        0x008045a0:    f8bc3002    ...0    LDRH     r3,[r12,#2]
        0x008045a4:    f10e0e78    ..x.    ADD      lr,lr,#0x78
        0x008045a8:    f8ce3000    ...0    STR      r3,[lr,#0]
        0x008045ac:    f8d9e000    ....    LDR      lr,[r9,#0]
        0x008045b0:    f04e0e04    N...    ORR      lr,lr,#4
        0x008045b4:    f8c9e000    ....    STR      lr,[r9,#0]
        0x008045b8:    f8d4e000    ....    LDR      lr,[r4,#0]
        0x008045bc:    f04e4e40    N.@N    ORR      lr,lr,#0xc0000000
        0x008045c0:    f8c4e000    ....    STR      lr,[r4,#0]
        0x008045c4:    46e6        .F      MOV      lr,r12
        0x008045c6:    f8d0c000    ....    LDR      r12,[r0,#0]
        0x008045ca:    459c        .E      CMP      r12,r3
        0x008045cc:    d1fb        ..      BNE      0x8045c6 ; rtc_calibration + 318
        0x008045ce:    f8dfc140    ..@.    LDR      r12,[pc,#320] ; [0x804710] = 0xa000c518
        0x008045d2:    f10c0c2c    ..,.    ADD      r12,r12,#0x2c
        0x008045d6:    f8cca000    ....    STR      r10,[r12,#0]
        0x008045da:    f8d93000    ...0    LDR      r3,[r9,#0]
        0x008045de:    f4435380    C..S    ORR      r3,r3,#0x1000
        0x008045e2:    f8c93000    ...0    STR      r3,[r9,#0]
        0x008045e6:    f8d93000    ...0    LDR      r3,[r9,#0]
        0x008045ea:    f0430301    C...    ORR      r3,r3,#1
        0x008045ee:    f8c93000    ...0    STR      r3,[r9,#0]
        0x008045f2:    683b        ;h      LDR      r3,[r7,#0]
        0x008045f4:    f0430301    C...    ORR      r3,r3,#1
        0x008045f8:    603b        ;`      STR      r3,[r7,#0]
        0x008045fa:    6823        #h      LDR      r3,[r4,#0]
        0x008045fc:    f0234340    #.@C    BIC      r3,r3,#0xc0000000
        0x00804600:    6023        #`      STR      r3,[r4,#0]
        0x00804602:    6803        .h      LDR      r3,[r0,#0]
        0x00804604:    2b00        .+      CMP      r3,#0
        0x00804606:    d0fc        ..      BEQ      0x804602 ; rtc_calibration + 378
        0x00804608:    f8d79004    ....    LDR      r9,[r7,#4]
        0x0080460c:    e00a        ..      B        0x804624 ; rtc_calibration + 412
        0x0080460e:    1e49        I.      SUBS     r1,r1,#1
        0x00804610:    1c4b        K.      ADDS     r3,r1,#1
        0x00804612:    d107        ..      BNE      0x804624 ; rtc_calibration + 412
        0x00804614:    4659        YF      MOV      r1,r11
        0x00804616:    6823        #h      LDR      r3,[r4,#0]
        0x00804618:    f0234340    #.@C    BIC      r3,r3,#0xc0000000
        0x0080461c:    6023        #`      STR      r3,[r4,#0]
        0x0080461e:    6803        .h      LDR      r3,[r0,#0]
        0x00804620:    42b3        .B      CMP      r3,r6
        0x00804622:    d203        ..      BCS      0x80462c ; rtc_calibration + 420
        0x00804624:    f8dc3000    ...0    LDR      r3,[r12,#0]
        0x00804628:    05db        ..      LSLS     r3,r3,#23
        0x0080462a:    d5f0        ..      BPL      0x80460e ; rtc_calibration + 390
        0x0080462c:    6879        yh      LDR      r1,[r7,#4]
        0x0080462e:    f8cca000    ....    STR      r10,[r12,#0]
        0x00804632:    f89e3001    ...0    LDRB     r3,[lr,#1]
        0x00804636:    4313        .C      ORRS     r3,r3,r2
        0x00804638:    d006        ..      BEQ      0x804648 ; rtc_calibration + 448
        0x0080463a:    eba10109    ....    SUB      r1,r1,r9
        0x0080463e:    440d        .D      ADD      r5,r5,r1
        0x00804640:    f44f717a    O.zq    MOV      r1,#0x3e8
        0x00804644:    1e49        I.      SUBS     r1,r1,#1
        0x00804646:    d1fd        ..      BNE      0x804644 ; rtc_calibration + 444
        0x00804648:    1c52        R.      ADDS     r2,r2,#1
        0x0080464a:    f8dfc0c0    ....    LDR      r12,[pc,#192] ; [0x80470c] = 0x300067a8
        0x0080464e:    4542        BE      CMP      r2,r8
        0x00804650:    f4ffaf77    ..w.    BCC      0x804542 ; rtc_calibration + 186
        0x00804654:    9800        ..      LDR      r0,[sp,#0]
        0x00804656:    f3808810    ....    MSR      PRIMASK,r0
        0x0080465a:    4664        dF      MOV      r4,r12
        0x0080465c:    7860        `x      LDRB     r0,[r4,#1]
        0x0080465e:    b918        ..      CBNZ     r0,0x804668 ; rtc_calibration + 480
        0x00804660:    f1a80801    ....    SUB      r8,r8,#1
        0x00804664:    f8848000    ....    STRB     r8,[r4,#0]
        0x00804668:    8860        `.      LDRH     r0,[r4,#2]
        0x0080466a:    f002dfe2    ....    BL       __aeabi_ui2d ; 0x1007632
        0x0080466e:    ec410b18    A...    VMOV     d8,r0,r1
        0x00804672:    7820         x      LDRB     r0,[r4,#0]
        0x00804674:    f002dfdd    ....    BL       __aeabi_ui2d ; 0x1007632
        0x00804678:    ec410b19    A...    VMOV     d9,r0,r1
        0x0080467c:    4628        (F      MOV      r0,r5
        0x0080467e:    f002dfd8    ....    BL       __aeabi_ui2d ; 0x1007632
        0x00804682:    ec532b19    S..+    VMOV     r2,r3,d9
        0x00804686:    f002de1f    ....    BL       __aeabi_ddiv ; 0x10072c8
        0x0080468a:    ec410b19    A...    VMOV     d9,r0,r1
        0x0080468e:    4821        !H      LDR      r0,[pc,#132] ; [0x804714] = 0x30006408
        0x00804690:    6800        .h      LDR      r0,[r0,#0]
        0x00804692:    f002dfce    ....    BL       __aeabi_ui2d ; 0x1007632
        0x00804696:    ec532b19    S..+    VMOV     r2,r3,d9
        0x0080469a:    f002de15    ....    BL       __aeabi_ddiv ; 0x10072c8
        0x0080469e:    ec532b18    S..+    VMOV     r2,r3,d8
        0x008046a2:    f003d81f    ....    BL       __aeabi_dmul ; 0x10076e4
        0x008046a6:    f002dd35    ..5.    BL       __aeabi_d2f ; 0x1007114
        0x008046aa:    6060        ``      STR      r0,[r4,#4]
        0x008046ac:    4c18        .L      LDR      r4,[pc,#96] ; [0x804710] = 0xa000c518
        0x008046ae:    6820         h      LDR      r0,[r4,#0]
        0x008046b0:    f0200001     ...    BIC      r0,r0,#1
        0x008046b4:    6020         `      STR      r0,[r4,#0]
        0x008046b6:    2000        .       MOVS     r0,#0
        0x008046b8:    f000dbb6    ....    BL       ll_calendar_set_clock_div ; 0x1004e28
        0x008046bc:    6820         h      LDR      r0,[r4,#0]
        0x008046be:    f4205080     ..P    BIC      r0,r0,#0x1000
        0x008046c2:    6020         `      STR      r0,[r4,#0]
        0x008046c4:    6820         h      LDR      r0,[r4,#0]
        0x008046c6:    f4205000     ..P    BIC      r0,r0,#0x2000
        0x008046ca:    6020         `      STR      r0,[r4,#0]
        0x008046cc:    f000db8c    ....    BL       ll_calendar_clear_flag_alarm ; 0x1004de8
        0x008046d0:    f3ef8010    ....    MRS      r0,PRIMASK
        0x008046d4:    2101        .!      MOVS     r1,#1
        0x008046d6:    f3818810    ....    MSR      PRIMASK,r1
        0x008046da:    490d        .I      LDR      r1,[pc,#52] ; [0x804710] = 0xa000c518
        0x008046dc:    f46f7200    o..r    MVN      r2,#0x200
        0x008046e0:    312c        ,1      ADDS     r1,r1,#0x2c
        0x008046e2:    600a        .`      STR      r2,[r1,#0]
        0x008046e4:    f3808810    ....    MSR      PRIMASK,r0
        0x008046e8:    2021        !       MOVS     r0,#0x21
        0x008046ea:    f3fef129    ..).    BL       __NVIC_ClearPendingIRQ ; 0x1002940
        0x008046ee:    9801        ..      LDR      r0,[sp,#4]
        0x008046f0:    6038        8`      STR      r0,[r7,#0]
        0x008046f2:    4904        .I      LDR      r1,[pc,#16] ; [0x804704] = 0xe000edfc
        0x008046f4:    9802        ..      LDR      r0,[sp,#8]
        0x008046f6:    6008        .`      STR      r0,[r1,#0]
        0x008046f8:    b003        ..      ADD      sp,sp,#0xc
        0x008046fa:    ecbd8b04    ....    VPOP     {d8-d9}
        0x008046fe:    e8bd8ff0    ....    POP      {r4-r11,pc}
    $d
        0x00804702:    0000        ..      DCW    0
        0x00804704:    e000edfc    ....    DCD    3758157308
        0x00804708:    e0001000    ....    DCD    3758100480
        0x0080470c:    300067a8    .g.0    DCD    805332904
        0x00804710:    a000c518    ....    DCD    2684405016
        0x00804714:    30006408    .d.0    DCD    805331976
    $t
    RAM_CODE
    hal_exflash_warm_init
        0x00804718:    e92d5ffc    -.._    PUSH     {r2-r12,lr}
        0x0080471c:    4604        .F      MOV      r4,r0
        0x0080471e:    2500        .%      MOVS     r5,#0
        0x00804720:    2600        .&      MOVS     r6,#0
        0x00804722:    2c00        .,      CMP      r4,#0
        0x00804724:    d00a        ..      BEQ      0x80473c ; hal_exflash_warm_init + 36
        0x00804726:    7a20         z      LDRB     r0,[r4,#8]
        0x00804728:    2801        .(      CMP      r0,#1
        0x0080472a:    d00a        ..      BEQ      0x804742 ; hal_exflash_warm_init + 42
        0x0080472c:    f04f0801    O...    MOV      r8,#1
        0x00804730:    f8848008    ....    STRB     r8,[r4,#8]
        0x00804734:    7a60        `z      LDRB     r0,[r4,#9]
        0x00804736:    2700        .'      MOVS     r7,#0
        0x00804738:    b128        (.      CBZ      r0,0x804746 ; hal_exflash_warm_init + 46
        0x0080473a:    e00b        ..      B        0x804754 ; hal_exflash_warm_init + 60
        0x0080473c:    2001        .       MOVS     r0,#1
        0x0080473e:    e8bd9ffc    ....    POP      {r2-r12,pc}
        0x00804742:    2002        .       MOVS     r0,#2
        0x00804744:    e7fb        ..      B        0x80473e ; hal_exflash_warm_init + 38
        0x00804746:    60e7        .`      STR      r7,[r4,#0xc]
        0x00804748:    6127        'a      STR      r7,[r4,#0x10]
        0x0080474a:    7227        'r      STRB     r7,[r4,#8]
        0x0080474c:    495c        \I      LDR      r1,[pc,#368] ; [0x8048c0] = 0x61a80
        0x0080474e:    4620         F      MOV      r0,r4
        0x00804750:    f414f76c    ..l.    BL       hal_exflash_set_retry ; 0x1962c
        0x00804754:    6820         h      LDR      r0,[r4,#0]
        0x00804756:    6801        .h      LDR      r1,[r0,#0]
        0x00804758:    f8d11c10    ....    LDR      r1,[r1,#0xc10]
        0x0080475c:    f0010101    ....    AND      r1,r1,#1
        0x00804760:    b111        ..      CBZ      r1,0x804768 ; hal_exflash_warm_init + 80
        0x00804762:    6921        !i      LDR      r1,[r4,#0x10]
        0x00804764:    b3f1        ..      CBZ      r1,0x8047e4 ; hal_exflash_warm_init + 204
        0x00804766:    e06c        l.      B        0x804842 ; hal_exflash_warm_init + 298
        0x00804768:    f8dfa158    ..X.    LDR      r10,[pc,#344] ; [0x8048c4] = 0xa000c504
        0x0080476c:    f8da0000    ....    LDR      r0,[r10,#0]
        0x00804770:    f0400020    @. .    ORR      r0,r0,#0x20
        0x00804774:    f8ca0000    ....    STR      r0,[r10,#0]
        0x00804778:    6820         h      LDR      r0,[r4,#0]
        0x0080477a:    f8c08004    ....    STR      r8,[r0,#4]
        0x0080477e:    6820         h      LDR      r0,[r4,#0]
        0x00804780:    f001fa1e    ....    BL       hal_xqspi_init_ext ; 0x805bc0
        0x00804784:    b2c5        ..      UXTB     r5,r0
        0x00804786:    2d00        .-      CMP      r5,#0
        0x00804788:    d15c        \.      BNE      0x804844 ; hal_exflash_warm_init + 300
        0x0080478a:    f8dfb13c    ..<.    LDR      r11,[pc,#316] ; [0x8048c8] = 0xe000edfc
        0x0080478e:    f8df913c    ..<.    LDR      r9,[pc,#316] ; [0x8048cc] = 0xe0001000
        0x00804792:    4620         F      MOV      r0,r4
        0x00804794:    f409f7fa    ....    BL       exflash_wakeup ; 0xe78c
        0x00804798:    484d        MH      LDR      r0,[pc,#308] ; [0x8048d0] = 0x300067b4
        0x0080479a:    6840        @h      LDR      r0,[r0,#4]
        0x0080479c:    a14d        M.      ADR      r1,{pc}+0x138 ; 0x8048d4
        0x0080479e:    c906        ..      LDM      r1,{r1,r2}
        0x008047a0:    e9cd1200    ....    STRD     r1,r2,[sp,#0]
        0x008047a4:    f8da1000    ....    LDR      r1,[r10,#0]
        0x008047a8:    f0010207    ....    AND      r2,r1,#7
        0x008047ac:    f81d5002    ...P    LDRB     r5,[sp,r2]
        0x008047b0:    4345        EC      MULS     r5,r0,r5
        0x008047b2:    b1b0        ..      CBZ      r0,0x8047e2 ; hal_exflash_warm_init + 202
        0x008047b4:    f8db0000    ....    LDR      r0,[r11,#0]
        0x008047b8:    f0407180    @..q    ORR      r1,r0,#0x1000000
        0x008047bc:    f8cb1000    ....    STR      r1,[r11,#0]
        0x008047c0:    f8d91000    ....    LDR      r1,[r9,#0]
        0x008047c4:    f0410201    A...    ORR      r2,r1,#1
        0x008047c8:    f8c92000    ...     STR      r2,[r9,#0]
        0x008047cc:    f8d92004    ...     LDR      r2,[r9,#4]
        0x008047d0:    f8d93004    ...0    LDR      r3,[r9,#4]
        0x008047d4:    1a9b        ..      SUBS     r3,r3,r2
        0x008047d6:    42ab        .B      CMP      r3,r5
        0x008047d8:    d3fa        ..      BCC      0x8047d0 ; hal_exflash_warm_init + 184
        0x008047da:    f8c91000    ....    STR      r1,[r9,#0]
        0x008047de:    f8cb0000    ....    STR      r0,[r11,#0]
        0x008047e2:    e000        ..      B        0x8047e6 ; hal_exflash_warm_init + 206
        0x008047e4:    e013        ..      B        0x80480e ; hal_exflash_warm_init + 246
        0x008047e6:    4620         F      MOV      r0,r4
        0x008047e8:    f000fe49    ..I.    BL       exflash_check_id_patch ; 0x80547e
        0x008047ec:    b2c5        ..      UXTB     r5,r0
        0x008047ee:    1c76        v.      ADDS     r6,r6,#1
        0x008047f0:    b2b6        ..      UXTH     r6,r6
        0x008047f2:    b115        ..      CBZ      r5,0x8047fa ; hal_exflash_warm_init + 226
        0x008047f4:    f5b67ffa    ....    CMP      r6,#0x1f4
        0x008047f8:    d3cb        ..      BCC      0x804792 ; hal_exflash_warm_init + 122
        0x008047fa:    6860        `h      LDR      r0,[r4,#4]
        0x008047fc:    b928        (.      CBNZ     r0,0x80480a ; hal_exflash_warm_init + 242
        0x008047fe:    6820         h      LDR      r0,[r4,#0]
        0x00804800:    6047        G`      STR      r7,[r0,#4]
        0x00804802:    6820         h      LDR      r0,[r4,#0]
        0x00804804:    f001f9dc    ....    BL       hal_xqspi_init_ext ; 0x805bc0
        0x00804808:    b2c5        ..      UXTB     r5,r0
        0x0080480a:    61a7        .a      STR      r7,[r4,#0x18]
        0x0080480c:    e01a        ..      B        0x804844 ; hal_exflash_warm_init + 300
        0x0080480e:    68e1        .h      LDR      r1,[r4,#0xc]
        0x00804810:    b9b9        ..      CBNZ     r1,0x804842 ; hal_exflash_warm_init + 298
        0x00804812:    f3ef8610    ....    MRS      r6,PRIMASK
        0x00804816:    2101        .!      MOVS     r1,#1
        0x00804818:    f3818810    ....    MSR      PRIMASK,r1
        0x0080481c:    f8c08004    ....    STR      r8,[r0,#4]
        0x00804820:    6820         h      LDR      r0,[r4,#0]
        0x00804822:    f001f9cd    ....    BL       hal_xqspi_init_ext ; 0x805bc0
        0x00804826:    4620         F      MOV      r0,r4
        0x00804828:    f409f5e8    ....    BL       exflash_check_id ; 0xe3fc
        0x0080482c:    b2c5        ..      UXTB     r5,r0
        0x0080482e:    b10d        ..      CBZ      r5,0x804834 ; hal_exflash_warm_init + 284
        0x00804830:    2003        .       MOVS     r0,#3
        0x00804832:    61a0        .a      STR      r0,[r4,#0x18]
        0x00804834:    6820         h      LDR      r0,[r4,#0]
        0x00804836:    6047        G`      STR      r7,[r0,#4]
        0x00804838:    6820         h      LDR      r0,[r4,#0]
        0x0080483a:    f001f9c1    ....    BL       hal_xqspi_init_ext ; 0x805bc0
        0x0080483e:    f3868810    ....    MSR      PRIMASK,r6
        0x00804842:    6067        g`      STR      r7,[r4,#4]
        0x00804844:    f8848009    ....    STRB     r8,[r4,#9]
        0x00804848:    7227        'r      STRB     r7,[r4,#8]
        0x0080484a:    4628        (F      MOV      r0,r5
        0x0080484c:    e777        w.      B        0x80473e ; hal_exflash_warm_init + 38
    warm_boot_patch
        0x0080484e:    e92d41f0    -..A    PUSH     {r4-r8,lr}
        0x00804852:    481c        .H      LDR      r0,[pc,#112] ; [0x8048c4] = 0xa000c504
        0x00804854:    3074        t0      ADDS     r0,r0,#0x74
        0x00804856:    6800        .h      LDR      r0,[r0,#0]
        0x00804858:    0a85        ..      LSRS     r5,r0,#10
        0x0080485a:    02ad        ..      LSLS     r5,r5,#10
        0x0080485c:    4c1f        .L      LDR      r4,[pc,#124] ; [0x8048dc] = 0x801f10
        0x0080485e:    4820         H      LDR      r0,[pc,#128] ; [0x8048e0] = 0x802180
        0x00804860:    6800        .h      LDR      r0,[r0,#0]
        0x00804862:    4920         I      LDR      r1,[pc,#128] ; [0x8048e4] = 0x474f4f44
        0x00804864:    4288        .B      CMP      r0,r1
        0x00804866:    d102        ..      BNE      0x80486e ; warm_boot_patch + 32
        0x00804868:    481f        .H      LDR      r0,[pc,#124] ; [0x8048e8] = 0x62c00
        0x0080486a:    f42af7e1    *...    BL       jump_app ; 0x2f830
        0x0080486e:    4e18        .N      LDR      r6,[pc,#96] ; [0x8048d0] = 0x300067b4
        0x00804870:    2001        .       MOVS     r0,#1
        0x00804872:    7030        0p      STRB     r0,[r6,#0]
        0x00804874:    05c7        ..      LSLS     r7,r0,#23
        0x00804876:    b175        u.      CBZ      r5,0x804896 ; warm_boot_patch + 72
        0x00804878:    f477f378    w.x.    BL       sys_security_enable_status_check ; 0x7bf6c
        0x0080487c:    b158        X.      CBZ      r0,0x804896 ; warm_boot_patch + 72
        0x0080487e:    e9d40102    ....    LDRD     r0,r1,[r4,#8]
        0x00804882:    4288        .B      CMP      r0,r1
        0x00804884:    d112        ..      BNE      0x8048ac ; warm_boot_patch + 94
        0x00804886:    f1a07080    ...p    SUB      r0,r0,#0x1000000
        0x0080488a:    42b8        .B      CMP      r0,r7
        0x0080488c:    d20e        ..      BCS      0x8048ac ; warm_boot_patch + 94
        0x0080488e:    4817        .H      LDR      r0,[pc,#92] ; [0x8048ec] = 0x801f64
        0x00804890:    f7ffff42    ..B.    BL       hal_exflash_warm_init ; 0x804718
        0x00804894:    e00a        ..      B        0x8048ac ; warm_boot_patch + 94
        0x00804896:    e9d40102    ....    LDRD     r0,r1,[r4,#8]
        0x0080489a:    4288        .B      CMP      r0,r1
        0x0080489c:    d106        ..      BNE      0x8048ac ; warm_boot_patch + 94
        0x0080489e:    f1a07080    ...p    SUB      r0,r0,#0x1000000
        0x008048a2:    42b8        .B      CMP      r0,r7
        0x008048a4:    d202        ..      BCS      0x8048ac ; warm_boot_patch + 94
        0x008048a6:    4811        .H      LDR      r0,[pc,#68] ; [0x8048ec] = 0x801f64
        0x008048a8:    f7ffff36    ..6.    BL       hal_exflash_warm_init ; 0x804718
        0x008048ac:    2000        .       MOVS     r0,#0
        0x008048ae:    7030        0p      STRB     r0,[r6,#0]
        0x008048b0:    f001f926    ..&.    BL       rom_cbk_execute ; 0x805b00
        0x008048b4:    68e0        .h      LDR      r0,[r4,#0xc]
        0x008048b6:    e8bd41f0    ...A    POP      {r4-r8,lr}
        0x008048ba:    f42ab7b9    *...    B        jump_app ; 0x2f830
    $d
        0x008048be:    0000        ..      DCW    0
        0x008048c0:    00061a80    ....    DCD    400000
        0x008048c4:    a000c504    ....    DCD    2684404996
        0x008048c8:    e000edfc    ....    DCD    3758157308
        0x008048cc:    e0001000    ....    DCD    3758100480
        0x008048d0:    300067b4    .g.0    DCD    805332916
        0x008048d4:    18103040    @0..    DCD    403714112
        0x008048d8:    00002010    . ..    DCD    8208
        0x008048dc:    00801f10    ....    DCD    8396560
        0x008048e0:    00802180    .!..    DCD    8397184
        0x008048e4:    474f4f44    DOOG    DCD    1196379972
        0x008048e8:    00062c00    .,..    DCD    404480
        0x008048ec:    00801f64    d...    DCD    8396644
    $t
    RAM_CODE
    platform_rng2_calibration_is_busy
        0x008048f0:    b508        ..      PUSH     {r3,lr}
        0x008048f2:    480e        .H      LDR      r0,[pc,#56] ; [0x80492c] = 0xa000e238
        0x008048f4:    6800        .h      LDR      r0,[r0,#0]
        0x008048f6:    9000        ..      STR      r0,[sp,#0]
        0x008048f8:    9800        ..      LDR      r0,[sp,#0]
        0x008048fa:    0780        ..      LSLS     r0,r0,#30
        0x008048fc:    d004        ..      BEQ      0x804908 ; platform_rng2_calibration_is_busy + 24
        0x008048fe:    9800        ..      LDR      r0,[sp,#0]
        0x00804900:    03c0        ..      LSLS     r0,r0,#15
        0x00804902:    d401        ..      BMI      0x804908 ; platform_rng2_calibration_is_busy + 24
        0x00804904:    2001        .       MOVS     r0,#1
        0x00804906:    bd08        ..      POP      {r3,pc}
        0x00804908:    2000        .       MOVS     r0,#0
        0x0080490a:    bd08        ..      POP      {r3,pc}
    ll_pwr_req_excute_psc_command
        0x0080490c:    4908        .I      LDR      r1,[pc,#32] ; [0x804930] = 0xa000c584
        0x0080490e:    b2c0        ..      UXTB     r0,r0
        0x00804910:    6008        .`      STR      r0,[r1,#0]
        0x00804912:    1f08        ..      SUBS     r0,r1,#4
        0x00804914:    6801        .h      LDR      r1,[r0,#0]
        0x00804916:    f0410101    A...    ORR      r1,r1,#1
        0x0080491a:    6001        .`      STR      r1,[r0,#0]
        0x0080491c:    4770        pG      BX       lr
    ll_pwr_is_active_flag_psc_cmd_busy
        0x0080491e:    4804        .H      LDR      r0,[pc,#16] ; [0x804930] = 0xa000c584
        0x00804920:    1f00        ..      SUBS     r0,r0,#4
        0x00804922:    6800        .h      LDR      r0,[r0,#0]
        0x00804924:    f3c00040    ..@.    UBFX     r0,r0,#1,#1
        0x00804928:    4770        pG      BX       lr
    $d
        0x0080492a:    0000        ..      DCW    0
        0x0080492c:    a000e238    8...    DCD    2684412472
        0x00804930:    a000c584    ....    DCD    2684405124
    $t
    RAM_CODE
    enable_quad_xmc
        0x00804934:    b5fe        ..      PUSH     {r1-r7,lr}
        0x00804936:    4605        .F      MOV      r5,r0
        0x00804938:    2000        .       MOVS     r0,#0
        0x0080493a:    9001        ..      STR      r0,[sp,#4]
        0x0080493c:    9000        ..      STR      r0,[sp,#0]
        0x0080493e:    203a        :       MOVS     r0,#0x3a
        0x00804940:    9002        ..      STR      r0,[sp,#8]
        0x00804942:    f44f767a    O.zv    MOV      r6,#0x3e8
        0x00804946:    4633        3F      MOV      r3,r6
        0x00804948:    2201        ."      MOVS     r2,#1
        0x0080494a:    a902        ..      ADD      r1,sp,#8
        0x0080494c:    6828        (h      LDR      r0,[r5,#0]
        0x0080494e:    f41df3f3    ....    BL       hal_xqspi_transmit ; 0x22138
        0x00804952:    4604        .F      MOV      r4,r0
        0x00804954:    bbe4        ..      CBNZ     r4,0x8049d0 ; enable_quad_xmc + 156
        0x00804956:    4669        iF      MOV      r1,sp
        0x00804958:    4628        (F      MOV      r0,r5
        0x0080495a:    f000ff2a    ..*.    BL       enable_quad_stat ; 0x8057b2
        0x0080495e:    f8bd0000    ....    LDRH     r0,[sp,#0]
        0x00804962:    f04f0704    O...    MOV      r7,#4
        0x00804966:    0640        @.      LSLS     r0,r0,#25
        0x00804968:    d420         .      BMI      0x8049ac ; enable_quad_xmc + 120
        0x0080496a:    2006        .       MOVS     r0,#6
        0x0080496c:    9002        ..      STR      r0,[sp,#8]
        0x0080496e:    4633        3F      MOV      r3,r6
        0x00804970:    2201        ."      MOVS     r2,#1
        0x00804972:    a902        ..      ADD      r1,sp,#8
        0x00804974:    6828        (h      LDR      r0,[r5,#0]
        0x00804976:    f41df3df    ....    BL       hal_xqspi_transmit ; 0x22138
        0x0080497a:    4604        .F      MOV      r4,r0
        0x0080497c:    b9fc        ..      CBNZ     r4,0x8049be ; enable_quad_xmc + 138
        0x0080497e:    2001        .       MOVS     r0,#1
        0x00804980:    f88d0004    ....    STRB     r0,[sp,#4]
        0x00804984:    f8bd0000    ....    LDRH     r0,[sp,#0]
        0x00804988:    f0400040    @.@.    ORR      r0,r0,#0x40
        0x0080498c:    f88d0005    ....    STRB     r0,[sp,#5]
        0x00804990:    4633        3F      MOV      r3,r6
        0x00804992:    2202        ."      MOVS     r2,#2
        0x00804994:    a901        ..      ADD      r1,sp,#4
        0x00804996:    6828        (h      LDR      r0,[r5,#0]
        0x00804998:    f41df3ce    ....    BL       hal_xqspi_transmit ; 0x22138
        0x0080499c:    4604        .F      MOV      r4,r0
        0x0080499e:    b974        t.      CBNZ     r4,0x8049be ; enable_quad_xmc + 138
        0x008049a0:    4984        .I      LDR      r1,[pc,#528] ; [0x804bb4] = 0x61a80
        0x008049a2:    4628        (F      MOV      r0,r5
        0x008049a4:    f409f6b6    ....    BL       exflash_wait_busy ; 0xe714
        0x008049a8:    4604        .F      MOV      r4,r0
        0x008049aa:    b944        D.      CBNZ     r4,0x8049be ; enable_quad_xmc + 138
        0x008049ac:    9702        ..      STR      r7,[sp,#8]
        0x008049ae:    4633        3F      MOV      r3,r6
        0x008049b0:    2201        ."      MOVS     r2,#1
        0x008049b2:    a902        ..      ADD      r1,sp,#8
        0x008049b4:    6828        (h      LDR      r0,[r5,#0]
        0x008049b6:    f41df3bf    ....    BL       hal_xqspi_transmit ; 0x22138
        0x008049ba:    4604        .F      MOV      r4,r0
        0x008049bc:    b144        D.      CBZ      r4,0x8049d0 ; enable_quad_xmc + 156
        0x008049be:    9702        ..      STR      r7,[sp,#8]
        0x008049c0:    4633        3F      MOV      r3,r6
        0x008049c2:    2201        ."      MOVS     r2,#1
        0x008049c4:    a902        ..      ADD      r1,sp,#8
        0x008049c6:    6828        (h      LDR      r0,[r5,#0]
        0x008049c8:    f41df3b6    ....    BL       hal_xqspi_transmit ; 0x22138
        0x008049cc:    4620         F      MOV      r0,r4
        0x008049ce:    bdfe        ..      POP      {r1-r7,pc}
        0x008049d0:    e7ff        ..      B        0x8049d2 ; enable_quad_xmc + 158
        0x008049d2:    4620         F      MOV      r0,r4
        0x008049d4:    e7fb        ..      B        0x8049ce ; enable_quad_xmc + 154
    enable_quad_mode2
        0x008049d6:    b538        8.      PUSH     {r3-r5,lr}
        0x008049d8:    4605        .F      MOV      r5,r0
        0x008049da:    460c        .F      MOV      r4,r1
        0x008049dc:    4628        (F      MOV      r0,r5
        0x008049de:    f409f58b    ....    BL       exflash_enable_write ; 0xe4f8
        0x008049e2:    2800        .(      CMP      r0,#0
        0x008049e4:    d116        ..      BNE      0x804a14 ; enable_quad_mode2 + 62
        0x008049e6:    2001        .       MOVS     r0,#1
        0x008049e8:    f88d0000    ....    STRB     r0,[sp,#0]
        0x008049ec:    f88d4001    ...@    STRB     r4,[sp,#1]
        0x008049f0:    2002        .       MOVS     r0,#2
        0x008049f2:    ea402014    @..     ORR      r0,r0,r4,LSR #8
        0x008049f6:    f88d0002    ....    STRB     r0,[sp,#2]
        0x008049fa:    f44f737a    O.zs    MOV      r3,#0x3e8
        0x008049fe:    2203        ."      MOVS     r2,#3
        0x00804a00:    4669        iF      MOV      r1,sp
        0x00804a02:    6828        (h      LDR      r0,[r5,#0]
        0x00804a04:    f41df398    ....    BL       hal_xqspi_transmit ; 0x22138
        0x00804a08:    2800        .(      CMP      r0,#0
        0x00804a0a:    d103        ..      BNE      0x804a14 ; enable_quad_mode2 + 62
        0x00804a0c:    4969        iI      LDR      r1,[pc,#420] ; [0x804bb4] = 0x61a80
        0x00804a0e:    4628        (F      MOV      r0,r5
        0x00804a10:    f409f680    ....    BL       exflash_wait_busy ; 0xe714
        0x00804a14:    bd38        8.      POP      {r3-r5,pc}
    enable_quad_mode1
        0x00804a16:    b538        8.      PUSH     {r3-r5,lr}
        0x00804a18:    4604        .F      MOV      r4,r0
        0x00804a1a:    2000        .       MOVS     r0,#0
        0x00804a1c:    9000        ..      STR      r0,[sp,#0]
        0x00804a1e:    2031        1       MOVS     r0,#0x31
        0x00804a20:    f88d0000    ....    STRB     r0,[sp,#0]
        0x00804a24:    2002        .       MOVS     r0,#2
        0x00804a26:    ea402011    @..     ORR      r0,r0,r1,LSR #8
        0x00804a2a:    f88d0001    ....    STRB     r0,[sp,#1]
        0x00804a2e:    4620         F      MOV      r0,r4
        0x00804a30:    f409f562    ..b.    BL       exflash_enable_write ; 0xe4f8
        0x00804a34:    2800        .(      CMP      r0,#0
        0x00804a36:    d10c        ..      BNE      0x804a52 ; enable_quad_mode1 + 60
        0x00804a38:    f44f737a    O.zs    MOV      r3,#0x3e8
        0x00804a3c:    2202        ."      MOVS     r2,#2
        0x00804a3e:    4669        iF      MOV      r1,sp
        0x00804a40:    6820         h      LDR      r0,[r4,#0]
        0x00804a42:    f41df379    ..y.    BL       hal_xqspi_transmit ; 0x22138
        0x00804a46:    2800        .(      CMP      r0,#0
        0x00804a48:    d103        ..      BNE      0x804a52 ; enable_quad_mode1 + 60
        0x00804a4a:    495a        ZI      LDR      r1,[pc,#360] ; [0x804bb4] = 0x61a80
        0x00804a4c:    4620         F      MOV      r0,r4
        0x00804a4e:    f409f661    ..a.    BL       exflash_wait_busy ; 0xe714
        0x00804a52:    bd38        8.      POP      {r3-r5,pc}
    enable_quad_mode0
        0x00804a54:    b538        8.      PUSH     {r3-r5,lr}
        0x00804a56:    4604        .F      MOV      r4,r0
        0x00804a58:    2100        .!      MOVS     r1,#0
        0x00804a5a:    9100        ..      STR      r1,[sp,#0]
        0x00804a5c:    4669        iF      MOV      r1,sp
        0x00804a5e:    4620         F      MOV      r0,r4
        0x00804a60:    f000fea7    ....    BL       enable_quad_stat ; 0x8057b2
        0x00804a64:    f8bd1000    ....    LDRH     r1,[sp,#0]
        0x00804a68:    f4417100    A..q    ORR      r1,r1,#0x200
        0x00804a6c:    9100        ..      STR      r1,[sp,#0]
        0x00804a6e:    4620         F      MOV      r0,r4
        0x00804a70:    f409f69a    ....    BL       exflash_write_status ; 0xe7a8
        0x00804a74:    bd38        8.      POP      {r3-r5,pc}
    enable_quad_normal
        0x00804a76:    b5f8        ..      PUSH     {r3-r7,lr}
        0x00804a78:    4606        .F      MOV      r6,r0
        0x00804a7a:    2400        .$      MOVS     r4,#0
        0x00804a7c:    2500        .%      MOVS     r5,#0
        0x00804a7e:    9500        ..      STR      r5,[sp,#0]
        0x00804a80:    68f0        .h      LDR      r0,[r6,#0xc]
        0x00804a82:    494d        MI      LDR      r1,[pc,#308] ; [0x804bb8] = 0x856017
        0x00804a84:    4288        .B      CMP      r0,r1
        0x00804a86:    d10d        ..      BNE      0x804aa4 ; enable_quad_normal + 46
        0x00804a88:    9500        ..      STR      r5,[sp,#0]
        0x00804a8a:    4669        iF      MOV      r1,sp
        0x00804a8c:    4630        0F      MOV      r0,r6
        0x00804a8e:    f000fe90    ....    BL       enable_quad_stat ; 0x8057b2
        0x00804a92:    f8bd1000    ....    LDRH     r1,[sp,#0]
        0x00804a96:    0588        ..      LSLS     r0,r1,#22
        0x00804a98:    d425        %.      BMI      0x804ae6 ; enable_quad_normal + 112
        0x00804a9a:    4630        0F      MOV      r0,r6
        0x00804a9c:    f7ffff9b    ....    BL       enable_quad_mode2 ; 0x8049d6
        0x00804aa0:    4604        .F      MOV      r4,r0
        0x00804aa2:    e020         .      B        0x804ae6 ; enable_quad_normal + 112
        0x00804aa4:    4630        0F      MOV      r0,r6
        0x00804aa6:    f7ffffd5    ....    BL       enable_quad_mode0 ; 0x804a54
        0x00804aaa:    4604        .F      MOV      r4,r0
        0x00804aac:    0020         .      MOVS     r0,r4
        0x00804aae:    d11a        ..      BNE      0x804ae6 ; enable_quad_normal + 112
        0x00804ab0:    4669        iF      MOV      r1,sp
        0x00804ab2:    4630        0F      MOV      r0,r6
        0x00804ab4:    f000fe7d    ..}.    BL       enable_quad_stat ; 0x8057b2
        0x00804ab8:    f8bd1000    ....    LDRH     r1,[sp,#0]
        0x00804abc:    0588        ..      LSLS     r0,r1,#22
        0x00804abe:    d412        ..      BMI      0x804ae6 ; enable_quad_normal + 112
        0x00804ac0:    4630        0F      MOV      r0,r6
        0x00804ac2:    f7ffffa8    ....    BL       enable_quad_mode1 ; 0x804a16
        0x00804ac6:    4604        .F      MOV      r4,r0
        0x00804ac8:    0020         .      MOVS     r0,r4
        0x00804aca:    d10c        ..      BNE      0x804ae6 ; enable_quad_normal + 112
        0x00804acc:    9500        ..      STR      r5,[sp,#0]
        0x00804ace:    4669        iF      MOV      r1,sp
        0x00804ad0:    4630        0F      MOV      r0,r6
        0x00804ad2:    f000fe6e    ..n.    BL       enable_quad_stat ; 0x8057b2
        0x00804ad6:    f8bd1000    ....    LDRH     r1,[sp,#0]
        0x00804ada:    0588        ..      LSLS     r0,r1,#22
        0x00804adc:    d403        ..      BMI      0x804ae6 ; enable_quad_normal + 112
        0x00804ade:    4630        0F      MOV      r0,r6
        0x00804ae0:    f7ffff79    ..y.    BL       enable_quad_mode2 ; 0x8049d6
        0x00804ae4:    4604        .F      MOV      r4,r0
        0x00804ae6:    4620         F      MOV      r0,r4
        0x00804ae8:    bdf8        ..      POP      {r3-r7,pc}
    enable_quad
        0x00804aea:    b510        ..      PUSH     {r4,lr}
        0x00804aec:    68c1        .h      LDR      r1,[r0,#0xc]
        0x00804aee:    b2c9        ..      UXTB     r1,r1
        0x00804af0:    68c2        .h      LDR      r2,[r0,#0xc]
        0x00804af2:    f3c24207    ...B    UBFX     r2,r2,#16,#8
        0x00804af6:    2a20         *      CMP      r2,#0x20
        0x00804af8:    d104        ..      BNE      0x804b04 ; enable_quad + 26
        0x00804afa:    2916        .)      CMP      r1,#0x16
        0x00804afc:    d902        ..      BLS      0x804b04 ; enable_quad + 26
        0x00804afe:    f7ffff19    ....    BL       enable_quad_xmc ; 0x804934
        0x00804b02:    bd10        ..      POP      {r4,pc}
        0x00804b04:    f7ffffb7    ....    BL       enable_quad_normal ; 0x804a76
        0x00804b08:    bd10        ..      POP      {r4,pc}
    platform_exflash_enable_quad
        0x00804b0a:    e92d41f0    -..A    PUSH     {r4-r8,lr}
        0x00804b0e:    4604        .F      MOV      r4,r0
        0x00804b10:    f3ef8611    ....    MRS      r6,BASEPRI
        0x00804b14:    6820         h      LDR      r0,[r4,#0]
        0x00804b16:    6801        .h      LDR      r1,[r0,#0]
        0x00804b18:    f8d11c10    ....    LDR      r1,[r1,#0xc10]
        0x00804b1c:    f0010101    ....    AND      r1,r1,#1
        0x00804b20:    2501        .%      MOVS     r5,#1
        0x00804b22:    f04f0802    O...    MOV      r8,#2
        0x00804b26:    2900        .)      CMP      r1,#0
        0x00804b28:    d019        ..      BEQ      0x804b5e ; platform_exflash_enable_quad + 84
        0x00804b2a:    4924        $I      LDR      r1,[pc,#144] ; [0x804bbc] = 0xe000e402
        0x00804b2c:    780a        .x      LDRB     r2,[r1,#0]
        0x00804b2e:    4924        $I      LDR      r1,[pc,#144] ; [0x804bc0] = 0xe000ed0c
        0x00804b30:    6809        .h      LDR      r1,[r1,#0]
        0x00804b32:    f3c12102    ...!    UBFX     r1,r1,#8,#3
        0x00804b36:    1c49        I.      ADDS     r1,r1,#1
        0x00804b38:    fa05f101    ....    LSL      r1,r5,r1
        0x00804b3c:    4411        .D      ADD      r1,r1,r2
        0x00804b3e:    b2c9        ..      UXTB     r1,r1
        0x00804b40:    f3818811    ....    MSR      BASEPRI,r1
        0x00804b44:    f3ef8710    ....    MRS      r7,PRIMASK
        0x00804b48:    f3858810    ....    MSR      PRIMASK,r5
        0x00804b4c:    6045        E`      STR      r5,[r0,#4]
        0x00804b4e:    6820         h      LDR      r0,[r4,#0]
        0x00804b50:    f001f836    ..6.    BL       hal_xqspi_init_ext ; 0x805bc0
        0x00804b54:    f8848009    ....    STRB     r8,[r4,#9]
        0x00804b58:    f3878810    ....    MSR      PRIMASK,r7
        0x00804b5c:    e00b        ..      B        0x804b76 ; platform_exflash_enable_quad + 108
        0x00804b5e:    4620         F      MOV      r0,r4
        0x00804b60:    f409f614    ....    BL       exflash_wakeup ; 0xe78c
        0x00804b64:    4620         F      MOV      r0,r4
        0x00804b66:    f409f449    ..I.    BL       exflash_check_id ; 0xe3fc
        0x00804b6a:    b110        ..      CBZ      r0,0x804b72 ; platform_exflash_enable_quad + 104
        0x00804b6c:    2003        .       MOVS     r0,#3
        0x00804b6e:    61a0        .a      STR      r0,[r4,#0x18]
        0x00804b70:    e001        ..      B        0x804b76 ; platform_exflash_enable_quad + 108
        0x00804b72:    f8848009    ....    STRB     r8,[r4,#9]
        0x00804b76:    4620         F      MOV      r0,r4
        0x00804b78:    f7ffffb7    ....    BL       enable_quad ; 0x804aea
        0x00804b7c:    4680        .F      MOV      r8,r0
        0x00804b7e:    6860        `h      LDR      r0,[r4,#4]
        0x00804b80:    b130        0.      CBZ      r0,0x804b90 ; platform_exflash_enable_quad + 134
        0x00804b82:    4620         F      MOV      r0,r4
        0x00804b84:    f409f478    ..x.    BL       exflash_deepsleep ; 0xe478
        0x00804b88:    7265        er      STRB     r5,[r4,#9]
        0x00804b8a:    4640        @F      MOV      r0,r8
        0x00804b8c:    e8bd81f0    ....    POP      {r4-r8,pc}
        0x00804b90:    f3ef8710    ....    MRS      r7,PRIMASK
        0x00804b94:    2001        .       MOVS     r0,#1
        0x00804b96:    f3808810    ....    MSR      PRIMASK,r0
        0x00804b9a:    6821        !h      LDR      r1,[r4,#0]
        0x00804b9c:    2000        .       MOVS     r0,#0
        0x00804b9e:    6048        H`      STR      r0,[r1,#4]
        0x00804ba0:    6820         h      LDR      r0,[r4,#0]
        0x00804ba2:    f001f80d    ....    BL       hal_xqspi_init_ext ; 0x805bc0
        0x00804ba6:    7265        er      STRB     r5,[r4,#9]
        0x00804ba8:    f3878810    ....    MSR      PRIMASK,r7
        0x00804bac:    b2f0        ..      UXTB     r0,r6
        0x00804bae:    f3808811    ....    MSR      BASEPRI,r0
        0x00804bb2:    e7ea        ..      B        0x804b8a ; platform_exflash_enable_quad + 128
    $d
        0x00804bb4:    00061a80    ....    DCD    400000
        0x00804bb8:    00856017    .`..    DCD    8740887
        0x00804bbc:    e000e402    ....    DCD    3758154754
        0x00804bc0:    e000ed0c    ....    DCD    3758157068
    $t
    RAM_CODE
    xo_offset_slowly_set
        0x00804bc4:    e92d47f0    -..G    PUSH     {r4-r10,lr}
        0x00804bc8:    4605        .F      MOV      r5,r0
        0x00804bca:    460e        .F      MOV      r6,r1
        0x00804bcc:    4fe4        .O      LDR      r7,[pc,#912] ; [0x804f60] = 0xa000c538
        0x00804bce:    6838        8h      LDR      r0,[r7,#0]
        0x00804bd0:    f3c02488    ...$    UBFX     r4,r0,#10,#9
        0x00804bd4:    f8df838c    ....    LDR      r8,[pc,#908] ; [0x804f64] = 0xfff803ff
        0x00804bd8:    f8df938c    ....    LDR      r9,[pc,#908] ; [0x804f68] = 0x30006814
        0x00804bdc:    e010        ..      B        0x804c00 ; xo_offset_slowly_set + 60
        0x00804bde:    1b28        (.      SUBS     r0,r5,r4
        0x00804be0:    42b0        .B      CMP      r0,r6
        0x00804be2:    da01        ..      BGE      0x804be8 ; xo_offset_slowly_set + 36
        0x00804be4:    462c        ,F      MOV      r4,r5
        0x00804be6:    e001        ..      B        0x804bec ; xo_offset_slowly_set + 40
        0x00804be8:    19a0        ..      ADDS     r0,r4,r6
        0x00804bea:    b284        ..      UXTH     r4,r0
        0x00804bec:    6838        8h      LDR      r0,[r7,#0]
        0x00804bee:    ea000008    ....    AND      r0,r0,r8
        0x00804bf2:    ea402084    @..     ORR      r0,r0,r4,LSL #10
        0x00804bf6:    6038        8`      STR      r0,[r7,#0]
        0x00804bf8:    f8990002    ....    LDRB     r0,[r9,#2]
        0x00804bfc:    f476f7ff    v...    BL       sys_delay_us ; 0x7bbfe
        0x00804c00:    42ac        .B      CMP      r4,r5
        0x00804c02:    d3ec        ..      BCC      0x804bde ; xo_offset_slowly_set + 26
        0x00804c04:    e010        ..      B        0x804c28 ; xo_offset_slowly_set + 100
        0x00804c06:    1b60        `.      SUBS     r0,r4,r5
        0x00804c08:    42b0        .B      CMP      r0,r6
        0x00804c0a:    da01        ..      BGE      0x804c10 ; xo_offset_slowly_set + 76
        0x00804c0c:    462c        ,F      MOV      r4,r5
        0x00804c0e:    e001        ..      B        0x804c14 ; xo_offset_slowly_set + 80
        0x00804c10:    1ba0        ..      SUBS     r0,r4,r6
        0x00804c12:    b284        ..      UXTH     r4,r0
        0x00804c14:    6838        8h      LDR      r0,[r7,#0]
        0x00804c16:    ea000008    ....    AND      r0,r0,r8
        0x00804c1a:    ea402084    @..     ORR      r0,r0,r4,LSL #10
        0x00804c1e:    6038        8`      STR      r0,[r7,#0]
        0x00804c20:    f8990002    ....    LDRB     r0,[r9,#2]
        0x00804c24:    f476f7eb    v...    BL       sys_delay_us ; 0x7bbfe
        0x00804c28:    42ac        .B      CMP      r4,r5
        0x00804c2a:    d8ec        ..      BHI      0x804c06 ; xo_offset_slowly_set + 66
        0x00804c2c:    e8bd87f0    ....    POP      {r4-r10,pc}
    boot_xo_bias_set
        0x00804c30:    b570        p.      PUSH     {r4-r6,lr}
        0x00804c32:    4dcd        .M      LDR      r5,[pc,#820] ; [0x804f68] = 0x30006814
        0x00804c34:    8a69        i.      LDRH     r1,[r5,#0x12]
        0x00804c36:    89e8        ..      LDRH     r0,[r5,#0xe]
        0x00804c38:    f7ffffc4    ....    BL       xo_offset_slowly_set ; 0x804bc4
        0x00804c3c:    4ec8        .N      LDR      r6,[pc,#800] ; [0x804f60] = 0xa000c538
        0x00804c3e:    1f36        6.      SUBS     r6,r6,#4
        0x00804c40:    6830        0h      LDR      r0,[r6,#0]
        0x00804c42:    f000041f    ....    AND      r4,r0,#0x1f
        0x00804c46:    e00f        ..      B        0x804c68 ; boot_xo_bias_set + 56
        0x00804c48:    78e9        .x      LDRB     r1,[r5,#3]
        0x00804c4a:    1b02        ..      SUBS     r2,r0,r4
        0x00804c4c:    428a        .B      CMP      r2,r1
        0x00804c4e:    da01        ..      BGE      0x804c54 ; boot_xo_bias_set + 36
        0x00804c50:    4604        .F      MOV      r4,r0
        0x00804c52:    e001        ..      B        0x804c58 ; boot_xo_bias_set + 40
        0x00804c54:    1860        `.      ADDS     r0,r4,r1
        0x00804c56:    b2c4        ..      UXTB     r4,r0
        0x00804c58:    6830        0h      LDR      r0,[r6,#0]
        0x00804c5a:    f020001f     ...    BIC      r0,r0,#0x1f
        0x00804c5e:    4320         C      ORRS     r0,r0,r4
        0x00804c60:    6030        0`      STR      r0,[r6,#0]
        0x00804c62:    78a8        .x      LDRB     r0,[r5,#2]
        0x00804c64:    f476f7cb    v...    BL       sys_delay_us ; 0x7bbfe
        0x00804c68:    7868        hx      LDRB     r0,[r5,#1]
        0x00804c6a:    4284        .B      CMP      r4,r0
        0x00804c6c:    d3ec        ..      BCC      0x804c48 ; boot_xo_bias_set + 24
        0x00804c6e:    bd70        p.      POP      {r4-r6,pc}
    work_xo_bias_set
        0x00804c70:    b570        p.      PUSH     {r4-r6,lr}
        0x00804c72:    4dbd        .M      LDR      r5,[pc,#756] ; [0x804f68] = 0x30006814
        0x00804c74:    8a69        i.      LDRH     r1,[r5,#0x12]
        0x00804c76:    8a28        (.      LDRH     r0,[r5,#0x10]
        0x00804c78:    f7ffffa4    ....    BL       xo_offset_slowly_set ; 0x804bc4
        0x00804c7c:    4eb8        .N      LDR      r6,[pc,#736] ; [0x804f60] = 0xa000c538
        0x00804c7e:    1f36        6.      SUBS     r6,r6,#4
        0x00804c80:    6830        0h      LDR      r0,[r6,#0]
        0x00804c82:    f000041f    ....    AND      r4,r0,#0x1f
        0x00804c86:    e00f        ..      B        0x804ca8 ; work_xo_bias_set + 56
        0x00804c88:    78e9        .x      LDRB     r1,[r5,#3]
        0x00804c8a:    1a22        ".      SUBS     r2,r4,r0
        0x00804c8c:    428a        .B      CMP      r2,r1
        0x00804c8e:    da01        ..      BGE      0x804c94 ; work_xo_bias_set + 36
        0x00804c90:    4604        .F      MOV      r4,r0
        0x00804c92:    e001        ..      B        0x804c98 ; work_xo_bias_set + 40
        0x00804c94:    1a60        `.      SUBS     r0,r4,r1
        0x00804c96:    b2c4        ..      UXTB     r4,r0
        0x00804c98:    6830        0h      LDR      r0,[r6,#0]
        0x00804c9a:    f020001f     ...    BIC      r0,r0,#0x1f
        0x00804c9e:    4320         C      ORRS     r0,r0,r4
        0x00804ca0:    6030        0`      STR      r0,[r6,#0]
        0x00804ca2:    78a8        .x      LDRB     r0,[r5,#2]
        0x00804ca4:    f476f7ab    v...    BL       sys_delay_us ; 0x7bbfe
        0x00804ca8:    7828        (x      LDRB     r0,[r5,#0]
        0x00804caa:    4284        .B      CMP      r4,r0
        0x00804cac:    d8ec        ..      BHI      0x804c88 ; work_xo_bias_set + 24
        0x00804cae:    bd70        p.      POP      {r4-r6,pc}
    sys_is_adjust_boot_digldo
        0x00804cb0:    2000        .       MOVS     r0,#0
        0x00804cb2:    49ae        .I      LDR      r1,[pc,#696] ; [0x804f6c] = 0x803212
        0x00804cb4:    8b8a        ..      LDRH     r2,[r1,#0x1c]
        0x00804cb6:    f5a2438e    ...C    SUB      r3,r2,#0x4700
        0x00804cba:    3b44        D;      SUBS     r3,r3,#0x44
        0x00804cbc:    d102        ..      BNE      0x804cc4 ; sys_is_adjust_boot_digldo + 20
        0x00804cbe:    7888        .x      LDRB     r0,[r1,#2]
        0x00804cc0:    f000001f    ....    AND      r0,r0,#0x1f
        0x00804cc4:    2808        .(      CMP      r0,#8
        0x00804cc6:    d003        ..      BEQ      0x804cd0 ; sys_is_adjust_boot_digldo + 32
        0x00804cc8:    2809        .(      CMP      r0,#9
        0x00804cca:    d001        ..      BEQ      0x804cd0 ; sys_is_adjust_boot_digldo + 32
        0x00804ccc:    2000        .       MOVS     r0,#0
        0x00804cce:    4770        pG      BX       lr
        0x00804cd0:    2001        .       MOVS     r0,#1
        0x00804cd2:    4770        pG      BX       lr
    boot_digldo_dcdc_set
        0x00804cd4:    b570        p.      PUSH     {r4-r6,lr}
        0x00804cd6:    f7ffffeb    ....    BL       sys_is_adjust_boot_digldo ; 0x804cb0
        0x00804cda:    2800        .(      CMP      r0,#0
        0x00804cdc:    d054        T.      BEQ      0x804d88 ; boot_digldo_dcdc_set + 180
        0x00804cde:    49a3        .I      LDR      r1,[pc,#652] ; [0x804f6c] = 0x803212
        0x00804ce0:    8b88        ..      LDRH     r0,[r1,#0x1c]
        0x00804ce2:    f5a0428e    ...B    SUB      r2,r0,#0x4700
        0x00804ce6:    3a44        D:      SUBS     r2,r2,#0x44
        0x00804ce8:    d14e        N.      BNE      0x804d88 ; boot_digldo_dcdc_set + 180
        0x00804cea:    f8910029    ..).    LDRB     r0,[r1,#0x29]
        0x00804cee:    0602        ..      LSLS     r2,r0,#24
        0x00804cf0:    d505        ..      BPL      0x804cfe ; boot_digldo_dcdc_set + 42
        0x00804cf2:    f3c01241    ..A.    UBFX     r2,r0,#5,#2
        0x00804cf6:    1a80        ..      SUBS     r0,r0,r2
        0x00804cf8:    f000031f    ....    AND      r3,r0,#0x1f
        0x00804cfc:    e004        ..      B        0x804d08 ; boot_digldo_dcdc_set + 52
        0x00804cfe:    f3c01241    ..A.    UBFX     r2,r0,#5,#2
        0x00804d02:    4410        .D      ADD      r0,r0,r2
        0x00804d04:    f000031f    ....    AND      r3,r0,#0x1f
        0x00804d08:    f891002b    ..+.    LDRB     r0,[r1,#0x2b]
        0x00804d0c:    f000021f    ....    AND      r2,r0,#0x1f
        0x00804d10:    4d93        .M      LDR      r5,[pc,#588] ; [0x804f60] = 0xa000c538
        0x00804d12:    3d14        .=      SUBS     r5,r5,#0x14
        0x00804d14:    6828        (h      LDR      r0,[r5,#0]
        0x00804d16:    4c94        .L      LDR      r4,[pc,#592] ; [0x804f68] = 0x30006814
        0x00804d18:    f3c04004    ...@    UBFX     r0,r0,#16,#5
        0x00804d1c:    6420         d      STR      r0,[r4,#0x40]
        0x00804d1e:    4e90        .N      LDR      r6,[pc,#576] ; [0x804f60] = 0xa000c538
        0x00804d20:    3e28        (>      SUBS     r6,r6,#0x28
        0x00804d22:    6830        0h      LDR      r0,[r6,#0]
        0x00804d24:    f3c040c4    ...@    UBFX     r0,r0,#19,#5
        0x00804d28:    6460        `d      STR      r0,[r4,#0x44]
        0x00804d2a:    6b20         k      LDR      r0,[r4,#0x30]
        0x00804d2c:    28ff        .(      CMP      r0,#0xff
        0x00804d2e:    d004        ..      BEQ      0x804d3a ; boot_digldo_dcdc_set + 102
        0x00804d30:    283c        <(      CMP      r0,#0x3c
        0x00804d32:    dd05        ..      BLE      0x804d40 ; boot_digldo_dcdc_set + 108
        0x00804d34:    210c        .!      MOVS     r1,#0xc
        0x00804d36:    2008        .       MOVS     r0,#8
        0x00804d38:    e009        ..      B        0x804d4e ; boot_digldo_dcdc_set + 122
        0x00804d3a:    210a        .!      MOVS     r1,#0xa
        0x00804d3c:    2006        .       MOVS     r0,#6
        0x00804d3e:    e006        ..      B        0x804d4e ; boot_digldo_dcdc_set + 122
        0x00804d40:    2820         (      CMP      r0,#0x20
        0x00804d42:    dd02        ..      BLE      0x804d4a ; boot_digldo_dcdc_set + 118
        0x00804d44:    210b        .!      MOVS     r1,#0xb
        0x00804d46:    2007        .       MOVS     r0,#7
        0x00804d48:    e001        ..      B        0x804d4e ; boot_digldo_dcdc_set + 122
        0x00804d4a:    210a        .!      MOVS     r1,#0xa
        0x00804d4c:    2006        .       MOVS     r0,#6
        0x00804d4e:    4419        .D      ADD      r1,r1,r3
        0x00804d50:    291f        .)      CMP      r1,#0x1f
        0x00804d52:    d300        ..      BCC      0x804d56 ; boot_digldo_dcdc_set + 130
        0x00804d54:    211f        .!      MOVS     r1,#0x1f
        0x00804d56:    4282        .B      CMP      r2,r0
        0x00804d58:    d901        ..      BLS      0x804d5e ; boot_digldo_dcdc_set + 138
        0x00804d5a:    1a10        ..      SUBS     r0,r2,r0
        0x00804d5c:    e000        ..      B        0x804d60 ; boot_digldo_dcdc_set + 140
        0x00804d5e:    2000        .       MOVS     r0,#0
        0x00804d60:    682a        *h      LDR      r2,[r5,#0]
        0x00804d62:    f42212f8    "...    BIC      r2,r2,#0x1f0000
        0x00804d66:    ea424101    B..A    ORR      r1,r2,r1,LSL #16
        0x00804d6a:    6029        )`      STR      r1,[r5,#0]
        0x00804d6c:    6831        1h      LDR      r1,[r6,#0]
        0x00804d6e:    f4210178    !.x.    BIC      r1,r1,#0xf80000
        0x00804d72:    ea4140c0    A..@    ORR      r0,r1,r0,LSL #19
        0x00804d76:    6030        0`      STR      r0,[r6,#0]
        0x00804d78:    6828        (h      LDR      r0,[r5,#0]
        0x00804d7a:    f3c04004    ...@    UBFX     r0,r0,#16,#5
        0x00804d7e:    64a0        .d      STR      r0,[r4,#0x48]
        0x00804d80:    6830        0h      LDR      r0,[r6,#0]
        0x00804d82:    f3c040c4    ...@    UBFX     r0,r0,#19,#5
        0x00804d86:    64e0        .d      STR      r0,[r4,#0x4c]
        0x00804d88:    bd70        p.      POP      {r4-r6,pc}
    work_digldo_dcdc_set
        0x00804d8a:    b510        ..      PUSH     {r4,lr}
        0x00804d8c:    f7ffff90    ....    BL       sys_is_adjust_boot_digldo ; 0x804cb0
        0x00804d90:    2800        .(      CMP      r0,#0
        0x00804d92:    d019        ..      BEQ      0x804dc8 ; work_digldo_dcdc_set + 62
        0x00804d94:    4875        uH      LDR      r0,[pc,#468] ; [0x804f6c] = 0x803212
        0x00804d96:    8b80        ..      LDRH     r0,[r0,#0x1c]
        0x00804d98:    f5a0418e    ...A    SUB      r1,r0,#0x4700
        0x00804d9c:    3944        D9      SUBS     r1,r1,#0x44
        0x00804d9e:    d113        ..      BNE      0x804dc8 ; work_digldo_dcdc_set + 62
        0x00804da0:    486f        oH      LDR      r0,[pc,#444] ; [0x804f60] = 0xa000c538
        0x00804da2:    3814        .8      SUBS     r0,r0,#0x14
        0x00804da4:    6801        .h      LDR      r1,[r0,#0]
        0x00804da6:    f42112f8    !...    BIC      r2,r1,#0x1f0000
        0x00804daa:    496f        oI      LDR      r1,[pc,#444] ; [0x804f68] = 0x30006814
        0x00804dac:    3140        @1      ADDS     r1,r1,#0x40
        0x00804dae:    880b        ..      LDRH     r3,[r1,#0]
        0x00804db0:    ea424203    B..B    ORR      r2,r2,r3,LSL #16
        0x00804db4:    6002        .`      STR      r2,[r0,#0]
        0x00804db6:    486a        jH      LDR      r0,[pc,#424] ; [0x804f60] = 0xa000c538
        0x00804db8:    3828        (8      SUBS     r0,r0,#0x28
        0x00804dba:    6802        .h      LDR      r2,[r0,#0]
        0x00804dbc:    8889        ..      LDRH     r1,[r1,#4]
        0x00804dbe:    f4220278    ".x.    BIC      r2,r2,#0xf80000
        0x00804dc2:    ea4241c1    B..A    ORR      r1,r2,r1,LSL #19
        0x00804dc6:    6001        .`      STR      r1,[r0,#0]
        0x00804dc8:    bd10        ..      POP      {r4,pc}
    hal_pm_resume
        0x00804dca:    4770        pG      BX       lr
    warm_boot_second
        0x00804dcc:    b510        ..      PUSH     {r4,lr}
        0x00804dce:    201a        .       MOVS     r0,#0x1a
        0x00804dd0:    f3fdf5ff    ....    BL       __NVIC_EnableIRQ ; 0x10029d2
        0x00804dd4:    2001        .       MOVS     r0,#1
        0x00804dd6:    f3fdf5fc    ....    BL       __NVIC_EnableIRQ ; 0x10029d2
        0x00804dda:    201b        .       MOVS     r0,#0x1b
        0x00804ddc:    f3fdf606    ....    BL       __NVIC_GetPendingIRQ ; 0x10029ec
        0x00804de0:    b340        @.      CBZ      r0,0x804e34 ; warm_boot_second + 104
        0x00804de2:    485f        _H      LDR      r0,[pc,#380] ; [0x804f60] = 0xa000c538
        0x00804de4:    3834        48      SUBS     r0,r0,#0x34
        0x00804de6:    6800        .h      LDR      r0,[r0,#0]
        0x00804de8:    f3c01000    ....    UBFX     r0,r0,#4,#1
        0x00804dec:    b110        ..      CBZ      r0,0x804df4 ; warm_boot_second + 40
        0x00804dee:    2020                MOVS     r0,#0x20
        0x00804df0:    f000f8a9    ....    BL       ll_pwr_clear_ext_wakeup_status ; 0x804f46
        0x00804df4:    f000f89d    ....    BL       ll_pwr_get_ext_wakeup_status ; 0x804f32
        0x00804df8:    495d        ]I      LDR      r1,[pc,#372] ; [0x804f70] = 0x300067a4
        0x00804dfa:    7008        .p      STRB     r0,[r1,#0]
        0x00804dfc:    7808        .x      LDRB     r0,[r1,#0]
        0x00804dfe:    f3fff7c7    ....    BL       ll_aon_gpio_is_enabled_it ; 0x1004d90
        0x00804e02:    b128        (.      CBZ      r0,0x804e10 ; warm_boot_second + 68
        0x00804e04:    2012        .       MOVS     r0,#0x12
        0x00804e06:    f3fdf62d    ..-.    BL       __NVIC_SetPendingIRQ ; 0x1002a64
        0x00804e0a:    2012        .       MOVS     r0,#0x12
        0x00804e0c:    f3fdf5e1    ....    BL       __NVIC_EnableIRQ ; 0x10029d2
        0x00804e10:    4c53        SL      LDR      r4,[pc,#332] ; [0x804f60] = 0xa000c538
        0x00804e12:    340c        .4      ADDS     r4,r4,#0xc
        0x00804e14:    6820         h      LDR      r0,[r4,#0]
        0x00804e16:    f3c01000    ....    UBFX     r0,r0,#4,#1
        0x00804e1a:    b110        ..      CBZ      r0,0x804e22 ; warm_boot_second + 86
        0x00804e1c:    201b        .       MOVS     r0,#0x1b
        0x00804e1e:    f3fdf5d8    ....    BL       __NVIC_EnableIRQ ; 0x10029d2
        0x00804e22:    20ff        .       MOVS     r0,#0xff
        0x00804e24:    f000f88f    ....    BL       ll_pwr_clear_ext_wakeup_status ; 0x804f46
        0x00804e28:    f06f0004    o...    MVN      r0,#4
        0x00804e2c:    6020         `      STR      r0,[r4,#0]
        0x00804e2e:    201b        .       MOVS     r0,#0x1b
        0x00804e30:    f3fdf593    ....    BL       __NVIC_ClearPendingIRQ ; 0x100295a
        0x00804e34:    484f        OH      LDR      r0,[pc,#316] ; [0x804f74] = 0x30006958
        0x00804e36:    7800        .x      LDRB     r0,[r0,#0]
        0x00804e38:    b110        ..      CBZ      r0,0x804e40 ; warm_boot_second + 116
        0x00804e3a:    201b        .       MOVS     r0,#0x1b
        0x00804e3c:    f3fdf5c9    ....    BL       __NVIC_EnableIRQ ; 0x10029d2
        0x00804e40:    2012        .       MOVS     r0,#0x12
        0x00804e42:    f3fdf5c6    ....    BL       __NVIC_EnableIRQ ; 0x10029d2
        0x00804e46:    201c        .       MOVS     r0,#0x1c
        0x00804e48:    f3fdf5c3    ....    BL       __NVIC_EnableIRQ ; 0x10029d2
        0x00804e4c:    e8bd4010    ...@    POP      {r4,lr}
        0x00804e50:    2021        !       MOVS     r0,#0x21
        0x00804e52:    f3fdb5be    ....    B.W      __NVIC_EnableIRQ ; 0x10029d2
    warm_boot_first
        0x00804e56:    b510        ..      PUSH     {r4,lr}
        0x00804e58:    f000feeb    ....    BL       system_priority_restore_func ; 0x805c32
        0x00804e5c:    2018        .       MOVS     r0,#0x18
        0x00804e5e:    f3fdf57c    ..|.    BL       __NVIC_ClearPendingIRQ ; 0x100295a
        0x00804e62:    2019        .       MOVS     r0,#0x19
        0x00804e64:    f3fdf5b5    ....    BL       __NVIC_EnableIRQ ; 0x10029d2
        0x00804e68:    2002        .       MOVS     r0,#2
        0x00804e6a:    f3fdf5b2    ....    BL       __NVIC_EnableIRQ ; 0x10029d2
        0x00804e6e:    f3fff273    ..s.    BL       hal_flash_init ; 0x1004358
        0x00804e72:    f7ffffaa    ....    BL       hal_pm_resume ; 0x804dca
        0x00804e76:    f473f54d    s.M.    BL       pwr_mgmt_dev_resume ; 0x78914
        0x00804e7a:    e8bd4010    ...@    POP      {r4,lr}
        0x00804e7e:    f45db78b    ]...    B        pwr_mgmt_load_context ; 0x62d98
    warm_boot
        0x00804e82:    b510        ..      PUSH     {r4,lr}
        0x00804e84:    f000fed5    ....    BL       system_priority_restore_func ; 0x805c32
        0x00804e88:    2018        .       MOVS     r0,#0x18
        0x00804e8a:    f3fdf566    ..f.    BL       __NVIC_ClearPendingIRQ ; 0x100295a
        0x00804e8e:    2019        .       MOVS     r0,#0x19
        0x00804e90:    f3fdf59f    ....    BL       __NVIC_EnableIRQ ; 0x10029d2
        0x00804e94:    2002        .       MOVS     r0,#2
        0x00804e96:    f3fdf59c    ....    BL       __NVIC_EnableIRQ ; 0x10029d2
        0x00804e9a:    f3fff25d    ..].    BL       hal_flash_init ; 0x1004358
        0x00804e9e:    f473f539    s.9.    BL       pwr_mgmt_dev_resume ; 0x78914
        0x00804ea2:    2001        .       MOVS     r0,#1
        0x00804ea4:    f3fdf595    ....    BL       __NVIC_EnableIRQ ; 0x10029d2
        0x00804ea8:    f7ffff8f    ....    BL       hal_pm_resume ; 0x804dca
        0x00804eac:    201b        .       MOVS     r0,#0x1b
        0x00804eae:    f3fdf59d    ....    BL       __NVIC_GetPendingIRQ ; 0x10029ec
        0x00804eb2:    b340        @.      CBZ      r0,0x804f06 ; warm_boot + 132
        0x00804eb4:    482a        *H      LDR      r0,[pc,#168] ; [0x804f60] = 0xa000c538
        0x00804eb6:    3834        48      SUBS     r0,r0,#0x34
        0x00804eb8:    6800        .h      LDR      r0,[r0,#0]
        0x00804eba:    f3c01000    ....    UBFX     r0,r0,#4,#1
        0x00804ebe:    b110        ..      CBZ      r0,0x804ec6 ; warm_boot + 68
        0x00804ec0:    2020                MOVS     r0,#0x20
        0x00804ec2:    f000f840    ..@.    BL       ll_pwr_clear_ext_wakeup_status ; 0x804f46
        0x00804ec6:    f000f834    ..4.    BL       ll_pwr_get_ext_wakeup_status ; 0x804f32
        0x00804eca:    4929        )I      LDR      r1,[pc,#164] ; [0x804f70] = 0x300067a4
        0x00804ecc:    7008        .p      STRB     r0,[r1,#0]
        0x00804ece:    7808        .x      LDRB     r0,[r1,#0]
        0x00804ed0:    f3fff75e    ..^.    BL       ll_aon_gpio_is_enabled_it ; 0x1004d90
        0x00804ed4:    b128        (.      CBZ      r0,0x804ee2 ; warm_boot + 96
        0x00804ed6:    2012        .       MOVS     r0,#0x12
        0x00804ed8:    f3fdf5c4    ....    BL       __NVIC_SetPendingIRQ ; 0x1002a64
        0x00804edc:    2012        .       MOVS     r0,#0x12
        0x00804ede:    f3fdf578    ..x.    BL       __NVIC_EnableIRQ ; 0x10029d2
        0x00804ee2:    4c1f        .L      LDR      r4,[pc,#124] ; [0x804f60] = 0xa000c538
        0x00804ee4:    340c        .4      ADDS     r4,r4,#0xc
        0x00804ee6:    6820         h      LDR      r0,[r4,#0]
        0x00804ee8:    f3c01000    ....    UBFX     r0,r0,#4,#1
        0x00804eec:    b110        ..      CBZ      r0,0x804ef4 ; warm_boot + 114
        0x00804eee:    201b        .       MOVS     r0,#0x1b
        0x00804ef0:    f3fdf56f    ..o.    BL       __NVIC_EnableIRQ ; 0x10029d2
        0x00804ef4:    20ff        .       MOVS     r0,#0xff
        0x00804ef6:    f000f826    ..&.    BL       ll_pwr_clear_ext_wakeup_status ; 0x804f46
        0x00804efa:    f06f0004    o...    MVN      r0,#4
        0x00804efe:    6020         `      STR      r0,[r4,#0]
        0x00804f00:    201b        .       MOVS     r0,#0x1b
        0x00804f02:    f3fdf52a    ..*.    BL       __NVIC_ClearPendingIRQ ; 0x100295a
        0x00804f06:    481b        .H      LDR      r0,[pc,#108] ; [0x804f74] = 0x30006958
        0x00804f08:    7800        .x      LDRB     r0,[r0,#0]
        0x00804f0a:    b110        ..      CBZ      r0,0x804f12 ; warm_boot + 144
        0x00804f0c:    201b        .       MOVS     r0,#0x1b
        0x00804f0e:    f3fdf560    ..`.    BL       __NVIC_EnableIRQ ; 0x10029d2
        0x00804f12:    2012        .       MOVS     r0,#0x12
        0x00804f14:    f3fdf55d    ..].    BL       __NVIC_EnableIRQ ; 0x10029d2
        0x00804f18:    201c        .       MOVS     r0,#0x1c
        0x00804f1a:    f3fdf55a    ..Z.    BL       __NVIC_EnableIRQ ; 0x10029d2
        0x00804f1e:    201a        .       MOVS     r0,#0x1a
        0x00804f20:    f3fdf557    ..W.    BL       __NVIC_EnableIRQ ; 0x10029d2
        0x00804f24:    2021        !       MOVS     r0,#0x21
        0x00804f26:    f3fdf554    ..T.    BL       __NVIC_EnableIRQ ; 0x10029d2
        0x00804f2a:    e8bd4010    ...@    POP      {r4,lr}
        0x00804f2e:    f45db733    ].3.    B        pwr_mgmt_load_context ; 0x62d98
    ll_pwr_get_ext_wakeup_status
        0x00804f32:    480b        .H      LDR      r0,[pc,#44] ; [0x804f60] = 0xa000c538
        0x00804f34:    300c        .0      ADDS     r0,r0,#0xc
        0x00804f36:    6800        .h      LDR      r0,[r0,#0]
        0x00804f38:    4909        .I      LDR      r1,[pc,#36] ; [0x804f60] = 0xa000c538
        0x00804f3a:    f3c04007    ...@    UBFX     r0,r0,#16,#8
        0x00804f3e:    3120         1      ADDS     r1,r1,#0x20
        0x00804f40:    6809        .h      LDR      r1,[r1,#0]
        0x00804f42:    4008        .@      ANDS     r0,r0,r1
        0x00804f44:    4770        pG      BX       lr
    ll_pwr_clear_ext_wakeup_status
        0x00804f46:    f3ef8110    ....    MRS      r1,PRIMASK
        0x00804f4a:    2201        ."      MOVS     r2,#1
        0x00804f4c:    f3828810    ....    MSR      PRIMASK,r2
        0x00804f50:    4a03        .J      LDR      r2,[pc,#12] ; [0x804f60] = 0xa000c538
        0x00804f52:    ea6f4000    o..@    MVN      r0,r0,LSL #16
        0x00804f56:    320c        .2      ADDS     r2,r2,#0xc
        0x00804f58:    6010        .`      STR      r0,[r2,#0]
        0x00804f5a:    f3818810    ....    MSR      PRIMASK,r1
        0x00804f5e:    4770        pG      BX       lr
    $d
        0x00804f60:    a000c538    8...    DCD    2684405048
        0x00804f64:    fff803ff    ....    DCD    4294444031
        0x00804f68:    30006814    .h.0    DCD    805333012
        0x00804f6c:    00803212    .2..    DCD    8401426
        0x00804f70:    300067a4    .g.0    DCD    805332900
        0x00804f74:    30006958    Xi.0    DCD    805333336
    $t
    RAM_CODE
    get_sram_size
        0x00804f78:    b508        ..      PUSH     {r3,lr}
        0x00804f7a:    4668        hF      MOV      r0,sp
        0x00804f7c:    f001d9e6    ....    BL       sys_device_sram_get ; 0x100634c
        0x00804f80:    b928        (.      CBNZ     r0,0x804f8e ; get_sram_size + 22
        0x00804f82:    f89d0000    ....    LDRB     r0,[sp,#0]
        0x00804f86:    2802        .(      CMP      r0,#2
        0x00804f88:    d003        ..      BEQ      0x804f92 ; get_sram_size + 26
        0x00804f8a:    2801        .(      CMP      r0,#1
        0x00804f8c:    d003        ..      BEQ      0x804f96 ; get_sram_size + 30
        0x00804f8e:    2000        .       MOVS     r0,#0
        0x00804f90:    bd08        ..      POP      {r3,pc}
        0x00804f92:    2002        .       MOVS     r0,#2
        0x00804f94:    bd08        ..      POP      {r3,pc}
        0x00804f96:    2001        .       MOVS     r0,#1
        0x00804f98:    bd08        ..      POP      {r3,pc}
    system_calculate_sram_size
        0x00804f9a:    b570        p.      PUSH     {r4-r6,lr}
        0x00804f9c:    4604        .F      MOV      r4,r0
        0x00804f9e:    460d        .F      MOV      r5,r1
        0x00804fa0:    f7ffffea    ....    BL       get_sram_size ; 0x804f78
        0x00804fa4:    2802        .(      CMP      r0,#2
        0x00804fa6:    d00a        ..      BEQ      0x804fbe ; system_calculate_sram_size + 36
        0x00804fa8:    2801        .(      CMP      r0,#1
        0x00804faa:    d107        ..      BNE      0x804fbc ; system_calculate_sram_size + 34
        0x00804fac:    6820         h      LDR      r0,[r4,#0]
        0x00804fae:    f420107f     ...    BIC      r0,r0,#0x3fc000
        0x00804fb2:    6020         `      STR      r0,[r4,#0]
        0x00804fb4:    6828        (h      LDR      r0,[r5,#0]
        0x00804fb6:    f420107f     ...    BIC      r0,r0,#0x3fc000
        0x00804fba:    6028        (`      STR      r0,[r5,#0]
        0x00804fbc:    bd70        p.      POP      {r4-r6,pc}
        0x00804fbe:    4828        (H      LDR      r0,[pc,#160] ; [0x805060] = 0xffc003ff
        0x00804fc0:    6821        !h      LDR      r1,[r4,#0]
        0x00804fc2:    4001        .@      ANDS     r1,r1,r0
        0x00804fc4:    6021        !`      STR      r1,[r4,#0]
        0x00804fc6:    6829        )h      LDR      r1,[r5,#0]
        0x00804fc8:    4001        .@      ANDS     r1,r1,r0
        0x00804fca:    6029        )`      STR      r1,[r5,#0]
        0x00804fcc:    bd70        p.      POP      {r4-r6,pc}
    mem_pwr_mgmt_work_state_set
        0x00804fce:    b51c        ..      PUSH     {r2-r4,lr}
        0x00804fd0:    9001        ..      STR      r0,[sp,#4]
        0x00804fd2:    2000        .       MOVS     r0,#0
        0x00804fd4:    9000        ..      STR      r0,[sp,#0]
        0x00804fd6:    a901        ..      ADD      r1,sp,#4
        0x00804fd8:    4668        hF      MOV      r0,sp
        0x00804fda:    f7ffffde    ....    BL       system_calculate_sram_size ; 0x804f9a
        0x00804fde:    9801        ..      LDR      r0,[sp,#4]
        0x00804fe0:    4920         I      LDR      r1,[pc,#128] ; [0x805064] = 0xa000c568
        0x00804fe2:    f00030aa    ...0    AND      r0,r0,#0xaaaaaaaa
        0x00804fe6:    6008        .`      STR      r0,[r1,#0]
        0x00804fe8:    481e        .H      LDR      r0,[pc,#120] ; [0x805064] = 0xa000c568
        0x00804fea:    3018        .0      ADDS     r0,r0,#0x18
        0x00804fec:    6801        .h      LDR      r1,[r0,#0]
        0x00804fee:    f3c10140    ..@.    UBFX     r1,r1,#1,#1
        0x00804ff2:    2900        .)      CMP      r1,#0
        0x00804ff4:    d1fa        ..      BNE      0x804fec ; mem_pwr_mgmt_work_state_set + 30
        0x00804ff6:    4a1b        .J      LDR      r2,[pc,#108] ; [0x805064] = 0xa000c568
        0x00804ff8:    210a        .!      MOVS     r1,#0xa
        0x00804ffa:    321c        .2      ADDS     r2,r2,#0x1c
        0x00804ffc:    6011        .`      STR      r1,[r2,#0]
        0x00804ffe:    6801        .h      LDR      r1,[r0,#0]
        0x00805000:    f0410101    A...    ORR      r1,r1,#1
        0x00805004:    6001        .`      STR      r1,[r0,#0]
        0x00805006:    6801        .h      LDR      r1,[r0,#0]
        0x00805008:    f3c10140    ..@.    UBFX     r1,r1,#1,#1
        0x0080500c:    2900        .)      CMP      r1,#0
        0x0080500e:    d1fa        ..      BNE      0x805006 ; mem_pwr_mgmt_work_state_set + 56
        0x00805010:    bd1c        ..      POP      {r2-r4,pc}
    mem_pwr_mgmt_sleep_state_set
        0x00805012:    b51c        ..      PUSH     {r2-r4,lr}
        0x00805014:    2100        .!      MOVS     r1,#0
        0x00805016:    9101        ..      STR      r1,[sp,#4]
        0x00805018:    9000        ..      STR      r0,[sp,#0]
        0x0080501a:    a901        ..      ADD      r1,sp,#4
        0x0080501c:    4668        hF      MOV      r0,sp
        0x0080501e:    f7ffffbc    ....    BL       system_calculate_sram_size ; 0x804f9a
        0x00805022:    4910        .I      LDR      r1,[pc,#64] ; [0x805064] = 0xa000c568
        0x00805024:    9800        ..      LDR      r0,[sp,#0]
        0x00805026:    1f09        ..      SUBS     r1,r1,#4
        0x00805028:    6008        .`      STR      r0,[r1,#0]
        0x0080502a:    bd1c        ..      POP      {r2-r4,pc}
    mem_pwr_mgmt_check_processs
        0x0080502c:    b570        p.      PUSH     {r4-r6,lr}
        0x0080502e:    480d        .H      LDR      r0,[pc,#52] ; [0x805064] = 0xa000c568
        0x00805030:    6805        .h      LDR      r5,[r0,#0]
        0x00805032:    2400        .$      MOVS     r4,#0
        0x00805034:    f7ffffa0    ....    BL       get_sram_size ; 0x804f78
        0x00805038:    2802        .(      CMP      r0,#2
        0x0080503a:    d002        ..      BEQ      0x805042 ; mem_pwr_mgmt_check_processs + 22
        0x0080503c:    2801        .(      CMP      r0,#1
        0x0080503e:    d003        ..      BEQ      0x805048 ; mem_pwr_mgmt_check_processs + 28
        0x00805040:    e004        ..      B        0x80504c ; mem_pwr_mgmt_check_processs + 32
        0x00805042:    4c07        .L      LDR      r4,[pc,#28] ; [0x805060] = 0xffc003ff
        0x00805044:    43e4        .C      MVNS     r4,r4
        0x00805046:    e001        ..      B        0x80504c ; mem_pwr_mgmt_check_processs + 32
        0x00805048:    f44f147f    O...    MOV      r4,#0x3fc000
        0x0080504c:    4225        %B      TST      r5,r4
        0x0080504e:    d006        ..      BEQ      0x80505e ; mem_pwr_mgmt_check_processs + 50
        0x00805050:    4628        (F      MOV      r0,r5
        0x00805052:    f7ffffbc    ....    BL       mem_pwr_mgmt_work_state_set ; 0x804fce
        0x00805056:    4628        (F      MOV      r0,r5
        0x00805058:    e8bd4070    ..p@    POP      {r4-r6,lr}
        0x0080505c:    e7d9        ..      B        mem_pwr_mgmt_sleep_state_set ; 0x805012
        0x0080505e:    bd70        p.      POP      {r4-r6,pc}
    $d
        0x00805060:    ffc003ff    ....    DCD    4290774015
        0x00805064:    a000c568    h...    DCD    2684405096
    $t
    RAM_CODE
    ll_cgc_disable_secu_clk
        0x00805068:    48f8        .H      LDR      r0,[pc,#992] ; [0x80544c] = 0xa000e2a0
        0x0080506a:    6841        Ah      LDR      r1,[r0,#4]
        0x0080506c:    f0210101    !...    BIC      r1,r1,#1
        0x00805070:    6041        A`      STR      r1,[r0,#4]
        0x00805072:    68c1        .h      LDR      r1,[r0,#0xc]
        0x00805074:    f0217100    !..q    BIC      r1,r1,#0x2000000
        0x00805078:    60c1        .`      STR      r1,[r0,#0xc]
        0x0080507a:    6801        .h      LDR      r1,[r0,#0]
        0x0080507c:    f0210101    !...    BIC      r1,r1,#1
        0x00805080:    6001        .`      STR      r1,[r0,#0]
        0x00805082:    68c1        .h      LDR      r1,[r0,#0xc]
        0x00805084:    f0217180    !..q    BIC      r1,r1,#0x1000000
        0x00805088:    60c1        .`      STR      r1,[r0,#0xc]
        0x0080508a:    4770        pG      BX       lr
    ll_cgc_enable_secu_clk
        0x0080508c:    48f0        .H      LDR      r0,[pc,#960] ; [0x805450] = 0x30006954
        0x0080508e:    6800        .h      LDR      r0,[r0,#0]
        0x00805090:    2800        .(      CMP      r0,#0
        0x00805092:    d110        ..      BNE      0x8050b6 ; ll_cgc_enable_secu_clk + 42
        0x00805094:    48ed        .H      LDR      r0,[pc,#948] ; [0x80544c] = 0xa000e2a0
        0x00805096:    6841        Ah      LDR      r1,[r0,#4]
        0x00805098:    f0410101    A...    ORR      r1,r1,#1
        0x0080509c:    6041        A`      STR      r1,[r0,#4]
        0x0080509e:    68c1        .h      LDR      r1,[r0,#0xc]
        0x008050a0:    f0417100    A..q    ORR      r1,r1,#0x2000000
        0x008050a4:    60c1        .`      STR      r1,[r0,#0xc]
        0x008050a6:    6801        .h      LDR      r1,[r0,#0]
        0x008050a8:    f0410101    A...    ORR      r1,r1,#1
        0x008050ac:    6001        .`      STR      r1,[r0,#0]
        0x008050ae:    68c1        .h      LDR      r1,[r0,#0xc]
        0x008050b0:    f0417180    A..q    ORR      r1,r1,#0x1000000
        0x008050b4:    60c1        .`      STR      r1,[r0,#0xc]
        0x008050b6:    4770        pG      BX       lr
    hal_exflash_operation_protection
        0x008050b8:    b510        ..      PUSH     {r4,lr}
        0x008050ba:    2200        ."      MOVS     r2,#0
        0x008050bc:    2800        .(      CMP      r0,#0
        0x008050be:    d00c        ..      BEQ      0x8050da ; hal_exflash_operation_protection + 34
        0x008050c0:    7a03        .z      LDRB     r3,[r0,#8]
        0x008050c2:    2b01        .+      CMP      r3,#1
        0x008050c4:    d00b        ..      BEQ      0x8050de ; hal_exflash_operation_protection + 38
        0x008050c6:    2301        .#      MOVS     r3,#1
        0x008050c8:    7203        .r      STRB     r3,[r0,#8]
        0x008050ca:    7a44        Dz      LDRB     r4,[r0,#9]
        0x008050cc:    2300        .#      MOVS     r3,#0
        0x008050ce:    2c01        .,      CMP      r4,#1
        0x008050d0:    d007        ..      BEQ      0x8050e2 ; hal_exflash_operation_protection + 42
        0x008050d2:    2202        ."      MOVS     r2,#2
        0x008050d4:    7203        .r      STRB     r3,[r0,#8]
        0x008050d6:    4610        .F      MOV      r0,r2
        0x008050d8:    bd10        ..      POP      {r4,pc}
        0x008050da:    2001        .       MOVS     r0,#1
        0x008050dc:    bd10        ..      POP      {r4,pc}
        0x008050de:    2002        .       MOVS     r0,#2
        0x008050e0:    bd10        ..      POP      {r4,pc}
        0x008050e2:    6183        .a      STR      r3,[r0,#0x18]
        0x008050e4:    4cdb        .L      LDR      r4,[pc,#876] ; [0x805454] = 0x30006964
        0x008050e6:    6021        !`      STR      r1,[r4,#0]
        0x008050e8:    e7f4        ..      B        0x8050d4 ; hal_exflash_operation_protection + 28
    hal_exflash_write
        0x008050ea:    e92d4ff0    -..O    PUSH     {r4-r11,lr}
        0x008050ee:    f5ad7d07    ...}    SUB      sp,sp,#0x21c
        0x008050f2:    4604        .F      MOV      r4,r0
        0x008050f4:    4690        .F      MOV      r8,r2
        0x008050f6:    461d        .F      MOV      r5,r3
        0x008050f8:    2700        .'      MOVS     r7,#0
        0x008050fa:    f1a17680    ...v    SUB      r6,r1,#0x1000000
        0x008050fe:    f3ef8011    ....    MRS      r0,BASEPRI
        0x00805102:    9006        ..      STR      r0,[sp,#0x18]
        0x00805104:    f3ef8010    ....    MRS      r0,PRIMASK
        0x00805108:    9005        ..      STR      r0,[sp,#0x14]
        0x0080510a:    f1b17f80    ....    CMP      r1,#0x1000000
        0x0080510e:    d30e        ..      BCC      0x80512e ; hal_exflash_write + 68
        0x00805110:    6920         i      LDR      r0,[r4,#0x10]
        0x00805112:    194a        J.      ADDS     r2,r1,r5
        0x00805114:    f1007080    ...p    ADD      r0,r0,#0x1000000
        0x00805118:    4282        .B      CMP      r2,r0
        0x0080511a:    d808        ..      BHI      0x80512e ; hal_exflash_write + 68
        0x0080511c:    f1b80f00    ....    CMP      r8,#0
        0x00805120:    d005        ..      BEQ      0x80512e ; hal_exflash_write + 68
        0x00805122:    b125        %.      CBZ      r5,0x80512e ; hal_exflash_write + 68
        0x00805124:    7aa0        .z      LDRB     r0,[r4,#0xa]
        0x00805126:    2801        .(      CMP      r0,#1
        0x00805128:    d108        ..      BNE      0x80513c ; hal_exflash_write + 82
        0x0080512a:    0788        ..      LSLS     r0,r1,#30
        0x0080512c:    d006        ..      BEQ      0x80513c ; hal_exflash_write + 82
        0x0080512e:    2008        .       MOVS     r0,#8
        0x00805130:    61a0        .a      STR      r0,[r4,#0x18]
        0x00805132:    2001        .       MOVS     r0,#1
        0x00805134:    f50d7d07    ...}    ADD      sp,sp,#0x21c
        0x00805138:    e8bd8ff0    ....    POP      {r4-r11,pc}
        0x0080513c:    7a20         z      LDRB     r0,[r4,#8]
        0x0080513e:    2801        .(      CMP      r0,#1
        0x00805140:    d009        ..      BEQ      0x805156 ; hal_exflash_write + 108
        0x00805142:    2001        .       MOVS     r0,#1
        0x00805144:    7220         r      STRB     r0,[r4,#8]
        0x00805146:    7a60        `z      LDRB     r0,[r4,#9]
        0x00805148:    2801        .(      CMP      r0,#1
        0x0080514a:    d006        ..      BEQ      0x80515a ; hal_exflash_write + 112
        0x0080514c:    2702        .'      MOVS     r7,#2
        0x0080514e:    2000        .       MOVS     r0,#0
        0x00805150:    7220         r      STRB     r0,[r4,#8]
        0x00805152:    4638        8F      MOV      r0,r7
        0x00805154:    e7ee        ..      B        0x805134 ; hal_exflash_write + 74
        0x00805156:    2002        .       MOVS     r0,#2
        0x00805158:    e7ec        ..      B        0x805134 ; hal_exflash_write + 74
        0x0080515a:    2000        .       MOVS     r0,#0
        0x0080515c:    61a0        .a      STR      r0,[r4,#0x18]
        0x0080515e:    6820         h      LDR      r0,[r4,#0]
        0x00805160:    6800        .h      LDR      r0,[r0,#0]
        0x00805162:    f8d00c10    ....    LDR      r0,[r0,#0xc10]
        0x00805166:    f0000001    ....    AND      r0,r0,#1
        0x0080516a:    b968        h.      CBNZ     r0,0x805188 ; hal_exflash_write + 158
        0x0080516c:    4620         F      MOV      r0,r4
        0x0080516e:    f409f30d    ....    BL       exflash_wakeup ; 0xe78c
        0x00805172:    4620         F      MOV      r0,r4
        0x00805174:    f409f142    ..B.    BL       exflash_check_id ; 0xe3fc
        0x00805178:    4607        .F      MOV      r7,r0
        0x0080517a:    0038        8.      MOVS     r0,r7
        0x0080517c:    d002        ..      BEQ      0x805184 ; hal_exflash_write + 154
        0x0080517e:    2003        .       MOVS     r0,#3
        0x00805180:    61a0        .a      STR      r0,[r4,#0x18]
        0x00805182:    e0b2        ..      B        0x8052ea ; hal_exflash_write + 512
        0x00805184:    2002        .       MOVS     r0,#2
        0x00805186:    7260        `r      STRB     r0,[r4,#9]
        0x00805188:    eb060a05    ....    ADD      r10,r6,r5
        0x0080518c:    e0aa        ..      B        0x8052e4 ; hal_exflash_write + 506
        0x0080518e:    b2f0        ..      UXTB     r0,r6
        0x00805190:    f5c07580    ...u    RSB      r5,r0,#0x100
        0x00805194:    1970        p.      ADDS     r0,r6,r5
        0x00805196:    4582        .E      CMP      r10,r0
        0x00805198:    d201        ..      BCS      0x80519e ; hal_exflash_write + 180
        0x0080519a:    ebaa0506    ....    SUB      r5,r10,r6
        0x0080519e:    2000        .       MOVS     r0,#0
        0x008051a0:    f50d798e    ...y    ADD      r9,sp,#0x11c
        0x008051a4:    e004        ..      B        0x8051b0 ; hal_exflash_write + 198
        0x008051a6:    f8181000    ....    LDRB     r1,[r8,r0]
        0x008051aa:    f8091000    ....    STRB     r1,[r9,r0]
        0x008051ae:    1c40        @.      ADDS     r0,r0,#1
        0x008051b0:    42a8        .B      CMP      r0,r5
        0x008051b2:    d3f8        ..      BCC      0x8051a6 ; hal_exflash_write + 188
        0x008051b4:    af47        G.      ADD      r7,sp,#0x11c
        0x008051b6:    6821        !h      LDR      r1,[r4,#0]
        0x008051b8:    6808        .h      LDR      r0,[r1,#0]
        0x008051ba:    f8d00c10    ....    LDR      r0,[r0,#0xc10]
        0x008051be:    f0000001    ....    AND      r0,r0,#1
        0x008051c2:    b1c0        ..      CBZ      r0,0x8051f6 ; hal_exflash_write + 268
        0x008051c4:    48a3        .H      LDR      r0,[pc,#652] ; [0x805454] = 0x30006964
        0x008051c6:    6800        .h      LDR      r0,[r0,#0]
        0x008051c8:    b1c8        ..      CBZ      r0,0x8051fe ; hal_exflash_write + 276
        0x008051ca:    4aa3        .J      LDR      r2,[pc,#652] ; [0x805458] = 0xe000ed0c
        0x008051cc:    6812        .h      LDR      r2,[r2,#0]
        0x008051ce:    f3c22202    ..."    UBFX     r2,r2,#8,#3
        0x008051d2:    1c52        R.      ADDS     r2,r2,#1
        0x008051d4:    4090        .@      LSLS     r0,r0,r2
        0x008051d6:    b2c0        ..      UXTB     r0,r0
        0x008051d8:    f3808811    ....    MSR      BASEPRI,r0
        0x008051dc:    f3ef8b10    ....    MRS      r11,PRIMASK
        0x008051e0:    2001        .       MOVS     r0,#1
        0x008051e2:    f3808810    ....    MSR      PRIMASK,r0
        0x008051e6:    6048        H`      STR      r0,[r1,#4]
        0x008051e8:    6820         h      LDR      r0,[r4,#0]
        0x008051ea:    f000fce9    ....    BL       hal_xqspi_init_ext ; 0x805bc0
        0x008051ee:    2002        .       MOVS     r0,#2
        0x008051f0:    7260        `r      STRB     r0,[r4,#9]
        0x008051f2:    f38b8810    ....    MSR      PRIMASK,r11
        0x008051f6:    7aa0        .z      LDRB     r0,[r4,#0xa]
        0x008051f8:    2801        .(      CMP      r0,#1
        0x008051fa:    d004        ..      BEQ      0x805206 ; hal_exflash_write + 284
        0x008051fc:    e03a        :.      B        0x805274 ; hal_exflash_write + 394
        0x008051fe:    2001        .       MOVS     r0,#1
        0x00805200:    f3808810    ....    MSR      PRIMASK,r0
        0x00805204:    e7ea        ..      B        0x8051dc ; hal_exflash_write + 242
        0x00805206:    f476f6b1    v...    BL       sys_security_enable_status_check ; 0x7bf6c
        0x0080520a:    b398        ..      CBZ      r0,0x805274 ; hal_exflash_write + 394
        0x0080520c:    f00507f0    ....    AND      r7,r5,#0xf0
        0x00805210:    f7ffff2a    ..*.    BL       ll_cgc_disable_secu_clk ; 0x805068
        0x00805214:    2d0f        .-      CMP      r5,#0xf
        0x00805216:    d906        ..      BLS      0x805226 ; hal_exflash_write + 316
        0x00805218:    f025020f    %...    BIC      r2,r5,#0xf
        0x0080521c:    ab07        ..      ADD      r3,sp,#0x1c
        0x0080521e:    a947        G.      ADD      r1,sp,#0x11c
        0x00805220:    4630        0F      MOV      r0,r6
        0x00805222:    f476f69b    v...    BL       sys_security_data_use_present ; 0x7bf5c
        0x00805226:    0728        (.      LSLS     r0,r5,#28
        0x00805228:    d021        !.      BEQ      0x80526e ; hal_exflash_write + 388
        0x0080522a:    2000        .       MOVS     r0,#0
        0x0080522c:    9001        ..      STR      r0,[sp,#4]
        0x0080522e:    9002        ..      STR      r0,[sp,#8]
        0x00805230:    9003        ..      STR      r0,[sp,#0xc]
        0x00805232:    9004        ..      STR      r0,[sp,#0x10]
        0x00805234:    4649        IF      MOV      r1,r9
        0x00805236:    f10d0b04    ....    ADD      r11,sp,#4
        0x0080523a:    f005090f    ....    AND      r9,r5,#0xf
        0x0080523e:    e004        ..      B        0x80524a ; hal_exflash_write + 352
        0x00805240:    183a        :.      ADDS     r2,r7,r0
        0x00805242:    5c8a        .\      LDRB     r2,[r1,r2]
        0x00805244:    f80b2000    ...     STRB     r2,[r11,r0]
        0x00805248:    1c40        @.      ADDS     r0,r0,#1
        0x0080524a:    4581        .E      CMP      r9,r0
        0x0080524c:    d8f8        ..      BHI      0x805240 ; hal_exflash_write + 342
        0x0080524e:    19f0        ..      ADDS     r0,r6,r7
        0x00805250:    ab01        ..      ADD      r3,sp,#4
        0x00805252:    2210        ."      MOVS     r2,#0x10
        0x00805254:    a901        ..      ADD      r1,sp,#4
        0x00805256:    f476f681    v...    BL       sys_security_data_use_present ; 0x7bf5c
        0x0080525a:    2000        .       MOVS     r0,#0
        0x0080525c:    a907        ..      ADD      r1,sp,#0x1c
        0x0080525e:    e004        ..      B        0x80526a ; hal_exflash_write + 384
        0x00805260:    183b        ;.      ADDS     r3,r7,r0
        0x00805262:    f81b2000    ...     LDRB     r2,[r11,r0]
        0x00805266:    54ca        .T      STRB     r2,[r1,r3]
        0x00805268:    1c40        @.      ADDS     r0,r0,#1
        0x0080526a:    4581        .E      CMP      r9,r0
        0x0080526c:    d8f8        ..      BHI      0x805260 ; hal_exflash_write + 374
        0x0080526e:    af07        ..      ADD      r7,sp,#0x1c
        0x00805270:    f7ffff0c    ....    BL       ll_cgc_enable_secu_clk ; 0x80508c
        0x00805274:    f44f707a    O.zp    MOV      r0,#0x3e8
        0x00805278:    9000        ..      STR      r0,[sp,#0]
        0x0080527a:    462b        +F      MOV      r3,r5
        0x0080527c:    463a        :F      MOV      r2,r7
        0x0080527e:    4631        1F      MOV      r1,r6
        0x00805280:    4620         F      MOV      r0,r4
        0x00805282:    f409f1a9    ....    BL       exflash_page_program ; 0xe5d8
        0x00805286:    4607        .F      MOV      r7,r0
        0x00805288:    6860        `h      LDR      r0,[r4,#4]
        0x0080528a:    b9d8        ..      CBNZ     r0,0x8052c4 ; hal_exflash_write + 474
        0x0080528c:    6820         h      LDR      r0,[r4,#0]
        0x0080528e:    6801        .h      LDR      r1,[r0,#0]
        0x00805290:    f8d11c10    ....    LDR      r1,[r1,#0xc10]
        0x00805294:    f0010101    ....    AND      r1,r1,#1
        0x00805298:    b9a1        ..      CBNZ     r1,0x8052c4 ; hal_exflash_write + 474
        0x0080529a:    f3ef8910    ....    MRS      r9,PRIMASK
        0x0080529e:    2101        .!      MOVS     r1,#1
        0x008052a0:    f3818810    ....    MSR      PRIMASK,r1
        0x008052a4:    2100        .!      MOVS     r1,#0
        0x008052a6:    6041        A`      STR      r1,[r0,#4]
        0x008052a8:    6820         h      LDR      r0,[r4,#0]
        0x008052aa:    f000fc89    ....    BL       hal_xqspi_init_ext ; 0x805bc0
        0x008052ae:    2001        .       MOVS     r0,#1
        0x008052b0:    7260        `r      STRB     r0,[r4,#9]
        0x008052b2:    f3898810    ....    MSR      PRIMASK,r9
        0x008052b6:    4867        gH      LDR      r0,[pc,#412] ; [0x805454] = 0x30006964
        0x008052b8:    6800        .h      LDR      r0,[r0,#0]
        0x008052ba:    b138        8.      CBZ      r0,0x8052cc ; hal_exflash_write + 482
        0x008052bc:    9806        ..      LDR      r0,[sp,#0x18]
        0x008052be:    b2c0        ..      UXTB     r0,r0
        0x008052c0:    f3808811    ....    MSR      BASEPRI,r0
        0x008052c4:    b167        g.      CBZ      r7,0x8052e0 ; hal_exflash_write + 502
        0x008052c6:    2001        .       MOVS     r0,#1
        0x008052c8:    61a0        .a      STR      r0,[r4,#0x18]
        0x008052ca:    e00e        ..      B        0x8052ea ; hal_exflash_write + 512
        0x008052cc:    9805        ..      LDR      r0,[sp,#0x14]
        0x008052ce:    b118        ..      CBZ      r0,0x8052d8 ; hal_exflash_write + 494
        0x008052d0:    2001        .       MOVS     r0,#1
        0x008052d2:    f3808810    ....    MSR      PRIMASK,r0
        0x008052d6:    e7f5        ..      B        0x8052c4 ; hal_exflash_write + 474
        0x008052d8:    2000        .       MOVS     r0,#0
        0x008052da:    f3808810    ....    MSR      PRIMASK,r0
        0x008052de:    e7f1        ..      B        0x8052c4 ; hal_exflash_write + 474
        0x008052e0:    442e        .D      ADD      r6,r6,r5
        0x008052e2:    44a8        .D      ADD      r8,r8,r5
        0x008052e4:    45b2        .E      CMP      r10,r6
        0x008052e6:    f63faf52    ?.R.    BHI      0x80518e ; hal_exflash_write + 164
        0x008052ea:    6860        `h      LDR      r0,[r4,#4]
        0x008052ec:    2801        .(      CMP      r0,#1
        0x008052ee:    f47faf2e    ....    BNE      0x80514e ; hal_exflash_write + 100
        0x008052f2:    4620         F      MOV      r0,r4
        0x008052f4:    f409f0c0    ....    BL       exflash_deepsleep ; 0xe478
        0x008052f8:    2001        .       MOVS     r0,#1
        0x008052fa:    7260        `r      STRB     r0,[r4,#9]
        0x008052fc:    e727        '.      B        0x80514e ; hal_exflash_write + 100
    hal_exflash_erase
        0x008052fe:    e92d5ff0    -.._    PUSH     {r4-r12,lr}
        0x00805302:    4604        .F      MOV      r4,r0
        0x00805304:    460e        .F      MOV      r6,r1
        0x00805306:    469b        .F      MOV      r11,r3
        0x00805308:    2500        .%      MOVS     r5,#0
        0x0080530a:    f1a27a80    ...z    SUB      r10,r2,#0x1000000
        0x0080530e:    f3ef8811    ....    MRS      r8,BASEPRI
        0x00805312:    f3ef8910    ....    MRS      r9,PRIMASK
        0x00805316:    2e00        ..      CMP      r6,#0
        0x00805318:    d10c        ..      BNE      0x805334 ; hal_exflash_erase + 54
        0x0080531a:    f1b27f80    ....    CMP      r2,#0x1000000
        0x0080531e:    d317        ..      BCC      0x805350 ; hal_exflash_erase + 82
        0x00805320:    6920         i      LDR      r0,[r4,#0x10]
        0x00805322:    eb02010b    ....    ADD      r1,r2,r11
        0x00805326:    f1007080    ...p    ADD      r0,r0,#0x1000000
        0x0080532a:    4281        .B      CMP      r1,r0
        0x0080532c:    d810        ..      BHI      0x805350 ; hal_exflash_erase + 82
        0x0080532e:    f1bb0f00    ....    CMP      r11,#0
        0x00805332:    d00d        ..      BEQ      0x805350 ; hal_exflash_erase + 82
        0x00805334:    7a20         z      LDRB     r0,[r4,#8]
        0x00805336:    2801        .(      CMP      r0,#1
        0x00805338:    d00e        ..      BEQ      0x805358 ; hal_exflash_erase + 90
        0x0080533a:    2701        .'      MOVS     r7,#1
        0x0080533c:    7227        'r      STRB     r7,[r4,#8]
        0x0080533e:    7a60        `z      LDRB     r0,[r4,#9]
        0x00805340:    2801        .(      CMP      r0,#1
        0x00805342:    d00b        ..      BEQ      0x80535c ; hal_exflash_erase + 94
        0x00805344:    2502        .%      MOVS     r5,#2
        0x00805346:    2000        .       MOVS     r0,#0
        0x00805348:    7220         r      STRB     r0,[r4,#8]
        0x0080534a:    4628        (F      MOV      r0,r5
        0x0080534c:    e8bd9ff0    ....    POP      {r4-r12,pc}
        0x00805350:    2008        .       MOVS     r0,#8
        0x00805352:    61a0        .a      STR      r0,[r4,#0x18]
        0x00805354:    2001        .       MOVS     r0,#1
        0x00805356:    e7f9        ..      B        0x80534c ; hal_exflash_erase + 78
        0x00805358:    2002        .       MOVS     r0,#2
        0x0080535a:    e7f7        ..      B        0x80534c ; hal_exflash_erase + 78
        0x0080535c:    2000        .       MOVS     r0,#0
        0x0080535e:    61a0        .a      STR      r0,[r4,#0x18]
        0x00805360:    6820         h      LDR      r0,[r4,#0]
        0x00805362:    6800        .h      LDR      r0,[r0,#0]
        0x00805364:    f8d00c10    ....    LDR      r0,[r0,#0xc10]
        0x00805368:    f0000001    ....    AND      r0,r0,#1
        0x0080536c:    b968        h.      CBNZ     r0,0x80538a ; hal_exflash_erase + 140
        0x0080536e:    4620         F      MOV      r0,r4
        0x00805370:    f409f20c    ....    BL       exflash_wakeup ; 0xe78c
        0x00805374:    4620         F      MOV      r0,r4
        0x00805376:    f409f041    ..A.    BL       exflash_check_id ; 0xe3fc
        0x0080537a:    4605        .F      MOV      r5,r0
        0x0080537c:    0028        (.      MOVS     r0,r5
        0x0080537e:    d002        ..      BEQ      0x805386 ; hal_exflash_erase + 136
        0x00805380:    2003        .       MOVS     r0,#3
        0x00805382:    61a0        .a      STR      r0,[r4,#0x18]
        0x00805384:    e072        r.      B        0x80546c ; hal_exflash_erase + 366
        0x00805386:    2002        .       MOVS     r0,#2
        0x00805388:    7260        `r      STRB     r0,[r4,#9]
        0x0080538a:    2e01        ..      CMP      r6,#1
        0x0080538c:    d005        ..      BEQ      0x80539a ; hal_exflash_erase + 156
        0x0080538e:    ea4f361a    O..6    LSR      r6,r10,#12
        0x00805392:    ea4f3606    O..6    LSL      r6,r6,#12
        0x00805396:    44da        .D      ADD      r10,r10,r11
        0x00805398:    e066        f.      B        0x805468 ; hal_exflash_erase + 362
        0x0080539a:    4620         F      MOV      r0,r4
        0x0080539c:    f409f0ba    ....    BL       exflash_erase_chip ; 0xe514
        0x008053a0:    4605        .F      MOV      r5,r0
        0x008053a2:    0028        (.      MOVS     r0,r5
        0x008053a4:    d062        b.      BEQ      0x80546c ; hal_exflash_erase + 366
        0x008053a6:    61a7        .a      STR      r7,[r4,#0x18]
        0x008053a8:    e060        `.      B        0x80546c ; hal_exflash_erase + 366
        0x008053aa:    6821        !h      LDR      r1,[r4,#0]
        0x008053ac:    6808        .h      LDR      r0,[r1,#0]
        0x008053ae:    f8d00c10    ....    LDR      r0,[r0,#0xc10]
        0x008053b2:    f0000001    ....    AND      r0,r0,#1
        0x008053b6:    b1c0        ..      CBZ      r0,0x8053ea ; hal_exflash_erase + 236
        0x008053b8:    4826        &H      LDR      r0,[pc,#152] ; [0x805454] = 0x30006964
        0x008053ba:    6800        .h      LDR      r0,[r0,#0]
        0x008053bc:    b1e8        ..      CBZ      r0,0x8053fa ; hal_exflash_erase + 252
        0x008053be:    4a26        &J      LDR      r2,[pc,#152] ; [0x805458] = 0xe000ed0c
        0x008053c0:    6812        .h      LDR      r2,[r2,#0]
        0x008053c2:    f3c22202    ..."    UBFX     r2,r2,#8,#3
        0x008053c6:    1c52        R.      ADDS     r2,r2,#1
        0x008053c8:    4090        .@      LSLS     r0,r0,r2
        0x008053ca:    b2c0        ..      UXTB     r0,r0
        0x008053cc:    f3808811    ....    MSR      BASEPRI,r0
        0x008053d0:    f3ef8510    ....    MRS      r5,PRIMASK
        0x008053d4:    2001        .       MOVS     r0,#1
        0x008053d6:    f3808810    ....    MSR      PRIMASK,r0
        0x008053da:    604f        O`      STR      r7,[r1,#4]
        0x008053dc:    6820         h      LDR      r0,[r4,#0]
        0x008053de:    f000fbef    ....    BL       hal_xqspi_init_ext ; 0x805bc0
        0x008053e2:    2002        .       MOVS     r0,#2
        0x008053e4:    7260        `r      STRB     r0,[r4,#9]
        0x008053e6:    f3858810    ....    MSR      PRIMASK,r5
        0x008053ea:    4631        1F      MOV      r1,r6
        0x008053ec:    4620         F      MOV      r0,r4
        0x008053ee:    f409f0bf    ....    BL       exflash_erase_sector ; 0xe570
        0x008053f2:    4605        .F      MOV      r5,r0
        0x008053f4:    6860        `h      LDR      r0,[r4,#4]
        0x008053f6:    b120         .      CBZ      r0,0x805402 ; hal_exflash_erase + 260
        0x008053f8:    e01e        ..      B        0x805438 ; hal_exflash_erase + 314
        0x008053fa:    2001        .       MOVS     r0,#1
        0x008053fc:    f3808810    ....    MSR      PRIMASK,r0
        0x00805400:    e7e6        ..      B        0x8053d0 ; hal_exflash_erase + 210
        0x00805402:    6820         h      LDR      r0,[r4,#0]
        0x00805404:    6801        .h      LDR      r1,[r0,#0]
        0x00805406:    f8d11c10    ....    LDR      r1,[r1,#0xc10]
        0x0080540a:    f0010101    ....    AND      r1,r1,#1
        0x0080540e:    b999        ..      CBNZ     r1,0x805438 ; hal_exflash_erase + 314
        0x00805410:    f3ef8b10    ....    MRS      r11,PRIMASK
        0x00805414:    2101        .!      MOVS     r1,#1
        0x00805416:    f3818810    ....    MSR      PRIMASK,r1
        0x0080541a:    2100        .!      MOVS     r1,#0
        0x0080541c:    6041        A`      STR      r1,[r0,#4]
        0x0080541e:    6820         h      LDR      r0,[r4,#0]
        0x00805420:    f000fbce    ....    BL       hal_xqspi_init_ext ; 0x805bc0
        0x00805424:    7267        gr      STRB     r7,[r4,#9]
        0x00805426:    f38b8810    ....    MSR      PRIMASK,r11
        0x0080542a:    480a        .H      LDR      r0,[pc,#40] ; [0x805454] = 0x30006964
        0x0080542c:    6800        .h      LDR      r0,[r0,#0]
        0x0080542e:    b130        0.      CBZ      r0,0x80543e ; hal_exflash_erase + 320
        0x00805430:    f00800ff    ....    AND      r0,r8,#0xff
        0x00805434:    f3808811    ....    MSR      BASEPRI,r0
        0x00805438:    b1a5        ..      CBZ      r5,0x805464 ; hal_exflash_erase + 358
        0x0080543a:    61a7        .a      STR      r7,[r4,#0x18]
        0x0080543c:    e016        ..      B        0x80546c ; hal_exflash_erase + 366
        0x0080543e:    f1b90f00    ....    CMP      r9,#0
        0x00805442:    d00b        ..      BEQ      0x80545c ; hal_exflash_erase + 350
        0x00805444:    2001        .       MOVS     r0,#1
        0x00805446:    f3808810    ....    MSR      PRIMASK,r0
        0x0080544a:    e7f5        ..      B        0x805438 ; hal_exflash_erase + 314
    $d
        0x0080544c:    a000e2a0    ....    DCD    2684412576
        0x00805450:    30006954    Ti.0    DCD    805333332
        0x00805454:    30006964    di.0    DCD    805333348
        0x00805458:    e000ed0c    ....    DCD    3758157068
    $t
        0x0080545c:    2000        .       MOVS     r0,#0
        0x0080545e:    f3808810    ....    MSR      PRIMASK,r0
        0x00805462:    e7e9        ..      B        0x805438 ; hal_exflash_erase + 314
        0x00805464:    f5065680    ...V    ADD      r6,r6,#0x1000
        0x00805468:    45b2        .E      CMP      r10,r6
        0x0080546a:    d89e        ..      BHI      0x8053aa ; hal_exflash_erase + 172
        0x0080546c:    6860        `h      LDR      r0,[r4,#4]
        0x0080546e:    2801        .(      CMP      r0,#1
        0x00805470:    f47faf69    ..i.    BNE      0x805346 ; hal_exflash_erase + 72
        0x00805474:    4620         F      MOV      r0,r4
        0x00805476:    f408f7ff    ....    BL       exflash_deepsleep ; 0xe478
        0x0080547a:    7267        gr      STRB     r7,[r4,#9]
        0x0080547c:    e763        c.      B        0x805346 ; hal_exflash_erase + 72
    exflash_check_id_patch
        0x0080547e:    b510        ..      PUSH     {r4,lr}
        0x00805480:    b08a        ..      SUB      sp,sp,#0x28
        0x00805482:    4604        .F      MOV      r4,r0
        0x00805484:    209f        .       MOVS     r0,#0x9f
        0x00805486:    9002        ..      STR      r0,[sp,#8]
        0x00805488:    2000        .       MOVS     r0,#0
        0x0080548a:    9003        ..      STR      r0,[sp,#0xc]
        0x0080548c:    2101        .!      MOVS     r1,#1
        0x0080548e:    9104        ..      STR      r1,[sp,#0x10]
        0x00805490:    9005        ..      STR      r0,[sp,#0x14]
        0x00805492:    9006        ..      STR      r0,[sp,#0x18]
        0x00805494:    9007        ..      STR      r0,[sp,#0x1c]
        0x00805496:    9008        ..      STR      r0,[sp,#0x20]
        0x00805498:    2003        .       MOVS     r0,#3
        0x0080549a:    9009        ..      STR      r0,[sp,#0x24]
        0x0080549c:    f44f737a    O.zs    MOV      r3,#0x3e8
        0x008054a0:    aa01        ..      ADD      r2,sp,#4
        0x008054a2:    a902        ..      ADD      r1,sp,#8
        0x008054a4:    6820         h      LDR      r0,[r4,#0]
        0x008054a6:    f41cf40d    ....    BL       hal_xqspi_command_receive ; 0x21cc4
        0x008054aa:    2800        .(      CMP      r0,#0
        0x008054ac:    d111        ..      BNE      0x8054d2 ; exflash_check_id_patch + 84
        0x008054ae:    68e0        .h      LDR      r0,[r4,#0xc]
        0x008054b0:    b908        ..      CBNZ     r0,0x8054b6 ; exflash_check_id_patch + 56
        0x008054b2:    6920         i      LDR      r0,[r4,#0x10]
        0x008054b4:    b178        x.      CBZ      r0,0x8054d6 ; exflash_check_id_patch + 88
        0x008054b6:    f89d0005    ....    LDRB     r0,[sp,#5]
        0x008054ba:    f89d1004    ....    LDRB     r1,[sp,#4]
        0x008054be:    0200        ..      LSLS     r0,r0,#8
        0x008054c0:    eb004001    ...@    ADD      r0,r0,r1,LSL #16
        0x008054c4:    f89d1006    ....    LDRB     r1,[sp,#6]
        0x008054c8:    4408        .D      ADD      r0,r0,r1
        0x008054ca:    68e1        .h      LDR      r1,[r4,#0xc]
        0x008054cc:    4281        .B      CMP      r1,r0
        0x008054ce:    d11c        ..      BNE      0x80550a ; exflash_check_id_patch + 140
        0x008054d0:    2000        .       MOVS     r0,#0
        0x008054d2:    b00a        ..      ADD      sp,sp,#0x28
        0x008054d4:    bd10        ..      POP      {r4,pc}
        0x008054d6:    f89d0004    ....    LDRB     r0,[sp,#4]
        0x008054da:    b1a0        ..      CBZ      r0,0x805506 ; exflash_check_id_patch + 136
        0x008054dc:    28ff        .(      CMP      r0,#0xff
        0x008054de:    d012        ..      BEQ      0x805506 ; exflash_check_id_patch + 136
        0x008054e0:    f89d1005    ....    LDRB     r1,[sp,#5]
        0x008054e4:    0209        ..      LSLS     r1,r1,#8
        0x008054e6:    eb014000    ...@    ADD      r0,r1,r0,LSL #16
        0x008054ea:    f89d1006    ....    LDRB     r1,[sp,#6]
        0x008054ee:    4408        .D      ADD      r0,r0,r1
        0x008054f0:    60e0        .`      STR      r0,[r4,#0xc]
        0x008054f2:    f89d0006    ....    LDRB     r0,[sp,#6]
        0x008054f6:    f000010f    ....    AND      r1,r0,#0xf
        0x008054fa:    f44f3080    O..0    MOV      r0,#0x10000
        0x008054fe:    4088        .@      LSLS     r0,r0,r1
        0x00805500:    6120         a      STR      r0,[r4,#0x10]
        0x00805502:    2000        .       MOVS     r0,#0
        0x00805504:    e7e5        ..      B        0x8054d2 ; exflash_check_id_patch + 84
        0x00805506:    2001        .       MOVS     r0,#1
        0x00805508:    e7e3        ..      B        0x8054d2 ; exflash_check_id_patch + 84
        0x0080550a:    2001        .       MOVS     r0,#1
        0x0080550c:    e7e1        ..      B        0x8054d2 ; exflash_check_id_patch + 84
    hal_exflash_deepsleep_patch
        0x0080550e:    e92d41f0    -..A    PUSH     {r4-r8,lr}
        0x00805512:    4604        .F      MOV      r4,r0
        0x00805514:    2000        .       MOVS     r0,#0
        0x00805516:    7a21        !z      LDRB     r1,[r4,#8]
        0x00805518:    2901        .)      CMP      r1,#1
        0x0080551a:    d006        ..      BEQ      0x80552a ; hal_exflash_deepsleep_patch + 28
        0x0080551c:    2501        .%      MOVS     r5,#1
        0x0080551e:    7225        %r      STRB     r5,[r4,#8]
        0x00805520:    7a61        az      LDRB     r1,[r4,#9]
        0x00805522:    2700        .'      MOVS     r7,#0
        0x00805524:    2901        .)      CMP      r1,#1
        0x00805526:    d003        ..      BEQ      0x805530 ; hal_exflash_deepsleep_patch + 34
        0x00805528:    e020         .      B        0x80556c ; hal_exflash_deepsleep_patch + 94
        0x0080552a:    2002        .       MOVS     r0,#2
        0x0080552c:    e8bd81f0    ....    POP      {r4-r8,pc}
        0x00805530:    f3ef8610    ....    MRS      r6,PRIMASK
        0x00805534:    2001        .       MOVS     r0,#1
        0x00805536:    f3808810    ....    MSR      PRIMASK,r0
        0x0080553a:    61a7        .a      STR      r7,[r4,#0x18]
        0x0080553c:    2002        .       MOVS     r0,#2
        0x0080553e:    7260        `r      STRB     r0,[r4,#9]
        0x00805540:    6820         h      LDR      r0,[r4,#0]
        0x00805542:    6801        .h      LDR      r1,[r0,#0]
        0x00805544:    f8d11c10    ....    LDR      r1,[r1,#0xc10]
        0x00805548:    f0010101    ....    AND      r1,r1,#1
        0x0080554c:    b119        ..      CBZ      r1,0x805556 ; hal_exflash_deepsleep_patch + 72
        0x0080554e:    6045        E`      STR      r5,[r0,#4]
        0x00805550:    6820         h      LDR      r0,[r4,#0]
        0x00805552:    f000fb35    ..5.    BL       hal_xqspi_init_ext ; 0x805bc0
        0x00805556:    4620         F      MOV      r0,r4
        0x00805558:    f408f78e    ....    BL       exflash_deepsleep ; 0xe478
        0x0080555c:    2800        .(      CMP      r0,#0
        0x0080555e:    d000        ..      BEQ      0x805562 ; hal_exflash_deepsleep_patch + 84
        0x00805560:    61a5        .a      STR      r5,[r4,#0x18]
        0x00805562:    d000        ..      BEQ      0x805566 ; hal_exflash_deepsleep_patch + 88
        0x00805564:    61a5        .a      STR      r5,[r4,#0x18]
        0x00805566:    7265        er      STRB     r5,[r4,#9]
        0x00805568:    f3868810    ....    MSR      PRIMASK,r6
        0x0080556c:    7227        'r      STRB     r7,[r4,#8]
        0x0080556e:    e7dd        ..      B        0x80552c ; hal_exflash_deepsleep_patch + 30
    hal_exflash_wakeup_patch
        0x00805570:    e92d47f0    -..G    PUSH     {r4-r10,lr}
        0x00805574:    4604        .F      MOV      r4,r0
        0x00805576:    2500        .%      MOVS     r5,#0
        0x00805578:    2600        .&      MOVS     r6,#0
        0x0080557a:    7a20         z      LDRB     r0,[r4,#8]
        0x0080557c:    2801        .(      CMP      r0,#1
        0x0080557e:    d006        ..      BEQ      0x80558e ; hal_exflash_wakeup_patch + 30
        0x00805580:    2701        .'      MOVS     r7,#1
        0x00805582:    7227        'r      STRB     r7,[r4,#8]
        0x00805584:    7a60        `z      LDRB     r0,[r4,#9]
        0x00805586:    46a9        .F      MOV      r9,r5
        0x00805588:    2801        .(      CMP      r0,#1
        0x0080558a:    d003        ..      BEQ      0x805594 ; hal_exflash_wakeup_patch + 36
        0x0080558c:    e03a        :.      B        0x805604 ; hal_exflash_wakeup_patch + 148
        0x0080558e:    2002        .       MOVS     r0,#2
        0x00805590:    e8bd87f0    ....    POP      {r4-r10,pc}
        0x00805594:    f3ef8810    ....    MRS      r8,PRIMASK
        0x00805598:    2001        .       MOVS     r0,#1
        0x0080559a:    f3808810    ....    MSR      PRIMASK,r0
        0x0080559e:    f8c49018    ....    STR      r9,[r4,#0x18]
        0x008055a2:    2002        .       MOVS     r0,#2
        0x008055a4:    7260        `r      STRB     r0,[r4,#9]
        0x008055a6:    6820         h      LDR      r0,[r4,#0]
        0x008055a8:    6801        .h      LDR      r1,[r0,#0]
        0x008055aa:    f8d11c10    ....    LDR      r1,[r1,#0xc10]
        0x008055ae:    f0010101    ....    AND      r1,r1,#1
        0x008055b2:    b119        ..      CBZ      r1,0x8055bc ; hal_exflash_wakeup_patch + 76
        0x008055b4:    6047        G`      STR      r7,[r0,#4]
        0x008055b6:    6820         h      LDR      r0,[r4,#0]
        0x008055b8:    f000fb02    ....    BL       hal_xqspi_init_ext ; 0x805bc0
        0x008055bc:    f44f7afa    O..z    MOV      r10,#0x1f4
        0x008055c0:    4620         F      MOV      r0,r4
        0x008055c2:    f409f0e3    ....    BL       exflash_wakeup ; 0xe78c
        0x008055c6:    4620         F      MOV      r0,r4
        0x008055c8:    f7ffff59    ..Y.    BL       exflash_check_id_patch ; 0x80547e
        0x008055cc:    4605        .F      MOV      r5,r0
        0x008055ce:    1c76        v.      ADDS     r6,r6,#1
        0x008055d0:    b2b6        ..      UXTH     r6,r6
        0x008055d2:    b10d        ..      CBZ      r5,0x8055d8 ; hal_exflash_wakeup_patch + 104
        0x008055d4:    4556        VE      CMP      r6,r10
        0x008055d6:    d3f3        ..      BCC      0x8055c0 ; hal_exflash_wakeup_patch + 80
        0x008055d8:    b105        ..      CBZ      r5,0x8055dc ; hal_exflash_wakeup_patch + 108
        0x008055da:    61a7        .a      STR      r7,[r4,#0x18]
        0x008055dc:    6860        `h      LDR      r0,[r4,#4]
        0x008055de:    b960        `.      CBNZ     r0,0x8055fa ; hal_exflash_wakeup_patch + 138
        0x008055e0:    6820         h      LDR      r0,[r4,#0]
        0x008055e2:    6801        .h      LDR      r1,[r0,#0]
        0x008055e4:    f8d11c10    ....    LDR      r1,[r1,#0xc10]
        0x008055e8:    f0010101    ....    AND      r1,r1,#1
        0x008055ec:    b929        ).      CBNZ     r1,0x8055fa ; hal_exflash_wakeup_patch + 138
        0x008055ee:    f8c09004    ....    STR      r9,[r0,#4]
        0x008055f2:    6820         h      LDR      r0,[r4,#0]
        0x008055f4:    f000fae4    ....    BL       hal_xqspi_init_ext ; 0x805bc0
        0x008055f8:    7267        gr      STRB     r7,[r4,#9]
        0x008055fa:    b105        ..      CBZ      r5,0x8055fe ; hal_exflash_wakeup_patch + 142
        0x008055fc:    61a7        .a      STR      r7,[r4,#0x18]
        0x008055fe:    7267        gr      STRB     r7,[r4,#9]
        0x00805600:    f3888810    ....    MSR      PRIMASK,r8
        0x00805604:    f8849008    ....    STRB     r9,[r4,#8]
        0x00805608:    4628        (F      MOV      r0,r5
        0x0080560a:    e7c1        ..      B        0x805590 ; hal_exflash_wakeup_patch + 32
    hal_exflash_suspend
        0x0080560c:    b510        ..      PUSH     {r4,lr}
        0x0080560e:    4604        .F      MOV      r4,r0
        0x00805610:    6860        `h      LDR      r0,[r4,#4]
        0x00805612:    2800        .(      CMP      r0,#0
        0x00805614:    d001        ..      BEQ      0x80561a ; hal_exflash_suspend + 14
        0x00805616:    2001        .       MOVS     r0,#1
        0x00805618:    bd10        ..      POP      {r4,pc}
        0x0080561a:    7a60        `z      LDRB     r0,[r4,#9]
        0x0080561c:    2802        .(      CMP      r0,#2
        0x0080561e:    d007        ..      BEQ      0x805630 ; hal_exflash_suspend + 36
        0x00805620:    7a60        `z      LDRB     r0,[r4,#9]
        0x00805622:    2822        "(      CMP      r0,#0x22
        0x00805624:    d004        ..      BEQ      0x805630 ; hal_exflash_suspend + 36
        0x00805626:    7a60        `z      LDRB     r0,[r4,#9]
        0x00805628:    2842        B(      CMP      r0,#0x42
        0x0080562a:    d001        ..      BEQ      0x805630 ; hal_exflash_suspend + 36
        0x0080562c:    2001        .       MOVS     r0,#1
        0x0080562e:    bd10        ..      POP      {r4,pc}
        0x00805630:    7a60        `z      LDRB     r0,[r4,#9]
        0x00805632:    2802        .(      CMP      r0,#2
        0x00805634:    d009        ..      BEQ      0x80564a ; hal_exflash_suspend + 62
        0x00805636:    4620         F      MOV      r0,r4
        0x00805638:    f409f042    ..B.    BL       exflash_suspend ; 0xe6c0
        0x0080563c:    2800        .(      CMP      r0,#0
        0x0080563e:    d1f6        ..      BNE      0x80562e ; hal_exflash_suspend + 34
        0x00805640:    7a60        `z      LDRB     r0,[r4,#9]
        0x00805642:    2822        "(      CMP      r0,#0x22
        0x00805644:    d009        ..      BEQ      0x80565a ; hal_exflash_suspend + 78
        0x00805646:    2041        A       MOVS     r0,#0x41
        0x00805648:    7260        `r      STRB     r0,[r4,#9]
        0x0080564a:    6821        !h      LDR      r1,[r4,#0]
        0x0080564c:    2000        .       MOVS     r0,#0
        0x0080564e:    6048        H`      STR      r0,[r1,#4]
        0x00805650:    6820         h      LDR      r0,[r4,#0]
        0x00805652:    f000fab5    ....    BL       hal_xqspi_init_ext ; 0x805bc0
        0x00805656:    2000        .       MOVS     r0,#0
        0x00805658:    bd10        ..      POP      {r4,pc}
        0x0080565a:    2021        !       MOVS     r0,#0x21
        0x0080565c:    e7f4        ..      B        0x805648 ; hal_exflash_suspend + 60
    hal_exflash_resume
        0x0080565e:    b510        ..      PUSH     {r4,lr}
        0x00805660:    4604        .F      MOV      r4,r0
        0x00805662:    6860        `h      LDR      r0,[r4,#4]
        0x00805664:    2800        .(      CMP      r0,#0
        0x00805666:    d001        ..      BEQ      0x80566c ; hal_exflash_resume + 14
        0x00805668:    2001        .       MOVS     r0,#1
        0x0080566a:    bd10        ..      POP      {r4,pc}
        0x0080566c:    7a60        `z      LDRB     r0,[r4,#9]
        0x0080566e:    2802        .(      CMP      r0,#2
        0x00805670:    d007        ..      BEQ      0x805682 ; hal_exflash_resume + 36
        0x00805672:    7a60        `z      LDRB     r0,[r4,#9]
        0x00805674:    2821        !(      CMP      r0,#0x21
        0x00805676:    d004        ..      BEQ      0x805682 ; hal_exflash_resume + 36
        0x00805678:    7a60        `z      LDRB     r0,[r4,#9]
        0x0080567a:    2841        A(      CMP      r0,#0x41
        0x0080567c:    d001        ..      BEQ      0x805682 ; hal_exflash_resume + 36
        0x0080567e:    2001        .       MOVS     r0,#1
        0x00805680:    bd10        ..      POP      {r4,pc}
        0x00805682:    6821        !h      LDR      r1,[r4,#0]
        0x00805684:    2001        .       MOVS     r0,#1
        0x00805686:    6048        H`      STR      r0,[r1,#4]
        0x00805688:    6820         h      LDR      r0,[r4,#0]
        0x0080568a:    f000fa99    ....    BL       hal_xqspi_init_ext ; 0x805bc0
        0x0080568e:    7a60        `z      LDRB     r0,[r4,#9]
        0x00805690:    2802        .(      CMP      r0,#2
        0x00805692:    d009        ..      BEQ      0x8056a8 ; hal_exflash_resume + 74
        0x00805694:    4620         F      MOV      r0,r4
        0x00805696:    f409f005    ....    BL       exflash_resume ; 0xe6a4
        0x0080569a:    2800        .(      CMP      r0,#0
        0x0080569c:    d1f0        ..      BNE      0x805680 ; hal_exflash_resume + 34
        0x0080569e:    7a60        `z      LDRB     r0,[r4,#9]
        0x008056a0:    2821        !(      CMP      r0,#0x21
        0x008056a2:    d003        ..      BEQ      0x8056ac ; hal_exflash_resume + 78
        0x008056a4:    2042        B       MOVS     r0,#0x42
        0x008056a6:    7260        `r      STRB     r0,[r4,#9]
        0x008056a8:    2000        .       MOVS     r0,#0
        0x008056aa:    bd10        ..      POP      {r4,pc}
        0x008056ac:    2022        "       MOVS     r0,#0x22
        0x008056ae:    e7fa        ..      B        0x8056a6 ; hal_exflash_resume + 72
    hal_exflash_operation
        0x008056b0:    e92d5ff0    -.._    PUSH     {r4-r12,lr}
        0x008056b4:    4604        .F      MOV      r4,r0
        0x008056b6:    460d        .F      MOV      r5,r1
        0x008056b8:    f3ef8711    ....    MRS      r7,BASEPRI
        0x008056bc:    f3ef8910    ....    MRS      r9,PRIMASK
        0x008056c0:    2d00        .-      CMP      r5,#0
        0x008056c2:    d00e        ..      BEQ      0x8056e2 ; hal_exflash_operation + 50
        0x008056c4:    7a20         z      LDRB     r0,[r4,#8]
        0x008056c6:    2801        .(      CMP      r0,#1
        0x008056c8:    d00d        ..      BEQ      0x8056e6 ; hal_exflash_operation + 54
        0x008056ca:    2601        .&      MOVS     r6,#1
        0x008056cc:    7226        &r      STRB     r6,[r4,#8]
        0x008056ce:    7a60        `z      LDRB     r0,[r4,#9]
        0x008056d0:    f04f0a00    O...    MOV      r10,#0
        0x008056d4:    2801        .(      CMP      r0,#1
        0x008056d6:    d008        ..      BEQ      0x8056ea ; hal_exflash_operation + 58
        0x008056d8:    2502        .%      MOVS     r5,#2
        0x008056da:    f884a008    ....    STRB     r10,[r4,#8]
        0x008056de:    4628        (F      MOV      r0,r5
        0x008056e0:    e634        4.      B        0x80534c ; hal_exflash_erase + 78
        0x008056e2:    2001        .       MOVS     r0,#1
        0x008056e4:    e632        2.      B        0x80534c ; hal_exflash_erase + 78
        0x008056e6:    2002        .       MOVS     r0,#2
        0x008056e8:    e630        0.      B        0x80534c ; hal_exflash_erase + 78
        0x008056ea:    f8c4a018    ....    STR      r10,[r4,#0x18]
        0x008056ee:    6821        !h      LDR      r1,[r4,#0]
        0x008056f0:    6808        .h      LDR      r0,[r1,#0]
        0x008056f2:    f8d00c10    ....    LDR      r0,[r0,#0xc10]
        0x008056f6:    f0000001    ....    AND      r0,r0,#1
        0x008056fa:    f04f0b02    O...    MOV      r11,#2
        0x008056fe:    b1d0        ..      CBZ      r0,0x805736 ; hal_exflash_operation + 134
        0x00805700:    4895        .H      LDR      r0,[pc,#596] ; [0x805958] = 0x30006964
        0x00805702:    6800        .h      LDR      r0,[r0,#0]
        0x00805704:    b1f8        ..      CBZ      r0,0x805746 ; hal_exflash_operation + 150
        0x00805706:    4a95        .J      LDR      r2,[pc,#596] ; [0x80595c] = 0xe000ed0c
        0x00805708:    6812        .h      LDR      r2,[r2,#0]
        0x0080570a:    f3c22202    ..."    UBFX     r2,r2,#8,#3
        0x0080570e:    1c52        R.      ADDS     r2,r2,#1
        0x00805710:    4090        .@      LSLS     r0,r0,r2
        0x00805712:    b2c0        ..      UXTB     r0,r0
        0x00805714:    f3808811    ....    MSR      BASEPRI,r0
        0x00805718:    f3ef8810    ....    MRS      r8,PRIMASK
        0x0080571c:    2001        .       MOVS     r0,#1
        0x0080571e:    f3808810    ....    MSR      PRIMASK,r0
        0x00805722:    604e        N`      STR      r6,[r1,#4]
        0x00805724:    6820         h      LDR      r0,[r4,#0]
        0x00805726:    f000fa4b    ..K.    BL       hal_xqspi_init_ext ; 0x805bc0
        0x0080572a:    4620         F      MOV      r0,r4
        0x0080572c:    47a8        .G      BLX      r5
        0x0080572e:    4605        .F      MOV      r5,r0
        0x00805730:    0028        (.      MOVS     r0,r5
        0x00805732:    d110        ..      BNE      0x805756 ; hal_exflash_operation + 166
        0x00805734:    e00b        ..      B        0x80574e ; hal_exflash_operation + 158
        0x00805736:    4620         F      MOV      r0,r4
        0x00805738:    47a8        .G      BLX      r5
        0x0080573a:    4605        .F      MOV      r5,r0
        0x0080573c:    0028        (.      MOVS     r0,r5
        0x0080573e:    d128        (.      BNE      0x805792 ; hal_exflash_operation + 226
        0x00805740:    f884b009    ....    STRB     r11,[r4,#9]
        0x00805744:    e007        ..      B        0x805756 ; hal_exflash_operation + 166
        0x00805746:    2001        .       MOVS     r0,#1
        0x00805748:    f3808810    ....    MSR      PRIMASK,r0
        0x0080574c:    e7e4        ..      B        0x805718 ; hal_exflash_operation + 104
        0x0080574e:    f884b009    ....    STRB     r11,[r4,#9]
        0x00805752:    f3888810    ....    MSR      PRIMASK,r8
        0x00805756:    6860        `h      LDR      r0,[r4,#4]
        0x00805758:    b9c8        ..      CBNZ     r0,0x80578e ; hal_exflash_operation + 222
        0x0080575a:    6820         h      LDR      r0,[r4,#0]
        0x0080575c:    6801        .h      LDR      r1,[r0,#0]
        0x0080575e:    f8d11c10    ....    LDR      r1,[r1,#0xc10]
        0x00805762:    f0010101    ....    AND      r1,r1,#1
        0x00805766:    b991        ..      CBNZ     r1,0x80578e ; hal_exflash_operation + 222
        0x00805768:    f3ef8810    ....    MRS      r8,PRIMASK
        0x0080576c:    2101        .!      MOVS     r1,#1
        0x0080576e:    f3818810    ....    MSR      PRIMASK,r1
        0x00805772:    f8c0a004    ....    STR      r10,[r0,#4]
        0x00805776:    6820         h      LDR      r0,[r4,#0]
        0x00805778:    f000fa22    ..".    BL       hal_xqspi_init_ext ; 0x805bc0
        0x0080577c:    7266        fr      STRB     r6,[r4,#9]
        0x0080577e:    f3888810    ....    MSR      PRIMASK,r8
        0x00805782:    4875        uH      LDR      r0,[pc,#468] ; [0x805958] = 0x30006964
        0x00805784:    6800        .h      LDR      r0,[r0,#0]
        0x00805786:    b148        H.      CBZ      r0,0x80579c ; hal_exflash_operation + 236
        0x00805788:    b2f8        ..      UXTB     r0,r7
        0x0080578a:    f3808811    ....    MSR      BASEPRI,r0
        0x0080578e:    b105        ..      CBZ      r5,0x805792 ; hal_exflash_operation + 226
        0x00805790:    61a6        .a      STR      r6,[r4,#0x18]
        0x00805792:    6860        `h      LDR      r0,[r4,#4]
        0x00805794:    2801        .(      CMP      r0,#1
        0x00805796:    d1a0        ..      BNE      0x8056da ; hal_exflash_operation + 42
        0x00805798:    7266        fr      STRB     r6,[r4,#9]
        0x0080579a:    e79e        ..      B        0x8056da ; hal_exflash_operation + 42
        0x0080579c:    f1b90f00    ....    CMP      r9,#0
        0x008057a0:    d003        ..      BEQ      0x8057aa ; hal_exflash_operation + 250
        0x008057a2:    2001        .       MOVS     r0,#1
        0x008057a4:    f3808810    ....    MSR      PRIMASK,r0
        0x008057a8:    e7f1        ..      B        0x80578e ; hal_exflash_operation + 222
        0x008057aa:    2000        .       MOVS     r0,#0
        0x008057ac:    f3808810    ....    MSR      PRIMASK,r0
        0x008057b0:    e7ed        ..      B        0x80578e ; hal_exflash_operation + 222
    enable_quad_stat
        0x008057b2:    b5f0        ..      PUSH     {r4-r7,lr}
        0x008057b4:    b089        ..      SUB      sp,sp,#0x24
        0x008057b6:    4606        .F      MOV      r6,r0
        0x008057b8:    460c        .F      MOV      r4,r1
        0x008057ba:    2500        .%      MOVS     r5,#0
        0x008057bc:    9500        ..      STR      r5,[sp,#0]
        0x008057be:    2005        .       MOVS     r0,#5
        0x008057c0:    9001        ..      STR      r0,[sp,#4]
        0x008057c2:    9502        ..      STR      r5,[sp,#8]
        0x008057c4:    2001        .       MOVS     r0,#1
        0x008057c6:    9003        ..      STR      r0,[sp,#0xc]
        0x008057c8:    9504        ..      STR      r5,[sp,#0x10]
        0x008057ca:    9505        ..      STR      r5,[sp,#0x14]
        0x008057cc:    9506        ..      STR      r5,[sp,#0x18]
        0x008057ce:    9507        ..      STR      r5,[sp,#0x1c]
        0x008057d0:    9008        ..      STR      r0,[sp,#0x20]
        0x008057d2:    8025        %.      STRH     r5,[r4,#0]
        0x008057d4:    f44f777a    O.zw    MOV      r7,#0x3e8
        0x008057d8:    463b        ;F      MOV      r3,r7
        0x008057da:    466a        jF      MOV      r2,sp
        0x008057dc:    a901        ..      ADD      r1,sp,#4
        0x008057de:    6830        0h      LDR      r0,[r6,#0]
        0x008057e0:    f41cf270    ..p.    BL       hal_xqspi_command_receive ; 0x21cc4
        0x008057e4:    8820         .      LDRH     r0,[r4,#0]
        0x008057e6:    f89d1000    ....    LDRB     r1,[sp,#0]
        0x008057ea:    4308        .C      ORRS     r0,r0,r1
        0x008057ec:    8020         .      STRH     r0,[r4,#0]
        0x008057ee:    2035        5       MOVS     r0,#0x35
        0x008057f0:    9001        ..      STR      r0,[sp,#4]
        0x008057f2:    9500        ..      STR      r5,[sp,#0]
        0x008057f4:    463b        ;F      MOV      r3,r7
        0x008057f6:    466a        jF      MOV      r2,sp
        0x008057f8:    a901        ..      ADD      r1,sp,#4
        0x008057fa:    6830        0h      LDR      r0,[r6,#0]
        0x008057fc:    f41cf262    ..b.    BL       hal_xqspi_command_receive ; 0x21cc4
        0x00805800:    8820         .      LDRH     r0,[r4,#0]
        0x00805802:    f89d1000    ....    LDRB     r1,[sp,#0]
        0x00805806:    ea402001    @..     ORR      r0,r0,r1,LSL #8
        0x0080580a:    8020         .      STRH     r0,[r4,#0]
        0x0080580c:    2000        .       MOVS     r0,#0
        0x0080580e:    b009        ..      ADD      sp,sp,#0x24
        0x00805810:    bdf0        ..      POP      {r4-r7,pc}
    hal_exflash_read_status_reg
        0x00805812:    e92d41f0    -..A    PUSH     {r4-r8,lr}
        0x00805816:    4607        .F      MOV      r7,r0
        0x00805818:    2601        .&      MOVS     r6,#1
        0x0080581a:    4c51        QL      LDR      r4,[pc,#324] ; [0x805960] = 0x801f64
        0x0080581c:    7a60        `z      LDRB     r0,[r4,#9]
        0x0080581e:    2801        .(      CMP      r0,#1
        0x00805820:    d11e        ..      BNE      0x805860 ; hal_exflash_read_status_reg + 78
        0x00805822:    f3ef8510    ....    MRS      r5,PRIMASK
        0x00805826:    f3808810    ....    MSR      PRIMASK,r0
        0x0080582a:    6820         h      LDR      r0,[r4,#0]
        0x0080582c:    6802        .h      LDR      r2,[r0,#0]
        0x0080582e:    f8d21c10    ....    LDR      r1,[r2,#0xc10]
        0x00805832:    f0010101    ....    AND      r1,r1,#1
        0x00805836:    b121        !.      CBZ      r1,0x805842 ; hal_exflash_read_status_reg + 48
        0x00805838:    2101        .!      MOVS     r1,#1
        0x0080583a:    6041        A`      STR      r1,[r0,#4]
        0x0080583c:    6820         h      LDR      r0,[r4,#0]
        0x0080583e:    f000f9bf    ....    BL       hal_xqspi_init_ext ; 0x805bc0
        0x00805842:    4639        9F      MOV      r1,r7
        0x00805844:    4846        FH      LDR      r0,[pc,#280] ; [0x805960] = 0x801f64
        0x00805846:    f7ffffb4    ....    BL       enable_quad_stat ; 0x8057b2
        0x0080584a:    4606        .F      MOV      r6,r0
        0x0080584c:    6860        `h      LDR      r0,[r4,#4]
        0x0080584e:    b928        (.      CBNZ     r0,0x80585c ; hal_exflash_read_status_reg + 74
        0x00805850:    6821        !h      LDR      r1,[r4,#0]
        0x00805852:    2000        .       MOVS     r0,#0
        0x00805854:    6048        H`      STR      r0,[r1,#4]
        0x00805856:    6820         h      LDR      r0,[r4,#0]
        0x00805858:    f000f9b2    ....    BL       hal_xqspi_init_ext ; 0x805bc0
        0x0080585c:    f3858810    ....    MSR      PRIMASK,r5
        0x00805860:    4630        0F      MOV      r0,r6
        0x00805862:    e663        c.      B        0x80552c ; hal_exflash_deepsleep_patch + 30
    hal_exflash_write_status_reg
        0x00805864:    e92d41f0    -..A    PUSH     {r4-r8,lr}
        0x00805868:    4607        .F      MOV      r7,r0
        0x0080586a:    2601        .&      MOVS     r6,#1
        0x0080586c:    4c3c        <L      LDR      r4,[pc,#240] ; [0x805960] = 0x801f64
        0x0080586e:    7a60        `z      LDRB     r0,[r4,#9]
        0x00805870:    2801        .(      CMP      r0,#1
        0x00805872:    d121        !.      BNE      0x8058b8 ; hal_exflash_write_status_reg + 84
        0x00805874:    f3ef8510    ....    MRS      r5,PRIMASK
        0x00805878:    f3808810    ....    MSR      PRIMASK,r0
        0x0080587c:    6820         h      LDR      r0,[r4,#0]
        0x0080587e:    6802        .h      LDR      r2,[r0,#0]
        0x00805880:    f8d21c10    ....    LDR      r1,[r2,#0xc10]
        0x00805884:    f0010101    ....    AND      r1,r1,#1
        0x00805888:    46b0        .F      MOV      r8,r6
        0x0080588a:    b121        !.      CBZ      r1,0x805896 ; hal_exflash_write_status_reg + 50
        0x0080588c:    f8c08004    ....    STR      r8,[r0,#4]
        0x00805890:    6820         h      LDR      r0,[r4,#0]
        0x00805892:    f000f995    ....    BL       hal_xqspi_init_ext ; 0x805bc0
        0x00805896:    4639        9F      MOV      r1,r7
        0x00805898:    4831        1H      LDR      r0,[pc,#196] ; [0x805960] = 0x801f64
        0x0080589a:    f408f785    ....    BL       exflash_write_status ; 0xe7a8
        0x0080589e:    4606        .F      MOV      r6,r0
        0x008058a0:    f8848009    ....    STRB     r8,[r4,#9]
        0x008058a4:    6860        `h      LDR      r0,[r4,#4]
        0x008058a6:    b928        (.      CBNZ     r0,0x8058b4 ; hal_exflash_write_status_reg + 80
        0x008058a8:    6821        !h      LDR      r1,[r4,#0]
        0x008058aa:    2000        .       MOVS     r0,#0
        0x008058ac:    6048        H`      STR      r0,[r1,#4]
        0x008058ae:    6820         h      LDR      r0,[r4,#0]
        0x008058b0:    f000f986    ....    BL       hal_xqspi_init_ext ; 0x805bc0
        0x008058b4:    f3858810    ....    MSR      PRIMASK,r5
        0x008058b8:    4630        0F      MOV      r0,r6
        0x008058ba:    e637        7.      B        0x80552c ; hal_exflash_deepsleep_patch + 30
    exflash_read_uid
        0x008058bc:    b5f0        ..      PUSH     {r4-r7,lr}
        0x008058be:    b089        ..      SUB      sp,sp,#0x24
        0x008058c0:    4605        .F      MOV      r5,r0
        0x008058c2:    460f        .F      MOV      r7,r1
        0x008058c4:    24ff        .$      MOVS     r4,#0xff
        0x008058c6:    204b        K       MOVS     r0,#0x4b
        0x008058c8:    9001        ..      STR      r0,[sp,#4]
        0x008058ca:    2000        .       MOVS     r0,#0
        0x008058cc:    9002        ..      STR      r0,[sp,#8]
        0x008058ce:    2101        .!      MOVS     r1,#1
        0x008058d0:    9103        ..      STR      r1,[sp,#0xc]
        0x008058d2:    9004        ..      STR      r0,[sp,#0x10]
        0x008058d4:    2120         !      MOVS     r1,#0x20
        0x008058d6:    9105        ..      STR      r1,[sp,#0x14]
        0x008058d8:    9006        ..      STR      r0,[sp,#0x18]
        0x008058da:    9007        ..      STR      r0,[sp,#0x1c]
        0x008058dc:    2010        .       MOVS     r0,#0x10
        0x008058de:    9008        ..      STR      r0,[sp,#0x20]
        0x008058e0:    f44f767a    O.zv    MOV      r6,#0x3e8
        0x008058e4:    e007        ..      B        0x8058f6 ; exflash_read_uid + 58
        0x008058e6:    4633        3F      MOV      r3,r6
        0x008058e8:    463a        :F      MOV      r2,r7
        0x008058ea:    a901        ..      ADD      r1,sp,#4
        0x008058ec:    6828        (h      LDR      r0,[r5,#0]
        0x008058ee:    f41cf1e9    ....    BL       hal_xqspi_command_receive ; 0x21cc4
        0x008058f2:    2800        .(      CMP      r0,#0
        0x008058f4:    d18b        ..      BNE      0x80580e ; enable_quad_stat + 92
        0x008058f6:    1e64        d.      SUBS     r4,r4,#1
        0x008058f8:    b2e4        ..      UXTB     r4,r4
        0x008058fa:    d2f4        ..      BCS      0x8058e6 ; exflash_read_uid + 42
        0x008058fc:    b10c        ..      CBZ      r4,0x805902 ; exflash_read_uid + 70
        0x008058fe:    2000        .       MOVS     r0,#0
        0x00805900:    e785        ..      B        0x80580e ; enable_quad_stat + 92
        0x00805902:    2001        .       MOVS     r0,#1
        0x00805904:    e783        ..      B        0x80580e ; enable_quad_stat + 92
    hal_exflash_read_uid
        0x00805906:    e92d41f0    -..A    PUSH     {r4-r8,lr}
        0x0080590a:    4607        .F      MOV      r7,r0
        0x0080590c:    2601        .&      MOVS     r6,#1
        0x0080590e:    4c14        .L      LDR      r4,[pc,#80] ; [0x805960] = 0x801f64
        0x00805910:    7a60        `z      LDRB     r0,[r4,#9]
        0x00805912:    2801        .(      CMP      r0,#1
        0x00805914:    d11e        ..      BNE      0x805954 ; hal_exflash_read_uid + 78
        0x00805916:    f3ef8510    ....    MRS      r5,PRIMASK
        0x0080591a:    f3808810    ....    MSR      PRIMASK,r0
        0x0080591e:    6820         h      LDR      r0,[r4,#0]
        0x00805920:    6802        .h      LDR      r2,[r0,#0]
        0x00805922:    f8d21c10    ....    LDR      r1,[r2,#0xc10]
        0x00805926:    f0010101    ....    AND      r1,r1,#1
        0x0080592a:    b121        !.      CBZ      r1,0x805936 ; hal_exflash_read_uid + 48
        0x0080592c:    2101        .!      MOVS     r1,#1
        0x0080592e:    6041        A`      STR      r1,[r0,#4]
        0x00805930:    6820         h      LDR      r0,[r4,#0]
        0x00805932:    f000f945    ..E.    BL       hal_xqspi_init_ext ; 0x805bc0
        0x00805936:    4639        9F      MOV      r1,r7
        0x00805938:    4809        .H      LDR      r0,[pc,#36] ; [0x805960] = 0x801f64
        0x0080593a:    f7ffffbf    ....    BL       exflash_read_uid ; 0x8058bc
        0x0080593e:    4606        .F      MOV      r6,r0
        0x00805940:    6860        `h      LDR      r0,[r4,#4]
        0x00805942:    b928        (.      CBNZ     r0,0x805950 ; hal_exflash_read_uid + 74
        0x00805944:    6821        !h      LDR      r1,[r4,#0]
        0x00805946:    2000        .       MOVS     r0,#0
        0x00805948:    6048        H`      STR      r0,[r1,#4]
        0x0080594a:    6820         h      LDR      r0,[r4,#0]
        0x0080594c:    f000f938    ..8.    BL       hal_xqspi_init_ext ; 0x805bc0
        0x00805950:    f3858810    ....    MSR      PRIMASK,r5
        0x00805954:    4630        0F      MOV      r0,r6
        0x00805956:    e5e9        ..      B        0x80552c ; hal_exflash_deepsleep_patch + 30
    $d
        0x00805958:    30006964    di.0    DCD    805333348
        0x0080595c:    e000ed0c    ....    DCD    3758157068
        0x00805960:    00801f64    d...    DCD    8396644
    $t
    RAM_CODE
    ble_core_power_off
        0x00805964:    487e        ~H      LDR      r0,[pc,#504] ; [0x805b60] = 0xa000c504
        0x00805966:    6801        .h      LDR      r1,[r0,#0]
        0x00805968:    f3c111c0    ....    UBFX     r1,r1,#7,#1
        0x0080596c:    2900        .)      CMP      r1,#0
        0x0080596e:    d00b        ..      BEQ      0x805988 ; ble_core_power_off + 36
        0x00805970:    6801        .h      LDR      r1,[r0,#0]
        0x00805972:    f4215180    !..Q    BIC      r1,r1,#0x1000
        0x00805976:    6001        .`      STR      r1,[r0,#0]
        0x00805978:    6801        .h      LDR      r1,[r0,#0]
        0x0080597a:    f4417180    A..q    ORR      r1,r1,#0x100
        0x0080597e:    6001        .`      STR      r1,[r0,#0]
        0x00805980:    6801        .h      LDR      r1,[r0,#0]
        0x00805982:    f0210140    !.@.    BIC      r1,r1,#0x40
        0x00805986:    6001        .`      STR      r1,[r0,#0]
        0x00805988:    4770        pG      BX       lr
    ble_core_power_on
        0x0080598a:    4875        uH      LDR      r0,[pc,#468] ; [0x805b60] = 0xa000c504
        0x0080598c:    6801        .h      LDR      r1,[r0,#0]
        0x0080598e:    f3c111c0    ....    UBFX     r1,r1,#7,#1
        0x00805992:    2900        .)      CMP      r1,#0
        0x00805994:    d00b        ..      BEQ      0x8059ae ; ble_core_power_on + 36
        0x00805996:    6801        .h      LDR      r1,[r0,#0]
        0x00805998:    f0410140    A.@.    ORR      r1,r1,#0x40
        0x0080599c:    6001        .`      STR      r1,[r0,#0]
        0x0080599e:    6801        .h      LDR      r1,[r0,#0]
        0x008059a0:    f4217180    !..q    BIC      r1,r1,#0x100
        0x008059a4:    6001        .`      STR      r1,[r0,#0]
        0x008059a6:    6801        .h      LDR      r1,[r0,#0]
        0x008059a8:    f4415180    A..Q    ORR      r1,r1,#0x1000
        0x008059ac:    6001        .`      STR      r1,[r0,#0]
        0x008059ae:    4770        pG      BX       lr
    rwip_clkn_set
        0x008059b0:    f0404080    @..@    ORR      r0,r0,#0x40000000
        0x008059b4:    496b        kI      LDR      r1,[pc,#428] ; [0x805b64] = 0xb00000f4
        0x008059b6:    6008        .`      STR      r0,[r1,#0]
        0x008059b8:    6808        .h      LDR      r0,[r1,#0]
        0x008059ba:    f0404080    @..@    ORR      r0,r0,#0x40000000
        0x008059be:    f84109f4    A...    STR      r0,[r1],#-0xf4
        0x008059c2:    f8d100f4    ....    LDR      r0,[r1,#0xf4]
        0x008059c6:    f3c07080    ...p    UBFX     r0,r0,#30,#1
        0x008059ca:    2800        .(      CMP      r0,#0
        0x008059cc:    d1f9        ..      BNE      0x8059c2 ; rwip_clkn_set + 18
        0x008059ce:    4770        pG      BX       lr
    ble_sleep_time_record
        0x008059d0:    b51c        ..      PUSH     {r2-r4,lr}
        0x008059d2:    4668        hF      MOV      r0,sp
        0x008059d4:    f44ef4ae    N...    BL       rwip_time_get ; 0x54334
        0x008059d8:    4863        cH      LDR      r0,[pc,#396] ; [0x805b68] = 0x30006968
        0x008059da:    e9dd1200    ....    LDRD     r1,r2,[sp,#0]
        0x008059de:    e9c01202    ....    STRD     r1,r2,[r0,#8]
        0x008059e2:    bd1c        ..      POP      {r2-r4,pc}
    ble_wakup_time_check
        0x008059e4:    b57c        |.      PUSH     {r2-r6,lr}
        0x008059e6:    4668        hF      MOV      r0,sp
        0x008059e8:    f44ef4a4    N...    BL       rwip_time_get ; 0x54334
        0x008059ec:    4c5e        ^L      LDR      r4,[pc,#376] ; [0x805b68] = 0x30006968
        0x008059ee:    e9dd0100    ....    LDRD     r0,r1,[sp,#0]
        0x008059f2:    e9c40104    ....    STRD     r0,r1,[r4,#0x10]
        0x008059f6:    f1040010    ....    ADD      r0,r4,#0x10
        0x008059fa:    f1040508    ....    ADD      r5,r4,#8
        0x008059fe:    6800        .h      LDR      r0,[r0,#0]
        0x00805a00:    6829        )h      LDR      r1,[r5,#0]
        0x00805a02:    1a40        @.      SUBS     r0,r0,r1
        0x00805a04:    f0204070     .p@    BIC      r0,r0,#0xf0000000
        0x00805a08:    f06f4178    o.xA    MVN      r1,#0xf8000000
        0x00805a0c:    4288        .B      CMP      r0,r1
        0x00805a0e:    d320         .      BCC      0x805a52 ; ble_wakup_time_check + 110
        0x00805a10:    2000        .       MOVS     r0,#0
        0x00805a12:    9001        ..      STR      r0,[sp,#4]
        0x00805a14:    4855        UH      LDR      r0,[pc,#340] ; [0x805b6c] = 0xa000e200
        0x00805a16:    6800        .h      LDR      r0,[r0,#0]
        0x00805a18:    a901        ..      ADD      r1,sp,#4
        0x00805a1a:    f474f253    t.S.    BL       rwip_lpcycles_2_hus ; 0x79ec4
        0x00805a1e:    ee000a10    ....    VMOV     s0,r0
        0x00805a22:    6020         `      STR      r0,[r4,#0]
        0x00805a24:    eef80a40    ..@.    VCVT.F32.U32 s1,s0
        0x00805a28:    ed9f1a51    ..Q.    VLDR     s2,[pc,#324] ; [0x805b70] = 0x441c4000
        0x00805a2c:    ee800a81    ....    VDIV.F32 s0,s1,s2
        0x00805a30:    eef60a00    ....    VMOV.F32 s1,#0.50000000
        0x00805a34:    ee300a20    0. .    VADD.F32 s0,s0,s1
        0x00805a38:    eebc0ac0    ....    VCVT.U32.F32 s0,s0
        0x00805a3c:    ee100a10    ....    VMOV     r0,s0
        0x00805a40:    6829        )h      LDR      r1,[r5,#0]
        0x00805a42:    4408        .D      ADD      r0,r0,r1
        0x00805a44:    f0204070     .p@    BIC      r0,r0,#0xf0000000
        0x00805a48:    f7ffffb2    ....    BL       rwip_clkn_set ; 0x8059b0
        0x00805a4c:    6860        `h      LDR      r0,[r4,#4]
        0x00805a4e:    1c40        @.      ADDS     r0,r0,#1
        0x00805a50:    6060        ``      STR      r0,[r4,#4]
        0x00805a52:    bd7c        |.      POP      {r2-r6,pc}
    ble_wait_for_core_sleep_stat
        0x00805a54:    f04f4130    O.0A    MOV      r1,#0xb0000000
        0x00805a58:    6b08        .k      LDR      r0,[r1,#0x30]
        0x00805a5a:    f3c030c0    ...0    UBFX     r0,r0,#15,#1
        0x00805a5e:    2800        .(      CMP      r0,#0
        0x00805a60:    d0fa        ..      BEQ      0x805a58 ; ble_wait_for_core_sleep_stat + 4
        0x00805a62:    6b8a        .k      LDR      r2,[r1,#0x38]
        0x00805a64:    6b88        .k      LDR      r0,[r1,#0x38]
        0x00805a66:    4290        .B      CMP      r0,r2
        0x00805a68:    d0fc        ..      BEQ      0x805a64 ; ble_wait_for_core_sleep_stat + 16
        0x00805a6a:    4770        pG      BX       lr
    ble_wait_for_core_wakeup_stat
        0x00805a6c:    483c        <H      LDR      r0,[pc,#240] ; [0x805b60] = 0xa000c504
        0x00805a6e:    303c        <0      ADDS     r0,r0,#0x3c
        0x00805a70:    6801        .h      LDR      r1,[r0,#0]
        0x00805a72:    f3c131c0    ...1    UBFX     r1,r1,#15,#1
        0x00805a76:    2900        .)      CMP      r1,#0
        0x00805a78:    d1fa        ..      BNE      0x805a70 ; ble_wait_for_core_wakeup_stat + 4
        0x00805a7a:    f04f4130    O.0A    MOV      r1,#0xb0000000
        0x00805a7e:    6b08        .k      LDR      r0,[r1,#0x30]
        0x00805a80:    f3c030c0    ...0    UBFX     r0,r0,#15,#1
        0x00805a84:    2800        .(      CMP      r0,#0
        0x00805a86:    d1fa        ..      BNE      0x805a7e ; ble_wait_for_core_wakeup_stat + 18
        0x00805a88:    4770        pG      BX       lr
    ble_is_in_sleep_state
        0x00805a8a:    b510        ..      PUSH     {r4,lr}
        0x00805a8c:    4834        4H      LDR      r0,[pc,#208] ; [0x805b60] = 0xa000c504
        0x00805a8e:    6800        .h      LDR      r0,[r0,#0]
        0x00805a90:    f3c010c0    ....    UBFX     r0,r0,#7,#1
        0x00805a94:    2800        .(      CMP      r0,#0
        0x00805a96:    d00e        ..      BEQ      0x805ab6 ; ble_is_in_sleep_state + 44
        0x00805a98:    4836        6H      LDR      r0,[pc,#216] ; [0x805b74] = 0x30006980
        0x00805a9a:    7800        .x      LDRB     r0,[r0,#0]
        0x00805a9c:    b148        H.      CBZ      r0,0x805ab2 ; ble_is_in_sleep_state + 40
        0x00805a9e:    4830        0H      LDR      r0,[pc,#192] ; [0x805b60] = 0xa000c504
        0x00805aa0:    303c        <0      ADDS     r0,r0,#0x3c
        0x00805aa2:    6800        .h      LDR      r0,[r0,#0]
        0x00805aa4:    f3c030c0    ...0    UBFX     r0,r0,#15,#1
        0x00805aa8:    b118        ..      CBZ      r0,0x805ab2 ; ble_is_in_sleep_state + 40
        0x00805aaa:    2019        .       MOVS     r0,#0x19
        0x00805aac:    f3fcf7b2    ....    BL       __NVIC_GetPendingIRQ ; 0x1002a14
        0x00805ab0:    b118        ..      CBZ      r0,0x805aba ; ble_is_in_sleep_state + 48
        0x00805ab2:    2000        .       MOVS     r0,#0
        0x00805ab4:    bd10        ..      POP      {r4,pc}
        0x00805ab6:    2001        .       MOVS     r0,#1
        0x00805ab8:    bd10        ..      POP      {r4,pc}
        0x00805aba:    2001        .       MOVS     r0,#1
        0x00805abc:    bd10        ..      POP      {r4,pc}
    ble_sleep_handler_without_stack_init
        0x00805abe:    b510        ..      PUSH     {r4,lr}
        0x00805ac0:    482d        -H      LDR      r0,[pc,#180] ; [0x805b78] = 0x801f64
        0x00805ac2:    f7fffda3    ....    BL       hal_exflash_suspend ; 0x80560c
        0x00805ac6:    f3fcf643    ..C.    BL       BLESLP_Handler_without_stack_init ; 0x1002750
        0x00805aca:    e8bd4010    ...@    POP      {r4,lr}
        0x00805ace:    482a        *H      LDR      r0,[pc,#168] ; [0x805b78] = 0x801f64
        0x00805ad0:    f7ffbdc5    ....    B.W      hal_exflash_resume ; 0x80565e
    ble_sdk_handler_without_stack_init
        0x00805ad4:    b510        ..      PUSH     {r4,lr}
        0x00805ad6:    4828        (H      LDR      r0,[pc,#160] ; [0x805b78] = 0x801f64
        0x00805ad8:    f7fffd98    ....    BL       hal_exflash_suspend ; 0x80560c
        0x00805adc:    f3fcf6bb    ....    BL       BLE_SDK_IRQ_Handler_without_stack_init ; 0x1002856
        0x00805ae0:    e8bd4010    ...@    POP      {r4,lr}
        0x00805ae4:    4824        $H      LDR      r0,[pc,#144] ; [0x805b78] = 0x801f64
        0x00805ae6:    f7ffbdba    ....    B.W      hal_exflash_resume ; 0x80565e
    ble_irq_handler_without_stack_init
        0x00805aea:    b510        ..      PUSH     {r4,lr}
        0x00805aec:    4822        "H      LDR      r0,[pc,#136] ; [0x805b78] = 0x801f64
        0x00805aee:    f7fffd8d    ....    BL       hal_exflash_suspend ; 0x80560c
        0x00805af2:    f3fcf69f    ....    BL       BLE_IRQ_Handler_without_stack_init ; 0x1002834
        0x00805af6:    e8bd4010    ...@    POP      {r4,lr}
        0x00805afa:    481f        .H      LDR      r0,[pc,#124] ; [0x805b78] = 0x801f64
        0x00805afc:    f7ffbdaf    ....    B.W      hal_exflash_resume ; 0x80565e
    rom_cbk_execute
    __tagsym$$noinline
        0x00805b00:    b510        ..      PUSH     {r4,lr}
        0x00805b02:    f7fff8b5    ....    BL       work_xo_bias_set ; 0x804c70
        0x00805b06:    f7ffff40    ..@.    BL       ble_core_power_on ; 0x80598a
        0x00805b0a:    2019        .       MOVS     r0,#0x19
        0x00805b0c:    f3fcf782    ....    BL       __NVIC_GetPendingIRQ ; 0x1002a14
        0x00805b10:    2800        .(      CMP      r0,#0
        0x00805b12:    d004        ..      BEQ      0x805b1e ; rom_cbk_execute + 30
        0x00805b14:    4819        .H      LDR      r0,[pc,#100] ; [0x805b7c] = 0x802468
        0x00805b16:    6800        .h      LDR      r0,[r0,#0]
        0x00805b18:    e8bd4010    ...@    POP      {r4,lr}
        0x00805b1c:    4700        .G      BX       r0
        0x00805b1e:    bd10        ..      POP      {r4,pc}
    rom_callback_patch
        0x00805b20:    4817        .H      LDR      r0,[pc,#92] ; [0x805b80] = 0x3000640c
        0x00805b22:    6800        .h      LDR      r0,[r0,#0]
        0x00805b24:    f3808808    ....    MSR      MSP,r0
        0x00805b28:    f3bf8f6f    ..o.    ISB      
        0x00805b2c:    f7febe8f    ....    B        warm_boot_patch ; 0x80484e
    get_remain_sleep_dur
        0x00805b30:    b508        ..      PUSH     {r3,lr}
        0x00805b32:    480b        .H      LDR      r0,[pc,#44] ; [0x805b60] = 0xa000c504
        0x00805b34:    303c        <0      ADDS     r0,r0,#0x3c
        0x00805b36:    6800        .h      LDR      r0,[r0,#0]
        0x00805b38:    f3c030c0    ...0    UBFX     r0,r0,#15,#1
        0x00805b3c:    2800        .(      CMP      r0,#0
        0x00805b3e:    d00c        ..      BEQ      0x805b5a ; get_remain_sleep_dur + 42
        0x00805b40:    2000        .       MOVS     r0,#0
        0x00805b42:    9000        ..      STR      r0,[sp,#0]
        0x00805b44:    4806        .H      LDR      r0,[pc,#24] ; [0x805b60] = 0xa000c504
        0x00805b46:    306c        l0      ADDS     r0,r0,#0x6c
        0x00805b48:    6800        .h      LDR      r0,[r0,#0]
        0x00805b4a:    4908        .I      LDR      r1,[pc,#32] ; [0x805b6c] = 0xa000e200
        0x00805b4c:    6809        .h      LDR      r1,[r1,#0]
        0x00805b4e:    1a40        @.      SUBS     r0,r0,r1
        0x00805b50:    4669        iF      MOV      r1,sp
        0x00805b52:    f474f1b7    t...    BL       rwip_lpcycles_2_hus ; 0x79ec4
        0x00805b56:    0840        @.      LSRS     r0,r0,#1
        0x00805b58:    bd08        ..      POP      {r3,pc}
        0x00805b5a:    2000        .       MOVS     r0,#0
        0x00805b5c:    bd08        ..      POP      {r3,pc}
    $d
        0x00805b5e:    0000        ..      DCW    0
        0x00805b60:    a000c504    ....    DCD    2684404996
        0x00805b64:    b00000f4    ....    DCD    2952790260
        0x00805b68:    30006968    hi.0    DCD    805333352
        0x00805b6c:    a000e200    ....    DCD    2684412416
        0x00805b70:    441c4000    .@.D    DCD    1142702080
        0x00805b74:    30006980    .i.0    DCD    805333376
        0x00805b78:    00801f64    d...    DCD    8396644
        0x00805b7c:    00802468    h$..    DCD    8397928
        0x00805b80:    3000640c    .d.0    DCD    805331980
    $t
    RAM_CODE
    ll_pwr_req_excute_psc_command
        0x00805b84:    490d        .I      LDR      r1,[pc,#52] ; [0x805bbc] = 0xa000c584
        0x00805b86:    b2c0        ..      UXTB     r0,r0
        0x00805b88:    6008        .`      STR      r0,[r1,#0]
        0x00805b8a:    1f08        ..      SUBS     r0,r1,#4
        0x00805b8c:    6801        .h      LDR      r1,[r0,#0]
        0x00805b8e:    f0410101    A...    ORR      r1,r1,#1
        0x00805b92:    6001        .`      STR      r1,[r0,#0]
        0x00805b94:    4770        pG      BX       lr
    ll_pwr_clear_ext_wakeup_status
        0x00805b96:    f3ef8110    ....    MRS      r1,PRIMASK
        0x00805b9a:    2201        ."      MOVS     r2,#1
        0x00805b9c:    f3828810    ....    MSR      PRIMASK,r2
        0x00805ba0:    4a06        .J      LDR      r2,[pc,#24] ; [0x805bbc] = 0xa000c584
        0x00805ba2:    ea6f4000    o..@    MVN      r0,r0,LSL #16
        0x00805ba6:    3a40        @:      SUBS     r2,r2,#0x40
        0x00805ba8:    6010        .`      STR      r0,[r2,#0]
        0x00805baa:    f3818810    ....    MSR      PRIMASK,r1
        0x00805bae:    4770        pG      BX       lr
    ll_pwr_is_active_flag_psc_cmd_busy
        0x00805bb0:    4802        .H      LDR      r0,[pc,#8] ; [0x805bbc] = 0xa000c584
        0x00805bb2:    1f00        ..      SUBS     r0,r0,#4
        0x00805bb4:    6800        .h      LDR      r0,[r0,#0]
        0x00805bb6:    f3c00040    ..@.    UBFX     r0,r0,#1,#1
        0x00805bba:    4770        pG      BX       lr
    $d
        0x00805bbc:    a000c584    ....    DCD    2684405124
    $t
    RAM_CODE
    hal_xqspi_init_ext
        0x00805bc0:    f000b8da    ....    B.W      hal_xqspi_init_ext_patch ; 0x805d78
    hal_exflash_read
        0x00805bc4:    f413b436    ..6.    B        hal_exflash_read_rom ; 0x19434
    RAM_CODE
    sys_context_save_func
        0x00805bc8:    b510        ..      PUSH     {r4,lr}
        0x00805bca:    f7fff831    ..1.    BL       boot_xo_bias_set ; 0x804c30
        0x00805bce:    f7fff881    ....    BL       boot_digldo_dcdc_set ; 0x804cd4
        0x00805bd2:    2000        .       MOVS     r0,#0
        0x00805bd4:    4a1d        .J      LDR      r2,[pc,#116] ; [0x805c4c] = 0x30006998
        0x00805bd6:    491e        .I      LDR      r1,[pc,#120] ; [0x805c50] = 0x300074e8
        0x00805bd8:    f8523020    R. 0    LDR      r3,[r2,r0,LSL #2]
        0x00805bdc:    681b        .h      LDR      r3,[r3,#0]
        0x00805bde:    f8413020    A. 0    STR      r3,[r1,r0,LSL #2]
        0x00805be2:    1c40        @.      ADDS     r0,r0,#1
        0x00805be4:    2831        1(      CMP      r0,#0x31
        0x00805be6:    d3f7        ..      BCC      0x805bd8 ; sys_context_save_func + 16
        0x00805be8:    481a        .H      LDR      r0,[pc,#104] ; [0x805c54] = 0xe000ed0c
        0x00805bea:    6800        .h      LDR      r0,[r0,#0]
        0x00805bec:    4a1a        .J      LDR      r2,[pc,#104] ; [0x805c58] = 0x5fa0000
        0x00805bee:    b280        ..      UXTH     r0,r0
        0x00805bf0:    4310        .C      ORRS     r0,r0,r2
        0x00805bf2:    f8c100c4    ....    STR      r0,[r1,#0xc4]
        0x00805bf6:    4819        .H      LDR      r0,[pc,#100] ; [0x805c5c] = 0xa000c550
        0x00805bf8:    6801        .h      LDR      r1,[r0,#0]
        0x00805bfa:    f421017f    !...    BIC      r1,r1,#0xff0000
        0x00805bfe:    6001        .`      STR      r1,[r0,#0]
        0x00805c00:    4816        .H      LDR      r0,[pc,#88] ; [0x805c5c] = 0xa000c550
        0x00805c02:    3810        .8      SUBS     r0,r0,#0x10
        0x00805c04:    6801        .h      LDR      r1,[r0,#0]
        0x00805c06:    f02161f8    !..a    BIC      r1,r1,#0x7c00000
        0x00805c0a:    6001        .`      STR      r1,[r0,#0]
        0x00805c0c:    bd10        ..      POP      {r4,pc}
    sys_context_restore_func
        0x00805c0e:    b510        ..      PUSH     {r4,lr}
        0x00805c10:    2000        .       MOVS     r0,#0
        0x00805c12:    4a0f        .J      LDR      r2,[pc,#60] ; [0x805c50] = 0x300074e8
        0x00805c14:    490d        .I      LDR      r1,[pc,#52] ; [0x805c4c] = 0x30006998
        0x00805c16:    f8523020    R. 0    LDR      r3,[r2,r0,LSL #2]
        0x00805c1a:    f8514020    Q. @    LDR      r4,[r1,r0,LSL #2]
        0x00805c1e:    6023        #`      STR      r3,[r4,#0]
        0x00805c20:    1c40        @.      ADDS     r0,r0,#1
        0x00805c22:    2825        %(      CMP      r0,#0x25
        0x00805c24:    d3f7        ..      BCC      0x805c16 ; sys_context_restore_func + 8
        0x00805c26:    f408f641    ..A.    BL       force_dpad_le_high ; 0xe8ac
        0x00805c2a:    e8bd4010    ...@    POP      {r4,lr}
        0x00805c2e:    f7ffb8ac    ....    B        work_digldo_dcdc_set ; 0x804d8a
    system_priority_restore_func
        0x00805c32:    b510        ..      PUSH     {r4,lr}
        0x00805c34:    2025        %       MOVS     r0,#0x25
        0x00805c36:    4a06        .J      LDR      r2,[pc,#24] ; [0x805c50] = 0x300074e8
        0x00805c38:    4904        .I      LDR      r1,[pc,#16] ; [0x805c4c] = 0x30006998
        0x00805c3a:    f8523020    R. 0    LDR      r3,[r2,r0,LSL #2]
        0x00805c3e:    f8514020    Q. @    LDR      r4,[r1,r0,LSL #2]
        0x00805c42:    6023        #`      STR      r3,[r4,#0]
        0x00805c44:    1c40        @.      ADDS     r0,r0,#1
        0x00805c46:    2832        2(      CMP      r0,#0x32
        0x00805c48:    d3f7        ..      BCC      0x805c3a ; system_priority_restore_func + 8
        0x00805c4a:    bd10        ..      POP      {r4,pc}
    $d
        0x00805c4c:    30006998    .i.0    DCD    805333400
        0x00805c50:    300074e8    .t.0    DCD    805336296
        0x00805c54:    e000ed0c    ....    DCD    3758157068
        0x00805c58:    05fa0000    ....    DCD    100270080
        0x00805c5c:    a000c550    P...    DCD    2684405072
    $t
    RAM_CODE
    hal_xqspi_set_xip_present_status_patch
        0x00805c60:    b510        ..      PUSH     {r4,lr}
        0x00805c62:    6802        .h      LDR      r2,[r0,#0]
        0x00805c64:    6813        .h      LDR      r3,[r2,#0]
        0x00805c66:    f0430301    C...    ORR      r3,r3,#1
        0x00805c6a:    6013        .`      STR      r3,[r2,#0]
        0x00805c6c:    bf00        ..      NOP      
        0x00805c6e:    bf00        ..      NOP      
        0x00805c70:    bf00        ..      NOP      
        0x00805c72:    bf00        ..      NOP      
        0x00805c74:    bf00        ..      NOP      
        0x00805c76:    bf00        ..      NOP      
        0x00805c78:    bf00        ..      NOP      
        0x00805c7a:    bf00        ..      NOP      
        0x00805c7c:    bf00        ..      NOP      
        0x00805c7e:    f8d23c0c    ...<    LDR      r3,[r2,#0xc0c]
        0x00805c82:    f0230301    #...    BIC      r3,r3,#1
        0x00805c86:    f8c23c0c    ...<    STR      r3,[r2,#0xc0c]
        0x00805c8a:    f8d23c10    ...<    LDR      r3,[r2,#0xc10]
        0x00805c8e:    f0030301    ....    AND      r3,r3,#1
        0x00805c92:    2b00        .+      CMP      r3,#0
        0x00805c94:    d1f9        ..      BNE      0x805c8a ; hal_xqspi_set_xip_present_status_patch + 42
        0x00805c96:    2901        .)      CMP      r1,#1
        0x00805c98:    d006        ..      BEQ      0x805ca8 ; hal_xqspi_set_xip_present_status_patch + 72
        0x00805c9a:    2100        .!      MOVS     r1,#0
        0x00805c9c:    f8c21470    ..p.    STR      r1,[r2,#0x470]
        0x00805ca0:    6880        .h      LDR      r0,[r0,#8]
        0x00805ca2:    2801        .(      CMP      r0,#1
        0x00805ca4:    d004        ..      BEQ      0x805cb0 ; hal_xqspi_set_xip_present_status_patch + 80
        0x00805ca6:    e05a        Z.      B        0x805d5e ; hal_xqspi_set_xip_present_status_patch + 254
        0x00805ca8:    2101        .!      MOVS     r1,#1
        0x00805caa:    f8c21470    ..p.    STR      r1,[r2,#0x470]
        0x00805cae:    e7f7        ..      B        0x805ca0 ; hal_xqspi_set_xip_present_status_patch + 64
        0x00805cb0:    49fb        .I      LDR      r1,[pc,#1004] ; [0x8060a0] = 0xa000c504
        0x00805cb2:    6808        .h      LDR      r0,[r1,#0]
        0x00805cb4:    f3c05340    ..@S    UBFX     r3,r0,#21,#1
        0x00805cb8:    6808        .h      LDR      r0,[r1,#0]
        0x00805cba:    f4201000     ...    BIC      r0,r0,#0x200000
        0x00805cbe:    6008        .`      STR      r0,[r1,#0]
        0x00805cc0:    6810        .h      LDR      r0,[r2,#0]
        0x00805cc2:    f40064f0    ...d    AND      r4,r0,#0x780
        0x00805cc6:    6810        .h      LDR      r0,[r2,#0]
        0x00805cc8:    f42060f0     ..`    BIC      r0,r0,#0x780
        0x00805ccc:    6010        .`      STR      r0,[r2,#0]
        0x00805cce:    6810        .h      LDR      r0,[r2,#0]
        0x00805cd0:    f0400008    @...    ORR      r0,r0,#8
        0x00805cd4:    6010        .`      STR      r0,[r2,#0]
        0x00805cd6:    6810        .h      LDR      r0,[r2,#0]
        0x00805cd8:    f0400002    @...    ORR      r0,r0,#2
        0x00805cdc:    6010        .`      STR      r0,[r2,#0]
        0x00805cde:    bf00        ..      NOP      
        0x00805ce0:    bf00        ..      NOP      
        0x00805ce2:    bf00        ..      NOP      
        0x00805ce4:    bf00        ..      NOP      
        0x00805ce6:    bf00        ..      NOP      
        0x00805ce8:    bf00        ..      NOP      
        0x00805cea:    bf00        ..      NOP      
        0x00805cec:    bf00        ..      NOP      
        0x00805cee:    bf00        ..      NOP      
        0x00805cf0:    bf00        ..      NOP      
        0x00805cf2:    bf00        ..      NOP      
        0x00805cf4:    bf00        ..      NOP      
        0x00805cf6:    bf00        ..      NOP      
        0x00805cf8:    bf00        ..      NOP      
        0x00805cfa:    bf00        ..      NOP      
        0x00805cfc:    bf00        ..      NOP      
        0x00805cfe:    bf00        ..      NOP      
        0x00805d00:    bf00        ..      NOP      
        0x00805d02:    bf00        ..      NOP      
        0x00805d04:    bf00        ..      NOP      
        0x00805d06:    bf00        ..      NOP      
        0x00805d08:    bf00        ..      NOP      
        0x00805d0a:    bf00        ..      NOP      
        0x00805d0c:    bf00        ..      NOP      
        0x00805d0e:    bf00        ..      NOP      
        0x00805d10:    bf00        ..      NOP      
        0x00805d12:    bf00        ..      NOP      
        0x00805d14:    bf00        ..      NOP      
        0x00805d16:    6910        .i      LDR      r0,[r2,#0x10]
        0x00805d18:    f0000001    ....    AND      r0,r0,#1
        0x00805d1c:    2800        .(      CMP      r0,#0
        0x00805d1e:    d1fa        ..      BNE      0x805d16 ; hal_xqspi_set_xip_present_status_patch + 182
        0x00805d20:    6810        .h      LDR      r0,[r2,#0]
        0x00805d22:    f0200008     ...    BIC      r0,r0,#8
        0x00805d26:    6010        .`      STR      r0,[r2,#0]
        0x00805d28:    6810        .h      LDR      r0,[r2,#0]
        0x00805d2a:    f0200002     ...    BIC      r0,r0,#2
        0x00805d2e:    6010        .`      STR      r0,[r2,#0]
        0x00805d30:    6810        .h      LDR      r0,[r2,#0]
        0x00805d32:    f0200001     ...    BIC      r0,r0,#1
        0x00805d36:    6010        .`      STR      r0,[r2,#0]
        0x00805d38:    bf00        ..      NOP      
        0x00805d3a:    bf00        ..      NOP      
        0x00805d3c:    bf00        ..      NOP      
        0x00805d3e:    bf00        ..      NOP      
        0x00805d40:    bf00        ..      NOP      
        0x00805d42:    bf00        ..      NOP      
        0x00805d44:    bf00        ..      NOP      
        0x00805d46:    bf00        ..      NOP      
        0x00805d48:    bf00        ..      NOP      
        0x00805d4a:    6810        .h      LDR      r0,[r2,#0]
        0x00805d4c:    f42060f0     ..`    BIC      r0,r0,#0x780
        0x00805d50:    4320         C      ORRS     r0,r0,r4
        0x00805d52:    6010        .`      STR      r0,[r2,#0]
        0x00805d54:    b11b        ..      CBZ      r3,0x805d5e ; hal_xqspi_set_xip_present_status_patch + 254
        0x00805d56:    6808        .h      LDR      r0,[r1,#0]
        0x00805d58:    f4401000    @...    ORR      r0,r0,#0x200000
        0x00805d5c:    6008        .`      STR      r0,[r1,#0]
        0x00805d5e:    f8d20c0c    ....    LDR      r0,[r2,#0xc0c]
        0x00805d62:    f0400001    @...    ORR      r0,r0,#1
        0x00805d66:    f8c20c0c    ....    STR      r0,[r2,#0xc0c]
        0x00805d6a:    f8d20c10    ....    LDR      r0,[r2,#0xc10]
        0x00805d6e:    f0000001    ....    AND      r0,r0,#1
        0x00805d72:    2800        .(      CMP      r0,#0
        0x00805d74:    d0f9        ..      BEQ      0x805d6a ; hal_xqspi_set_xip_present_status_patch + 266
        0x00805d76:    bd10        ..      POP      {r4,pc}
    hal_xqspi_init_ext_patch
        0x00805d78:    b5f0        ..      PUSH     {r4-r7,lr}
        0x00805d7a:    b089        ..      SUB      sp,sp,#0x24
        0x00805d7c:    4604        .F      MOV      r4,r0
        0x00805d7e:    2500        .%      MOVS     r5,#0
        0x00805d80:    2c00        .,      CMP      r4,#0
        0x00805d82:    d00b        ..      BEQ      0x805d9c ; hal_xqspi_init_ext_patch + 36
        0x00805d84:    f8940030    ..0.    LDRB     r0,[r4,#0x30]
        0x00805d88:    2801        .(      CMP      r0,#1
        0x00805d8a:    d00a        ..      BEQ      0x805da2 ; hal_xqspi_init_ext_patch + 42
        0x00805d8c:    2701        .'      MOVS     r7,#1
        0x00805d8e:    f8847030    ..0p    STRB     r7,[r4,#0x30]
        0x00805d92:    f8940031    ..1.    LDRB     r0,[r4,#0x31]
        0x00805d96:    2600        .&      MOVS     r6,#0
        0x00805d98:    b128        (.      CBZ      r0,0x805da6 ; hal_xqspi_init_ext_patch + 46
        0x00805d9a:    e00e        ..      B        0x805dba ; hal_xqspi_init_ext_patch + 66
        0x00805d9c:    2001        .       MOVS     r0,#1
        0x00805d9e:    b009        ..      ADD      sp,sp,#0x24
        0x00805da0:    bdf0        ..      POP      {r4-r7,pc}
        0x00805da2:    2002        .       MOVS     r0,#2
        0x00805da4:    e7fb        ..      B        0x805d9e ; hal_xqspi_init_ext_patch + 38
        0x00805da6:    f8846030    ..0`    STRB     r6,[r4,#0x30]
        0x00805daa:    4620         F      MOV      r0,r4
        0x00805dac:    f41cf0b4    ....    BL       hal_xqspi_msp_init ; 0x21f18
        0x00805db0:    f44f717a    O.zq    MOV      r1,#0x3e8
        0x00805db4:    4620         F      MOV      r0,r4
        0x00805db6:    f41cf107    ....    BL       hal_xqspi_set_retry ; 0x21fc8
        0x00805dba:    6820         h      LDR      r0,[r4,#0]
        0x00805dbc:    f8d00c10    ....    LDR      r0,[r0,#0xc10]
        0x00805dc0:    f0000001    ....    AND      r0,r0,#1
        0x00805dc4:    b930        0.      CBNZ     r0,0x805dd4 ; hal_xqspi_init_ext_patch + 92
        0x00805dc6:    2200        ."      MOVS     r2,#0
        0x00805dc8:    2101        .!      MOVS     r1,#1
        0x00805dca:    4620         F      MOV      r0,r4
        0x00805dcc:    6ba3        .k      LDR      r3,[r4,#0x38]
        0x00805dce:    f456f517    V...    BL       xqspi_wait_flag_state_until_retry ; 0x5c800
        0x00805dd2:    4605        .F      MOV      r5,r0
        0x00805dd4:    b9d5        ..      CBNZ     r5,0x805e0c ; hal_xqspi_init_ext_patch + 148
        0x00805dd6:    6860        `h      LDR      r0,[r4,#4]
        0x00805dd8:    9001        ..      STR      r0,[sp,#4]
        0x00805dda:    68a0        .h      LDR      r0,[r4,#8]
        0x00805ddc:    9002        ..      STR      r0,[sp,#8]
        0x00805dde:    68e0        .h      LDR      r0,[r4,#0xc]
        0x00805de0:    9003        ..      STR      r0,[sp,#0xc]
        0x00805de2:    6920         i      LDR      r0,[r4,#0x10]
        0x00805de4:    9008        ..      STR      r0,[sp,#0x20]
        0x00805de6:    7d20         }      LDRB     r0,[r4,#0x14]
        0x00805de8:    f3c00040    ..@.    UBFX     r0,r0,#1,#1
        0x00805dec:    9006        ..      STR      r0,[sp,#0x18]
        0x00805dee:    7d20         }      LDRB     r0,[r4,#0x14]
        0x00805df0:    f0000001    ....    AND      r0,r0,#1
        0x00805df4:    9007        ..      STR      r0,[sp,#0x1c]
        0x00805df6:    2010        .       MOVS     r0,#0x10
        0x00805df8:    9004        ..      STR      r0,[sp,#0x10]
        0x00805dfa:    2004        .       MOVS     r0,#4
        0x00805dfc:    9005        ..      STR      r0,[sp,#0x14]
        0x00805dfe:    a901        ..      ADD      r1,sp,#4
        0x00805e00:    6820         h      LDR      r0,[r4,#0]
        0x00805e02:    f000f979    ..y.    BL       ll_xqspi_init_patch ; 0x8060f8
        0x00805e06:    2801        .(      CMP      r0,#1
        0x00805e08:    d004        ..      BEQ      0x805e14 ; hal_xqspi_init_ext_patch + 156
        0x00805e0a:    2501        .%      MOVS     r5,#1
        0x00805e0c:    f8846030    ..0`    STRB     r6,[r4,#0x30]
        0x00805e10:    4628        (F      MOV      r0,r5
        0x00805e12:    e7c4        ..      B        0x805d9e ; hal_xqspi_init_ext_patch + 38
        0x00805e14:    6860        `h      LDR      r0,[r4,#4]
        0x00805e16:    2801        .(      CMP      r0,#1
        0x00805e18:    d106        ..      BNE      0x805e28 ; hal_xqspi_init_ext_patch + 176
        0x00805e1a:    6820         h      LDR      r0,[r4,#0]
        0x00805e1c:    f8d0143c    ..<.    LDR      r1,[r0,#0x43c]
        0x00805e20:    f0410101    A...    ORR      r1,r1,#1
        0x00805e24:    f8c0143c    ..<.    STR      r1,[r0,#0x43c]
        0x00805e28:    6366        fc      STR      r6,[r4,#0x34]
        0x00805e2a:    f8847031    ..1p    STRB     r7,[r4,#0x31]
        0x00805e2e:    e7ed        ..      B        0x805e0c ; hal_xqspi_init_ext_patch + 148
    xqspi_receive_patch
        0x00805e30:    e92d4ff7    -..O    PUSH     {r0-r2,r4-r11,lr}
        0x00805e34:    4604        .F      MOV      r4,r0
        0x00805e36:    6800        .h      LDR      r0,[r0,#0]
        0x00805e38:    460d        .F      MOV      r5,r1
        0x00805e3a:    f2004804    ...H    ADD      r8,r0,#0x404
        0x00805e3e:    f5006780    ...g    ADD      r7,r0,#0x400
        0x00805e42:    f2004614    ...F    ADD      r6,r0,#0x414
        0x00805e46:    f8d0b470    ..p.    LDR      r11,[r0,#0x470]
        0x00805e4a:    1f30        0.      SUBS     r0,r6,#4
        0x00805e4c:    6801        .h      LDR      r1,[r0,#0]
        0x00805e4e:    f0210108    !...    BIC      r1,r1,#8
        0x00805e52:    6001        .`      STR      r1,[r0,#0]
        0x00805e54:    6820         h      LDR      r0,[r4,#0]
        0x00805e56:    2101        .!      MOVS     r1,#1
        0x00805e58:    f8c01470    ..p.    STR      r1,[r0,#0x470]
        0x00805e5c:    6aa0        .j      LDR      r0,[r4,#0x28]
        0x00805e5e:    f04f3aff    O..:    MOV      r10,#0xffffffff
        0x00805e62:    2810        .(      CMP      r0,#0x10
        0x00805e64:    d947        G.      BLS      0x805ef6 ; xqspi_receive_patch + 198
        0x00805e66:    6aa0        .j      LDR      r0,[r4,#0x28]
        0x00805e68:    2170        p!      MOVS     r1,#0x70
        0x00805e6a:    f0000903    ....    AND      r9,r0,#3
        0x00805e6e:    6820         h      LDR      r0,[r4,#0]
        0x00805e70:    f000f8ed    ....    BL       ll_xqspi_set_qspi_datasize ; 0x80604e
        0x00805e74:    6aa0        .j      LDR      r0,[r4,#0x28]
        0x00805e76:    0880        ..      LSRS     r0,r0,#2
        0x00805e78:    e021        !.      B        0x805ebe ; xqspi_receive_patch + 142
        0x00805e7a:    6ae0        .j      LDR      r0,[r4,#0x2c]
        0x00805e7c:    2810        .(      CMP      r0,#0x10
        0x00805e7e:    d901        ..      BLS      0x805e84 ; xqspi_receive_patch + 84
        0x00805e80:    2210        ."      MOVS     r2,#0x10
        0x00805e82:    e000        ..      B        0x805e86 ; xqspi_receive_patch + 86
        0x00805e84:    6ae2        .j      LDR      r2,[r4,#0x2c]
        0x00805e86:    4651        QF      MOV      r1,r10
        0x00805e88:    4610        .F      MOV      r0,r2
        0x00805e8a:    e000        ..      B        0x805e8e ; xqspi_receive_patch + 94
        0x00805e8c:    6039        9`      STR      r1,[r7,#0]
        0x00805e8e:    1e40        @.      SUBS     r0,r0,#1
        0x00805e90:    d2fc        ..      BCS      0x805e8c ; xqspi_receive_patch + 92
        0x00805e92:    4611        .F      MOV      r1,r2
        0x00805e94:    e00f        ..      B        0x805eb6 ; xqspi_receive_patch + 134
        0x00805e96:    6830        0h      LDR      r0,[r6,#0]
        0x00805e98:    0680        ..      LSLS     r0,r0,#26
        0x00805e9a:    d4fc        ..      BMI      0x805e96 ; xqspi_receive_patch + 102
        0x00805e9c:    f8d80000    ....    LDR      r0,[r8,#0]
        0x00805ea0:    0e03        ..      LSRS     r3,r0,#24
        0x00805ea2:    f8053b01    ...;    STRB     r3,[r5],#1
        0x00805ea6:    0c03        ..      LSRS     r3,r0,#16
        0x00805ea8:    f8053b01    ...;    STRB     r3,[r5],#1
        0x00805eac:    0a03        ..      LSRS     r3,r0,#8
        0x00805eae:    f8053b02    ...;    STRB     r3,[r5],#2
        0x00805eb2:    f8050c01    ....    STRB     r0,[r5,#-1]
        0x00805eb6:    1e49        I.      SUBS     r1,r1,#1
        0x00805eb8:    d2ed        ..      BCS      0x805e96 ; xqspi_receive_patch + 102
        0x00805eba:    6ae0        .j      LDR      r0,[r4,#0x2c]
        0x00805ebc:    1a80        ..      SUBS     r0,r0,r2
        0x00805ebe:    62e0        .b      STR      r0,[r4,#0x2c]
        0x00805ec0:    6ae0        .j      LDR      r0,[r4,#0x2c]
        0x00805ec2:    2800        .(      CMP      r0,#0
        0x00805ec4:    d1d9        ..      BNE      0x805e7a ; xqspi_receive_patch + 74
        0x00805ec6:    f1b90f00    ....    CMP      r9,#0
        0x00805eca:    d00f        ..      BEQ      0x805eec ; xqspi_receive_patch + 188
        0x00805ecc:    f8c7a000    ....    STR      r10,[r7,#0]
        0x00805ed0:    6830        0h      LDR      r0,[r6,#0]
        0x00805ed2:    0680        ..      LSLS     r0,r0,#26
        0x00805ed4:    d4fc        ..      BMI      0x805ed0 ; xqspi_receive_patch + 160
        0x00805ed6:    f8d81000    ....    LDR      r1,[r8,#0]
        0x00805eda:    2000        .       MOVS     r0,#0
        0x00805edc:    e004        ..      B        0x805ee8 ; xqspi_receive_patch + 184
        0x00805ede:    0e0a        ..      LSRS     r2,r1,#24
        0x00805ee0:    542a        *T      STRB     r2,[r5,r0]
        0x00805ee2:    0209        ..      LSLS     r1,r1,#8
        0x00805ee4:    1c40        @.      ADDS     r0,r0,#1
        0x00805ee6:    b2c0        ..      UXTB     r0,r0
        0x00805ee8:    4548        HE      CMP      r0,r9
        0x00805eea:    d3f8        ..      BCC      0x805ede ; xqspi_receive_patch + 174
        0x00805eec:    2110        .!      MOVS     r1,#0x10
        0x00805eee:    6820         h      LDR      r0,[r4,#0]
        0x00805ef0:    f000f8ad    ....    BL       ll_xqspi_set_qspi_datasize ; 0x80604e
        0x00805ef4:    e012        ..      B        0x805f1c ; xqspi_receive_patch + 236
        0x00805ef6:    6ae0        .j      LDR      r0,[r4,#0x2c]
        0x00805ef8:    4651        QF      MOV      r1,r10
        0x00805efa:    e000        ..      B        0x805efe ; xqspi_receive_patch + 206
        0x00805efc:    6039        9`      STR      r1,[r7,#0]
        0x00805efe:    1e40        @.      SUBS     r0,r0,#1
        0x00805f00:    d2fc        ..      BCS      0x805efc ; xqspi_receive_patch + 204
        0x00805f02:    6ae0        .j      LDR      r0,[r4,#0x2c]
        0x00805f04:    e006        ..      B        0x805f14 ; xqspi_receive_patch + 228
        0x00805f06:    6831        1h      LDR      r1,[r6,#0]
        0x00805f08:    0689        ..      LSLS     r1,r1,#26
        0x00805f0a:    d4fc        ..      BMI      0x805f06 ; xqspi_receive_patch + 214
        0x00805f0c:    f8981000    ....    LDRB     r1,[r8,#0]
        0x00805f10:    f8051b01    ....    STRB     r1,[r5],#1
        0x00805f14:    1e40        @.      SUBS     r0,r0,#1
        0x00805f16:    d2f6        ..      BCS      0x805f06 ; xqspi_receive_patch + 214
        0x00805f18:    2000        .       MOVS     r0,#0
        0x00805f1a:    62e0        .b      STR      r0,[r4,#0x2c]
        0x00805f1c:    6821        !h      LDR      r1,[r4,#0]
        0x00805f1e:    f8c1b470    ..p.    STR      r11,[r1,#0x470]
        0x00805f22:    9b02        ..      LDR      r3,[sp,#8]
        0x00805f24:    b003        ..      ADD      sp,sp,#0xc
        0x00805f26:    4620         F      MOV      r0,r4
        0x00805f28:    e8bd4ff0    ...O    POP      {r4-r11,lr}
        0x00805f2c:    2200        ."      MOVS     r2,#0
        0x00805f2e:    2101        .!      MOVS     r1,#1
        0x00805f30:    f456b466    V.f.    B        xqspi_wait_flag_state_until_retry ; 0x5c800
    hal_xqspi_command_receive_patch
        0x00805f34:    e92d47f0    -..G    PUSH     {r4-r10,lr}
        0x00805f38:    4604        .F      MOV      r4,r0
        0x00805f3a:    460d        .F      MOV      r5,r1
        0x00805f3c:    4690        .F      MOV      r8,r2
        0x00805f3e:    4699        .F      MOV      r9,r3
        0x00805f40:    f8940030    ..0.    LDRB     r0,[r4,#0x30]
        0x00805f44:    2801        .(      CMP      r0,#1
        0x00805f46:    d00c        ..      BEQ      0x805f62 ; hal_xqspi_command_receive_patch + 46
        0x00805f48:    2601        .&      MOVS     r6,#1
        0x00805f4a:    f8846030    ..0`    STRB     r6,[r4,#0x30]
        0x00805f4e:    f8940031    ..1.    LDRB     r0,[r4,#0x31]
        0x00805f52:    2700        .'      MOVS     r7,#0
        0x00805f54:    2801        .(      CMP      r0,#1
        0x00805f56:    d006        ..      BEQ      0x805f66 ; hal_xqspi_command_receive_patch + 50
        0x00805f58:    2002        .       MOVS     r0,#2
        0x00805f5a:    f8847030    ..0p    STRB     r7,[r4,#0x30]
        0x00805f5e:    e8bd87f0    ....    POP      {r4-r10,pc}
        0x00805f62:    2002        .       MOVS     r0,#2
        0x00805f64:    e7fb        ..      B        0x805f5e ; hal_xqspi_command_receive_patch + 42
        0x00805f66:    6367        gc      STR      r7,[r4,#0x34]
        0x00805f68:    2002        .       MOVS     r0,#2
        0x00805f6a:    f8840031    ..1.    STRB     r0,[r4,#0x31]
        0x00805f6e:    464b        KF      MOV      r3,r9
        0x00805f70:    2200        ."      MOVS     r2,#0
        0x00805f72:    2101        .!      MOVS     r1,#1
        0x00805f74:    4620         F      MOV      r0,r4
        0x00805f76:    f456f443    V.C.    BL       xqspi_wait_flag_state_until_retry ; 0x5c800
        0x00805f7a:    b9f8        ..      CBNZ     r0,0x805fbc ; hal_xqspi_command_receive_patch + 136
        0x00805f7c:    2022        "       MOVS     r0,#0x22
        0x00805f7e:    f8840031    ..1.    STRB     r0,[r4,#0x31]
        0x00805f82:    f8c48024    ..$.    STR      r8,[r4,#0x24]
        0x00805f86:    69e8        .i      LDR      r0,[r5,#0x1c]
        0x00805f88:    62a0        .b      STR      r0,[r4,#0x28]
        0x00805f8a:    69e8        .i      LDR      r0,[r5,#0x1c]
        0x00805f8c:    62e0        .b      STR      r0,[r4,#0x2c]
        0x00805f8e:    6820         h      LDR      r0,[r4,#0]
        0x00805f90:    f8d01418    ....    LDR      r1,[r0,#0x418]
        0x00805f94:    f0410101    A...    ORR      r1,r1,#1
        0x00805f98:    f8c01418    ....    STR      r1,[r0,#0x418]
        0x00805f9c:    4629        )F      MOV      r1,r5
        0x00805f9e:    4620         F      MOV      r0,r4
        0x00805fa0:    f456f379    V.y.    BL       xqspi_send_inst_addr ; 0x5c696
        0x00805fa4:    464a        JF      MOV      r2,r9
        0x00805fa6:    4641        AF      MOV      r1,r8
        0x00805fa8:    4620         F      MOV      r0,r4
        0x00805faa:    f7ffff41    ..A.    BL       xqspi_receive_patch ; 0x805e30
        0x00805fae:    6821        !h      LDR      r1,[r4,#0]
        0x00805fb0:    f8d12418    ...$    LDR      r2,[r1,#0x418]
        0x00805fb4:    f0220201    "...    BIC      r2,r2,#1
        0x00805fb8:    f8c12418    ...$    STR      r2,[r1,#0x418]
        0x00805fbc:    f8846031    ..1`    STRB     r6,[r4,#0x31]
        0x00805fc0:    e7cb        ..      B        0x805f5a ; hal_xqspi_command_receive_patch + 38
    hal_xqspi_command_receive_align_word
        0x00805fc2:    e92d47f0    -..G    PUSH     {r4-r10,lr}
        0x00805fc6:    4604        .F      MOV      r4,r0
        0x00805fc8:    460d        .F      MOV      r5,r1
        0x00805fca:    4690        .F      MOV      r8,r2
        0x00805fcc:    4699        .F      MOV      r9,r3
        0x00805fce:    f8940030    ..0.    LDRB     r0,[r4,#0x30]
        0x00805fd2:    2801        .(      CMP      r0,#1
        0x00805fd4:    d00b        ..      BEQ      0x805fee ; hal_xqspi_command_receive_align_word + 44
        0x00805fd6:    2601        .&      MOVS     r6,#1
        0x00805fd8:    f8846030    ..0`    STRB     r6,[r4,#0x30]
        0x00805fdc:    f8940031    ..1.    LDRB     r0,[r4,#0x31]
        0x00805fe0:    2700        .'      MOVS     r7,#0
        0x00805fe2:    2801        .(      CMP      r0,#1
        0x00805fe4:    d005        ..      BEQ      0x805ff2 ; hal_xqspi_command_receive_align_word + 48
        0x00805fe6:    2002        .       MOVS     r0,#2
        0x00805fe8:    f8847030    ..0p    STRB     r7,[r4,#0x30]
        0x00805fec:    e7b7        ..      B        0x805f5e ; hal_xqspi_command_receive_patch + 42
        0x00805fee:    2002        .       MOVS     r0,#2
        0x00805ff0:    e7b5        ..      B        0x805f5e ; hal_xqspi_command_receive_patch + 42
        0x00805ff2:    6367        gc      STR      r7,[r4,#0x34]
        0x00805ff4:    2002        .       MOVS     r0,#2
        0x00805ff6:    f8840031    ..1.    STRB     r0,[r4,#0x31]
        0x00805ffa:    464b        KF      MOV      r3,r9
        0x00805ffc:    2200        ."      MOVS     r2,#0
        0x00805ffe:    2101        .!      MOVS     r1,#1
        0x00806000:    4620         F      MOV      r0,r4
        0x00806002:    f456f3fd    V...    BL       xqspi_wait_flag_state_until_retry ; 0x5c800
        0x00806006:    b9f8        ..      CBNZ     r0,0x806048 ; hal_xqspi_command_receive_align_word + 134
        0x00806008:    2022        "       MOVS     r0,#0x22
        0x0080600a:    f8840031    ..1.    STRB     r0,[r4,#0x31]
        0x0080600e:    f8c48024    ..$.    STR      r8,[r4,#0x24]
        0x00806012:    69e8        .i      LDR      r0,[r5,#0x1c]
        0x00806014:    62a0        .b      STR      r0,[r4,#0x28]
        0x00806016:    69e8        .i      LDR      r0,[r5,#0x1c]
        0x00806018:    62e0        .b      STR      r0,[r4,#0x2c]
        0x0080601a:    6820         h      LDR      r0,[r4,#0]
        0x0080601c:    f8d01418    ....    LDR      r1,[r0,#0x418]
        0x00806020:    f0410101    A...    ORR      r1,r1,#1
        0x00806024:    f8c01418    ....    STR      r1,[r0,#0x418]
        0x00806028:    4629        )F      MOV      r1,r5
        0x0080602a:    4620         F      MOV      r0,r4
        0x0080602c:    f456f333    V.3.    BL       xqspi_send_inst_addr ; 0x5c696
        0x00806030:    464a        JF      MOV      r2,r9
        0x00806032:    4641        AF      MOV      r1,r8
        0x00806034:    4620         F      MOV      r0,r4
        0x00806036:    f000f812    ....    BL       xqspi_receive_align_word ; 0x80605e
        0x0080603a:    6821        !h      LDR      r1,[r4,#0]
        0x0080603c:    f8d12418    ...$    LDR      r2,[r1,#0x418]
        0x00806040:    f0220201    "...    BIC      r2,r2,#1
        0x00806044:    f8c12418    ...$    STR      r2,[r1,#0x418]
        0x00806048:    f8846031    ..1`    STRB     r6,[r4,#0x31]
        0x0080604c:    e7cc        ..      B        0x805fe8 ; hal_xqspi_command_receive_align_word + 38
    ll_xqspi_set_qspi_datasize
        0x0080604e:    f8d02410    ...$    LDR      r2,[r0,#0x410]
        0x00806052:    f0220270    ".p.    BIC      r2,r2,#0x70
        0x00806056:    430a        .C      ORRS     r2,r2,r1
        0x00806058:    f8c02410    ...$    STR      r2,[r0,#0x410]
        0x0080605c:    4770        pG      BX       lr
    xqspi_receive_align_word
        0x0080605e:    e92d47f0    -..G    PUSH     {r4-r10,lr}
        0x00806062:    4604        .F      MOV      r4,r0
        0x00806064:    6800        .h      LDR      r0,[r0,#0]
        0x00806066:    4692        .F      MOV      r10,r2
        0x00806068:    f2004804    ...H    ADD      r8,r0,#0x404
        0x0080606c:    f5006780    ...g    ADD      r7,r0,#0x400
        0x00806070:    f2004614    ...F    ADD      r6,r0,#0x414
        0x00806074:    f8d09470    ..p.    LDR      r9,[r0,#0x470]
        0x00806078:    460d        .F      MOV      r5,r1
        0x0080607a:    1f30        0.      SUBS     r0,r6,#4
        0x0080607c:    6801        .h      LDR      r1,[r0,#0]
        0x0080607e:    f0210108    !...    BIC      r1,r1,#8
        0x00806082:    6001        .`      STR      r1,[r0,#0]
        0x00806084:    6821        !h      LDR      r1,[r4,#0]
        0x00806086:    2001        .       MOVS     r0,#1
        0x00806088:    f8c10470    ..p.    STR      r0,[r1,#0x470]
        0x0080608c:    2170        p!      MOVS     r1,#0x70
        0x0080608e:    6820         h      LDR      r0,[r4,#0]
        0x00806090:    f7ffffdd    ....    BL       ll_xqspi_set_qspi_datasize ; 0x80604e
        0x00806094:    6aa0        .j      LDR      r0,[r4,#0x28]
        0x00806096:    0880        ..      LSRS     r0,r0,#2
        0x00806098:    62e0        .b      STR      r0,[r4,#0x2c]
        0x0080609a:    f04f33ff    O..3    MOV      r3,#0xffffffff
        0x0080609e:    e019        ..      B        0x8060d4 ; xqspi_receive_align_word + 118
    $d
        0x008060a0:    a000c504    ....    DCD    2684404996
    $t
        0x008060a4:    6ae0        .j      LDR      r0,[r4,#0x2c]
        0x008060a6:    2810        .(      CMP      r0,#0x10
        0x008060a8:    d901        ..      BLS      0x8060ae ; xqspi_receive_align_word + 80
        0x008060aa:    2210        ."      MOVS     r2,#0x10
        0x008060ac:    e000        ..      B        0x8060b0 ; xqspi_receive_align_word + 82
        0x008060ae:    6ae2        .j      LDR      r2,[r4,#0x2c]
        0x008060b0:    4610        .F      MOV      r0,r2
        0x008060b2:    e000        ..      B        0x8060b6 ; xqspi_receive_align_word + 88
        0x008060b4:    603b        ;`      STR      r3,[r7,#0]
        0x008060b6:    1e40        @.      SUBS     r0,r0,#1
        0x008060b8:    d2fc        ..      BCS      0x8060b4 ; xqspi_receive_align_word + 86
        0x008060ba:    4611        .F      MOV      r1,r2
        0x008060bc:    e005        ..      B        0x8060ca ; xqspi_receive_align_word + 108
        0x008060be:    6830        0h      LDR      r0,[r6,#0]
        0x008060c0:    0680        ..      LSLS     r0,r0,#26
        0x008060c2:    d4fc        ..      BMI      0x8060be ; xqspi_receive_align_word + 96
        0x008060c4:    f8d80000    ....    LDR      r0,[r8,#0]
        0x008060c8:    c501        ..      STM      r5!,{r0}
        0x008060ca:    1e49        I.      SUBS     r1,r1,#1
        0x008060cc:    d2f7        ..      BCS      0x8060be ; xqspi_receive_align_word + 96
        0x008060ce:    6ae0        .j      LDR      r0,[r4,#0x2c]
        0x008060d0:    1a80        ..      SUBS     r0,r0,r2
        0x008060d2:    62e0        .b      STR      r0,[r4,#0x2c]
        0x008060d4:    6ae0        .j      LDR      r0,[r4,#0x2c]
        0x008060d6:    2800        .(      CMP      r0,#0
        0x008060d8:    d1e4        ..      BNE      0x8060a4 ; xqspi_receive_align_word + 70
        0x008060da:    2110        .!      MOVS     r1,#0x10
        0x008060dc:    6820         h      LDR      r0,[r4,#0]
        0x008060de:    f7ffffb6    ....    BL       ll_xqspi_set_qspi_datasize ; 0x80604e
        0x008060e2:    6821        !h      LDR      r1,[r4,#0]
        0x008060e4:    f8c19470    ..p.    STR      r9,[r1,#0x470]
        0x008060e8:    4653        SF      MOV      r3,r10
        0x008060ea:    4620         F      MOV      r0,r4
        0x008060ec:    e8bd47f0    ...G    POP      {r4-r10,lr}
        0x008060f0:    2200        ."      MOVS     r2,#0
        0x008060f2:    2101        .!      MOVS     r1,#1
        0x008060f4:    f456b384    V...    B        xqspi_wait_flag_state_until_retry ; 0x5c800
    RAM_CODE
    ll_xqspi_init_patch
        0x008060f8:    b570        p.      PUSH     {r4-r6,lr}
        0x008060fa:    4604        .F      MOV      r4,r0
        0x008060fc:    460d        .F      MOV      r5,r1
        0x008060fe:    4ea8        .N      LDR      r6,[pc,#672] ; [0x8063a0] = 0xa000c504
        0x00806100:    6828        (h      LDR      r0,[r5,#0]
        0x00806102:    2801        .(      CMP      r0,#1
        0x00806104:    d052        R.      BEQ      0x8061ac ; ll_xqspi_init_patch + 180
        0x00806106:    f5046482    ...d    ADD      r4,r4,#0x410
        0x0080610a:    6ae0        .j      LDR      r0,[r4,#0x2c]
        0x0080610c:    f0200001     ...    BIC      r0,r0,#1
        0x00806110:    62e0        .b      STR      r0,[r4,#0x2c]
        0x00806112:    68a8        .h      LDR      r0,[r5,#8]
        0x00806114:    f8d417f0    ....    LDR      r1,[r4,#0x7f0]
        0x00806118:    f02101ff    !...    BIC      r1,r1,#0xff
        0x0080611c:    4301        .C      ORRS     r1,r1,r0
        0x0080611e:    f8c417f0    ....    STR      r1,[r4,#0x7f0]
        0x00806122:    f8d407f4    ....    LDR      r0,[r4,#0x7f4]
        0x00806126:    f0200001     ...    BIC      r0,r0,#1
        0x0080612a:    f8c407f4    ....    STR      r0,[r4,#0x7f4]
        0x0080612e:    f8d407f4    ....    LDR      r0,[r4,#0x7f4]
        0x00806132:    f020001e     ...    BIC      r0,r0,#0x1e
        0x00806136:    f0400002    @...    ORR      r0,r0,#2
        0x0080613a:    f8c407f4    ....    STR      r0,[r4,#0x7f4]
        0x0080613e:    69a8        .i      LDR      r0,[r5,#0x18]
        0x00806140:    f8d417f4    ....    LDR      r1,[r4,#0x7f4]
        0x00806144:    f0210120    !. .    BIC      r1,r1,#0x20
        0x00806148:    ea411040    A.@.    ORR      r0,r1,r0,LSL #5
        0x0080614c:    f8c407f4    ....    STR      r0,[r4,#0x7f4]
        0x00806150:    6968        hi      LDR      r0,[r5,#0x14]
        0x00806152:    f8d417f4    ....    LDR      r1,[r4,#0x7f4]
        0x00806156:    f0210140    !.@.    BIC      r1,r1,#0x40
        0x0080615a:    ea411080    A...    ORR      r0,r1,r0,LSL #6
        0x0080615e:    f8c407f4    ....    STR      r0,[r4,#0x7f4]
        0x00806162:    f8d407f4    ....    LDR      r0,[r4,#0x7f4]
        0x00806166:    f4407080    @..p    ORR      r0,r0,#0x100
        0x0080616a:    f8c407f4    ....    STR      r0,[r4,#0x7f4]
        0x0080616e:    f8d407f8    ....    LDR      r0,[r4,#0x7f8]
        0x00806172:    f02000ff     ...    BIC      r0,r0,#0xff
        0x00806176:    f0400033    @.3.    ORR      r0,r0,#0x33
        0x0080617a:    f8c407f8    ....    STR      r0,[r4,#0x7f8]
        0x0080617e:    6820         h      LDR      r0,[r4,#0]
        0x00806180:    f0400070    @.p.    ORR      r0,r0,#0x70
        0x00806184:    6020         `      STR      r0,[r4,#0]
        0x00806186:    2000        .       MOVS     r0,#0
        0x00806188:    64e0        .d      STR      r0,[r4,#0x4c]
        0x0080618a:    6820         h      LDR      r0,[r4,#0]
        0x0080618c:    f0400008    @...    ORR      r0,r0,#8
        0x00806190:    6020         `      STR      r0,[r4,#0]
        0x00806192:    f5a46482    ...d    SUB      r4,r4,#0x410
        0x00806196:    68a8        .h      LDR      r0,[r5,#8]
        0x00806198:    286b        k(      CMP      r0,#0x6b
        0x0080619a:    d064        d.      BEQ      0x806266 ; ll_xqspi_init_patch + 366
        0x0080619c:    dc57        W.      BGT      0x80624e ; ll_xqspi_init_patch + 342
        0x0080619e:    2803        .(      CMP      r0,#3
        0x008061a0:    d05a        Z.      BEQ      0x806258 ; ll_xqspi_init_patch + 352
        0x008061a2:    280b        .(      CMP      r0,#0xb
        0x008061a4:    d05f        _.      BEQ      0x806266 ; ll_xqspi_init_patch + 366
        0x008061a6:    283b        ;(      CMP      r0,#0x3b
        0x008061a8:    d16e        n.      BNE      0x806288 ; ll_xqspi_init_patch + 400
        0x008061aa:    e05c        \.      B        0x806266 ; ll_xqspi_init_patch + 366
        0x008061ac:    f8d40c10    ....    LDR      r0,[r4,#0xc10]
        0x008061b0:    f0000001    ....    AND      r0,r0,#1
        0x008061b4:    b170        p.      CBZ      r0,0x8061d4 ; ll_xqspi_init_patch + 220
        0x008061b6:    4620         F      MOV      r0,r4
        0x008061b8:    f000f8e4    ....    BL       ll_xqspi_disable_cache ; 0x806384
        0x008061bc:    f8d40c0c    ....    LDR      r0,[r4,#0xc0c]
        0x008061c0:    f0200001     ...    BIC      r0,r0,#1
        0x008061c4:    f8c40c0c    ....    STR      r0,[r4,#0xc0c]
        0x008061c8:    f8d40c10    ....    LDR      r0,[r4,#0xc10]
        0x008061cc:    f0000001    ....    AND      r0,r0,#1
        0x008061d0:    2800        .(      CMP      r0,#0
        0x008061d2:    d1f9        ..      BNE      0x8061c8 ; ll_xqspi_init_patch + 208
        0x008061d4:    f204440c    ...D    ADD      r4,r4,#0x40c
        0x008061d8:    6820         h      LDR      r0,[r4,#0]
        0x008061da:    f4204040     .@@    BIC      r0,r0,#0xc000
        0x008061de:    f4404080    @..@    ORR      r0,r0,#0x4000
        0x008061e2:    6020         `      STR      r0,[r4,#0]
        0x008061e4:    6820         h      LDR      r0,[r4,#0]
        0x008061e6:    f4205040     .@P    BIC      r0,r0,#0x3000
        0x008061ea:    6020         `      STR      r0,[r4,#0]
        0x008061ec:    6968        hi      LDR      r0,[r5,#0x14]
        0x008061ee:    6821        !h      LDR      r1,[r4,#0]
        0x008061f0:    f0210110    !...    BIC      r1,r1,#0x10
        0x008061f4:    ea411000    A...    ORR      r0,r1,r0,LSL #4
        0x008061f8:    6020         `      STR      r0,[r4,#0]
        0x008061fa:    69a8        .i      LDR      r0,[r5,#0x18]
        0x008061fc:    6821        !h      LDR      r1,[r4,#0]
        0x008061fe:    f0210108    !...    BIC      r1,r1,#8
        0x00806202:    ea4100c0    A...    ORR      r0,r1,r0,LSL #3
        0x00806206:    6020         `      STR      r0,[r4,#0]
        0x00806208:    6928        (i      LDR      r0,[r5,#0x10]
        0x0080620a:    6821        !h      LDR      r1,[r4,#0]
        0x0080620c:    f0210104    !...    BIC      r1,r1,#4
        0x00806210:    4301        .C      ORRS     r1,r1,r0
        0x00806212:    6021        !`      STR      r1,[r4,#0]
        0x00806214:    6820         h      LDR      r0,[r4,#0]
        0x00806216:    f0400001    @...    ORR      r0,r0,#1
        0x0080621a:    6020         `      STR      r0,[r4,#0]
        0x0080621c:    6860        `h      LDR      r0,[r4,#4]
        0x0080621e:    f0400080    @...    ORR      r0,r0,#0x80
        0x00806222:    6060        ``      STR      r0,[r4,#4]
        0x00806224:    68e8        .h      LDR      r0,[r5,#0xc]
        0x00806226:    6861        ah      LDR      r1,[r4,#4]
        0x00806228:    f0210170    !.p.    BIC      r1,r1,#0x70
        0x0080622c:    4301        .C      ORRS     r1,r1,r0
        0x0080622e:    6061        a`      STR      r1,[r4,#4]
        0x00806230:    2001        .       MOVS     r0,#1
        0x00806232:    6520         e      STR      r0,[r4,#0x50]
        0x00806234:    6860        `h      LDR      r0,[r4,#4]
        0x00806236:    f0400008    @...    ORR      r0,r0,#8
        0x0080623a:    6060        ``      STR      r0,[r4,#4]
        0x0080623c:    6860        `h      LDR      r0,[r4,#4]
        0x0080623e:    f0400003    @...    ORR      r0,r0,#3
        0x00806242:    6060        ``      STR      r0,[r4,#4]
        0x00806244:    6960        `i      LDR      r0,[r4,#0x14]
        0x00806246:    f02000ff     ...    BIC      r0,r0,#0xff
        0x0080624a:    6160        `a      STR      r0,[r4,#0x14]
        0x0080624c:    e094        ..      B        0x806378 ; ll_xqspi_init_patch + 640
        0x0080624e:    28bb        .(      CMP      r0,#0xbb
        0x00806250:    d002        ..      BEQ      0x806258 ; ll_xqspi_init_patch + 352
        0x00806252:    28eb        .(      CMP      r0,#0xeb
        0x00806254:    d118        ..      BNE      0x806288 ; ll_xqspi_init_patch + 400
        0x00806256:    e00f        ..      B        0x806278 ; ll_xqspi_init_patch + 384
        0x00806258:    f8d40c08    ....    LDR      r0,[r4,#0xc08]
        0x0080625c:    f4206070     .p`    BIC      r0,r0,#0xf00
        0x00806260:    f8c40c08    ....    STR      r0,[r4,#0xc08]
        0x00806264:    e010        ..      B        0x806288 ; ll_xqspi_init_patch + 400
        0x00806266:    f8d40c08    ....    LDR      r0,[r4,#0xc08]
        0x0080626a:    f4206070     .p`    BIC      r0,r0,#0xf00
        0x0080626e:    f4407080    @..p    ORR      r0,r0,#0x100
        0x00806272:    f8c40c08    ....    STR      r0,[r4,#0xc08]
        0x00806276:    e007        ..      B        0x806288 ; ll_xqspi_init_patch + 400
        0x00806278:    f8d40c08    ....    LDR      r0,[r4,#0xc08]
        0x0080627c:    f4206070     .p`    BIC      r0,r0,#0xf00
        0x00806280:    f4407000    @..p    ORR      r0,r0,#0x200
        0x00806284:    f8c40c08    ....    STR      r0,[r4,#0xc08]
        0x00806288:    4620         F      MOV      r0,r4
        0x0080628a:    f000f87b    ..{.    BL       ll_xqspi_disable_cache ; 0x806384
        0x0080628e:    6868        hh      LDR      r0,[r5,#4]
        0x00806290:    2801        .(      CMP      r0,#1
        0x00806292:    d165        e.      BNE      0x806360 ; ll_xqspi_init_patch + 616
        0x00806294:    6830        0h      LDR      r0,[r6,#0]
        0x00806296:    f3c05240    ..@R    UBFX     r2,r0,#21,#1
        0x0080629a:    6830        0h      LDR      r0,[r6,#0]
        0x0080629c:    f4201000     ...    BIC      r0,r0,#0x200000
        0x008062a0:    6030        0`      STR      r0,[r6,#0]
        0x008062a2:    6820         h      LDR      r0,[r4,#0]
        0x008062a4:    f40063f0    ...c    AND      r3,r0,#0x780
        0x008062a8:    6820         h      LDR      r0,[r4,#0]
        0x008062aa:    f42060f0     ..`    BIC      r0,r0,#0x780
        0x008062ae:    6020         `      STR      r0,[r4,#0]
        0x008062b0:    6820         h      LDR      r0,[r4,#0]
        0x008062b2:    f0400008    @...    ORR      r0,r0,#8
        0x008062b6:    6020         `      STR      r0,[r4,#0]
        0x008062b8:    6820         h      LDR      r0,[r4,#0]
        0x008062ba:    f0400010    @...    ORR      r0,r0,#0x10
        0x008062be:    6020         `      STR      r0,[r4,#0]
        0x008062c0:    6860        `h      LDR      r0,[r4,#4]
        0x008062c2:    f020000f     ...    BIC      r0,r0,#0xf
        0x008062c6:    6060        ``      STR      r0,[r4,#4]
        0x008062c8:    6860        `h      LDR      r0,[r4,#4]
        0x008062ca:    f0400010    @...    ORR      r0,r0,#0x10
        0x008062ce:    6060        ``      STR      r0,[r4,#4]
        0x008062d0:    4834        4H      LDR      r0,[pc,#208] ; [0x8063a4] = 0x300067b4
        0x008062d2:    7801        .x      LDRB     r1,[r0,#0]
        0x008062d4:    b919        ..      CBNZ     r1,0x8062de ; ll_xqspi_init_patch + 486
        0x008062d6:    6820         h      LDR      r0,[r4,#0]
        0x008062d8:    f0400002    @...    ORR      r0,r0,#2
        0x008062dc:    6020         `      STR      r0,[r4,#0]
        0x008062de:    bf00        ..      NOP      
        0x008062e0:    bf00        ..      NOP      
        0x008062e2:    bf00        ..      NOP      
        0x008062e4:    bf00        ..      NOP      
        0x008062e6:    bf00        ..      NOP      
        0x008062e8:    bf00        ..      NOP      
        0x008062ea:    bf00        ..      NOP      
        0x008062ec:    bf00        ..      NOP      
        0x008062ee:    bf00        ..      NOP      
        0x008062f0:    bf00        ..      NOP      
        0x008062f2:    bf00        ..      NOP      
        0x008062f4:    bf00        ..      NOP      
        0x008062f6:    bf00        ..      NOP      
        0x008062f8:    bf00        ..      NOP      
        0x008062fa:    bf00        ..      NOP      
        0x008062fc:    bf00        ..      NOP      
        0x008062fe:    bf00        ..      NOP      
        0x00806300:    bf00        ..      NOP      
        0x00806302:    bf00        ..      NOP      
        0x00806304:    bf00        ..      NOP      
        0x00806306:    bf00        ..      NOP      
        0x00806308:    bf00        ..      NOP      
        0x0080630a:    bf00        ..      NOP      
        0x0080630c:    bf00        ..      NOP      
        0x0080630e:    bf00        ..      NOP      
        0x00806310:    bf00        ..      NOP      
        0x00806312:    bf00        ..      NOP      
        0x00806314:    bf00        ..      NOP      
        0x00806316:    6920         i      LDR      r0,[r4,#0x10]
        0x00806318:    f0000001    ....    AND      r0,r0,#1
        0x0080631c:    2800        .(      CMP      r0,#0
        0x0080631e:    d1fa        ..      BNE      0x806316 ; ll_xqspi_init_patch + 542
        0x00806320:    6820         h      LDR      r0,[r4,#0]
        0x00806322:    f0200008     ...    BIC      r0,r0,#8
        0x00806326:    6020         `      STR      r0,[r4,#0]
        0x00806328:    b919        ..      CBNZ     r1,0x806332 ; ll_xqspi_init_patch + 570
        0x0080632a:    6820         h      LDR      r0,[r4,#0]
        0x0080632c:    f0200002     ...    BIC      r0,r0,#2
        0x00806330:    6020         `      STR      r0,[r4,#0]
        0x00806332:    6820         h      LDR      r0,[r4,#0]
        0x00806334:    f0200001     ...    BIC      r0,r0,#1
        0x00806338:    6020         `      STR      r0,[r4,#0]
        0x0080633a:    bf00        ..      NOP      
        0x0080633c:    bf00        ..      NOP      
        0x0080633e:    bf00        ..      NOP      
        0x00806340:    bf00        ..      NOP      
        0x00806342:    bf00        ..      NOP      
        0x00806344:    bf00        ..      NOP      
        0x00806346:    bf00        ..      NOP      
        0x00806348:    bf00        ..      NOP      
        0x0080634a:    bf00        ..      NOP      
        0x0080634c:    6820         h      LDR      r0,[r4,#0]
        0x0080634e:    f42060f0     ..`    BIC      r0,r0,#0x780
        0x00806352:    4318        .C      ORRS     r0,r0,r3
        0x00806354:    6020         `      STR      r0,[r4,#0]
        0x00806356:    b11a        ..      CBZ      r2,0x806360 ; ll_xqspi_init_patch + 616
        0x00806358:    6830        0h      LDR      r0,[r6,#0]
        0x0080635a:    f4401000    @...    ORR      r0,r0,#0x200000
        0x0080635e:    6030        0`      STR      r0,[r6,#0]
        0x00806360:    f8d40c0c    ....    LDR      r0,[r4,#0xc0c]
        0x00806364:    f0400001    @...    ORR      r0,r0,#1
        0x00806368:    f8c40c0c    ....    STR      r0,[r4,#0xc0c]
        0x0080636c:    f8d40c10    ....    LDR      r0,[r4,#0xc10]
        0x00806370:    f0000001    ....    AND      r0,r0,#1
        0x00806374:    2800        .(      CMP      r0,#0
        0x00806376:    d0f9        ..      BEQ      0x80636c ; ll_xqspi_init_patch + 628
        0x00806378:    6830        0h      LDR      r0,[r6,#0]
        0x0080637a:    f0400020    @. .    ORR      r0,r0,#0x20
        0x0080637e:    6030        0`      STR      r0,[r6,#0]
        0x00806380:    2001        .       MOVS     r0,#1
        0x00806382:    bd70        p.      POP      {r4-r6,pc}
    ll_xqspi_disable_cache
        0x00806384:    6801        .h      LDR      r1,[r0,#0]
        0x00806386:    f0410101    A...    ORR      r1,r1,#1
        0x0080638a:    6001        .`      STR      r1,[r0,#0]
        0x0080638c:    bf00        ..      NOP      
        0x0080638e:    bf00        ..      NOP      
        0x00806390:    bf00        ..      NOP      
        0x00806392:    bf00        ..      NOP      
        0x00806394:    bf00        ..      NOP      
        0x00806396:    bf00        ..      NOP      
        0x00806398:    bf00        ..      NOP      
        0x0080639a:    bf00        ..      NOP      
        0x0080639c:    bf00        ..      NOP      
        0x0080639e:    4770        pG      BX       lr
    $d
        0x008063a0:    a000c504    ....    DCD    2684404996
        0x008063a4:    300067b4    .g.0    DCD    805332916
    $t
    $Ven$TT$S$$assert_err
        0x008063a8:    f400b5aa    ....    B        assert_err ; 0x6f00

** Section #3 'RAM_RW' (SHT_PROGBITS) [SHF_ALLOC + SHF_WRITE]
    Size   : 432 bytes (alignment 256)
    Address: 0x300063ac


** Section #4 'RAM_ZI' (SHT_NOBITS) [SHF_ALLOC + SHF_WRITE]
    Size   : 2896 bytes (alignment 4)
    Address: 0x30006a60


** Section #5 'FPB_TABLE' (SHT_PROGBITS) [SHF_ALLOC + SHF_WRITE]
    Size   : 64 bytes (alignment 4)
    Address: 0x30007600


** Section #6 'RAM_TINY_RW' (SHT_PROGBITS) [SHF_ALLOC + SHF_EXECINSTR]
    Size   : 1484 bytes (alignment 4)
    Address: 0x300035cc

    $t
    TINY_RAM_SPACE
    pwr_mgmt_ble_wakeup
        0x300035cc:    b510        ..      PUSH     {r4,lr}
        0x300035ce:    f3ef8110    ....    MRS      r1,PRIMASK
        0x300035d2:    2001        .       MOVS     r0,#1
        0x300035d4:    f3808810    ....    MSR      PRIMASK,r0
        0x300035d8:    48f6        .H      LDR      r0,[pc,#984] ; [0x300039b4] = 0xa000c540
        0x300035da:    6802        .h      LDR      r2,[r0,#0]
        0x300035dc:    f3c232c0    ...2    UBFX     r2,r2,#15,#1
        0x300035e0:    2a00        .*      CMP      r2,#0
        0x300035e2:    d017        ..      BEQ      0x30003614 ; pwr_mgmt_ble_wakeup + 72
        0x300035e4:    4af3        .J      LDR      r2,[pc,#972] ; [0x300039b4] = 0xa000c540
        0x300035e6:    3234        42      ADDS     r2,r2,#0x34
        0x300035e8:    6812        .h      LDR      r2,[r2,#0]
        0x300035ea:    f3c2228a    ..."    UBFX     r2,r2,#10,#11
        0x300035ee:    4bf1        .K      LDR      r3,[pc,#964] ; [0x300039b4] = 0xa000c540
        0x300035f0:    3330        03      ADDS     r3,r3,#0x30
        0x300035f2:    681b        .h      LDR      r3,[r3,#0]
        0x300035f4:    4cf0        .L      LDR      r4,[pc,#960] ; [0x300039b8] = 0xa000e200
        0x300035f6:    6824        $h      LDR      r4,[r4,#0]
        0x300035f8:    4422        "D      ADD      r2,r2,r4
        0x300035fa:    1c52        R.      ADDS     r2,r2,#1
        0x300035fc:    429a        .B      CMP      r2,r3
        0x300035fe:    d209        ..      BCS      0x30003614 ; pwr_mgmt_ble_wakeup + 72
        0x30003600:    4aec        .J      LDR      r2,[pc,#944] ; [0x300039b4] = 0xa000c540
        0x30003602:    3a3c        <:      SUBS     r2,r2,#0x3c
        0x30003604:    6813        .h      LDR      r3,[r2,#0]
        0x30003606:    f3c35380    ...S    UBFX     r3,r3,#22,#1
        0x3000360a:    b91b        ..      CBNZ     r3,0x30003614 ; pwr_mgmt_ble_wakeup + 72
        0x3000360c:    6813        .h      LDR      r3,[r2,#0]
        0x3000360e:    f4430380    C...    ORR      r3,r3,#0x400000
        0x30003612:    6013        .`      STR      r3,[r2,#0]
        0x30003614:    f3818810    ....    MSR      PRIMASK,r1
        0x30003618:    6801        .h      LDR      r1,[r0,#0]
        0x3000361a:    f3c131c0    ...1    UBFX     r1,r1,#15,#1
        0x3000361e:    2900        .)      CMP      r1,#0
        0x30003620:    d1fa        ..      BNE      0x30003618 ; pwr_mgmt_ble_wakeup + 76
        0x30003622:    2019        .       MOVS     r0,#0x19
        0x30003624:    f000fa2c    ..,.    BL       $Ven$TT$L$$__NVIC_GetPendingIRQ ; 0x30003a80
        0x30003628:    b108        ..      CBZ      r0,0x3000362e ; pwr_mgmt_ble_wakeup + 98
        0x3000362a:    f000fa2e    ....    BL       $Ven$TT$L$$BLESLP_IRQHandler ; 0x30003a8a
        0x3000362e:    2001        .       MOVS     r0,#1
        0x30003630:    bd10        ..      POP      {r4,pc}
    pwr_mgmt_switch_dig_core_mode
        0x30003632:    49e0        .I      LDR      r1,[pc,#896] ; [0x300039b4] = 0xa000c540
        0x30003634:    4ae1        .J      LDR      r2,[pc,#900] ; [0x300039bc] = 0x3d0900
        0x30003636:    3114        .1      ADDS     r1,r1,#0x14
        0x30003638:    4290        .B      CMP      r0,r2
        0x3000363a:    d904        ..      BLS      0x30003646 ; pwr_mgmt_switch_dig_core_mode + 20
        0x3000363c:    6808        .h      LDR      r0,[r1,#0]
        0x3000363e:    f4201080     ...    BIC      r0,r0,#0x100000
        0x30003642:    6008        .`      STR      r0,[r1,#0]
        0x30003644:    4770        pG      BX       lr
        0x30003646:    6808        .h      LDR      r0,[r1,#0]
        0x30003648:    f4401080    @...    ORR      r0,r0,#0x100000
        0x3000364c:    6008        .`      STR      r0,[r1,#0]
        0x3000364e:    4770        pG      BX       lr
    pwr_mgmt_check_ext_timer
        0x30003650:    e92d47ff    -..G    PUSH     {r0-r10,lr}
        0x30003654:    f04f0902    O...    MOV      r9,#2
        0x30003658:    2000        .       MOVS     r0,#0
        0x3000365a:    9003        ..      STR      r0,[sp,#0xc]
        0x3000365c:    48d8        .H      LDR      r0,[pc,#864] ; [0x300039c0] = 0x8026b0
        0x3000365e:    6806        .h      LDR      r6,[r0,#0]
        0x30003660:    6847        Gh      LDR      r7,[r0,#4]
        0x30003662:    f8d0a008    ....    LDR      r10,[r0,#8]
        0x30003666:    f04f34ff    O..4    MOV      r4,#0xffffffff
        0x3000366a:    9402        ..      STR      r4,[sp,#8]
        0x3000366c:    9401        ..      STR      r4,[sp,#4]
        0x3000366e:    9400        ..      STR      r4,[sp,#0]
        0x30003670:    f8df8350    ..P.    LDR      r8,[pc,#848] ; [0x300039c4] = 0x8026bc
        0x30003674:    4dd4        .M      LDR      r5,[pc,#848] ; [0x300039c8] = 0x802684
        0x30003676:    f8d80004    ....    LDR      r0,[r8,#4]
        0x3000367a:    0100        ..      LSLS     r0,r0,#4
        0x3000367c:    d526        &.      BPL      0x300036cc ; pwr_mgmt_check_ext_timer + 124
        0x3000367e:    a901        ..      ADD      r1,sp,#4
        0x30003680:    2000        .       MOVS     r0,#0
        0x30003682:    f000fa07    ....    BL       $Ven$TT$L$$hal_pwr_get_timer_current_value ; 0x30003a94
        0x30003686:    4669        iF      MOV      r1,sp
        0x30003688:    07a0        ..      LSLS     r0,r4,#30
        0x3000368a:    f000fa03    ....    BL       $Ven$TT$L$$hal_pwr_get_timer_current_value ; 0x30003a94
        0x3000368e:    e9dd1000    ....    LDRD     r1,r0,[sp,#0]
        0x30003692:    4288        .B      CMP      r0,r1
        0x30003694:    d802        ..      BHI      0x3000369c ; pwr_mgmt_check_ext_timer + 76
        0x30003696:    1a08        ..      SUBS     r0,r1,r0
        0x30003698:    9001        ..      STR      r0,[sp,#4]
        0x3000369a:    e001        ..      B        0x300036a0 ; pwr_mgmt_check_ext_timer + 80
        0x3000369c:    43c0        .C      MVNS     r0,r0
        0x3000369e:    9001        ..      STR      r0,[sp,#4]
        0x300036a0:    a903        ..      ADD      r1,sp,#0xc
        0x300036a2:    9801        ..      LDR      r0,[sp,#4]
        0x300036a4:    f000f9fb    ....    BL       $Ven$TT$L$$sys_lpcycles_2_hus ; 0x30003a9e
        0x300036a8:    9001        ..      STR      r0,[sp,#4]
        0x300036aa:    42a0        .B      CMP      r0,r4
        0x300036ac:    d200        ..      BCS      0x300036b0 ; pwr_mgmt_check_ext_timer + 96
        0x300036ae:    4604        .F      MOV      r4,r0
        0x300036b0:    4550        PE      CMP      r0,r10
        0x300036b2:    d207        ..      BCS      0x300036c4 ; pwr_mgmt_check_ext_timer + 116
        0x300036b4:    6829        )h      LDR      r1,[r5,#0]
        0x300036b6:    b109        ..      CBZ      r1,0x300036bc ; pwr_mgmt_check_ext_timer + 108
        0x300036b8:    2004        .       MOVS     r0,#4
        0x300036ba:    4788        .G      BLX      r1
        0x300036bc:    2001        .       MOVS     r0,#1
        0x300036be:    b004        ..      ADD      sp,sp,#0x10
        0x300036c0:    e8bd87f0    ....    POP      {r4-r10,pc}
        0x300036c4:    6829        )h      LDR      r1,[r5,#0]
        0x300036c6:    b109        ..      CBZ      r1,0x300036cc ; pwr_mgmt_check_ext_timer + 124
        0x300036c8:    2005        .       MOVS     r0,#5
        0x300036ca:    4788        .G      BLX      r1
        0x300036cc:    f8d80004    ....    LDR      r0,[r8,#4]
        0x300036d0:    01c0        ..      LSLS     r0,r0,#7
        0x300036d2:    d51b        ..      BPL      0x3000370c ; pwr_mgmt_check_ext_timer + 188
        0x300036d4:    48bd        .H      LDR      r0,[pc,#756] ; [0x300039cc] = 0x802674
        0x300036d6:    7800        .x      LDRB     r0,[r0,#0]
        0x300036d8:    b9c0        ..      CBNZ     r0,0x3000370c ; pwr_mgmt_check_ext_timer + 188
        0x300036da:    a902        ..      ADD      r1,sp,#8
        0x300036dc:    f04f4000    O..@    MOV      r0,#0x80000000
        0x300036e0:    f000f9d8    ....    BL       $Ven$TT$L$$hal_pwr_get_timer_current_value ; 0x30003a94
        0x300036e4:    a903        ..      ADD      r1,sp,#0xc
        0x300036e6:    9802        ..      LDR      r0,[sp,#8]
        0x300036e8:    f000f9d9    ....    BL       $Ven$TT$L$$sys_lpcycles_2_hus ; 0x30003a9e
        0x300036ec:    9002        ..      STR      r0,[sp,#8]
        0x300036ee:    42a0        .B      CMP      r0,r4
        0x300036f0:    d200        ..      BCS      0x300036f4 ; pwr_mgmt_check_ext_timer + 164
        0x300036f2:    4604        .F      MOV      r4,r0
        0x300036f4:    42b0        .B      CMP      r0,r6
        0x300036f6:    d205        ..      BCS      0x30003704 ; pwr_mgmt_check_ext_timer + 180
        0x300036f8:    6829        )h      LDR      r1,[r5,#0]
        0x300036fa:    b109        ..      CBZ      r1,0x30003700 ; pwr_mgmt_check_ext_timer + 176
        0x300036fc:    2004        .       MOVS     r0,#4
        0x300036fe:    4788        .G      BLX      r1
        0x30003700:    2001        .       MOVS     r0,#1
        0x30003702:    e7dc        ..      B        0x300036be ; pwr_mgmt_check_ext_timer + 110
        0x30003704:    6829        )h      LDR      r1,[r5,#0]
        0x30003706:    b109        ..      CBZ      r1,0x3000370c ; pwr_mgmt_check_ext_timer + 188
        0x30003708:    2005        .       MOVS     r0,#5
        0x3000370a:    4788        .G      BLX      r1
        0x3000370c:    f8d80004    ....    LDR      r0,[r8,#4]
        0x30003710:    0140        @.      LSLS     r0,r0,#5
        0x30003712:    d50e        ..      BPL      0x30003732 ; pwr_mgmt_check_ext_timer + 226
        0x30003714:    f000f9c8    ....    BL       $Ven$TT$L$$get_remain_sleep_dur ; 0x30003aa8
        0x30003718:    0041        A.      LSLS     r1,r0,#1
        0x3000371a:    42a1        .B      CMP      r1,r4
        0x3000371c:    d300        ..      BCC      0x30003720 ; pwr_mgmt_check_ext_timer + 208
        0x3000371e:    4621        !F      MOV      r1,r4
        0x30003720:    460c        .F      MOV      r4,r1
        0x30003722:    42b8        .B      CMP      r0,r7
        0x30003724:    d205        ..      BCS      0x30003732 ; pwr_mgmt_check_ext_timer + 226
        0x30003726:    6829        )h      LDR      r1,[r5,#0]
        0x30003728:    b109        ..      CBZ      r1,0x3000372e ; pwr_mgmt_check_ext_timer + 222
        0x3000372a:    2006        .       MOVS     r0,#6
        0x3000372c:    4788        .G      BLX      r1
        0x3000372e:    2001        .       MOVS     r0,#1
        0x30003730:    e7c5        ..      B        0x300036be ; pwr_mgmt_check_ext_timer + 110
        0x30003732:    201a        .       MOVS     r0,#0x1a
        0x30003734:    f000f9a4    ....    BL       $Ven$TT$L$$__NVIC_GetPendingIRQ ; 0x30003a80
        0x30003738:    b938        8.      CBNZ     r0,0x3000374a ; pwr_mgmt_check_ext_timer + 250
        0x3000373a:    2021        !       MOVS     r0,#0x21
        0x3000373c:    f000f9a0    ....    BL       $Ven$TT$L$$__NVIC_GetPendingIRQ ; 0x30003a80
        0x30003740:    b918        ..      CBNZ     r0,0x3000374a ; pwr_mgmt_check_ext_timer + 250
        0x30003742:    2019        .       MOVS     r0,#0x19
        0x30003744:    f000f99c    ....    BL       $Ven$TT$L$$__NVIC_GetPendingIRQ ; 0x30003a80
        0x30003748:    b108        ..      CBZ      r0,0x3000374e ; pwr_mgmt_check_ext_timer + 254
        0x3000374a:    2001        .       MOVS     r0,#1
        0x3000374c:    e7b7        ..      B        0x300036be ; pwr_mgmt_check_ext_timer + 110
        0x3000374e:    4620         F      MOV      r0,r4
        0x30003750:    f7ffff6f    ..o.    BL       pwr_mgmt_switch_dig_core_mode ; 0x30003632
        0x30003754:    4648        HF      MOV      r0,r9
        0x30003756:    e7b2        ..      B        0x300036be ; pwr_mgmt_check_ext_timer + 110
    pwr_mgmt_shutdown_patch
        0x30003758:    b570        p.      PUSH     {r4-r6,lr}
        0x3000375a:    489d        .H      LDR      r0,[pc,#628] ; [0x300039d0] = 0x802480
        0x3000375c:    6800        .h      LDR      r0,[r0,#0]
        0x3000375e:    4780        .G      BLX      r0
        0x30003760:    2802        .(      CMP      r0,#2
        0x30003762:    d11c        ..      BNE      0x3000379e ; pwr_mgmt_shutdown_patch + 70
        0x30003764:    2001        .       MOVS     r0,#1
        0x30003766:    f000f9a4    ....    BL       $Ven$TT$L$$pwr_mgmt_set_wakeup_flag ; 0x30003ab2
        0x3000376a:    f000f9a7    ....    BL       $Ven$TT$L$$ble_core_power_off ; 0x30003abc
        0x3000376e:    4899        .H      LDR      r0,[pc,#612] ; [0x300039d4] = 0x3000683c
        0x30003770:    6800        .h      LDR      r0,[r0,#0]
        0x30003772:    4780        .G      BLX      r0
        0x30003774:    4898        .H      LDR      r0,[pc,#608] ; [0x300039d8] = 0x3000698c
        0x30003776:    6840        @h      LDR      r0,[r0,#4]
        0x30003778:    b100        ..      CBZ      r0,0x3000377c ; pwr_mgmt_shutdown_patch + 36
        0x3000377a:    4780        .G      BLX      r0
        0x3000377c:    f7ffff68    ..h.    BL       pwr_mgmt_check_ext_timer ; 0x30003650
        0x30003780:    4e96        .N      LDR      r6,[pc,#600] ; [0x300039dc] = 0x30006840
        0x30003782:    2802        .(      CMP      r0,#2
        0x30003784:    d00c        ..      BEQ      0x300037a0 ; pwr_mgmt_shutdown_patch + 72
        0x30003786:    6830        0h      LDR      r0,[r6,#0]
        0x30003788:    4780        .G      BLX      r0
        0x3000378a:    f000f99c    ....    BL       $Ven$TT$L$$work_digldo_dcdc_set ; 0x30003ac6
        0x3000378e:    f000f99f    ....    BL       $Ven$TT$L$$work_xo_bias_set ; 0x30003ad0
        0x30003792:    f000f9a2    ....    BL       $Ven$TT$L$$ble_core_power_on ; 0x30003ada
        0x30003796:    2000        .       MOVS     r0,#0
        0x30003798:    f000f98b    ....    BL       $Ven$TT$L$$pwr_mgmt_set_wakeup_flag ; 0x30003ab2
        0x3000379c:    2001        .       MOVS     r0,#1
        0x3000379e:    bd70        p.      POP      {r4-r6,pc}
        0x300037a0:    f44f248a    O..$    MOV      r4,#0x45000
        0x300037a4:    6860        `h      LDR      r0,[r4,#4]
        0x300037a6:    f64165a8    A..e    MOV      r5,#0x1ea8
        0x300037aa:    42a8        .B      CMP      r0,r5
        0x300037ac:    d002        ..      BEQ      0x300037b4 ; pwr_mgmt_shutdown_patch + 92
        0x300037ae:    488c        .H      LDR      r0,[pc,#560] ; [0x300039e0] = 0x801f64
        0x300037b0:    f000f998    ....    BL       $Ven$TT$L$$hal_exflash_deepsleep_patch ; 0x30003ae4
        0x300037b4:    f000f99b    ....    BL       $Ven$TT$L$$hal_pwr_enter_chip_deepsleep ; 0x30003aee
        0x300037b8:    6860        `h      LDR      r0,[r4,#4]
        0x300037ba:    42a8        .B      CMP      r0,r5
        0x300037bc:    d002        ..      BEQ      0x300037c4 ; pwr_mgmt_shutdown_patch + 108
        0x300037be:    4888        .H      LDR      r0,[pc,#544] ; [0x300039e0] = 0x801f64
        0x300037c0:    f000f99a    ....    BL       $Ven$TT$L$$hal_exflash_wakeup_patch ; 0x30003af8
        0x300037c4:    6830        0h      LDR      r0,[r6,#0]
        0x300037c6:    4780        .G      BLX      r0
        0x300037c8:    f000f97d    ..}.    BL       $Ven$TT$L$$work_digldo_dcdc_set ; 0x30003ac6
        0x300037cc:    f000f980    ....    BL       $Ven$TT$L$$work_xo_bias_set ; 0x30003ad0
        0x300037d0:    f000f983    ....    BL       $Ven$TT$L$$ble_core_power_on ; 0x30003ada
        0x300037d4:    2000        .       MOVS     r0,#0
        0x300037d6:    f000f96c    ..l.    BL       $Ven$TT$L$$pwr_mgmt_set_wakeup_flag ; 0x30003ab2
        0x300037da:    201b        .       MOVS     r0,#0x1b
        0x300037dc:    f000f950    ..P.    BL       $Ven$TT$L$$__NVIC_GetPendingIRQ ; 0x30003a80
        0x300037e0:    b330        0.      CBZ      r0,0x30003830 ; pwr_mgmt_shutdown_patch + 216
        0x300037e2:    4874        tH      LDR      r0,[pc,#464] ; [0x300039b4] = 0xa000c540
        0x300037e4:    383c        <8      SUBS     r0,r0,#0x3c
        0x300037e6:    6800        .h      LDR      r0,[r0,#0]
        0x300037e8:    f3c01000    ....    UBFX     r0,r0,#4,#1
        0x300037ec:    b110        ..      CBZ      r0,0x300037f4 ; pwr_mgmt_shutdown_patch + 156
        0x300037ee:    2020                MOVS     r0,#0x20
        0x300037f0:    f000f987    ....    BL       $Ven$TT$L$$ll_pwr_clear_ext_wakeup_status ; 0x30003b02
        0x300037f4:    4c6f        oL      LDR      r4,[pc,#444] ; [0x300039b4] = 0xa000c540
        0x300037f6:    1d24        $.      ADDS     r4,r4,#4
        0x300037f8:    6820         h      LDR      r0,[r4,#0]
        0x300037fa:    f240115f    @._.    MOV      r1,#0x15f
        0x300037fe:    4008        .@      ANDS     r0,r0,r1
        0x30003800:    0740        @.      LSLS     r0,r0,#29
        0x30003802:    d50d        ..      BPL      0x30003820 ; pwr_mgmt_shutdown_patch + 200
        0x30003804:    6820         h      LDR      r0,[r4,#0]
        0x30003806:    496b        kI      LDR      r1,[pc,#428] ; [0x300039b4] = 0xa000c540
        0x30003808:    3118        .1      ADDS     r1,r1,#0x18
        0x3000380a:    6809        .h      LDR      r1,[r1,#0]
        0x3000380c:    ea014010    ...@    AND      r0,r1,r0,LSR #16
        0x30003810:    4974        tI      LDR      r1,[pc,#464] ; [0x300039e4] = 0x300067a4
        0x30003812:    7008        .p      STRB     r0,[r1,#0]
        0x30003814:    20ff        .       MOVS     r0,#0xff
        0x30003816:    f000f974    ..t.    BL       $Ven$TT$L$$ll_pwr_clear_ext_wakeup_status ; 0x30003b02
        0x3000381a:    f06f0004    o...    MVN      r0,#4
        0x3000381e:    6020         `      STR      r0,[r4,#0]
        0x30003820:    6820         h      LDR      r0,[r4,#0]
        0x30003822:    f3c01000    ....    UBFX     r0,r0,#4,#1
        0x30003826:    b118        ..      CBZ      r0,0x30003830 ; pwr_mgmt_shutdown_patch + 216
        0x30003828:    496f        oI      LDR      r1,[pc,#444] ; [0x300039e8] = 0xe000e100
        0x3000382a:    f04f6000    O..`    MOV      r0,#0x8000000
        0x3000382e:    6008        .`      STR      r0,[r1,#0]
        0x30003830:    2000        .       MOVS     r0,#0
        0x30003832:    bd70        p.      POP      {r4-r6,pc}
    pwr_mgmt_ultra_sleep
        0x30003834:    ed2d8b04    -...    VPUSH    {d8-d9}
        0x30003838:    4604        .F      MOV      r4,r0
        0x3000383a:    f000f967    ..g.    BL       $Ven$TT$L$$pwr_mgmt_locker ; 0x30003b0c
        0x3000383e:    4865        eH      LDR      r0,[pc,#404] ; [0x300039d4] = 0x3000683c
        0x30003840:    6800        .h      LDR      r0,[r0,#0]
        0x30003842:    4780        .G      BLX      r0
        0x30003844:    485b        [H      LDR      r0,[pc,#364] ; [0x300039b4] = 0xa000c540
        0x30003846:    3820         8      SUBS     r0,r0,#0x20
        0x30003848:    6801        .h      LDR      r1,[r0,#0]
        0x3000384a:    f0410180    A...    ORR      r1,r1,#0x80
        0x3000384e:    6001        .`      STR      r1,[r0,#0]
        0x30003850:    6801        .h      LDR      r1,[r0,#0]
        0x30003852:    f4214178    !.xA    BIC      r1,r1,#0xf800
        0x30003856:    6001        .`      STR      r1,[r0,#0]
        0x30003858:    4d56        VM      LDR      r5,[pc,#344] ; [0x300039b4] = 0xa000c540
        0x3000385a:    3d3c        <=      SUBS     r5,r5,#0x3c
        0x3000385c:    6828        (h      LDR      r0,[r5,#0]
        0x3000385e:    f0205074     .tP    BIC      r0,r0,#0x3d000000
        0x30003862:    6028        (`      STR      r0,[r5,#0]
        0x30003864:    2c00        .,      CMP      r4,#0
        0x30003866:    d04a        J.      BEQ      0x300038fe ; pwr_mgmt_ultra_sleep + 202
        0x30003868:    6828        (h      LDR      r0,[r5,#0]
        0x3000386a:    f0407080    @..p    ORR      r0,r0,#0x1000000
        0x3000386e:    6028        (`      STR      r0,[r5,#0]
        0x30003870:    f000f951    ..Q.    BL       $Ven$TT$L$$ll_pwr_is_active_flag_psc_cmd_busy ; 0x30003b16
        0x30003874:    2801        .(      CMP      r0,#1
        0x30003876:    d0fb        ..      BEQ      0x30003870 ; pwr_mgmt_ultra_sleep + 60
        0x30003878:    2013        .       MOVS     r0,#0x13
        0x3000387a:    f000f951    ..Q.    BL       $Ven$TT$L$$ll_pwr_req_excute_psc_command ; 0x30003b20
        0x3000387e:    f000f954    ..T.    BL       $Ven$TT$L$$hal_sleep_timer_get_clock_freq ; 0x30003b2a
        0x30003882:    f000f957    ..W.    BL       $Ven$TT$L$$__aeabi_ui2d ; 0x30003b34
        0x30003886:    460f        .F      MOV      r7,r1
        0x30003888:    4606        .F      MOV      r6,r0
        0x3000388a:    ed9f9b58    ..X.    VLDR     d9,[pc,#352] ; [0x300039ec] = 0
        0x3000388e:    ec532b19    S..+    VMOV     r2,r3,d9
        0x30003892:    f000f954    ..T.    BL       $Ven$TT$L$$__aeabi_ddiv ; 0x30003b3e
        0x30003896:    ec410b10    A...    VMOV     d0,r0,r1
        0x3000389a:    ec532b10    S..+    VMOV     r2,r3,d0
        0x3000389e:    ed9f0b55    ..U.    VLDR     d0,[pc,#340] ; [0x300039f4] = 0xffe00000
        0x300038a2:    ec510b10    Q...    VMOV     r0,r1,d0
        0x300038a6:    f000f94a    ..J.    BL       $Ven$TT$L$$__aeabi_ddiv ; 0x30003b3e
        0x300038aa:    f000f94d    ..M.    BL       $Ven$TT$L$$__aeabi_d2uiz ; 0x30003b48
        0x300038ae:    4284        .B      CMP      r4,r0
        0x300038b0:    d900        ..      BLS      0x300038b4 ; pwr_mgmt_ultra_sleep + 128
        0x300038b2:    4604        .F      MOV      r4,r0
        0x300038b4:    4620         F      MOV      r0,r4
        0x300038b6:    f000f93d    ..=.    BL       $Ven$TT$L$$__aeabi_ui2d ; 0x30003b34
        0x300038ba:    ec476b10    G..k    VMOV     d0,r6,r7
        0x300038be:    ec410b18    A...    VMOV     d8,r0,r1
        0x300038c2:    ec532b19    S..+    VMOV     r2,r3,d9
        0x300038c6:    ec510b10    Q...    VMOV     r0,r1,d0
        0x300038ca:    f000f938    ..8.    BL       $Ven$TT$L$$__aeabi_ddiv ; 0x30003b3e
        0x300038ce:    ec532b18    S..+    VMOV     r2,r3,d8
        0x300038d2:    f000f93e    ..>.    BL       $Ven$TT$L$$__aeabi_dmul ; 0x30003b52
        0x300038d6:    f000f937    ..7.    BL       $Ven$TT$L$$__aeabi_d2uiz ; 0x30003b48
        0x300038da:    4936        6I      LDR      r1,[pc,#216] ; [0x300039b4] = 0xa000c540
        0x300038dc:    3150        P1      ADDS     r1,r1,#0x50
        0x300038de:    6008        .`      STR      r0,[r1,#0]
        0x300038e0:    f000f919    ....    BL       $Ven$TT$L$$ll_pwr_is_active_flag_psc_cmd_busy ; 0x30003b16
        0x300038e4:    2801        .(      CMP      r0,#1
        0x300038e6:    d0fb        ..      BEQ      0x300038e0 ; pwr_mgmt_ultra_sleep + 172
        0x300038e8:    2002        .       MOVS     r0,#2
        0x300038ea:    f000f919    ....    BL       $Ven$TT$L$$ll_pwr_req_excute_psc_command ; 0x30003b20
        0x300038ee:    f000f912    ....    BL       $Ven$TT$L$$ll_pwr_is_active_flag_psc_cmd_busy ; 0x30003b16
        0x300038f2:    2801        .(      CMP      r0,#1
        0x300038f4:    d0fb        ..      BEQ      0x300038ee ; pwr_mgmt_ultra_sleep + 186
        0x300038f6:    2010        .       MOVS     r0,#0x10
        0x300038f8:    f000f912    ....    BL       $Ven$TT$L$$ll_pwr_req_excute_psc_command ; 0x30003b20
        0x300038fc:    e006        ..      B        0x3000390c ; pwr_mgmt_ultra_sleep + 216
        0x300038fe:    f000f90a    ....    BL       $Ven$TT$L$$ll_pwr_is_active_flag_psc_cmd_busy ; 0x30003b16
        0x30003902:    2801        .(      CMP      r0,#1
        0x30003904:    d0fb        ..      BEQ      0x300038fe ; pwr_mgmt_ultra_sleep + 202
        0x30003906:    2013        .       MOVS     r0,#0x13
        0x30003908:    f000f90a    ....    BL       $Ven$TT$L$$ll_pwr_req_excute_psc_command ; 0x30003b20
        0x3000390c:    4829        )H      LDR      r0,[pc,#164] ; [0x300039b4] = 0xa000c540
        0x3000390e:    381c        .8      SUBS     r0,r0,#0x1c
        0x30003910:    6801        .h      LDR      r1,[r0,#0]
        0x30003912:    f4210100    !...    BIC      r1,r1,#0x800000
        0x30003916:    6001        .`      STR      r1,[r0,#0]
        0x30003918:    6828        (h      LDR      r0,[r5,#0]
        0x3000391a:    f42050de     ..P    BIC      r0,r0,#0x1bc0
        0x3000391e:    f44051de    @..Q    ORR      r1,r0,#0x1bc0
        0x30003922:    6029        )`      STR      r1,[r5,#0]
        0x30003924:    f4407040    @.@p    ORR      r0,r0,#0x300
        0x30003928:    6028        (`      STR      r0,[r5,#0]
        0x3000392a:    4934        4I      LDR      r1,[pc,#208] ; [0x300039fc] = 0x803212
        0x3000392c:    7848        Hx      LDRB     r0,[r1,#1]
        0x3000392e:    f3c000c0    ....    UBFX     r0,r0,#3,#1
        0x30003932:    8b89        ..      LDRH     r1,[r1,#0x1c]
        0x30003934:    4d1f        .M      LDR      r5,[pc,#124] ; [0x300039b4] = 0xa000c540
        0x30003936:    f5a1428e    ...B    SUB      r2,r1,#0x4700
        0x3000393a:    3514        .5      ADDS     r5,r5,#0x14
        0x3000393c:    3a44        D:      SUBS     r2,r2,#0x44
        0x3000393e:    d105        ..      BNE      0x3000394c ; pwr_mgmt_ultra_sleep + 280
        0x30003940:    b120         .      CBZ      r0,0x3000394c ; pwr_mgmt_ultra_sleep + 280
        0x30003942:    6828        (h      LDR      r0,[r5,#0]
        0x30003944:    f4400080    @...    ORR      r0,r0,#0x400000
        0x30003948:    6028        (`      STR      r0,[r5,#0]
        0x3000394a:    e003        ..      B        0x30003954 ; pwr_mgmt_ultra_sleep + 288
        0x3000394c:    6828        (h      LDR      r0,[r5,#0]
        0x3000394e:    f4200080     ...    BIC      r0,r0,#0x400000
        0x30003952:    6028        (`      STR      r0,[r5,#0]
        0x30003954:    4817        .H      LDR      r0,[pc,#92] ; [0x300039b4] = 0xa000c540
        0x30003956:    2400        .$      MOVS     r4,#0
        0x30003958:    3024        $0      ADDS     r0,r0,#0x24
        0x3000395a:    6004        .`      STR      r4,[r0,#0]
        0x3000395c:    4915        .I      LDR      r1,[pc,#84] ; [0x300039b4] = 0xa000c540
        0x3000395e:    4828        (H      LDR      r0,[pc,#160] ; [0x30003a00] = 0x222aaaaa
        0x30003960:    3128        (1      ADDS     r1,r1,#0x28
        0x30003962:    6008        .`      STR      r0,[r1,#0]
        0x30003964:    4813        .H      LDR      r0,[pc,#76] ; [0x300039b4] = 0xa000c540
        0x30003966:    3038        80      ADDS     r0,r0,#0x38
        0x30003968:    6004        .`      STR      r4,[r0,#0]
        0x3000396a:    4812        .H      LDR      r0,[pc,#72] ; [0x300039b4] = 0xa000c540
        0x3000396c:    3020         0      ADDS     r0,r0,#0x20
        0x3000396e:    6801        .h      LDR      r1,[r0,#0]
        0x30003970:    f36f010f    o...    BFC      r1,#0,#16
        0x30003974:    6001        .`      STR      r1,[r0,#0]
        0x30003976:    6801        .h      LDR      r1,[r0,#0]
        0x30003978:    f24f1275    O.u.    MOV      r2,#0xf175
        0x3000397c:    4311        .C      ORRS     r1,r1,r2
        0x3000397e:    6001        .`      STR      r1,[r0,#0]
        0x30003980:    4817        .H      LDR      r0,[pc,#92] ; [0x300039e0] = 0x801f64
        0x30003982:    f000f8af    ....    BL       $Ven$TT$L$$hal_exflash_deepsleep_patch ; 0x30003ae4
        0x30003986:    6828        (h      LDR      r0,[r5,#0]
        0x30003988:    f0207080     ..p    BIC      r0,r0,#0x1000000
        0x3000398c:    6028        (`      STR      r0,[r5,#0]
        0x3000398e:    6828        (h      LDR      r0,[r5,#0]
        0x30003990:    f0407000    @..p    ORR      r0,r0,#0x2000000
        0x30003994:    6028        (`      STR      r0,[r5,#0]
        0x30003996:    4d07        .M      LDR      r5,[pc,#28] ; [0x300039b4] = 0xa000c540
        0x30003998:    1d2d        -.      ADDS     r5,r5,#4
        0x3000399a:    602c        ,`      STR      r4,[r5,#0]
        0x3000399c:    f000f8bb    ....    BL       $Ven$TT$L$$ll_pwr_is_active_flag_psc_cmd_busy ; 0x30003b16
        0x300039a0:    2801        .(      CMP      r0,#1
        0x300039a2:    d0fb        ..      BEQ      0x3000399c ; pwr_mgmt_ultra_sleep + 360
        0x300039a4:    2003        .       MOVS     r0,#3
        0x300039a6:    f000f8bb    ....    BL       $Ven$TT$L$$ll_pwr_req_excute_psc_command ; 0x30003b20
        0x300039aa:    f000f8b4    ....    BL       $Ven$TT$L$$ll_pwr_is_active_flag_psc_cmd_busy ; 0x30003b16
        0x300039ae:    2801        .(      CMP      r0,#1
        0x300039b0:    d0fb        ..      BEQ      0x300039aa ; pwr_mgmt_ultra_sleep + 374
        0x300039b2:    e7f2        ..      B        0x3000399a ; pwr_mgmt_ultra_sleep + 358
    $d
        0x300039b4:    a000c540    @...    DCD    2684405056
        0x300039b8:    a000e200    ....    DCD    2684412416
        0x300039bc:    003d0900    ..=.    DCD    4000000
        0x300039c0:    008026b0    .&..    DCD    8398512
        0x300039c4:    008026bc    .&..    DCD    8398524
        0x300039c8:    00802684    .&..    DCD    8398468
        0x300039cc:    00802674    t&..    DCD    8398452
        0x300039d0:    00802480    .$..    DCD    8397952
        0x300039d4:    3000683c    <h.0    DCD    805333052
        0x300039d8:    3000698c    .i.0    DCD    805333388
        0x300039dc:    30006840    @h.0    DCD    805333056
        0x300039e0:    00801f64    d...    DCD    8396644
        0x300039e4:    300067a4    .g.0    DCD    805332900
        0x300039e8:    e000e100    ....    DCD    3758153984
        0x300039ec:    00000000    ....    DCD    0
        0x300039f0:    408f4000    .@.@    DCD    1083129856
        0x300039f4:    ffe00000    ....    DCD    4292870144
        0x300039f8:    41efffff    ...A    DCD    1106247679
        0x300039fc:    00803212    .2..    DCD    8401426
        0x30003a00:    222aaaaa    ..*"    DCD    573221546
    $t
    pwr_mgmt_schedule
        0x30003a04:    b570        p.      PUSH     {r4-r6,lr}
        0x30003a06:    f000f8a9    ....    BL       $Ven$TT$L$$pwr_mgmt_save_ctx_lvl_two ; 0x30003b5c
        0x30003a0a:    491a        .I      LDR      r1,[pc,#104] ; [0x30003a74] = 0x3000698c
        0x30003a0c:    2001        .       MOVS     r0,#1
        0x30003a0e:    7008        .p      STRB     r0,[r1,#0]
        0x30003a10:    f000f8a9    ....    BL       $Ven$TT$L$$mem_pwr_mgmt_check_processs ; 0x30003b66
        0x30003a14:    f000f87a    ..z.    BL       $Ven$TT$L$$pwr_mgmt_locker ; 0x30003b0c
        0x30003a18:    4605        .F      MOV      r5,r0
        0x30003a1a:    f000f8a9    ....    BL       $Ven$TT$L$$pwr_mgmt_mode_get ; 0x30003b70
        0x30003a1e:    4c16        .L      LDR      r4,[pc,#88] ; [0x30003a78] = 0x8026a8
        0x30003a20:    2802        .(      CMP      r0,#2
        0x30003a22:    d00a        ..      BEQ      0x30003a3a ; pwr_mgmt_schedule + 54
        0x30003a24:    f000f8a4    ....    BL       $Ven$TT$L$$pwr_mgmt_mode_get ; 0x30003b70
        0x30003a28:    2801        .(      CMP      r0,#1
        0x30003a2a:    d101        ..      BNE      0x30003a30 ; pwr_mgmt_schedule + 44
        0x30003a2c:    6820         h      LDR      r0,[r4,#0]
        0x30003a2e:    4780        .G      BLX      r0
        0x30003a30:    4628        (F      MOV      r0,r5
        0x30003a32:    e8bd4070    ..p@    POP      {r4-r6,lr}
        0x30003a36:    f000b8a0    ....    B.W      $Ven$TT$L$$pwr_mgmt_unlocker ; 0x30003b7a
        0x30003a3a:    f000f8a3    ....    BL       $Ven$TT$L$$pwr_mgmt_dev_suspend ; 0x30003b84
        0x30003a3e:    b158        X.      CBZ      r0,0x30003a58 ; pwr_mgmt_schedule + 84
        0x30003a40:    490e        .I      LDR      r1,[pc,#56] ; [0x30003a7c] = 0x8026ac
        0x30003a42:    9803        ..      LDR      r0,[sp,#0xc]
        0x30003a44:    6008        .`      STR      r0,[r1,#0]
        0x30003a46:    f000f8a2    ....    BL       $Ven$TT$L$$save_context_and_enter_sleep ; 0x30003b8e
        0x30003a4a:    2801        .(      CMP      r0,#1
        0x30003a4c:    d00b        ..      BEQ      0x30003a66 ; pwr_mgmt_schedule + 98
        0x30003a4e:    4628        (F      MOV      r0,r5
        0x30003a50:    e8bd4070    ..p@    POP      {r4-r6,lr}
        0x30003a54:    f000b891    ....    B.W      $Ven$TT$L$$pwr_mgmt_unlocker ; 0x30003b7a
        0x30003a58:    6820         h      LDR      r0,[r4,#0]
        0x30003a5a:    4780        .G      BLX      r0
        0x30003a5c:    4628        (F      MOV      r0,r5
        0x30003a5e:    e8bd4070    ..p@    POP      {r4-r6,lr}
        0x30003a62:    f000b88a    ....    B.W      $Ven$TT$L$$pwr_mgmt_unlocker ; 0x30003b7a
        0x30003a66:    6820         h      LDR      r0,[r4,#0]
        0x30003a68:    4780        .G      BLX      r0
        0x30003a6a:    4628        (F      MOV      r0,r5
        0x30003a6c:    e8bd4070    ..p@    POP      {r4-r6,lr}
        0x30003a70:    f000b883    ....    B.W      $Ven$TT$L$$pwr_mgmt_unlocker ; 0x30003b7a
    $d
        0x30003a74:    3000698c    .i.0    DCD    805333388
        0x30003a78:    008026a8    .&..    DCD    8398504
        0x30003a7c:    008026ac    .&..    DCD    8398508
    $t
    $Ven$TT$L$$__NVIC_GetPendingIRQ
        0x30003a80:    f6422c3d    B.=,    MOV      r12,#0x2a3d
        0x30003a84:    f2c01c00    ....    MOVT     r12,#0x100
        0x30003a88:    4760        `G      BX       r12
    $Ven$TT$L$$BLESLP_IRQHandler
        0x30003a8a:    f2437cd1    C..|    MOV      r12,#0x37d1
        0x30003a8e:    f2c00c06    ....    MOVT     r12,#6
        0x30003a92:    4760        `G      BX       r12
    $Ven$TT$L$$hal_pwr_get_timer_current_value
        0x30003a94:    f2444c1d    D..L    MOV      r12,#0x441d
        0x30003a98:    f2c00c80    ....    MOVT     r12,#0x80
        0x30003a9c:    4760        `G      BX       r12
    $Ven$TT$L$$sys_lpcycles_2_hus
        0x30003a9e:    f64b6c49    K.Il    MOV      r12,#0xbe49
        0x30003aa2:    f2c00c07    ....    MOVT     r12,#7
        0x30003aa6:    4760        `G      BX       r12
    $Ven$TT$L$$get_remain_sleep_dur
        0x30003aa8:    f6453c31    E.1<    MOV      r12,#0x5b31
        0x30003aac:    f2c00c80    ....    MOVT     r12,#0x80
        0x30003ab0:    4760        `G      BX       r12
    $Ven$TT$L$$pwr_mgmt_set_wakeup_flag
        0x30003ab2:    f6485cd5    H..\    MOV      r12,#0x8dd5
        0x30003ab6:    f2c00c07    ....    MOVT     r12,#7
        0x30003aba:    4760        `G      BX       r12
    $Ven$TT$L$$ble_core_power_off
        0x30003abc:    f6451c65    E.e.    MOV      r12,#0x5965
        0x30003ac0:    f2c00c80    ....    MOVT     r12,#0x80
        0x30003ac4:    4760        `G      BX       r12
    $Ven$TT$L$$work_digldo_dcdc_set
        0x30003ac6:    f6445c8b    D..\    MOV      r12,#0x4d8b
        0x30003aca:    f2c00c80    ....    MOVT     r12,#0x80
        0x30003ace:    4760        `G      BX       r12
    $Ven$TT$L$$work_xo_bias_set
        0x30003ad0:    f6444c71    D.qL    MOV      r12,#0x4c71
        0x30003ad4:    f2c00c80    ....    MOVT     r12,#0x80
        0x30003ad8:    4760        `G      BX       r12
    $Ven$TT$L$$ble_core_power_on
        0x30003ada:    f6451c8b    E...    MOV      r12,#0x598b
        0x30003ade:    f2c00c80    ....    MOVT     r12,#0x80
        0x30003ae2:    4760        `G      BX       r12
    $Ven$TT$L$$hal_exflash_deepsleep_patch
        0x30003ae4:    f2455c0f    E..\    MOV      r12,#0x550f
        0x30003ae8:    f2c00c80    ....    MOVT     r12,#0x80
        0x30003aec:    4760        `G      BX       r12
    $Ven$TT$L$$hal_pwr_enter_chip_deepsleep
        0x30003aee:    f64d7c05    M..|    MOV      r12,#0xdf05
        0x30003af2:    f2c00c01    ....    MOVT     r12,#1
        0x30003af6:    4760        `G      BX       r12
    $Ven$TT$L$$hal_exflash_wakeup_patch
        0x30003af8:    f2455c71    E.q\    MOV      r12,#0x5571
        0x30003afc:    f2c00c80    ....    MOVT     r12,#0x80
        0x30003b00:    4760        `G      BX       r12
    $Ven$TT$L$$ll_pwr_clear_ext_wakeup_status
        0x30003b02:    f6453c97    E..<    MOV      r12,#0x5b97
        0x30003b06:    f2c00c80    ....    MOVT     r12,#0x80
        0x30003b0a:    4760        `G      BX       r12
    $Ven$TT$L$$pwr_mgmt_locker
        0x30003b0c:    f6484c41    H.AL    MOV      r12,#0x8c41
        0x30003b10:    f2c00c07    ....    MOVT     r12,#7
        0x30003b14:    4760        `G      BX       r12
    $Ven$TT$L$$ll_pwr_is_active_flag_psc_cmd_busy
        0x30003b16:    f6453cb1    E..<    MOV      r12,#0x5bb1
        0x30003b1a:    f2c00c80    ....    MOVT     r12,#0x80
        0x30003b1e:    4760        `G      BX       r12
    $Ven$TT$L$$ll_pwr_req_excute_psc_command
        0x30003b20:    f6453c85    E..<    MOV      r12,#0x5b85
        0x30003b24:    f2c00c80    ....    MOVT     r12,#0x80
        0x30003b28:    4760        `G      BX       r12
    $Ven$TT$L$$hal_sleep_timer_get_clock_freq
        0x30003b2a:    f2445c69    D.i\    MOV      r12,#0x4569
        0x30003b2e:    f2c01c00    ....    MOVT     r12,#0x100
        0x30003b32:    4760        `G      BX       r12
    $Ven$TT$L$$__aeabi_ui2d
        0x30003b34:    f2476c33    G.3l    MOV      r12,#0x7633
        0x30003b38:    f2c01c00    ....    MOVT     r12,#0x100
        0x30003b3c:    4760        `G      BX       r12
    $Ven$TT$L$$__aeabi_ddiv
        0x30003b3e:    f2472cc9    G..,    MOV      r12,#0x72c9
        0x30003b42:    f2c01c00    ....    MOVT     r12,#0x100
        0x30003b46:    4760        `G      BX       r12
    $Ven$TT$L$$__aeabi_d2uiz
        0x30003b48:    f2475cd9    G..\    MOV      r12,#0x75d9
        0x30003b4c:    f2c01c00    ....    MOVT     r12,#0x100
        0x30003b50:    4760        `G      BX       r12
    $Ven$TT$L$$__aeabi_dmul
        0x30003b52:    f2476ce5    G..l    MOV      r12,#0x76e5
        0x30003b56:    f2c01c00    ....    MOVT     r12,#0x100
        0x30003b5a:    4760        `G      BX       r12
    $Ven$TT$L$$pwr_mgmt_save_ctx_lvl_two
        0x30003b5c:    f6425cc9    B..\    MOV      r12,#0x2dc9
        0x30003b60:    f2c00c06    ....    MOVT     r12,#6
        0x30003b64:    4760        `G      BX       r12
    $Ven$TT$L$$mem_pwr_mgmt_check_processs
        0x30003b66:    f2450c2d    E.-.    MOV      r12,#0x502d
        0x30003b6a:    f2c00c80    ....    MOVT     r12,#0x80
        0x30003b6e:    4760        `G      BX       r12
    $Ven$TT$L$$pwr_mgmt_mode_get
        0x30003b70:    f6484c59    H.YL    MOV      r12,#0x8c59
        0x30003b74:    f2c00c07    ....    MOVT     r12,#7
        0x30003b78:    4760        `G      BX       r12
    $Ven$TT$L$$pwr_mgmt_unlocker
        0x30003b7a:    f6487ced    H..|    MOV      r12,#0x8fed
        0x30003b7e:    f2c00c07    ....    MOVT     r12,#7
        0x30003b82:    4760        `G      BX       r12
    $Ven$TT$L$$pwr_mgmt_dev_suspend
        0x30003b84:    f6481c25    H.%.    MOV      r12,#0x8925
        0x30003b88:    f2c00c07    ....    MOVT     r12,#7
        0x30003b8c:    4760        `G      BX       r12
    $Ven$TT$L$$save_context_and_enter_sleep
        0x30003b8e:    f6497c35    I.5|    MOV      r12,#0x9f35
        0x30003b92:    f2c00c07    ....    MOVT     r12,#7
        0x30003b96:    4760        `G      BX       r12

** Section #7 'ARM_LIB_HEAP' (SHT_NOBITS) [SHF_ALLOC + SHF_WRITE]
    Size   : 4096 bytes (alignment 4)
    Address: 0x3003b000


** Section #8 'ARM_LIB_STACK' (SHT_NOBITS) [SHF_ALLOC + SHF_WRITE]
    Size   : 16384 bytes (alignment 4)
    Address: 0x3003c000


** Section #9 '.debug_abbrev' (SHT_PROGBITS)
    Size   : 1476 bytes


** Section #10 '.debug_frame' (SHT_PROGBITS)
    Size   : 10536 bytes


** Section #11 '.debug_info' (SHT_PROGBITS)
    Size   : 76504 bytes


** Section #12 '.debug_line' (SHT_PROGBITS)
    Size   : 19796 bytes


** Section #13 '.debug_loc' (SHT_PROGBITS)
    Size   : 6028 bytes


** Section #14 '.debug_macinfo' (SHT_PROGBITS)
    Size   : 261360 bytes


** Section #15 '.debug_pubnames' (SHT_PROGBITS)
    Size   : 3053 bytes


** Section #16 '.symtab' (SHT_SYMTAB)
    Size   : 51920 bytes (alignment 4)
    String table #17 '.strtab'
    Last local symbol no. 1331


** Section #17 '.strtab' (SHT_STRTAB)
    Size   : 60760 bytes


** Section #18 '.note' (SHT_NOTE)
    Size   : 48 bytes (alignment 4)


** Section #19 '.comment' (SHT_PROGBITS)
    Size   : 696700 bytes


** Section #20 '.shstrtab' (SHT_STRTAB)
    Size   : 220 bytes


