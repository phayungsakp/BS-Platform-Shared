# BS Platform — Design System

## 1. Visual Theme & Atmosphere

BS Platform is an enterprise-grade admin panel and management system, designed with a clean, professional aesthetic that balances data density with visual clarity. The interface is structured around a persistent sidebar navigation + top header bar layout, where the primary color (configurable via 6 theme presets) permeates the header bar, active states, and interactive elements — while the content area remains neutral white/gray to let data breathe.

The design philosophy is **functional minimalism for enterprise**: every component exists to serve data management workflows — CRUD operations, data grids, filtering, and form inputs. The UI retreats behind the data, using subtle color accents, clean typography, and consistent spacing to create a professional, uncluttered workspace. Dark mode transforms the interface into a glassmorphism-inspired experience with translucent surfaces, subtle glows, and high-contrast accent colors.

The typography anchors everything. **Prompt** (Thai-optimized Google Font) is the primary typeface, paired with Roboto as fallback. At heading sizes, weights 600–700 with tight line-heights create authoritative, space-efficient headlines. At body sizes, the text opens up with comfortable 1.5–1.6 line-heights for readable data labels and descriptions. Font sizes use `clamp()` for fluid responsive scaling.

The color story is **theme-adaptive**. Six configurable palettes (Indigo, Blue, Purple, Teal, Orange, Soft Pastel) allow organizations to brand the platform, but the structural color roles remain constant: primary color dominates the header bar and interactive elements, while semantic colors (green for success, red for error, yellow for warning, blue for info) are fixed across all themes. This ensures consistency regardless of which palette is active.

**Key Characteristics:**

- Prompt + Roboto font pairing — Thai-first with Latin fallback, fluid `clamp()` sizing
- 6 switchable theme palettes: Indigo (default), Blue, Purple, Teal, Orange, Soft Pastel
- Dual mode: Clean Light mode + Glassmorphism Dark mode with translucent surfaces
- Sidebar + Header Bar persistent layout — sidebar at 280px expanded, 72px collapsed
- Data-grid-centric design — MUI X DataGrid Pro powers all tabular views
- Consistent CRUD patterns: Add Record button → Modal form → Grid display → Edit/Delete actions
- Enterprise color coding: YES/NO status chips, priority flags, progress bar color ranges
- SweetAlert2 integration for confirmations with theme-aware dark mode styling
- `textTransform: "none"` globally — no uppercase button text, professional and readable
- Global `borderRadius: 12` with component-specific overrides (Cards: 16, Buttons: 8, Chips: 6)

---

## 2. Color Palette & Roles

### 2.1 Theme Presets (Light Mode)

BS Platform supports 6 configurable color palettes. Each provides a full shade scale (50–900) used for primary, secondary, and accent variations.

| Preset               | Key (ID)       | Primary (500)         | Secondary (600) | Light (200) | Dark (700) |
| -------------------- | -------------- | --------------------- | --------------- | ----------- | ---------- |
| **Indigo** (default) | `theme-1`      | `#3f51b5`             | `#3949ab`       | `#9fa8da`   | `#303f9f`  |
| Blue                 | `theme-2`      | `#5677fc`             | `#4e6cef`       | `#afbfff`   | `#455ede`  |
| Purple               | `theme-purple` | `#9c27b0`             | `#8e24aa`       | `#ce93d8`   | `#7b1fa2`  |
| Teal                 | `theme-teal`   | `#009688`             | `#00897b`       | `#80cbc4`   | `#00796b`  |
| Orange               | `theme-orange` | `#ff8a4b`             | `#ef7724`       | `#fed7aa`   | `#c75f1b`  |
| Soft Pastel          | `theme-pastel` | `#9BC2B2` / `#B6BBC7` | `#D6C3CE`       | `#F2E9D3`   | `#ECD4D4`  |

### 2.2 Semantic Colors (Fixed Across Themes)

| Role        | Main      | Light     | Dark      | Usage                                            |
| ----------- | --------- | --------- | --------- | ------------------------------------------------ |
| **Error**   | `#EF4444` | `#F87171` | `#DC2626` | Validation errors, delete actions, close buttons |
| **Warning** | `#F59E0B` | `#FBBF24` | `#D97706` | Caution alerts, pending states                   |
| **Info**    | `#3B82F6` | `#60A5FA` | `#2563EB` | Informational messages, normal priority          |
| **Success** | `#10B981` | `#34D399` | `#059669` | Save confirmations, active status                |

### 2.3 Surface & Background (Light Mode)

| Element                   | Color                  | Usage                                    |
| ------------------------- | ---------------------- | ---------------------------------------- |
| **Page background**       | `#F6F7FA`              | Main content area behind grids and cards |
| **Paper/Card background** | `#FFFFFF`              | Cards, modals, sidebar, content panels   |
| **Paper tinted**          | `alpha(primary, 0.04)` | Subtle tinted surfaces                   |
| **Column header**         | `alpha(primary, 0.05)` | DataGrid column header row               |
| **Table header**          | `alpha(primary, 0.06)` | Standard table head                      |
| **Row hover**             | `alpha(primary, 0.03)` | DataGrid row hover state                 |
| **Selected item**         | `alpha(primary, 0.14)` | Active sidebar menu item                 |
| **Hover item**            | `alpha(primary, 0.08)` | Sidebar hover state                      |
| **Accordion header**      | preset shade `100`     | Collapsible section headers              |
| **Accordion content**     | `#fafafa`              | Expanded section body                    |
| **Divider**               | `alpha(primary, 0.18)` | Separators between sections              |

### 2.4 Text Colors (Light Mode)

