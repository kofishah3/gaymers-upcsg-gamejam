# UNTREAD
*A 2D Side-Scrolling Time Trial Game About Speed, Risk, and Collective Memory*

## Overview

**UNTREAD** is a 2D side-scrolling time trial game where players compete not only to finish fast, but to finish *differently*. Every run leaves a trace. Each tile in the level records how often it has been traversed by previous players, slowly turning the environment into a map of collective habit.

Players are rewarded for speed, but also for taking paths that others avoid. As routes become popular, their value decreases—forcing the meta to constantly shift. The game features a **rolling leaderboard** that updates with every new run, ensuring that no strategy stays optimal forever.

---

## Core Concept

- Fixed 2D side-scrolling level
- Global tracking of tile traversal frequency
- Score based on:
  - Completion time
  - Path uniqueness
- Leaderboard that updates dynamically as new paths are taken

Speedrunning and exploration coexist in constant tension.

---

## Scoring System

The final score for a run is calculated using the following formula:

Score = (Uniqueness_Constant / Time) × Σ(1 / V_i), for i = 1 to n

### Where:

- **n** — Number of *unique* tiles touched during the current run  
- **V_i** — Total number of times tile *i* has been visited in all previous runs  
- **Time** — Total completion time of the run  
- **Uniqueness_Constant** — A tuning value used to scale scores


### Important Rule

To prevent exploitation:
- A tile only contributes to the score **the first time it is entered during a run**
- Re-entering or idling on the same tile does not increase uniqueness

This ensures that uniqueness reflects *path choice*, not stalling.

---

## Rolling Leaderboard

- The leaderboard updates every time a new run is completed
- Rankings are based on **final score**, not just time
- As more players traverse the same tiles:
  - Their uniqueness value decreases
  - Older high scores may naturally fall
- Leaderboard dominance is temporary by design

---

## World State Persistence

- Tile visit counts persist globally across all runs
- The level does not change structurally
- Its value evolves based on player behavior
- Every run subtly reshapes future scoring potential

The world remembers where players have been.

---

## Design Intent

UNTREAD is designed to:

- Encourage exploration without forcing it
- Prevent static “optimal” routes
- Reward risk-taking and experimentation
- Create asynchronous competition between players across time

The game relies on incentives rather than restrictions.

---

## Player Experience Goals

- Fast but thoughtful movement
- Meaningful navigation decisions
- Emergent strategies
- High replayability without procedural generation

---

## Notes & Implementation Considerations

- All tiles should be initialized with a minimum visit count (e.g., `Vᵢ = 1`) to avoid division by zero
- Level design plays a critical role in balancing:
  - Risk
  - Traversal cost
  - Path length
---

## Project Status

This project is currently in the **concept / prototype stage** and may evolve as balancing, visualization, and systems are refined.
