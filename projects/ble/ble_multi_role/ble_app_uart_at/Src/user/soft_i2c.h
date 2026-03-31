/**
 *****************************************************************************************
 *
 * @file soft_i2c.h
 *
 * @brief Software I2C driver header file (GPIO bit-banging implementation)
 *        Using GPIO_9 (SCL) and GPIO_10 (SDA) for WF5803F pressure sensor
 *
 * @note  Ported from test2.0 water level detection project
 *
 *****************************************************************************************
 */

#ifndef SOFT_I2C_H
#define SOFT_I2C_H

#include <stdint.h>
#include <stdbool.h>

/*
 * PUBLIC FUNCTION DECLARATIONS
 *****************************************************************************************
 */

/**
 *****************************************************************************************
 * @brief Initialize software I2C interface.
 *****************************************************************************************
 */
void soft_i2c_init(void);

/**
 *****************************************************************************************
 * @brief Deinitialize software I2C interface (for low-power mode).
 *****************************************************************************************
 */
void soft_i2c_deinit(void);

/**
 *****************************************************************************************
 * @brief Send I2C start condition.
 *
 * @return true if successful, false otherwise.
 *****************************************************************************************
 */
bool soft_i2c_start(void);

/**
 *****************************************************************************************
 * @brief Send I2C stop condition.
 *****************************************************************************************
 */
void soft_i2c_stop(void);

/**
 *****************************************************************************************
 * @brief Write one byte to I2C bus.
 *
 * @param[in] data: Byte to write.
 *
 * @return true if ACK received, false otherwise.
 *****************************************************************************************
 */
bool soft_i2c_write_byte(uint8_t data);

/**
 *****************************************************************************************
 * @brief Read one byte from I2C bus.
 *
 * @param[in] ack: Send ACK (true) or NACK (false) after reading.
 *
 * @return Byte read from bus.
 *****************************************************************************************
 */
uint8_t soft_i2c_read_byte(bool ack);

/**
 *****************************************************************************************
 * @brief Write data to I2C device register.
 *
 * @param[in] dev_addr: 7-bit device address.
 * @param[in] reg_addr: Register address.
 * @param[in] value: Value to write.
 *
 * @return true if successful, false otherwise.
 *****************************************************************************************
 */
bool soft_i2c_write_reg(uint8_t dev_addr, uint8_t reg_addr, uint8_t value);

/**
 *****************************************************************************************
 * @brief Read data from I2C device register.
 *
 * @param[in] dev_addr: 7-bit device address.
 * @param[in] reg_addr: Register address.
 * @param[out] buffer: Buffer to store read data.
 * @param[in] len: Number of bytes to read.
 *
 * @return true if successful, false otherwise.
 *****************************************************************************************
 */
bool soft_i2c_read_reg(uint8_t dev_addr, uint8_t reg_addr, uint8_t *buffer, uint16_t len);

/**
 *****************************************************************************************
 * @brief Reset I2C bus by sending 9 clock pulses to release SDA line.
 *
 * When I2C communication fails and the slave holds SDA low, the master can
 * send extra clock pulses to release SDA, then send STOP to restore bus.
 *****************************************************************************************
 */
void soft_i2c_bus_reset(void);

#endif // SOFT_I2C_H
