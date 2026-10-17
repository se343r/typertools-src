# Attribution

What this port carries from elsewhere, and under what terms. Everything not listed here is original
to the port and is MIT OR Apache-2.0 (`LICENSE-MIT`, `LICENSE-APACHE`).

## Carried over from TyperTools

| What | Title | Author | Source | Licence |
|---|---|---|---|---|
| The material this port reuses: interface strings, the style-library JSON shape, the geometry constants and the page layout | TyperTools 1.4.9 | © 2017 Swirt | https://github.com/Swirt/typertools-src at `8730704` | MIT |

TyperTools' `LICENSE.md` at the root of this repository is that notice, unmodified, and it covers the
row above: the MIT terms require the notice to travel with the material, which is why the port lives
in this repository next to the source it came from rather than in a tree of its own.

Because that licence permits it, this is a **port** rather than a clean-room reimplementation:
TyperTools' ExtendScript and React cannot run inside a WebAssembly panel, so the code is rewritten in
Rust, but what it says — the strings, the library format, the constants, the order of operations — is
read off `app_src/` and transliterated, which is also what lets the two be compared line by line.
Each constant in `src/geom.rs`, `src/props.rs` and `src/library.rs` names the file it came from. The
few rules that are deliberately *not* ported are listed in the module documentation of
`src/script.rs` and `src/library.rs`, with the reason.

## Deliberately not carried over

| Path | Why not |
|---|---|
| `app_src/lib/jam/*` | GPL v3+, © 2011–2016 Michel MARIANI. Taking it would relicense this port under the GPL, and it is ExtendScript helper code (`.jsxinc`) that a plug-in talking to PhotoCraft's own type engine has no use for. |
| `app_src/lib/CSInterface.js` | Adobe Systems, proprietary and not redistributable. There is no CEP host here to talk to. |
| `app_src/lib/topcoat/*` | Apache-2.0, © 2012 Adobe Systems Inc. — a CSS widget kit for a browser panel, plus bundled Source Sans Pro and Source Code Pro font files. The host draws this panel's widgets and supplies its own fonts, so there is nothing to style and nothing to ship. |
| `icons/*.png` | TyperTools' CEP panel icons. PhotoCraft draws the panel row itself; it has no per-plug-in icon surface. |

The `.json` style library this port reads and writes is TyperTools' own format, and the `type.*`
commands it drives are PhotoCraft's; neither is copied from the vendored material above.
