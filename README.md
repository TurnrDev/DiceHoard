# DiceHoard

**A DiceCloud fork with campaign management.**

DiceHoard is an independent fork of [DiceCloud](https://dicecloud.com), extending its free, auditable, real-time character sheets for D&D 5e with additional campaign and party management features.

This is the repository for [DiceHoard](https://dnd.turnr.net).

DiceHoard aims to bring character and campaign management together, building on DiceCloud's existing functionality rather than reinventing it.

## Features

DiceHoard retains DiceCloud's character management features, including:

- Real-time, automatically calculated character sheets.
- Customisable character attributes, abilities, spells and equipment.
- Reusable libraries for sharing character options and mechanics.
- Support for complex character builds and homebrew content.

DiceHoard also aims to introduce or extend:

- **Campaign management** — Organise characters and parties through DiceCloud's existing Tabletop functionality.
- **In-game time tracking** — Track the current date within a campaign.
- **Shared experience** — Manage a common pool of experience points distributed between party members.
- **Initiative tracking** *(under consideration)* — Manage turn order during encounters.

These additions are planned or in development and should not be assumed to be available in the current release.

Where possible, DiceHoard aims to use DiceCloud's existing libraries, variables and systems, keeping changes to the underlying application focused and maintainable.

## Philosophy

DiceHoard builds upon DiceCloud's original philosophy: **spend less time managing numbers and more time playing D&D.**

Setting up your character on DiceCloud takes a little longer than filling out a paper character sheet. The goal of an online sheet is to make actually playing the game more streamlined and ultimately more fun. Putting a little extra effort into setting up a character pays off throughout the campaign.

DiceCloud tracks where each number comes from and allows you to make changes on the fly.

Consider a hypothetical example:

> You need to swim through a sunken section of dungeon to retrieve a quest item.
>
> You'll need to remove your magical Plate Armor of +1 Constitution to avoid sinking.
>
> Taking it off removes your disadvantage on Stealth checks, changes your armour class, speed and Constitution, and consequently affects your hit points and Constitution saving throw.
>
> Working out those changes manually in the middle of a session would interrupt the game.
>
> With DiceCloud, simply move your armour from your equipment to your backpack. Your hit points, saving throws and armour class update automatically, leaving you more time to play.

DiceHoard extends this philosophy beyond individual characters to the campaign itself.

Tracking experience, managing party progression and keeping track of in-game time should be just as straightforward as managing a character sheet.

## Getting started

DiceHoard is built using [Meteor](https://www.meteor.com/) and MongoDB, retaining DiceCloud's underlying application architecture.

Running DiceHoard locally for development or self-hosting should work on Linux, Windows and macOS.

### Prerequisites

You'll need:

- [Git](https://git-scm.com/)
- [Meteor](https://www.meteor.com/install)

### Installation

Clone the repository:

```bash
git clone https://github.com/TurnrDev/DiceHoard.git
cd DiceHoard
```

Install dependencies and start the development server:

```bash
cd app
meteor npm install
meteor
```

You should see output similar to:

```text
=> Started proxy.
=> [HMR] Dev server listening on port 3003.
=> Started MongoDB.
=> Started your app.

=> App running at: http://localhost:3000/
```

Visit [http://localhost:3000](http://localhost:3000) to access your local DiceHoard instance.

### Environment variables

The following environment variables are available for configuring a deployment:

| Variable | Description |
|---|---|
| `MAIL_URL` | SMTP connection URL for outgoing email. |
| `METEOR_SETTINGS` | Application settings, including environment and optional Patreon configuration. |
| `MONGO_URL` | MongoDB connection URL for application data. |
| `MONGO_OPLOG_URL` | MongoDB oplog connection URL for real-time updates. |
| `NPM_CONFIG_PRODUCTION` | Set to `true` for production dependency installation. |
| `PROJECT_DIR` | Application directory, typically `app`. |
| `ROOT_URL` | Public URL of your DiceHoard instance. |
| `DEFAULT_LIBRARIES` | Comma-separated library IDs to subscribe to by default. |

#### Patreon configuration

DiceCloud includes Patreon integration for its original subscription features.

To disable Patreon functionality and unlock the associated restrictions in a self-hosted deployment, configure the public section of `METEOR_SETTINGS` with:

```json
{
  "public": {
    "environment": "development",
    "disablePatreon": true
  }
}
```

Alternatively, start the application with the included example settings:

```bash
meteor run --settings exampleMeteorSettings.json
```

The example settings disable Patreon integration by default.

## Upstream and attribution

DiceHoard is an independent fork of [DiceCloud](https://github.com/ThaumRystra/DiceCloud), originally developed by [ThaumRystra](https://github.com/ThaumRystra).

DiceHoard builds upon DiceCloud's existing character management system, extending its functionality with additional tools for managing campaigns and parties.

DiceHoard is independently maintained and is not affiliated with or endorsed by the original DiceCloud project.

The original DiceCloud project and its contributors retain credit for their work.

## Licence

DiceHoard is licensed under the [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.html).

DiceHoard is an independent fork of [DiceCloud](https://github.com/ThaumRystra/DiceCloud), incorporating modifications and additional functionality developed by TurnrDev beginning in 2026.

Original DiceCloud copyright notices and contributor attributions are retained. Modifications to DiceHoard are distributed under the same GPLv3 licence.
