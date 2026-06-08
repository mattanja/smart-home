"""Tuya TS0203 contact sensors."""

from zigpy.quirks.v2 import ClusterType, QuirkBuilder
from zigpy.zcl.clusters.general import Groups, Identify, OnOff, Ota, Scenes, Time
from zigpy.zcl.clusters.lightlink import LightLink

from zhaquirks.tuya import TuyaPowerConfigurationCluster2AAA

(
    QuirkBuilder("_TZ3000_6zvw8ham", "TS0203")
    .skip_configuration()
    .removes(Identify.cluster_id)
    .replaces(TuyaPowerConfigurationCluster2AAA)
    .removes(Groups.cluster_id, cluster_type=ClusterType.Client)
    .removes(Scenes.cluster_id, cluster_type=ClusterType.Client)
    .removes(OnOff.cluster_id, cluster_type=ClusterType.Client)
    .removes(0x0008, cluster_type=ClusterType.Client)
    .removes(Time.cluster_id, cluster_type=ClusterType.Client)
    .removes(Ota.cluster_id, cluster_type=ClusterType.Client)
    .removes(LightLink.cluster_id, cluster_type=ClusterType.Client)
    .add_to_registry()
)
