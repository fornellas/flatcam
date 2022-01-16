from tclCommands.TclCommand import TclCommand

import collections


class TclCommandSetAllInactive(TclCommand):
    """
    Tcl shell command to set all objects as inactive in the appGUI.

    example:

    """

    # List of all command aliases, to be able use old names for backward compatibility (add_poly, add_polygon)
    aliases = ['set_all_inactive']

    description = '%s %s' % ("--", "Sets all FlatCAM objects as inactive (not selected).")

    # Dictionary of types from Tcl command, needs to be ordered
    arg_names = collections.OrderedDict([])

    # Dictionary of types from Tcl command, needs to be ordered , this  is  for options  like -optionname value
    option_types = collections.OrderedDict([])

    # array of mandatory options for current Tcl command: required = {'name','outname'}
    required = []

    # structured help for current command, args needs to be ordered
    help = {
        'main': 'Sets all FlatCAM objects as inactive (not selected).',
        'args': collections.OrderedDict([]),
        'examples': []
    }

    def execute(self, args, unnamed_args):
        """

        :param args:
        :param unnamed_args:
        :return:
        """

        try:
            self.app.collection.set_all_inactive()
        except Exception as e:
            return "Command failed: %s" % str(e)
