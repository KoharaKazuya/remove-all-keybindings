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
    @removeAllKeybindings()

  removeAllKeybindings: ->

    # sources of keybindings
    sources = []
    for kb in atom.keymaps.getKeyBindings()
      sources.push kb.source unless kb.source in sources

    # remove keybindings from sources
    for source in sources
      unless @isExceptedSource(source)
        atom.keymaps.removeBindingsFromSource(source)

  isExceptedSource: (source) ->

    if atom.config.get('remove-all-keybindings.exceptYourKeymap') and
       source.indexOf(path.join('.atom', 'keymap')) isnt -1
      return true

    if atom.config.get('remove-all-keybindings.exceptBaseKeymap') and
       source.indexOf(path.join('app.asar', 'keymaps', 'base')) isnt -1
      return true

    if atom.config.get('remove-all-keybindings.exceptPlatformKeymap') and
       source.indexOf(path.join('app.asar', 'keymaps')) isnt -1 and
       (source.indexOf('darwin') isnt -1 or source.indexOf('win32') isnt -1 or
        source.indexOf('linux') isnt -1)
      return true

    return false
