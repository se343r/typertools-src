# TypeR for PhotoCraft

A **panel** plug-in for [PhotoCraft](https://github.com/storytold/photocraft) — plug-in ABI v2, the
native Rust image editor — that ports [TypeR](https://github.com/ScanR/TypeR) 2.5.0, the manga and
comic lettering panel for Adobe Photoshop, to the native app: its strings, its style-library format,
its geometry and its pane layout, driving PhotoCraft's own type engine.

This directory is that port, and it sits on branch `typer` of this repository, next to TypeR's own
source in the root (`app_src/`, `CSXS/`, `locale/`) — under TypeR's MIT licence that source is
reused rather than re-derived, so the two live together on purpose; see
[Licensing](#licensing) for the two things that stay out. The sibling branch `master` holds the same
kind of port of TypeR's ancestor, [TyperTools](https://github.com/Swirt/typertools-src) 1.4.9.

## Status

The port is built from TypeR 2.5.0 as its reference. What is here now is the workflow TypeR inherits
from TyperTools plus **TypeR's own features that need no host change** — its three-pane layout,
nested folders, folder-scoped prefix priority, `//` inheritance, ignore tags, markdown runs, RTL
direction, internal padding, resize-on-centre, both size steps, the quick style size, saved states
and both of its export shapes. It runs under its own id (`org.photocraft.typer`) so both ports can
be installed side by side. What remains is listed below.

| Where the work stands | |
|---|---|
| Working now | TypeR's three-pane layout and footer; script parsing with `//` inheritance and ignore tags; nested folders with folder-scoped prefix priority; Create / Insert / Align; `internalPadding` and `resizeTextBoxOnCenter`; the configurable layer size increment and style-size step; quick style size; markdown bold/italic runs; RTL direction; saved states; the style editor; import/export in TypeR's own and single-folder shapes as text |
| Next, reused rather than rewritten | TypeR's own locale files — nine languages, MIT — carried over as data instead of being re-translated (the panel is English only until that lands) |
| Next, needs a host allow-list row | Auto-centring without a selection (TypeR's bubble detection, on `select.magicWand`), multi-bubble mode, and the **stroke** a style carries (`layer.layerStyle.stroke`) |
| Next, needs new host surface | Pages (a file picker and document open/close/switch, which a panel is refused today), rebindable shortcuts (a panel contributes no commands), storage on disk for the library and states |
| Out of scope | TypeR's auto-updater (a panel has no network; PhotoCraft updates itself) and its seven themes (disabled in TypeR 2.5.0 itself; a panel here is on-theme for free) |

## The layout

TypeR is three stacked panes and a footer, in that order: the **preview** pane (the current line, its
style, the scale, Paste / Align, size −/+, previous/next), the **script** pane with a line-numbered
gutter, and the **style library** pane below it, with Help and Settings in the footer. The port keeps
that layout, not the page-tab layout the TyperTools port uses.

Two parts of it are not in the widget set the host draws today, and they are the two host widgets this
port is waiting on:

- a **draggable divider**, because TypeR's pane heights are adjusted by dragging (it stores the bottom
  pane's height as `bottomHeight`);
- a **line gutter** for the script pane — line numbers, the style prefix coloured per line, and the
  per-line insert arrow — where the `text` widget is a plain multiline field.

Until they exist the panes are drawn in TypeR's order but each is as tall as its widgets, and the
script is a plain multiline field (the line number and the style in use are named in the preview
pane instead of a gutter). Settings, Help and the style editor are TypeR modals; a panel window has
no modal, so they replace the panes and carry a Back button.

## What it does

A letterer pastes a script — one line of dialogue per row — tags a line with a style's prefix, and
sets it into the page in that style. The panel keeps a library of styles organised in folders, exports
and imports it in TypeR's JSON format, and drives the document through PhotoCraft's own type engine.

Everything the panel changes in the document goes through five engine commands — `type.create`,
`type.edit`, `type.setStyle`, `type.info`, `type.fonts` — which are exactly the five the host's
allow-list grants a panel that asks for `read` and `addLayers` (PhotoCraft's
`crates/engine/src/plugin_panel_cmds/permissions.rs`). Nothing else is reachable from it: no file, no
preference, no plug-in and no action. Growing that list is the host's decision, and the rows this port
needs are named in the status table above.

## Build

```sh
rustup target add wasm32-unknown-unknown
sh build.sh
```

`build.sh` runs `cargo build --release --target wasm32-unknown-unknown` and copies the module to
`typer.wasm` next to this README. This crate is not a member of any workspace: it builds for wasm only,
and nothing in it may reach a host crate. `cargo test` runs its ordinary unit tests — the plug-in's own
logic is pure Rust, and the ABI's guards are about the shipped module, not the test binary.

## Install

Needs a PhotoCraft with plug-in ABI v2 (the panel host; see that repository's `docs/plugins-v2.md`).
Then, from the app's control channel or the CLI:

```sh
plugin.install {"path": "photocraft/typer.wasm"}
plugin.panel.open {"id": "org.photocraft.typer"}
```

Or copy `typer.wasm` into the folder set in Edit › Preferences › Plug-ins (with *Use Additional
Plug-ins Folder* on); it then appears under Window › Plug-ins, and picking that row opens its window.

## Licensing

[TypeR](https://github.com/ScanR/TypeR) is MIT (© 2017 Swirt, the root `LICENSE.md`), so this port
**reuses its source** rather than re-deriving it: the interface strings, the style-library JSON shape,
the geometry constants and the pane layout are taken from TypeR as each part is built, and its MIT
notice travels with them (see `ATTRIBUTION.md`). Its locale files (`locale/messages.properties`, also
MIT) are reused the same way when the panel's text lands, so it can carry TypeR's own translations
instead of being English only.

Two things TypeR bundles are not TypeR's to give, and are **not** copied:

- `app_src/lib/jam/*` — GPL, © Michel MARIANI. Taking it would relicense this port under the GPL, and
  nothing needs it: the panel talks to PhotoCraft's own type engine, not to ExtendScript.
- `app_src/lib/CSInterface.js` — Adobe's, proprietary and not redistributable. There is no CEP host
  here to talk to anyway.

The rest of the port is MIT OR Apache-2.0 (`LICENSE-MIT`, `LICENSE-APACHE`, the same terms PhotoCraft
uses).
