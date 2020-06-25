#pragma once
#include <stdint.h>

struct frame_buffer_info_type {
    int physical_width;
    int physical_height;
    int virtual_width;
    int virtual_height;
    int gpu_pitch;
    int bit_depth;
    int x;
    int y;
    int16_t* gpu_pointer;
    int gpu_size;
};

// Global frame buffer info memory
struct frame_buffer_info_type frame_buffer_info;

/**
 * Initialise GPU frame buffer with the given parameters.
 * 
 * Parameters:
 *  width - Width of Frame Buffer
 *  height - Height of Frame Buffer
 *  bit_depth - Bit Depth of Frame Buffer
 * 
 * Returns:
 *  NULL - If frame buffer setup failed
 *   - or -
 *  Pointer to frame buffer info - If successful
 */
struct frame_buffer_info_type* initialise_frame_buffer(int width, int height, int bit_depth);

void test_render();