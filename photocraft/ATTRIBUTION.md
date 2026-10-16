# Attribution

What this port carries from elsewhere, and under what terms. Everything not listed here is original
to the port and is MIT OR Apache-2.0 (`LICENSE-MIT`, `LICENSE-APACHE`).

## Carried over from TypeR

| What | Title | Author | Source | Licence |
|---|---|---|---|---|
| The material this port reuses: interface strings, the style-library JSON shape, the geometry constants and the pane layout | TypeR 2.5.0 | © 2017 Swirt, with SeanR and Sakushi | https://github.com/ScanR/TypeR at `342be99` | MIT |

TypeR's `LICENSE.md` at the root of this repository is that notice, unmodified, and it covers the row
above: the MIT terms require the notice to travel with the material, which is why the port lives in
this repository next to the source it came from rather than in a tree of its own.

What is reused is carried over **as each part of TypeR is built** — the port began life as this
repository's TyperTools port retargeted to TypeR's own id (branch `master`), so today the tree holds
that shared groundwork, and TypeR's own strings, geometry and layout arrive with the features they
belong to. Anything reused lands with this file already covering it.

## Deliberately not carried over

| Path | Why not |
|---|---|
| `app_src/lib/jam/*` | GPL v3+, © 2011–2016 Michel MARIANI. Taking it would relicense this port under the GPL, and it is ExtendScript helper code (`.jsxinc`) that a plug-in talking to PhotoCraft's own type engine has no use for. |
| `app_src/lib/CSInterface.js` | Adobe Systems, proprietary and not redistributable. There is no CEP host here to talk to. |
| `app_src/lib/topcoat/*` | Apache-2.0, © 2012 Adobe Systems Inc. — a CSS widget kit for a browser panel; the host draws this panel's widgets, so there is nothing to style. Its bundled fonts are not used. |
| `icons/*.png` | TypeR's CEP panel icons. PhotoCraft draws the panel row itself; it has no per-plug-in icon surface. |

The Markdown and `.pcraft` files this port reads and writes are its own; the Photoshop-facing
formats it interoperates with (the `.json` style library, PSD text) are handled by PhotoCraft's
engine, not by anything copied from TypeR.