| Role               | Color     | Usage                                |
| ------------------ | --------- | ------------------------------------ |
| **Primary text**   | `#212121` | Headings, labels, primary content    |
| **Secondary text** | `#424242` | Descriptions, secondary labels       |
| **Contrast text**  | `#FFFFFF` | Text on primary-colored backgrounds  |
| **Close button**   | `#F33838` | Cancel/Close button text and borders |

### 2.5 Grey Scale

| Level | Color     | Usage               |
| ----- | --------- | ------------------- |
| 50    | `#F9FAFB` | Lightest background |
| 100   | `#F3F4F6` | Subtle backgrounds  |
| 200   | `#E5E7EB` | Borders, dividers   |
| 300   | `#D1D5DB` | Disabled borders    |
| 400   | `#9CA3AF` | Placeholder text    |
| 500   | `#6B7280` | Muted text          |
| 600   | `#4B5563` | Secondary text      |
| 700   | `#374151` | Primary text alt    |
| 800   | `#1F2937` | Dark text           |
| 900   | `#111827` | Darkest text        |

### 2.6 Functional Colors

| Element                      | Color                    | Context                      |
| ---------------------------- | ------------------------ | ---------------------------- |
| **Status YES**               | `#10B981` (success.main) | Active/Yes chip in DataGrid  |
| **Status NO**                | `#EF4444` (error.main)   | Inactive/No chip in DataGrid |
| **Priority Urgent**          | `#d32f2f`                | Task priority flag           |
| **Priority High**            | `#ed6c02`                | Task priority flag           |
| **Priority Normal**          | `#0288d1`                | Task priority flag           |
| **Priority Low**             | `#9e9e9e`                | Task priority flag           |
| **Progress ≥ 100%**          | `#619c18`                | Progress bar (green)         |
| **Progress ≥ 50%**           | `#ffcd00`                | Progress bar (yellow)        |
| **Progress < 50%**           | `#e20015`                | Progress bar (red)           |
| **Progress track**           | `#e0e0e0`                | Progress bar background      |
| **Switch ON (light)**        | `#65C466`                | iOS-style toggle checked     |
| **Switch ON (dark)**         | `#2ECA45`                | iOS-style toggle checked     |
| **Switch track OFF (light)** | `#E9E9EA`                | iOS-style toggle unchecked   |
| **Switch track OFF (dark)**  | `#39393D`                | iOS-style toggle unchecked   |

### 2.7 Dark Mode — Glassmorphism Palette

| Role                   | Color                           | Notes                     |
| ---------------------- | ------------------------------- | ------------------------- |
| **Primary**            | `#00D4FF` (Vibrant Cyan)        | Main interactive elements |
| **Secondary**          | `#A855F7` (Electric Purple)     | Complementary accent      |
| **Error**              | `#FF6B6B` (Soft Coral Red)      |                           |
| **Warning**            | `#FFD93D` (Golden Yellow)       |                           |
| **Info**               | `#4ECDC4` (Teal Cyan)           |                           |
| **Success**            | `#6BCB77` (Fresh Green)         |                           |
| **Background default** | `#0D0D0F`                       | Near Black                |
| **Background paper**   | `rgba(20, 20, 25, 0.98)`        | Glass Card surface        |
| **Glass card**         | `rgba(20, 20, 25, 0.96)`        | Primary glass surface     |
| **Glass card hover**   | `rgba(30, 30, 38, 0.95)`        | Hover state               |
| **Glass border**       | `rgba(255, 255, 255, 0.08)`     | Subtle edge               |
| **Glass border hover** | `rgba(255, 255, 255, 0.15)`     | Hover edge                |
| **Glass blur**         | `blur(12px)`                    | Backdrop filter           |
| **Glass shadow**       | `0 8px 32px rgba(0, 0, 0, 0.5)` | Depth                     |
| **Text primary**       | `#FFFFFF`                       |                           |
| **Text secondary**     | `#A0A0A0`                       |                           |
| **Divider**            | `rgba(255, 255, 255, 0.08)`     |                           |
| **SweetAlert popup**   | `#252526`                       | Modal background          |
| **SweetAlert text**    | `#D4D4D4`                       | Title text                |
| **SweetAlert content** | `#9D9D9D`                       | Body text                 |
| **SweetAlert confirm** | `#007ACC`                       | Confirm button            |
| **SweetAlert cancel**  | `#3C3C3C`                       | Cancel button             |
| **SweetAlert deny**    | `#F14C4C`                       | Deny/delete button        |
| **SweetAlert input**   | `#1E1E1E` bg, `#3C3C3C` border  | Input fields              |

### 2.8 Glow Effects (Dark Mode Only)

| Color          | Value                               |
| -------------- | ----------------------------------- |
| Primary glow   | `0 0 20px rgba(0, 212, 255, 0.3)`   |
| Secondary glow | `0 0 20px rgba(168, 85, 247, 0.3)`  |
| Success glow   | `0 0 20px rgba(107, 203, 119, 0.3)` |
| Error glow     | `0 0 20px rgba(255, 107, 107, 0.3)` |

---

## 3. Typography Rules

### 3.1 Font Family

- **Primary:** `'Prompt', 'Roboto', 'Inter', 'Helvetica', 'Arial', sans-serif`
- **Body fallback:** `'Roboto', -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Oxygen', 'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue', sans-serif`
- **Code:** `source-code-pro, Menlo, Monaco, Consolas, 'Courier New', monospace`
- **Font smoothing:** `-webkit-font-smoothing: antialiased; -moz-osx-font-smoothing: grayscale`

> **Note:** Prompt is a Thai-optimized Google Font that provides excellent readability for both Thai and Latin characters. It's the primary display font for all UI text.

### 3.2 Type Scale

