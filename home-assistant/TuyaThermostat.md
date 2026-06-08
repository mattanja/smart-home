## Thermometer

A4:C1:38:EB:D0:F1:A0:1C

action: zha_toolkit.scan_device
data:
  ieee: A4:C1:38:EB:D0:F1:A0:1C

## Re-Initialize Device

https://home-assistant.kernetics.de/developer-tools/action

service: zha_toolkit.misc_reinitialize
data:
  # Reference of the device that should be reinitialized
  ieee: 58:3b:c2:ff:fe:1c:9e:16



## Scan Device

https://home-assistant.kernetics.de/developer-tools/action

action: zha_toolkit.scan_device
data:
  ieee: 58:3b:c2:ff:fe:1c:9e:16

### Scan Device Result

zha_toolkit_version: v1.1.33
zigpy_version: 0.88.0
zigpy_rf_version: 0.48.2
ieee_org: climate.eg_wohnzimmer_thermostat
ieee: 58:3b:c2:ff:fe:1c:9e:16
command: scan_device
command_data: null
start_time: "2025-12-28T11:11:28.757221+00:00"
errors: []
params:
  dir: 0
  tries: 1
  expect_reply: true
  args: []
  kwargs: {}
  read_before_write: true
  read_after_write: true
scan:
  ieee: 58:3b:c2:ff:fe:1c:9e:16
  nwk: "0xce2f"
  model: TS0601
  manufacturer: _TZE284_khah2lkr
  manufacturer_id: "0x4098"
  endpoints:
    - id: 1
      device_type: "0x0301"
      profile: "0x0104"
      in_clusters:
        "0x0000":
          cluster_id: "0x0000"
          title: Basic
          name: basic
          attributes:
            "0x0000":
              attribute_id: "0x0000"
              attribute_name: zcl_version
              value_type:
                - "0x20"
                - uint8_t
                - Analog
              access: READ|REPORT
              access_acl: 5
              attribute_value: 3
            "0x0001":
              attribute_id: "0x0001"
              attribute_name: app_version
              value_type:
                - "0x20"
                - uint8_t
                - Analog
              access: READ|REPORT
              access_acl: 5
              attribute_value: 68
            "0x0002":
              attribute_id: "0x0002"
              attribute_name: stack_version
              value_type:
                - "0x20"
                - uint8_t
                - Analog
              access: READ|REPORT
              access_acl: 5
              attribute_value: 0
            "0x0003":
              attribute_id: "0x0003"
              attribute_name: hw_version
              value_type:
                - "0x20"
                - uint8_t
                - Analog
              access: READ|REPORT
              access_acl: 5
              attribute_value: 1
            "0x0004":
              attribute_id: "0x0004"
              attribute_name: manufacturer
              value_type:
                - "0x42"
                - CharacterString
                - Discrete
              access: READ|REPORT
              access_acl: 5
              attribute_value: _TZE284_khah2lkr
            "0x0005":
              attribute_id: "0x0005"
              attribute_name: model
              value_type:
                - "0x42"
                - CharacterString
                - Discrete
              access: READ|REPORT
              access_acl: 5
              attribute_value: TS0601
            "0x0006":
              attribute_id: "0x0006"
              attribute_name: date_code
              value_type:
                - "0x42"
                - CharacterString
                - Discrete
              access: READ|REPORT
              access_acl: 5
              attribute_value: ""
            "0x0007":
              attribute_id: "0x0007"
              attribute_name: power_source
              value_type:
                - "0x30"
                - enum8
                - Discrete
              access: READ|REPORT
              access_acl: 5
              attribute_value: 1
            "0xffde":
              attribute_id: "0xffde"
              attribute_name: "65502"
              value_type:
                - "0x20"
                - uint8_t
                - Analog
              access: READ|WRITE|REPORT
              access_acl: 7
            "0xffe0":
              attribute_id: "0xffe0"
              attribute_name: "65504"
              value_type:
                - "0x48"
                - Array
                - Discrete
              access: READ|REPORT
              access_acl: 5
            "0xffe1":
              attribute_id: "0xffe1"
              attribute_name: "65505"
              value_type:
                - "0x48"
                - Array
                - Discrete
              access: READ|REPORT
              access_acl: 5
            "0xffe2":
              attribute_id: "0xffe2"
              attribute_name: "65506"
              value_type:
                - "0x20"
                - uint8_t
                - Analog
              access: READ|REPORT
              access_acl: 5
            "0xffe3":
              attribute_id: "0xffe3"
              attribute_name: "65507"
              value_type:
                - "0x48"
                - Array
                - Discrete
              access: READ|REPORT
              access_acl: 5
            "0xfffd":
              attribute_id: "0xfffd"
              attribute_name: cluster_revision
              value_type:
                - "0x21"
                - uint16_t
                - Analog
              access: READ|REPORT
              access_acl: 5
            "0xfffe":
              attribute_id: "0xfffe"
              attribute_name: reporting_status
              value_type:
                - "0x30"
                - enum8
                - Discrete
              access: READ|REPORT
              access_acl: 5
          commands_received: {}
          commands_generated: {}
        "0x0001":
          cluster_id: "0x0001"
          title: Power Configuration
          name: power
          attributes: {}
          commands_received: {}
          commands_generated: {}
        "0x0004":
          cluster_id: "0x0004"
          title: Groups
          name: groups
          attributes:
            "0x0000":
              attribute_id: "0x0000"
              attribute_name: name_support
              value_type:
                - "0x18"
                - bitmap8
                - Discrete
              access: READ|REPORT
              access_acl: 5
              attribute_value: 0
            "0xfffd":
              attribute_id: "0xfffd"
              attribute_name: cluster_revision
              value_type:
                - "0x21"
                - uint16_t
                - Analog
              access: READ|REPORT
              access_acl: 5
              attribute_value: 2
          commands_received: {}
          commands_generated: {}
        "0x0005":
          cluster_id: "0x0005"
          title: Scenes
          name: scenes
          attributes:
            "0x0000":
              attribute_id: "0x0000"
              attribute_name: count
              value_type:
                - "0x20"
                - uint8_t
                - Analog
              access: READ|REPORT
              access_acl: 5
              attribute_value: 0
            "0x0001":
              attribute_id: "0x0001"
              attribute_name: current_scene
              value_type:
                - "0x20"
                - uint8_t
                - Analog
              access: READ|REPORT
              access_acl: 5
              attribute_value: 0
            "0x0002":
              attribute_id: "0x0002"
              attribute_name: current_group
              value_type:
                - "0x21"
                - uint16_t
                - Analog
              access: READ|REPORT
              access_acl: 5
              attribute_value: 0
            "0x0003":
              attribute_id: "0x0003"
              attribute_name: scene_valid
              value_type:
                - "0x10"
                - Bool
                - Discrete
              access: READ|REPORT
              access_acl: 5
              attribute_value: 0
            "0x0004":
              attribute_id: "0x0004"
              attribute_name: name_support
              value_type:
                - "0x18"
                - bitmap8
                - Discrete
              access: READ|REPORT
              access_acl: 5
              attribute_value: 0
            "0xfffd":
              attribute_id: "0xfffd"
              attribute_name: cluster_revision
              value_type:
                - "0x21"
                - uint16_t
                - Analog
              access: READ|REPORT
              access_acl: 5
              attribute_value: 2
          commands_received: {}
          commands_generated: {}
        "0x0201":
          cluster_id: "0x0201"
          title: Khal2lkrThermostat
          name: thermostat
          attributes: {}
          commands_received: {}
          commands_generated: {}
        "0x0204":
          cluster_id: "0x0204"
          title: Thermostat User Interface Configuration
          name: thermostat_ui
          attributes: {}
          commands_received: {}
          commands_generated: {}
        "0xed00":
          cluster_id: "0xed00"
          title: Cluster
          name: null
          attributes:
            "0xfffd":
              attribute_id: "0xfffd"
              attribute_name: "65533"
              value_type:
                - "0x21"
                - uint16_t
                - Analog
              access: READ|REPORT
              access_acl: 5
              attribute_value: 1
          commands_received: {}
          commands_generated: {}
        "0xef00":
          cluster_id: "0xef00"
          title: Tuya Manufacturer Specicific
          name: tuya_manufacturer
          attributes:
            "0x0000":
              attribute_id: "0x0000"
              attribute_name: "0"
              value_type:
                - "0x20"
                - uint8_t
                - Analog
              access: READ|REPORT
              access_acl: 5
          commands_received: {}
          commands_generated: {}
      out_clusters:
        "0x000a":
          cluster_id: "0x000a"
          title: Time
          name: time
          attributes:
            "0xfffd":
              attribute_id: "0xfffd"
              attribute_name: cluster_revision
              value_type:
                - "0x21"
                - uint16_t
                - Analog
              access: READ|REPORT
              access_acl: 5
              attribute_value: 1
          commands_received: {}
          commands_generated: {}
        "0x0019":
          cluster_id: "0x0019"
          title: Ota
          name: ota
          attributes:
            "0x0000":
              attribute_id: "0x0000"
              attribute_name: upgrade_server_id
              value_type:
                - "0xf0"
                - EUI64
                - Discrete
              access: READ|REPORT
              access_acl: 5
              attribute_value:
                - 255
                - 255
                - 255
                - 255
                - 255
                - 255
                - 255
                - 255
            "0x0001":
              attribute_id: "0x0001"
              attribute_name: file_offset
              value_type:
                - "0x23"
                - uint32_t
                - Analog
              access: READ|REPORT
              access_acl: 5
              attribute_value: 4294967295
            "0x0006":
              attribute_id: "0x0006"
              attribute_name: image_upgrade_status
              value_type:
                - "0x30"
                - enum8
                - Discrete
              access: READ|REPORT
              access_acl: 5
              attribute_value: 0
            "0xfffd":
              attribute_id: "0xfffd"
              attribute_name: cluster_revision
              value_type:
                - "0x21"
                - uint16_t
                - Analog
              access: READ|REPORT
              access_acl: 5
              attribute_value: 3
          commands_received: {}
          commands_generated: {}
success: true
