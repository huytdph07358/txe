import 'package:vss_environment/environment_enum.dart';
import 'package:vss_environment/environment_switch.dart';

import 'dev_domain.dart';
import 'live_domain.dart';

class BackendDomain {
  static String get vtx {
    return EnvironmentSwitch.environment == EnvironmentEnum.dev.env
        ? DevDomain.vtx
        : LiveDomain.vtx;
  }

  static String get acs {
    return EnvironmentSwitch.environment == EnvironmentEnum.dev.env
        ? DevDomain.acs
        : LiveDomain.acs;
  }

  static String get cos {
    return EnvironmentSwitch.environment == EnvironmentEnum.dev.env
        ? DevDomain.cos
        : LiveDomain.cos;
  }

  static String get fss {
    return EnvironmentSwitch.environment == EnvironmentEnum.dev.env
        ? DevDomain.fss
        : LiveDomain.fss;
  }

  static String get nms {
    return EnvironmentSwitch.environment == EnvironmentEnum.dev.env
        ? DevDomain.nms
        : LiveDomain.nms;
  }

  static String get vplus {
    return EnvironmentSwitch.environment == EnvironmentEnum.dev.env
        ? DevDomain.vplus
        : LiveDomain.vplus;
  }

  /*static String get cms {
    return EnvironmentSwitch.environment == EnvironmentEnum.dev.env
        ? DevDomain.cms
        : LiveDomain.cms;
  }*/

  /*static String get ckt {
    return EnvironmentSwitch.environment == EnvironmentEnum.dev.env
        ? DevDomain.ckt
        : LiveDomain.ckt;
  }

  static String get tvb {
    return EnvironmentSwitch.environment == EnvironmentEnum.dev.env
        ? DevDomain.tvb
        : LiveDomain.tvb;
  }

  static String get ehr {
    return EnvironmentSwitch.environment == EnvironmentEnum.dev.env
        ? DevDomain.ehr
        : LiveDomain.ehr;
  }

  static String get dkk {
    return EnvironmentSwitch.environment == EnvironmentEnum.dev.env
        ? DevDomain.dkk
        : LiveDomain.dkk;
  }

  static String get tourism {
    return EnvironmentSwitch.environment == EnvironmentEnum.dev.env
        ? DevDomain.tourism
        : LiveDomain.tourism;
  }

  static String get lcl {
    return EnvironmentSwitch.environment == EnvironmentEnum.dev.env
        ? DevDomain.lcl
        : LiveDomain.lcl;
  }*/
}