| Variant    | Size                               | Weight | Line Height | Letter Spacing | Usage                                         |
| ---------- | ---------------------------------- | ------ | ----------- | -------------- | --------------------------------------------- |
| **h1**     | `clamp(2rem, 4vw, 2.75rem)`        | 700    | 1.2         | `-0.02em`      | Page titles, hero headings                    |
| **h2**     | `clamp(1.75rem, 3.2vw, 2.25rem)`   | 700    | 1.3         | `-0.01em`      | Section headings                              |
| **h3**     | `clamp(1.5rem, 2.8vw, 2rem)`       | 600    | 1.3         | —              | Sub-section headings                          |
| **h4**     | `clamp(1.25rem, 2.2vw, 1.75rem)`   | 600    | 1.4         | —              | Card titles                                   |
| **h5**     | `clamp(1.1rem, 1.8vw, 1.5rem)`     | 600    | 1.4         | —              | Dialog titles                                 |
| **h6**     | `clamp(1rem, 1.5vw, 1.25rem)`      | 600    | 1.4         | —              | Sidebar group headers, toolbar titles         |
| **body1**  | `clamp(0.875rem, 1vw, 0.9375rem)`  | 400    | 1.6         | —              | Primary body text, form labels                |
| **body2**  | `clamp(0.8rem, 0.9vw, 0.8125rem)`  | 400    | 1.5         | —              | Secondary text, descriptions                  |
| **button** | `clamp(0.75rem, 0.9vw, 0.8125rem)` | 600    | —           | `0.01em`       | Button labels, always `textTransform: "none"` |

### 3.3 Component-Level Typography

| Context            | Size               | Weight | Notes                                       |
| ------------------ | ------------------ | ------ | ------------------------------------------- |
| Toolbar buttons    | `0.8125rem` (13px) | 500    | Add Record, filter buttons                  |
| Grid cell text     | `0.875rem` (14px)  | 400    | DataGrid cell content                       |
| Grid tooltip       | `0.875rem` (14px)  | 400    | Cell overflow tooltips                      |
| Sidebar menu items | `0.85rem`          | 400    | Navigation text                             |
| Switch label       | `0.75rem` (12px)   | 400    | iOS toggle label                            |
| Switch value       | `0.875rem` (14px)  | 400    | YES/NO text                                 |
| Notification chip  | `0.65rem` (~10px)  | 600    | "New" badge                                 |
| Avatar initials    | `0.875rem` (14px)  | 600    | User circle text                            |
| Quick filter input | `0.875rem` (14px)  | 400    | Search field text                           |
| Bulk edit buttons  | `0.75rem` (12px)   | 500    | Inline editing mini buttons                 |
| Login subtitle     | `0.8rem`           | 400    | Login page subtitle                         |
| Login button       | `1rem` (16px)      | 700    | Submit button                               |
| Popup title        | h3 variant         | 800    | Banner notification title                   |
| Popup description  | `1.1rem`           | 400    | Banner notification body, `lineHeight: 1.5` |
| Version label      | caption            | 500    | Login page version text                     |

### 3.4 Principles

- **Thai-first typography**: Prompt font is optimized for Thai script rendering. All UI text including headings, labels, and body text must display Thai characters correctly.
- **Fluid scaling**: All heading and body sizes use `clamp()` for responsive scaling without breakpoint jumps. This ensures smooth typography transition across screen sizes.
- **No uppercase**: `textTransform: "none"` is set globally on buttons. The platform uses sentence case everywhere for a professional, non-shouting appearance.
- **Weight restraint**: The scale spans 400 (regular) to 700 (bold). Weight 800 appears only in popup notification titles. Most text lives at 400 and 600.
- **Negative tracking on headings**: Only h1 (`-0.02em`) and h2 (`-0.01em`) use negative letter-spacing. Body text uses default tracking for readability.

---

## 4. Component Stylings

### 4.1 Buttons

**Global Button Override (MuiButton):**

- Border radius: `8px`
- Text transform: `"none"` (no uppercase)
- Font weight: `600`
- Padding: `10px 20px`
- Contained variant: `boxShadow: "none"` at rest; hover adds `shadows[3]`

**Primary Save Button (BSSaveOutlinedButton):**

- Variant: outlined
- Color: `theme.palette.custom.saveButton` or `primary.main`
- Border: `1px solid` primary color
- Hover: fills background with primary color, text becomes `#FFFFFF` (light) / `#000000` (dark)
- Focus/Active: uses `primary.dark`
- Use: Save actions in forms, modals

**Close/Cancel Button (BSCloseOutlinedButton):**

- Variant: outlined
- Color: `theme.palette.custom.closeButton` (`#F33838`) or `error.main`
- Border: `1px solid` error color
- Hover: fills background with error color, text becomes `#FFFFFF` (light) / `#000000` (dark)
- Use: Cancel, close, discard actions

**Toolbar Add Button:**

- Variant: `outlined`
- Size: `small`
- Font: `0.8125rem`, weight `500`
- Min height: `32px`
- Padding: `4px 8px`
- Border: `1px solid` primary color
- Hover: fills background with primary color, text becomes contrast color
- Split variant: `ButtonGroup` with dropdown arrow for additional options

**Filter Action Buttons:**

- Search: `contained`, `color="primary"`, `minWidth: 100`
- Clear: `outlined`, `color="secondary"`, `minWidth: 100`

**Login Submit Button:**

- Padding: `py: 1.6` (12.8px vertical)
- Border radius: `2.5` (20px) — pill-shaped
- Font: `1rem`, weight `700`
- Background: `linear-gradient(90deg, primary.main, primary.dark)` — reverses direction on hover
- Full width

