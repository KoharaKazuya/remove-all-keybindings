path = require 'path'

module.exports =

  config:
    exceptYourKeymap:
      type: 'boolean'
      default: true
    exceptBaseKeymap:
      type: 'boolean'
      default: true
    exceptPlatformKeymap:
      type: 'boolean'
      default: true

  activate: (state) ->
    atom.packages.onDidActivatePackage =>
      @removeAllKeybindings()

  deactivate: ->
    message = 'Removed keybindings are not restored.'
    detail = 'Reload keybindings by the command -- \'window:reload\''
    atom.notifications.addWarning message, detail: detail

  removeAllKeybindings: ->

    # sources of keybindings
    sources = []
    for kb in atom.keymaps.getKeyBindings()
      sources.push kb.source unless kb.source in sources

    # remove keybindings from sources
    for source in sources when not @isExceptedSource(source)
      atom.keymaps.removeBindingsFromSource(source)

  isExceptedSource: (source) ->

    if atom.config.get('remove-all-keybindings.exceptYourKeymap') and
       source.indexOf(path.join('.atom', 'keymap')) isnt -1
      return true

    if atom.config.get('remove-all-keybindings.exceptBaseKeymap') and
       source.indexOf('core:base') isnt -1
      return true

    if atom.config.get('remove-all-keybindings.exceptPlatformKeymap') and
       (source.indexOf('core:darwin') isnt -1 or source.indexOf('core:win32') isnt -1 or
        source.indexOf('core:linux') isnt -1)
      return true

    return false
