# Home Mesh
The following project contains the begining of the home-mesh project. This goal of this project is to enable a series of IoT smart devices that we can run locally within the network. One of our initial implementations will be to grow some carolina reapers at home. This will allow us to bootstrap a system and give us enough experience along the way.

## Firmware
The base nerves project. This is where we assemble, build and burn/upload our firmwares to our different devices. For example, when in the `hm_firmware` directory, you can build the collector for an rpi0 device with the following command:

```sh
$ HM_NODE_TYPE=collector MIX_TARGET=rpi0 mix firmware
$ HM_NODE_TYPE=collector MIX_TARGET=rpi0 mix burn
```

To set the wifi ssid/password, you can specify them in a `.envrc` file and use the `direnv` utility to populate the environment by running `direnv allow .` in the `hm_firmware` directory. Add the following lines to your `.envrc`.
```sh
export HM_WLAN_SSID="<YOUR_SSID_HERE>"
export HM_WLAN_PSK="<YOUR_WIFI_PASSWORD_HERE>"

# Optionally, to override the default (WPA-PSK) key management you can specify
export HM_WLAN_KEY_MGMT="<YOUR_KEY_MGMT_HERE>"
```

## Gateway
Primary aggregation device

### Gateway UI
Currently a phonenix web server providing a web portal

## Collector
Sensor collecting node. Should be configurable with different sensors

- [ ] Soil Moisture
- [ ] Soil Ph
- [ ] Soil Temperature
- [ ] Ambient Temperature


