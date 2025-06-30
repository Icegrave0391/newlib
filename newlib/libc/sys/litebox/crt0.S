/*
 * LiteBox crt0.S - C runtime initialization for LiteBox
 */

/*============================================================================*
 * Imported Symbols                                                           *
 *============================================================================*/

.extern _start  /* Initialize LiteBox environment */

/*============================================================================*
 * Exported Symbols                                                           *
 *============================================================================*/

.globl _do_start                  /* Entry point */

/*============================================================================*
 * Text Section                                                               *
 *============================================================================*/

.section .crt0, "ax"

/*
 * _do_start - Entry point for LiteBox programs
 *
 * This function:
 * 1. Sets up argc/argv arguments for the Rust _start function
 * 2. Calls the Rust _start function to initialize LiteBox environment
 * 3. The Rust _start function handles everything from there
 */
_do_start:
    /* Save the original stack pointer */
    movq %rsp, %rbp
    
    /* Get argc and argv from stack */
    /* In x86_64, argc is at (%rbp), and argv is at 8(%rbp) */
    movq (%rbp), %rdi    /* argc -> first argument (rdi) */
    leaq 8(%rbp), %rsi   /* argv -> second argument (rsi) */
    
    /* Align stack to 16 bytes (required by System V ABI) */
    andq $-16, %rsp
    
    /* 
     * Call the Rust _start function with argc in %rdi and argv in %rsi
     * It will calculate envp and handle initialization, calling main, and exit.
     */
    call _start
    
    /* If _start returns (it shouldn't since it calls exit), loop forever */
1:  
    hlt
    jmp 1b
