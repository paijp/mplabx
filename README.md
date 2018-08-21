# mplabx
- Dockerfile and sample makefile for Microchip PIC compiler and programmer.

http://www.microchip.com/mplab/mplab-x-ide

- `cd /root&& make build` to build a project.
- `docker run -it --rm --cap-add=SYS_RAWIO --device=/dev/bus/usb mplabx bash` to use `make burn` for PICkit3.
- You may have to restart a container when you plug a USB writer.