### 4.2 Cards & Containers

- **MuiCard:** `borderRadius: 16`, `border: "none"`
- **MuiPaper:** `borderRadius: "unset"` (override — flat surfaces for layout panels)
- **Login Card:** `maxWidth: 480`, `borderRadius: 4` (32px), `elevation: 8`, `backdropFilter: "blur(12px)"`, `boxShadow: "0 16px 40px rgba(16, 24, 40, 0.12)"`
- **MuiChip:** `borderRadius: 6`, `fontWeight: 500`
- **Filter Panel (BSFilterCustom):** Paper wrapped, padding `{ xs: 1, md: 2 }`

### 4.3 Navigation — Header Bar (AppBar)

- **Position:** `fixed`, `zIndex: drawer + 1`
- **Light mode:** Background = `theme.palette.primary.main`, text = `#fff`, bottom border = `primary.dark`
- **Dark mode:** Background = `background.paper`, text = `text.primary`, bottom border = `divider`
- **Backdrop:** `backdropFilter: "blur(8px)"`
- **Typography in light mode:** `color: #fff`, `fontWeight: 700`, `textShadow: "0 1px 2px rgba(0, 0, 0, 0.35)"`
- **Icon buttons in light mode:** `color: #fff`, `textShadow: "0 1px 2px rgba(0, 0, 0, 0.35)"`
- **Height:** Standard MUI toolbar height (~64px), content area = `calc(100vh - 80px)`
- **Responsive:** When sidebar open, shifts right by `drawerWidth` (280px). When collapsed, full width.

**Header Right Actions (left to right):**

1. `LanguageSwitch` — flag icon toggle (TH/EN)
2. `Brightness4Icon` / `Brightness7Icon` — dark/light mode toggle
3. `PaletteIcon` — theme color palette picker
4. `NotificationsIcon` with `Badge` (unread count) — notification bell
5. `Avatar` — user menu (initials-based, 32x32)

### 4.4 Navigation — Sidebar

- **Width expanded:** `280px`
- **Width collapsed:** `72px`
- **Background:** `theme.palette.background.paper`
- **Border right:** `"none"`
- **Transition:** `sharp` easing on width changes

**Logo Area (DrawerHeader):**

- Flex layout with app name + collapse button (`ChevronLeftIcon`)
- On mobile: temporary drawer overlay

**Search Box:**

- `SearchIcon` adornment
- `InputBase` with full width

**Menu Items:**

- Min height: `44px`
- Padding: `px: 1.5, py: 1`
- Margin bottom: `0.5` (4px)
- Border radius: `1.5` (12px)
- Font size: `0.85rem`
- Icon color: `text.secondary`
- Text color: `text.primary`

**Menu Item States:**

- **Hover:** `bgcolor: alpha(primary, 0.08)`
- **Selected/Active:** `bgcolor: alpha(primary, 0.14)`, icon color changes to `primary.main`, left accent bar appears (4px wide × 20px tall, `borderRadius: 4`, primary color, vertically centered via `::before` pseudo-element)
- **Selected hover:** `bgcolor: alpha(primary, 0.2)`

**Submenu Items:**

- Tree-style connector lines (vertical + horizontal)
- `Star` / `StarBorder` icons for favorites (toggle pinning)
- Expand/collapse: `ExpandMore` / `ExpandLess` icons

**Sidebar Icon Mapping:**
| Index | Icon | Menu Group |
|-------|------|------------|
| 0 | `StarIcon` | Favorite |
| 1 | `HouseIcon` | Home |
| 2 | `GroupIcon` | Authentication |
| 3 | `SettingsIcon` | Configs |
| 4 | `ImportExportIcon` | Import/Master |
| 5 | `LocalOfferIcon` | Master/Tags |
| 7 | `QueryStatsIcon` | Performance |
| 8 | `EmojiEventsIcon` | Awards/Incentive |
| default | `MenuOpenIcon` | Fallback |

### 4.5 Data Grid (BSDataGrid / DataGridPro)

**Global MuiDataGrid Override:**

- Column headers bg: `alpha(primary, 0.05)`
- Row hover: `alpha(primary, 0.03)`
- Border color: `theme.palette.divider`

**Toolbar Layout:**

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ [+ Add Record ▾]      🔍 Search... [Enter]   Show Filters  🔄  |||  ≡  ≡  ↓ │
└──────────────────────────────────────────────────────────────────────────────┘
```

- **Left:** Add Record button (outlined, with optional `ButtonGroup` split for dropdown)
- **Right:** Quick filter search (Enter-to-search, clear X), Header filter toggle, Refresh button, Column visibility (`|||`), Filter funnel, Density toggle (`≡`), Export dropdown (Excel/CSV/Print via `FileDownload` icon)

**Row Action Icons:**

- Column 1: `Edit` icon (pencil) — opens edit modal
- Column 2: `Delete` icon (trash) — opens SweetAlert2 confirmation
- Column 3: `#` row number
- Remaining: data columns

**Cell Overflow:**

- `OverflowTooltipCell`: `textOverflow: "ellipsis"`, `whiteSpace: "nowrap"`, tooltip delay 500ms, max tooltip width 400px

**Avatar Cells:**

- Size: 32x32px
- Background: hash-based color generation from text

**Pagination:**

- "Rows per page: 20 ▼" dropdown | "1~20 of N" text | First/Prev/Next/Last page buttons

### 4.6 Form Inputs

**BSTextField:**

- Wraps MUI `TextField` with `FormControl`
- Types: `string`, `int`, `float`/`decimal` (with precision/scale validation)
- Character count display (`showCharacterCount` + `maxLength`)
- `borderLeftRadius` prop for composite filter groups (sets `"unset"` on left radius)
- Error state: `FormHelperText` + red border
- Helper text spacing: `mt: 0.5, px: 1.5`

