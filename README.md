# Econometrics I (Part I) @ FGV EPGE - 2026

Repository for the first half of Econometrics I, taught by [Raul Riva](https://rgriva.github.io). The second half is taught by [Valdemar Pinho Neto](https://sites.google.com/view/valdemarneto/home).

| | |
|---|---|
| **Instructor** | Raul Guarini Riva ([raul.riva@fgv.br](mailto:raul.riva@fgv.br)) |
| **Part II** | Valdemar Pinho Neto ([valdemar.pinho@fgv.br](mailto:valdemar.pinho@fgv.br)) |
| **TA** | Taric Latif ([tariclatif@gmail.com](mailto:tariclatif@gmail.com)) |
| **Classes** | Wednesdays and Fridays, 9:00-11:00 |
| **Office hours** | Fridays, 17:00-18:00 (or email me to schedule another time) |

## Learning Goals

By the end of Week 5, you should be able to:

- Understand and implement non-parametric kernel-based methods;
- Apply bootstrap methods for i.i.d. data;
- Work with time series data: stationarity, persistence, autocorrelation, and ARMA estimation and forecasting;
- Implement GMM estimation under general heteroskedasticity and autocorrelation (very useful for panel methods!).

## Tentative Schedule

| Week | Topics |
|------|--------|
| 1 | Non-parametric estimation + (i.i.d.) Bootstrap |
| 2 | Time series building blocks + Lag operator, AR and MA models |
| 3 | ARMA models, Wold's decomposition, estimation |
| 4 | LLN and CLTs for dependent data + Intro to GMM |
| 5 | GMM asymptotic theory + HAC estimation |

## Materials

Slides are posted under [`lectures`](lectures) just before class, as HTML files. Download the repository and open them in any browser.

Slides do not replace the books. **Reading them is mandatory.** Each lecture lists the relevant chapters from:

- [Econometrics](https://www.amazon.com/Econometrics-Bruce-Hansen/dp/0691235899), by Bruce Hansen;
- [Time Series Analysis](https://www.amazon.com/Time-Analysis-James-Douglas-Hamilton/dp/0691042896), by James Hamilton;
- *Stochastic Limit Theory*, by James Davidson.

## Evaluation

- Parts I and II are graded independently. Final grade = 0.5 × Part I + 0.5 × Part II.
- In Part I, problem sets are worth **10%** and exams the remaining **90%**.
- Exams are in person and individual. You may bring **one A4 sheet of notes** (both sides), but you cannot share notes during the exam.

## Problem Sets

- Work in groups of **up to 3** people and keep the same group for all of Part I. Late submissions are not accepted.
- Problem sets and data are posted under [`problem_sets`](problem_sets). Submissions go through **GitHub Classroom**, with one private repository per group and problem set. Create a [GitHub account](https://github.com/join) if you don't have one.
- Submit a PDF report answering both the theoretical and empirical parts, plus your code as separate files. Don't put code in the report.
- Use any reasonable language (Python, R, Julia, Matlab, ...), but **no Stata and no pre-packaged routines** for the methods we study (e.g., no `gmm` package for a GMM question). Standard tools like numerical optimizers are fine.

## Attendance

Attendance is not mandatory. If you come, be on time: there is a 15-minute grace period, after which you may not enter unless you warned me in advance.

## Feedback

I **really need** ongoing feedback! 

If something makes lectures worse or better, tell me by email or in person. Feedback, even very negative feedback, will **not** affect your grade. If anything, it will make it better.

## License

Course materials are licensed under [CC BY 4.0](LICENSE).
