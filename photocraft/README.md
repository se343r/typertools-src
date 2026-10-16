# TyperTools for PhotoCraft

A **panel** plug-in for [PhotoCraft](https://github.com/storytold/photocraft) — plug-in ABI v2, the
native Rust image editor — that ports this repository's
[TyperTools](https://github.com/Swirt/typertools-src) 1.4.9, the manga and comic lettering workflow
panel for Adobe Photoshop, to the native app as a clean-room Rust reimplementation.

This directory is that port. The original CEP/ExtendScript panel is untouched in this repository's
root (`app_src/`, `CSXS/`, `locale/`); nothing here is built from it, and nothing here is copied from
it — see [Licensing](#licensing).

It is the port PhotoCraft's panel ABI was designed for, and the largest thing that runs on it: about
6,500 lines of ordinary safe Rust, no `unsafe`, no imports, no JavaScript, and one `.wasm` module
(336,828 bytes) that is committed here so it can be installed without a Rust toolchain.

## What it does

A letterer pastes a script — one line of dialogue per row — tags a line with a style's prefix, and
sets it into the page in that style. The panel keeps a library of styles organised in folders,
exports and imports it in TyperTools' own JSON format, and drives the document through PhotoCraft's
own type engine.

| Page | Controls | Operations it sends |
|---|---|---|
| Lettering | the script box, line field and ◀ ▶ ⏮ ⏭ | `ui.set` for the values, nothing to the document |
| | Create / Insert / Align | `doc.info`, then `doc.command` → `type.create` / `type.edit`, one history step per action |
| | A− / A+ (size steps) | `doc.info`, `type.edit` — one document pixel of points, keeping the layer where it was |
| | Apply / Apply, keep size | `doc.command` → `type.setStyle` on every selected layer |
| Text size | 1–999 % | scales the size *and* the leading on Create and Insert, as TyperTools' does |
| Styles | style rows, the default style, the apply arrow | `type.setStyle`; the arrow with Ctrl (Apply, keep size) adopts the layer's current size first |
| Style editor | name, prefixes, colour, folder, font, face, size, leading, tracking, kerning, both scales, baseline shift, caps, align, faux bold/italic, underline, strike, ligatures, indents, space before/after, colour, anti-aliasing | `doc.command` → `type.fonts` for the two dropdowns and `type.create` / `type.setStyle` for a preview |
| Folders | add, rename, delete; a style changes folder in the editor's Folder list | carried in the style library, stored with it |
| Settings | point text or box text, ignore prefixes, text size default, starter library, reset | stored with the library |
| Help | what is here, what is not and why, the library as JSON (Show JSON / Load / Merge / Clear) | `storage.set` |

Everything the panel changes in the document goes through five engine commands — `type.create`,
`type.edit`, `type.setStyle`, `type.info`, `type.fonts` — which are exactly the five the host's
allow-list grants a panel that asks for `read` and `addLayers` (PhotoCraft's
`crates/engine/src/plugin_panel_cmds/permissions.rs`). Nothing else is reachable from it: no file, no
preference, no plug-in and no action.

## Build

```sh
rustup target add wasm32-unknown-unknown
sh build.sh
```

`build.sh` runs `cargo build --release --target wasm32-unknown-unknown` and copies the module to
`photocraft/typertools.wasm` next to this README (the committed one was built from this source by
exactly that command). This crate is not a member of any workspace: it builds for wasm only, and
nothing in it may reach a host crate.

## Install

Needs a PhotoCraft with plug-in ABI v2 (the panel host, `docs/plugins-v2.md` there; it lands with
[PR #6702](https://github.com/storytold/photocraft/pull/6702)). Then, from the app's control channel
or the CLI:

```sh
plugin.install {"path": "photocraft/typertools.wasm"}
plugin.panel.open {"id": "org.photocraft.typertools"}
```

Or copy `typertools.wasm` into the folder set in Edit › Preferences › Plug-ins (with *Use Additional
Plug-ins Folder* on); it then appears under Window › Plug-ins, and picking that row opens its window.

## What it answers

The reply to each event is a JSON **array** of operations, written into the buffer `pc_alloc` handed
out and returned as `len << 32 | ptr`; `0` means "nothing to say". The module exports the ABI v2
entry points and **imports nothing at all** — the host refuses any module that imports, so a panel
reaches the host by returning operations, never by calling into it.

No secrets, no files, and no network: a panel's whole outside world is `doc.info`, the commands it was
granted, and the key-value store the host keeps for it under the plug-in's own id.

## What is not ported, and why

Four of TyperTools' features have no equivalent in ABI v2 or in PhotoCraft's type engine yet. Each is
refused with a message on screen rather than silently doing nothing, or — where the difference is only
in the control — is a button instead of the gesture:

- **Keyboard shortcuts.** The three hotkey actions are buttons: ABI v2 has no command or shortcut
  contribution, so a panel cannot add one. On Wayland this is also the better answer — an in-app
  shortcut behaves, a system-global hotkey needs the XDG portal.
- **File dialogs for import/export.** The ABI has no file dialogs, so the library JSON is shown in a
  text box to copy out or paste in. The format is TyperTools' own, so a library still moves between
  Photoshop's TyperTools and this port.
- **Hanging punctuation (burasagari)** and **hyphenation rendering**: `type.edit` stores both, but
  PhotoCraft's line breaking applies neither yet.
- **The marquee is not touched.** TyperTools insets the selection by 10 px and clears it when it
  aligns; this port reads the selection and leaves it alone, because ABI v2 grants no selection
  command.
- **Dragging a style or folder to reorder it.** The widget set has no drag list, so the Styles and
  Folders pages move a row with Up/Down buttons — the same reorder, and the order is what decides
  which of two styles sharing a prefix wins.

## Licensing

Clean-room. Upstream TyperTools is MIT (© 2017 Swirt, this repository's `LICENSE.md`) and this port
reimplements its *behaviour*: no source, artwork, locale file or vendored library of it is copied, and
in particular the GPL `app_src/lib/jam/*` that TyperTools bundles (© Michel MARIANI) and Adobe's
proprietary `CSInterface.js` are not used at all — there is no ExtendScript here.

The port itself is MIT OR Apache-2.0 (`LICENSE-MIT`, `LICENSE-APACHE`, the same terms PhotoCraft
uses). Its interface is English only: TyperTools' own locale strings are MIT and could be reused with
attribution, but none are — the panel has one language until someone asks for a second.
