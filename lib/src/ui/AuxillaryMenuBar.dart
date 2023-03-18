import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lg_controller/src/blocs/PageBloc.dart';
import 'package:lg_controller/src/menu/AuxillaryMenu.dart';
import 'package:lg_controller/src/osc/ModuleType.dart';
import 'package:lg_controller/src/osc/OSCActions.dart';
import 'package:lg_controller/src/states_events/PageActions.dart';
import 'package:lg_controller/src/utils/SizeScaling.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// auxillary menu bar widget.
class AuxillaryMenuBar extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: getIcons(context),
      ),
    );
  }

  /// Get icons for the auxillary menu options.
  List<Widget> getIcons(context) {
    List<Widget> list = new List<Widget>();
    for (var ic in AuxillaryMenu.values()) {
      if (ic == AuxillaryMenu.ADDITIONAL) {
        list.add(
          Expanded(
            flex: 10,
            child: additionalMenu(ic, context),
          ),
        );
      } else {
        list.add(
          Expanded(
            flex: 10,
            child: IconButton(
              iconSize: 24 + 24 * 0.5 * (SizeScaling.getWidthScaling() - 1),
              key: Key('AuxillaryMenu_items_' + ic.title),
              icon: ic.icon,
              tooltip: ic.title,
              onPressed: () => iconSelected(ic, context),
            ),
          ),
        );
      }
      list.add(
        Expanded(
          flex: 5,
          child: SizedBox(
            width: 5,
          ),
        ),
      );
    }
    return list;
  }

  /// Initiate page event for [ic] selected.
  iconSelected(AuxillaryMenu ic, context) {
    switch (ic) {
      case AuxillaryMenu.PROFILE:
        {
          BlocProvider.of<PageBloc>(context).add(PROFILE());
        }
        break;
      case AuxillaryMenu.SETTINGS:
        {
          BlocProvider.of<PageBloc>(context).add(SETTINGS());
        }
        break;
      default:
        {}
    }
  }

  /// Pop-up menu for the additional menu button.
  Widget additionalMenu(ic, context) {
    return PopupMenuButton<int>(
      itemBuilder: (context) => [
            PopupMenuItem(
              value: 1,
              child: Text(
                "Exit",
                style: TextStyle(
                    fontSize:
                        16 + 16 * 0.8 * (SizeScaling.getWidthScaling() - 1),
                    color: Colors.black54,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
      onSelected: (value) async {
        if (value == 1) {
          await OSCActions().sendModule(ModuleType.EXIT, "Exit");
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.remove('ip');
          prefs.remove('socket');
          prefs.remove('id');
          SystemNavigator.pop();
        }
      },
      key: Key('AuxillaryMenu_items_' + ic.title),
      child: IconButton(
        iconSize: 24 + 24 * 0.5 * (SizeScaling.getWidthScaling() - 1),
        icon: ic.icon,
        tooltip: ic.title,
      ),
      offset: Offset(0, 36 * SizeScaling.getHeightScaling()),
    );
  }
}
