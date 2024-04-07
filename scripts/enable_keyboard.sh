#!/bin/sh

GADGET_PATH="/config/usb_gadget/g1"

cd $GADGET_PATH/configs/
CONFIG_PATH="$GADGET_PATH/configs/`ls -1 | head -1`/"
STRINGS_PATH="$GADGET_PATH/strings/0x409/"


mkdir -p $GADGET_PATH/functions/hid.keyboard
cd $GADGET_PATH/functions/hid.keyboard

# HID protocol (according to USB spec: 1 for keyboard)
echo 1 > protocol
# device subclass
echo 1 > subclass
# number of bytes per record
echo 8 > report_length

# writing report descriptor
echo -ne \\x05\\x01\\x09\\x06\\xa1\\x01\\x05\\x07\\x19\\xe0\\x29\\xe7\\x15\\x00\\x25\\x01\\x75\\x01\\x95\\x08\\x81\\x02\\x95\\x01\\x75\\x08\\x81\\x03\\x95\\x05\\x75\\x01\\x05\\x08\\x19\\x01\\x29\\x05\\x91\\x02\\x95\\x01\\x75\\x03\\x91\\x03\\x95\\x06\\x75\\x08\\x15\\x00\\x25\\x65\\x05\\x07\\x19\\x00\\x29\\x65\\x81\\x00\\xc0 > report_desc

ln -s ${GADGET_PATH}/functions/hid.keyboard $CONFIG_PATH/hid.keyboard

echo "" > $GADGET_PATH/UDC
getprop sys.usb.controller > $GADGET_PATH/UDC
