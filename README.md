# UN Delegates Puzzle Solver (Prolog)

A Prolog solution to the "UN Delegates" logic puzzle: five delegates sit side by side in a meeting at the United Nations, and each has a different concern. The program uses backtracking to work out which delegate (by country) is worried about what.

## The puzzle

Each delegate is described by six attributes:

| Attribute | Values |
|-----------|--------|
| Tie       | Black, Blue, Green, White, plus one unnamed |
| Country   | French, Brazilian, Canadian, German, American |
| Concern   | Poverty, Deforestation, Immigrants, Climate Change, plus one unnamed |
| Age       | 40, 45, 50, 55, and one older value |
| Pet       | Cat, Dog, Fish, Snake, Turtle |
| Hobby     | Gardening, Jogging, Scuba diving, Woodworking, plus one unnamed |

Every value is used exactly once, and the delegates are numbered #1 to #5 from left to right. The clues place delegates by position ("at the second position", "at one of the ends"), by pairing attributes ("the 40-year-old likes Jogging"), or relative to each other ("next to", "somewhere between", "exactly to the right of").

## How it works

Each delegate is a term `d(Tie, Country, Concern, Age, Pet, Hobby)`, and the line of delegates is a list of five such terms. The solver follows the puzzle's tips and adds clues in this order, so that backtracking has as little to search as possible:

1. **Exact positions**: first, second and third delegate.
2. **"At one of the ends"** clues.
3. **Pair clues** that tie two attributes to the same delegate.
4. **Relative-position clues**: `left_of/3`, `right_exact/3`, `next_to/3` and `btw/4`, built on `append/3` and `member/2`.
5. A final check that every value is placed and used only once.

Prolog's unification fills in the unknown fields, and backtracking undoes any choice that breaks a clue.

## Requirements

[SWI-Prolog](https://www.swi-prolog.org/), or the online editor [SWISH](https://swish.swi-prolog.org/).

## Usage

**Command line:**

```
swipl -q -g main -t halt un_delegates.pl
```

**Interactive SWI-Prolog:**

```
?- [un_delegates].
?- main.
```

**SWISH:** paste the code into the editor, then type `main.` in the query box (without `?-`, as SWISH adds it itself).

## Expected output

```
Delegate #1: french -> poverty
Delegate #2: brazilian -> deforestation
Delegate #3: canadian -> concern5
Delegate #4: german -> immigrants
Delegate #5: american -> climate
```

## Full solution

| # | Tie | Country | Concern | Age | Pet | Hobby |
|---|-----|---------|---------|-----|-----|-------|
| 1 | White | French | Poverty | 50 | Cat | (unnamed) |
| 2 | Green | Brazilian | Deforestation | (oldest) | Fish | Gardening |
| 3 | Black | Canadian | (unnamed) | 45 | Snake | Scuba diving |
| 4 | (unnamed) | German | Immigrants | 40 | Turtle | Jogging |
| 5 | Blue | American | Climate Change | 55 | Dog | Woodworking |

## Notes

- The clues name only four of the five ties, concerns and hobbies. The fifth value of each is a placeholder in the code (`tie5`, `concern5`, `hobby5`). Replace them with the real names from the puzzle's dropdowns if you want the output to show them. The Canadian's concern prints as `concern5` for this reason.
- The clue about "the youngest man" means the ages include one value above 55. The code assumes 60, but any value above 55 gives the same solution.

## Files

- `un_delegates.pl`: the Prolog program
- `README.md`: this file