**BSAutoComplete:**

- Wraps MUI `Autocomplete`
- Modes: `single` (default), `multi`, `select`
- Debounced API search: 300ms delay
- Request dedup: 1500ms TTL cache
- `borderLeftRadius` support for filter groups
- `bsFlagColor` mode: shows colored `FlagIcon` with priority colors
- `bsLoadOnOpen`: lazy-load options when dropdown opens

**BSDatepicker:**

- Wraps MUI X `DatePicker` / `DateTimePicker` / `DateRangePicker`
- Default format: `DD/MM/YYYY`
- Range mode: `isRange` prop
- Date-only mode: `isDateOnly` prop
- `borderLeftRadius` support for filter groups
- Error state: `borderColor: "red"`

**BSSwitchField (iOS-style Toggle):**

- Track: width `42px`, height `26px`, border radius `13px`
- Thumb: `22x22px`, white, with shadow `0 2px 4px 0 rgb(0 35 11 / 20%)`
- Checked color (light): `#65C466`, (dark): `#2ECA45`
- Focus visible: `#33cf4d` with `6px solid #fff` border
- Values: `YES` / `NO` (configurable)
- Floating label: positioned absolutely `top: -14, left: 12`
- Container min height: `38px`, padding: `px: 1.5, py: 1`, border radius: `1` (8px)

### 4.7 Filter System (BSFilterCustom)

- Multi-row filter panel with operator + value pairs
- **Operator column:** `BsAutoComplete` with `borderRightRadius: "unset"` (left segment)
- **Value column:** Input with `borderLeftRadius: "unset"` (right segment, seamless join)
- **Supported value types:** BSAutoComplete, BSDatepicker, BSTextField
- **"Between" mode:** dual date/number inputs
- **Grid layout:** `xs: 12, sm: 6, md: 4, lg: 3` per filter field
- **Action buttons:** Search (`contained primary`) + Clear (`outlined secondary`), `minWidth: 100`

### 4.8 Dialogs & Modals

**Standard Dialog Pattern:**

- `maxWidth` variants: `"sm"` (reset password), `"md"` (notifications), `"lg"` (popups)
- `fullWidth` always
- Header: primary background + contrast text (for notification dialog)

**SweetAlert2 Integration (BSAlertSwal2):**

- Z-index: `50000` (container), `50001` (popup) — above all MUI dialogs
- Position: `"center"`, `allowOutsideClick: false`
- Light mode confirm: `#d33` (red), cancel: `#3085d6` (blue)
- Dark mode: popup `#252526`, text `#D4D4D4`, confirm `#007ACC`, cancel `#3C3C3C`, deny `#F14C4C`
- Input fields (dark): bg `#1E1E1E`, border `#3C3C3C`

**Snackbar (BSAlertSnackbar):**

- Default duration: `5000ms`
- Default severity: `"info"`
- Default variant: `"filled"`
- Default position: `vertical: "center", horizontal: "center"`

**Popup Notification (Banner Carousel):**

- Full-screen image carousel, `maxWidth: "lg"`
- Auto-rotate: 4000ms interval
- Keyboard navigation (left/right arrow keys)
- Full-bleed image with `objectFit: "contain"`
- Bottom gradient overlay: `linear-gradient(180deg, rgba(0,0,0,0) 0%, rgba(0,0,0,0.3) 40%, rgba(0,0,0,0.7) 100%)`
- Navigation: chevron arrows on sides (`rgba(0, 0, 0, 0.45)`, hover `rgba(0, 0, 0, 0.65)`)
- Pagination dots: 10x10px circles, inactive `rgba(255,255,255,0.4)`, active white
- Title text shadow: `0 2px 8px rgba(0,0,0,0.8)`
- CTA button: `contained`, `fontWeight: 600`, `px: 3, py: 1`

### 4.9 Linear Progress

**TopLinearProgress:**

- Position: `fixed`, top aligned to toolbar bottom
- Width: 100%
- Color: primary theme color
- Appears during page transitions and API loading

**BSLinearProgressWithLabel:**

- Height: configurable
- Border radius: `5px`
- Track: `#e0e0e0`
- Color by percentage:
  - `≥ 100%`: `#619c18` (green — complete)
  - `≥ 50%`: `#ffcd00` (yellow — in progress)
  - `< 50%`: `#e20015` (red — behind)

### 4.10 Breadcrumbs

- MUI `<Breadcrumbs>` component
- Display: `"contents"` (inline with header)
- Margin bottom: `mb: 2`
- Last segment: `<Typography color="text.primary">` (no link, current page)
- Other segments: `<Link color="inherit" underline="hover">` with router navigation
- Labels resolved through `useResource()` with resource group `"Menu"`
- Path segments are decoded, split by `_`, and title-cased

### 4.11 Language Switch

- Flag-based toggle (TH 🇹🇭 / EN 🇬🇧)
- `IconButton` with `borderRadius: 2` (16px), padding `1.5`
- Placed in header bar right section

---

## 5. Layout Principles

### 5.1 Main Layout Structure

