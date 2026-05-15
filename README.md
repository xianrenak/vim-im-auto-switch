# vim-im-auto-switch

A small Vim plugin for automatically switching macOS input sources when entering or leaving Insert mode.

This plugin is useful for people who write multilingual text in Vim, especially when using Chinese / Japanese / Korean input methods.  
It automatically switches to English input when leaving Insert mode, and restores the previous input source when entering Insert mode again.

The plugin uses [`im-select`](https://github.com/daipeihust/im-select) to control the macOS input source.

## 中文说明

`vim-im-auto-switch` 是一个基于 `im-select` 的 Vim 输入法自动切换插件。

它会在离开插入模式时自动切换到英文输入法，并在重新进入插入模式时恢复之前使用的输入法。

适合经常在 Vim 中混合使用中文、英文、日文、韩文输入的用户。

---

## Features

- Automatically switch to English input source when leaving Insert mode
- Restore the previous input source when entering Insert mode
- Save current input source when Vim loses focus during Insert mode
- Restore smartly when Vim gains focus again
- Optional `CursorHoldI` support to periodically save input source in Insert mode
- Configurable English input source
- Configurable `im-select` executable path
- Simple enable / disable commands

---

## Requirements

This plugin requires `im-select`.

Install it first:

```bash
brew install im-select
````

Or install it manually from:

```text
https://github.com/daipeihust/im-select
```

Make sure `im-select` is available in your shell:

```bash
im-select
```

Example output:

```text
com.apple.keylayout.ABC
```

---

## Installation

### Using vim-plug

Add this to your `.vimrc` or `init.vim`:

```vim
Plug 'xianrenak/vim-im-auto-switch'
```

Then run:

```vim
:PlugInstall
```

---

## Basic Usage

The plugin works automatically after installation.

Default behavior:

| Event         | Behavior                                                         |
| ------------- | ---------------------------------------------------------------- |
| `InsertEnter` | Restore last recorded input source                               |
| `InsertLeave` | Save current input source, then switch to English                |
| `FocusLost`   | Save input source if currently in Insert mode                    |
| `FocusGained` | Restore input source in Insert mode, otherwise switch to English |
| `CursorHoldI` | Save input source while staying in Insert mode                   |

---

## Configuration

### English input source

Default:

```vim
let g:im_auto_switch_english = 'com.apple.keylayout.ABC'
```

You can change it in your `.vimrc`:

```vim
let g:im_auto_switch_english = 'com.apple.keylayout.ABC'
```

To find your current input source ID, run:

```bash
im-select
```

Common macOS English input source:

```text
com.apple.keylayout.ABC
```

---

### Custom `im-select` path

If `im-select` is not available in Vim, set the full path manually.

For Intel Mac:

```vim
let g:im_auto_switch_im_select_path = '/usr/local/bin/im-select'
```

For Apple Silicon Mac:

```vim
let g:im_auto_switch_im_select_path = '/opt/homebrew/bin/im-select'
```

---

### Enable or disable the plugin

Default:

```vim
let g:im_auto_switch_enabled = 1
```

Disable by default:

```vim
let g:im_auto_switch_enabled = 0
```

---

### Configure `updatetime`

The plugin uses `CursorHoldI` to save the input source while staying in Insert mode.

Default:

```vim
let g:im_auto_switch_updatetime = 1000
```

This means Vim triggers `CursorHoldI` after 1000ms of no key input.

You can change it:

```vim
let g:im_auto_switch_updatetime = 500
```

Or disable `CursorHoldI` behavior:

```vim
let g:im_auto_switch_use_cursorhold = 0
```

---

## Recommended Configuration

```vim
let g:im_auto_switch_english = 'com.apple.keylayout.ABC'
let g:im_auto_switch_updatetime = 1000
let g:im_auto_switch_use_cursorhold = 1

Plug 'xianrenak/vim-im-auto-switch'
```

If needed:

```vim
let g:im_auto_switch_im_select_path = '/opt/homebrew/bin/im-select'
```

---

## Commands

### Enable plugin

```vim
:ImAutoSwitchEnable
```

### Disable plugin

```vim
:ImAutoSwitchDisable
```

### Manually switch to English

```vim
:ImAutoSwitchEnglish
```

### Manually restore last input source

```vim
:ImAutoSwitchRestore
```

---

## Example Workflow

Suppose your current input source is Chinese.

1. Enter Insert mode.
2. Type Chinese text.
3. Press `Esc`.
4. The plugin records the Chinese input source and switches to English.
5. Use Normal mode commands safely.
6. Enter Insert mode again.
7. The plugin restores the previous Chinese input source.

This avoids accidental Normal mode commands being interpreted through a non-English input method.

---

## Troubleshooting

### `im-select` does not work in Vim

Check whether Vim can find `im-select`:

```vim
:echo executable('im-select')
```

If it returns `0`, set the full path manually:

```vim
let g:im_auto_switch_im_select_path = '/opt/homebrew/bin/im-select'
```

or:

```vim
let g:im_auto_switch_im_select_path = '/usr/local/bin/im-select'
```

---

### Find the correct English input source ID

Switch your macOS input source to English, then run:

```bash
im-select
```

Use the returned value:

```vim
let g:im_auto_switch_english = 'your.input.source.id'
```

Example:

```vim
let g:im_auto_switch_english = 'com.apple.keylayout.ABC'
```

---

### Input source is not restored correctly after focus changes

You can enable `CursorHoldI` saving:

```vim
let g:im_auto_switch_use_cursorhold = 1
let g:im_auto_switch_updatetime = 1000
```

This allows the plugin to periodically record your current input source while you remain in Insert mode.

---

## Notes

This plugin is designed mainly for macOS.

It depends on `im-select`, so it should work as long as `im-select` supports your environment.

---

## License

MIT

