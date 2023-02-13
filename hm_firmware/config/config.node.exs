import Config

# Use Ringlogger as the logger backend and remove :console.
# See https://hexdocs.pm/ring_logger/readme.html for more information on
# configuring ring_logger.

config :logger, backends: [RingLogger]

# Use shoehorn to start the main application. See the shoehorn
# library documentation for more control in ordering how OTP
# applications are started and handling failures.

config :shoehorn, init: [:nerves_runtime, :nerves_pack]

# Erlinit can be configured without a rootfs_overlay. See
# https://github.com/nerves-project/erlinit/ for more information on
# configuring erlinit.

config :nerves,
  erlinit: [
    hostname_pattern: "nerves-%s"
  ]

# Configure the device for SSH IEx prompt access and firmware updates
#
# * See https://hexdocs.pm/nerves_ssh/readme.html for general SSH configuration
# * See https://hexdocs.pm/ssh_subsystem_fwup/readme.html for firmware updates

keys =
  [
    Path.join([System.user_home!(), ".ssh", "id_rsa_yubikey.pub"])
  ]
  |> Enum.filter(&File.exists?/1)

if keys == [],
  do:
    Mix.raise("""
    No SSH public keys found in ~/.ssh. An ssh authorized key is needed to
    log into the Nerves device and update firmware on it using ssh.
    See your project's config.exs for this error message.
    """)

config :nerves_ssh,
  authorized_keys: Enum.map(keys, &File.read!/1)

# Configure the network using vintage_net
# See https://github.com/nerves-networking/vintage_net for more information
config :vintage_net,
  regulatory_domain: "US",
  config: [
    {"usb0", %{type: VintageNetDirect}},
    {"eth0",
     %{
       type: VintageNetEthernet,
       ipv4: %{method: :dhcp}
     }},
    {"wlan0",
      %{
        type: VintageNetWiFi,
        vintage_net_wifi: %{
          networks: [
            %{
              key_mgmt: String.to_atom(System.get_env("HM_WLAN_KEY_MGMT") || "WPA-PSK"),
              ssid: System.get_env("HM_WLAN_SSID"),
              psk: System.get_env("HM_WLAN_PSK")
            }
          ]
        },
        ipv4: %{method: :dhcp},
      }
    }
  ]

config :mdns_lite,
  # The `hosts` key specifies what hostnames mdns_lite advertises.  `:hostname`
  # advertises the device's hostname.local. For the official Nerves systems, this
  # is "nerves-<4 digit serial#>.local".  The `"nerves"` host causes mdns_lite
  # to advertise "nerves.local" for convenience. If more than one Nerves device
  # is on the network, it is recommended to delete "nerves" from the list
  # because otherwise any of the devices may respond to nerves.local leading to
  # unpredictable behavior.

  hosts: [:hostname, "nerves"],
  ttl: 120,

  # Advertise the following services over mDNS.
  services: [
    %{
      protocol: "ssh",
      transport: "tcp",
      port: 22
    },
    %{
      protocol: "sftp-ssh",
      transport: "tcp",
      port: 22
    },
    %{
      protocol: "epmd",
      transport: "tcp",
      port: 4369
    }
  ]

# Configure nerves_init_gadget.
# See https://hexdocs.pm/nerves_init_gadget/readme.html for more information.
# Setting the node_name will enable Erlang Distribution.
# Only enable this for prod if you understand the risks.
# node_name = if Mix.env() != :prod, do: "homemesh"

# config :nerves_init_gadget,
#   ifname: "wlan0",
#   address_method: :dhcp,
#   mdns_domain: :hostname,
#   node_name: node_name,
#   node_host: :ip

# # Configure networking
# config :nerves_network, :default,
#   wlan0: [
#     ssid: System.get_env("HM_WLAN_SSID"),
#     psk: System.get_env("HM_WLAN_PSK"),
#     key_mgmt: String.to_atom(System.get_env("HM_WLAN_KEY_MGMT") || "WPA-PSK")
#   ]