```
┌─────────────────────────────────────────────────────────────────┐
│ AppBar (fixed, z-index: drawer+1)                              │
│ [☰ Toggle] [App Name] [Breadcrumbs]    [🌐][🌙][🎨][🔔][👤]  │
├──────────┬──────────────────────────────────────────────────────┤
│ Sidebar  │  Main Content Area                                  │
│ 280px /  │  width: 100%                                        │
│ 72px     │  height: calc(100vh - 80px)                         │
│          │  bgcolor: background.default (#F6F7FA)              │
│          │  overflow: auto                                      │
│          │                                                      │
│ [Search] │  ┌── Page Title ──────────────────────────────┐     │
│ [⭐ Fav] │  │  [Toolbar: + Add Record | Search | Filters]│     │
│ [🏠 Home]│  │  ┌── DataGrid ───────────────────────────┐ │     │
│ [👥 Auth]│  │  │ Actions | # | Col1 | Col2 | Status    │ │     │
│ [⚙ Conf]│  │  │ ✏ 🗑   | 1 | ...  | ...  | YES       │ │     │
│ [📦 Mast]│  │  │ ✏ 🗑   | 2 | ...  | ...  | NO        │ │     │
│ [📥 Imp] │  │  └─────────────────────────────────────────┘ │     │
│ [📋 Proj]│  │  Rows per page: 20 ▼  1~20 of 100  < >       │     │
│ [📊 Perf]│  └───────────────────────────────────────────────┘     │
├──────────┴──────────────────────────────────────────────────────┤
│ TopLinearProgress (fixed, appears during loading)               │
└─────────────────────────────────────────────────────────────────┘
```

### 5.2 Spacing System

- **Base unit:** `8px` (MUI default)
- **Theme spacing function:** `theme.spacing(n)` = `n × 8px`
- **Global border radius:** `12px` (with component overrides)

| Context                          | Value (spacing units) | Pixels              |
| -------------------------------- | --------------------- | ------------------- |
| Sidebar item padding             | `px: 1.5, py: 1`      | 12px × 8px          |
| Sidebar item margin-bottom       | `0.5`                 | 4px                 |
| Notification item padding        | `px: 3, py: 2`        | 24px × 16px         |
| Card content padding             | `xs: 3, md: 4`        | 24px / 32px         |
| Filter panel padding             | `xs: 1, md: 2`        | 8px / 16px          |
| Toolbar container padding-bottom | `4px`                 | 4px                 |
| BSTextField helper spacing       | `mt: 0.5, px: 1.5`    | 4px top, 12px sides |
| Quick filter input padding       | `5px 8px`             | 5px × 8px           |
| Button padding (global)          | `10px 20px`           | 10px × 20px         |
| Toolbar button padding           | `4px 8px`             | 4px × 8px           |
| Popup bottom bar                 | `px: 3, py: 3`        | 24px × 24px         |
| Dialog form spacing              | `mt: 2`               | 16px between fields |

### 5.3 Responsive Breakpoints

MUI default breakpoints with component-specific adaptations:

| Breakpoint | Width   | Key Changes                                              |
| ---------- | ------- | -------------------------------------------------------- |
| xs         | 0px+    | Single column filters, mobile sidebar (temporary drawer) |
| sm         | 600px+  | 2-column filters, compact toolbar                        |
| md         | 900px+  | Persistent sidebar, 4-column filters                     |
| lg         | 1200px+ | Full layout, 3-column filters                            |
| xl         | 1536px+ | Extended width layout                                    |

**Sidebar Responsive Behavior:**

- **Desktop (≥ md):** Persistent drawer, collapsible between 280px and 72px
- **Mobile (< md):** Temporary overlay drawer, full 280px width

**Filter Grid (BSFilterCustom):**

- `xs: 12` — full width
- `sm: 6` — 2 columns
- `md: 4` — 3 columns
- `lg: 3` — 4 columns

### 5.4 Border Radius Scale

| Context                     | Value     | Pixels            |
| --------------------------- | --------- | ----------------- |
| **Global default**          | `12`      | 12px              |
| **MuiCard**                 | `16`      | 16px              |
| **MuiButton**               | `8`       | 8px               |
| **MuiChip**                 | `6`       | 6px               |
| **MuiPaper**                | `"unset"` | 0px (flat panels) |
| **Sidebar menu item**       | `1.5`     | 12px              |
| **LanguageSwitch button**   | `2`       | 16px              |
| **Login card**              | `4`       | 32px              |
| **Login input**             | `2`       | 16px              |
| **Login button**            | `2.5`     | 20px (pill-ish)   |
| **Progress bar**            | `5`       | 5px               |
| **iOS Switch track**        | `13`      | 13px (full round) |
| **BSSwitchField container** | `1`       | 8px               |
| **Scrollbar thumb**         | `4px`     | 4px               |
| **Bulk edit toolbar**       | `1`       | 8px               |
| **Pagination dots**         | `50%`     | Circle            |

---

## 6. Depth & Elevation

### 6.1 Shadow Scale (Tailwind-inspired)

| Level              | Shadow                                                                          | Usage                                    |
| ------------------ | ------------------------------------------------------------------------------- | ---------------------------------------- |
| **0 (none)**       | `"none"`                                                                        | Flat surfaces, contained buttons at rest |
| **1 (subtle)**     | `0px 1px 2px 0px rgba(0, 0, 0, 0.05)`                                           | Minimal lift                             |
| **2 (low)**        | `0px 1px 3px rgba(0, 0, 0, 0.1), 0px 1px 2px rgba(0, 0, 0, 0.06)`               | Subtle cards                             |
| **3 (medium)**     | `0px 4px 6px -1px rgba(0, 0, 0, 0.1), 0px 2px 4px -1px rgba(0, 0, 0, 0.06)`     | Button hover, elevated cards             |
| **4 (elevated)**   | `0px 10px 15px -3px rgba(0, 0, 0, 0.1), 0px 4px 6px -2px rgba(0, 0, 0, 0.05)`   | Dropdowns, popovers                      |
| **5 (high)**       | `0px 20px 25px -5px rgba(0, 0, 0, 0.1), 0px 10px 10px -5px rgba(0, 0, 0, 0.04)` | Dialogs                                  |
| **6–24 (maximum)** | `0px 25px 50px -12px rgba(0, 0, 0, 0.25)`                                       | Modals, overlays                         |

