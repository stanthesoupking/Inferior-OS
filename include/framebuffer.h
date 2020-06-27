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

/**
 * Set a pixel (32 bit framebuffer)
 * 
 * Parameters:
 *  pixelX - X coordinate of pixel
 *  pixelY - Y coordinate of pixel
 *  pixelValue - Value to insert at given pixel coordinates
 */
void set_framebuffer_pixel_32(int pixelX, int pixelY, int pixelValue);

/**
 * Clear framebuffer with the given pixel value (32 bit framebuffer)
 * 
 * Parameters:
 *  pixelValue - Value to fill framebuffer with
 */
void clear_framebuffer_32(int pixelValue);