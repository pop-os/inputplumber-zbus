#!/usr/bin/env bash

set -ex

rm -rfv src
mkdir -p src
pushd src

xmls=(
    org.shadowblip.Input.CompositeDevice.xml
    org.shadowblip.Output.ForceFeedback.xml
    org.shadowblip.Input.Source.IIOIMUDevice.xml
    org.shadowblip.Input.Keyboard.xml
    org.shadowblip.Input.DBusDevice.xml
    org.shadowblip.Input.Source.HIDRawDevice.xml
    org.shadowblip.Input.Manager.xml
    org.shadowblip.Input.Source.LEDDevice.xml
    org.shadowblip.Input.Debug.xml
    org.shadowblip.Input.UdevDevice.xml
    org.shadowblip.Input.Source.EventDevice.xml
    #TODO: fix xml error: org.shadowblip.Input.Touchscreen.xml
    org.shadowblip.Input.Gamepad.xml
    org.shadowblip.Input.Mouse.xml
    org.shadowblip.Input.Metrics.xml
)

for xml in "${xmls[@]}"
do
    cargo run \
        --manifest-path ../zbus/zbus_xmlgen/Cargo.toml \
        --release \
        -- file "../InputPlumber/bindings/dbus-xml/$xml"
done

for file in *.rs
do
    name="$(basename "${file}" .rs)"
    echo "pub mod ${name};" >> lib.rs
done
echo "pub use zbus;" >> lib.rs

popd