### 6.2 Special Shadows

| Context                    | Shadow                               | Usage                     |
| -------------------------- | ------------------------------------ | ------------------------- |
| **Login card**             | `0 16px 40px rgba(16, 24, 40, 0.12)` | Login page card           |
| **iOS Switch thumb**       | `0 2px 4px 0 rgb(0 35 11 / 20%)`     | Toggle button             |
| **Popup link hover**       | `theme.shadows[8]`                   | CTA button hover in popup |
| **Popup title text**       | `0 2px 8px rgba(0,0,0,0.8)`          | Text shadow on image      |
| **Popup description text** | `0 1px 4px rgba(0,0,0,0.8)`          | Text shadow on image      |

### 6.3 Dark Mode Depth

| Element          | Treatment                                                                                                 |
| ---------------- | --------------------------------------------------------------------------------------------------------- |
| **Glass card**   | `background: rgba(20, 20, 25, 0.96)` + `backdropFilter: blur(12px)` + `border: rgba(255, 255, 255, 0.08)` |
| **Glass shadow** | `0 8px 32px rgba(0, 0, 0, 0.5)`                                                                           |
| **Glow effects** | `0 0 20px rgba(color, 0.3)` — subtle color glow around interactive elements                               |
| **Header bar**   | `backdropFilter: "blur(8px)"` — glass effect on dark surfaces                                             |
| **Scrollbar**    | Track `#0D0D0F`, thumb `#3A3A45`, hover `#6A6A75`                                                         |

### 6.4 Shadow Philosophy

BS Platform uses shadow sparingly and functionally. Contained buttons have **no shadow at rest** (`boxShadow: "none"`) — shadow only appears on hover to indicate interactivity. Elevation levels 6–24 are all identical (`25px 50px` at 0.25 opacity), creating a flat hierarchy above level 5. This prevents visual noise in a data-dense interface. In dark mode, depth comes primarily from **translucent backgrounds** and **glow effects** rather than traditional shadows.

---

## 7. Do's and Don'ts

### Do

- Use `Prompt` as the primary font family — it's Thai-optimized and the platform's identity
- Apply `textTransform: "none"` globally — professional, no-shouting button text
- Use `clamp()` for all font sizes — fluid responsive scaling without breakpoint jumps
- Follow the 6-palette theme system — never hardcode primary colors, always use `theme.palette.primary.*`
- Use `alpha(theme.palette.primary.main, fraction)` for all tinted surfaces — ensures theme-compatibility
- Use `EditOutlined` (pencil) and `DeleteOutlined` (trash) for row actions — gray `#757575`, no background
- Display status chips as colored badges — YES (success green) / NO (error red)
- Place toolbar actions in the standard order: Add → Search → Filters → Refresh → Column → Density → Export
- Use SweetAlert2 for delete confirmations with the standard "Delete Confirmation" title
- Use `borderLeftRadius: "unset"` pattern for composite filter inputs (operator + value)
- Wrap complex grids in `DataGridErrorBoundary`
- Apply `backdropFilter: "blur(8px)"` on header bar for subtle glass effect

### Don't

- Don't use emoji or colored circles as sidebar menu icons — use MUI icons only (`@mui/icons-material`)
- Don't add ✕ (X) close buttons on form modals — users close via "Cancel" button only
- Don't use colored/orange/amber modal titles — titles must be plain black text
- Don't add separate labels above input fields in Add/Edit modals — use placeholder text inside inputs only
- Don't put a Status/Active dropdown in Add forms — new records default to active
- Don't use uppercase text on buttons — `textTransform: "none"` is mandatory
- Don't use `MuiPaper` default border radius — it's overridden to `"unset"` for flat layout panels
- Don't hardcode primary colors — always reference `theme.palette.primary.*` for theme-switching support
- Don't use heavy shadows on data-dense screens — shadows are minimal, used only on hover/elevation changes
- Don't use raw CSS files for component styling — use MUI `sx` prop or `styled-components`
- Don't skip the `TopLinearProgress` during page loads — it provides essential loading feedback
- Don't use text labels ("TH", "EN") for language switching — use flag icons only
- Don't mix SF Pro or other non-Prompt fonts — the platform uses Prompt/Roboto exclusively

---

## 8. Responsive Behavior

### 8.1 Breakpoints

| Name   | Width       | Key Changes                                                           |
| ------ | ----------- | --------------------------------------------------------------------- |
| **xs** | 0–599px     | Mobile: temporary sidebar, single-column filters, stacked form fields |
| **sm** | 600–899px   | Small tablet: 2-column filters, compact toolbar                       |
| **md** | 900–1199px  | Tablet/Desktop: persistent sidebar begins, 3-column filters           |
| **lg** | 1200–1535px | Desktop: full layout, 4-column filters, expanded sidebar              |
| **xl** | 1536px+     | Large desktop: extended width, maximum data density                   |

### 8.2 Sidebar Behavior

| Screen         | Mode                       | Width                           | Toggle              |
| -------------- | -------------------------- | ------------------------------- | ------------------- |
| < md (mobile)  | Temporary drawer (overlay) | 280px                           | Hamburger menu icon |
| ≥ md (desktop) | Persistent drawer          | 280px expanded / 72px collapsed | ChevronLeft icon    |

### 8.3 Content Area Adaptation

- Main content: `width: 100%`, `height: calc(100vh - 80px)`, `overflow: auto`
- AppBar shifts when sidebar opens: `marginLeft: 280px`, `width: calc(100% - 280px)`
- DataGrids fill available width — columns auto-resize or scroll horizontally

