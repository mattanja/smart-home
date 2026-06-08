
Paulmann Licht

homeassistant  | 2023-11-23 23:12:48.613 DEBUG (MainThread) [zigpy.application] Device is initialized <Device model='501.34' manuf='Paulmann Licht GmbH' nwk=0x2742 ieee=b4:e3:f9:ff:fe:ec:50:fe is_initialized=True>

homeassistant  | 2023-11-23 23:43:47.365 ERROR (MainThread) [zhaquirks] Unexpected exception importing custom quirk 'paulmann.fourbtnremote'
homeassistant  | Traceback (most recent call last):
homeassistant  |   File "/usr/local/lib/python3.11/site-packages/zhaquirks/__init__.py", line 460, in setup
homeassistant  |     spec.loader.exec_module(module)
homeassistant  |   File "<frozen importlib._bootstrap_external>", line 940, in exec_module
homeassistant  |   File "<frozen importlib._bootstrap>", line 241, in _call_with_frames_removed
homeassistant  |   File "/config/quirks/paulmann/fourbtnremote.py", line 41, in <module>
homeassistant  |     from zhaquirks.paulmann import PAULMANN, PAULMANN_VARIANT
homeassistant  | ImportError: cannot import name 'PAULMANN_VARIANT' from 'zhaquirks.paulmann' (/usr/local/lib/python3.11/site-packages/zhaquirks/paulmann/__init__.py)
homeassistant  | 2023-11-23 23:43:47.368 WARNING (MainThread) [zhaquirks] Loaded custom quirks. Please contribute them to https://github.com/zigpy/zha-device-handlers
