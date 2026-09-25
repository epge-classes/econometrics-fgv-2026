# Econometrics I (Part I) @ FGV EPGE - 2026

Repository for the first half of Econometrics I, taught by [Raul Riva](https://rgriva.github.io). The second half is taught by [Valdemar Pinho Neto](https://sites.google.com/view/valdemarneto/home).

<table>
  <tr><td><b>Instructor</b></td><td>Raul Guarini Riva (<a href="mailto:raul.riva@fgv.br">raul.riva@fgv.br</a>)</td></tr>
  <tr><td><b>Part II</b></td><td>Valdemar Pinho Neto (<a href="mailto:valdemar.pinho@fgv.br">valdemar.pinho@fgv.br</a>)</td></tr>
  <tr><td><b>TA</b></td><td>Taric Latif (<a href="mailto:tariclatif@gmail.com">tariclatif@gmail.com</a>)</td></tr>
  <tr><td><b>Classes</b></td><td>Wednesdays and Fridays, 9:00-11:00</td></tr>
  <tr><td><b>Office hours</b></td><td>Fridays, 17:00-18:00 (or email me to schedule another time)</td></tr>
  <tr><td><b>Website</b></td><td><a href="https://epge-classes.github.io/econometrics-fgv-2026/">epge-classes.github.io/econometrics-fgv-2026</a></td></tr>
</table>

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

Slides are posted on the [course website](https://epge-classes.github.io/econometrics-fgv-2026/) just before class.

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
- Problem sets and data are posted under [`problem_sets`](problem_sets). Submissions go through **GitHub Classroom**, with one private repository per group and problem set. Create a [GitHub account](https://github.com/join) if you don't have one yet.
- Submit a PDF report answering both the theoretical and empirical parts, plus your code as separate files. Don't put code in the report.
- Use any reasonable language (Python, R, Julia, Matlab, ...), but **no Stata and no pre-packaged routines** for the methods we study (e.g., no `gmm` package for a GMM question). Standard tools like numerical optimizers are fine.

## AI Policy

You can, and you should, use AI tools in this class. But you should be smart about it.

- Use AI tools to **help you understand the material** and **to help you write code**. 
- Do **not** use them to blindly **write your reports**. The written exam may ask questions about the empirical exercises.
- You will have no AI help during the written exam, and that commands most of your grade.

Some problems might explicitly ask you to use AI tools.

## Attendance

Attendance is **not** mandatory. Coming to class will not directly impact your grades. But there is a catch. **If you come, you have to be be on time**: there is a 15-minute grace period, after which you may not enter unless you warned me in advance.

## Feedback

I **really need** ongoing feedback! 

If something makes lectures worse or better, tell me by email or in person. Feedback, even very negative feedback, will **not** affect your grade. If anything, it will make it better.

## License

Course materials are licensed under [CC BY 4.0](LICENSE).