### 8.4 Form Dialogs (Responsive)

- `maxWidth="sm"` dialogs: centered, up to 600px
- `maxWidth="md"` dialogs: centered, up to 900px
- `maxWidth="lg"` dialogs: full-screen feel, up to 1200px
- `fullWidth` always enabled — dialog stretches to max width

### 8.5 Typography Scaling

All headings and body text use `clamp()` for fluid scaling:

- h1: `2rem` (min) → `2.75rem` (max) at `4vw` growth
- body1: `0.875rem` (min) → `0.9375rem` (max) at `1vw` growth
- This eliminates jarring size jumps at breakpoints

---

## 9. Agent Prompt Guide

### 9.1 Quick Color Reference (Default Indigo Theme)

- Primary: `#3f51b5` (Indigo 500)
- Primary light: `#9fa8da` (Indigo 200)
- Primary dark: `#303f9f` (Indigo 700)
- Error/Close: `#EF4444`
- Warning: `#F59E0B`
- Info: `#3B82F6`
- Success/Save: `#10B981`
- Background: `#F6F7FA`
- Paper: `#FFFFFF`
- Text primary: `#212121`
- Text secondary: `#424242`
- Divider: `alpha(#3f51b5, 0.18)`
- Header bg: primary.main (theme-dynamic)
- Sidebar bg: `#FFFFFF`
- Active menu: `alpha(primary, 0.14)` + 4px left accent bar

### 9.2 Example Component Prompts

**CRUD Data Management Screen:**

> "Create a Master Product Type screen. Font family Prompt. Left sidebar 280px white bg with MUI outlined icons (gray #757575). Header bar with primary indigo #3f51b5 bg, white text, breadcrumb 'Master / ประเภทสินค้า'. Toolbar: outlined '+ Add Record' button left, Search input + 'Show Filters' + Refresh + column/filter/density icons right. DataGrid with columns: EditOutlined pencil icon (gray), DeleteOutlined trash icon (gray), # row number, รหัสประเภทสินค้า, ชื่อประเภทสินค้า (EN), ชื่อประเภทสินค้า (TH), คำอธิบาย, สถานะ (YES green chip / NO red chip). Pagination footer: 'Rows per page: 20 ▼ 1~20 of 48 < >'. Background #F6F7FA."

**Add Record Modal:**

> "Create an Add Record dialog overlay. No ✕ close button. Title: plain black text 'Add New Record'. Form fields in 2-column grid using placeholder text inside inputs only (no labels above). Fields: 'รหัสประเภทสินค้า _' (text), 'ชื่อประเภทสินค้า (EN) _' (text), 'ชื่อประเภทสินค้า (TH) \*' (text), 'คำอธิบาย' (text, full-width). No Status dropdown. Bottom actions right-aligned: 'Cancel' (text, red) + 'Save' (text, primary blue)."

**Delete Confirmation:**

> "Create a SweetAlert2 delete confirmation positioned center. Orange warning circle icon. Title: 'Delete Confirmation'. Message: 'Are you sure you want to delete this record?'. Two buttons: 'Cancel' (gray outline) + 'Yes, delete it!' (red #EF4444 filled). allowOutsideClick: false."

**Login Page:**

> "Create a login page. Full-viewport centered, bg with primary-tinted radial gradients + decorative 420px/520px blurred circles. White card maxWidth 480px, borderRadius 32px, elevation 8, backdropFilter blur(12px), shadow '0 16px 40px rgba(16, 24, 40, 0.12)'. Card: logo image + 'TIME SHEET SYSTEMS' title + subtitle + divider + Username field (PersonIcon, borderRadius 16px) + Password field (VpnKeyIcon, visibility toggle, borderRadius 16px) + full-width Login button (gradient bg primary.main→primary.dark, borderRadius 20px, weight 700, 1rem). Version label at bottom."

**Dashboard / Performance:**

> "Create an Executive Performance Dashboard. Font Prompt. Title 'Executive Performance Dashboard' h4 weight 700 + Thai subtitle. Top-right: year dropdown + month dropdown + badge count. 4-column KPI cards row (white bg, subtle shadow, MUI icon + label + large value). Left panel 60%: 'Project Summary' card with project items showing invoice amount + performance badge (primary color) + role chips. Right panel 40%: 'Role Distribution' with role names, amounts, percentages, horizontal progress bars (primary indigo color). TopLinearProgress while loading."

### 9.3 Iteration Guide

1. **Font family is Prompt** — not SF Pro, not Inter, not system fonts. Always `'Prompt', 'Roboto', sans-serif`
2. **6 theme presets** — designs must work across all palettes. Never hardcode `#3f51b5`; use `theme.palette.primary.main`
3. **Sidebar active indicator** is a 4px left accent bar (primary color), not a full background highlight
4. **Action icons are plain gray outlined MUI icons** — never use colored circles, filled backgrounds, or emoji
5. **Modal form fields use placeholder text inside inputs** — never add separate labels above fields
6. **Button text says "Save"** — not "Add", not "Submit". Cancel button uses text/outlined variant
7. **No ✕ close button on form modals** — only Cancel button to dismiss
8. **Status chips** use `success.main` for YES and `error.main` for NO — colored background with white text
9. **Progress bars** change color by percentage: red < 50%, yellow ≥ 50%, green ≥ 100%
10. **Dark mode is glassmorphism** — translucent surfaces, blur effects, cyan/purple accent, glow effects
11. **SweetAlert2** sits at z-index 50000+ — always above everything, with theme-aware dark mode colors
12. **Language switch uses flag icons** — not text labels "TH" / "EN"
