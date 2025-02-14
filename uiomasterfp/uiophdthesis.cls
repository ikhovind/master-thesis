%% University of Oslo thesis document class

%% Identification:

\NeedsTeXFormat{LaTeX2e}[1995/12/01]  % Any version, really!
\ProvidesClass{uiophdthesis}
  [2024/02/16 v1.16 UiO document class for a PhD thesis]

%% Required packages:
\RequirePackage[T1]{fontenc}
\RequirePackage{xifthen}
\RequirePackage{keyval}

%% Option declarations:
\DeclareOption{binding}{\def \uiom@bind {24pt}}
\DeclareOption{font=cmr}{\def \uiom@font {\RequirePackage{lmodern}
    \RequirePackage[scaled]{helvet}}}
\DeclareOption{font=garamond}{\def \uiom@font {\RequirePackage[garamond]{mathdesign}
    \RequirePackage[scaled]{helvet}}}
\DeclareOption{font=noto}{\def \uiom@font {\RequirePackage{noto}}}
\DeclareOption{font=times}{\RequirePackage{txfonts}}

% Default values:
\def \uiom@bind {0pt}

% Process options:
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
\ExecuteOptions{font=cmr}
\ProcessOptions \relax

%% Load base class:
\LoadClass[a4paper,12pt,twoside,openright]{report}

%% Language adaptions:
\newcommand{\papername}{Paper}

%% Margins:
\RequirePackage[vmargin=3cm,bindingoffset=\uiom@bind]{geometry}

%% Text adjustments:
\pretolerance = 3000
\tolerance = 6000   \hbadness = \tolerance
\setlength{\parskip}{0cm plus 1mm}

%% Select a font
\uiom@font

%% Chapter and section headers
%% (mainly to use \sf for these):
\RequirePackage{titlesec}
\titleformat{\part}[display]
  {\centering\sf\bfseries\Huge}{%
    \partname~\thepart}{15pt}{\Huge\sf\bfseries}
\titleformat{\chapter}[display]
  {\sf\huge\bfseries}{\chaptertitlename\ \thechapter}{15pt}{\Huge\sf\bfseries}
\titlespacing*{\chapter} {0pt}{50pt}{40pt}
\titleformat{\section}
  {\sf\Large\bfseries}{\thesection}{1em}{}
\titlespacing*{\section} {0pt}{3.5ex plus 1ex minus .2ex}{2.3ex plus .2ex}
\titleformat{\subsection}
  {\sf\large\bfseries}{\thesubsection}{1em}{}
\titlespacing*{\subsection} {0pt}{3.25ex plus 1ex minus .2ex}{1.5ex plus .2ex}
\titleformat{\subsubsection}
  {\sf\normalsize\bfseries}{\thesubsubsection}{1em}{}
\titlespacing*{\subsubsection}{0pt}{3.25ex plus 1ex minus .2ex}{1.5ex plus .2ex}
\titleformat{\paragraph}[runin]
  {\sf\normalsize\bfseries}{\theparagraph}{1em}{}
\titlespacing*{\paragraph} {0pt}{3.25ex plus 1ex minus .2ex}{1em}
\titleformat{\subparagraph}[runin]
  {\sf\normalsize\bfseries}{\thesubparagraph}{1em}{}
\titlespacing*{\subparagraph} {\parindent}{3.25ex plus 1ex minus .2ex}{1em}

%% Define \uiopaper and modify the numbering
%% in \part-s (only in uiophdthesis).
\newif \ifuiom@in@paper  \uiom@in@paperfalse
\newcounter{uiom@save@chap@num}
\newcounter{uiom@save@part@num}
\newcounter{uiom@save@paper@num}
\let \uiom@orig@partname = \partname
\let \uiom@orig@part = \part
\newcounter{uiom@save@fig@num}   \counterwithout{figure}{chapter}
\newcounter{uiom@save@tab@num}   \counterwithout{table}{chapter} 

\newcommand{\uiom@leave@paper}{%
  \ifuiom@in@paper
    \setcounter{uiom@save@paper@num}{\value{part}}%
    \setcounter{chapter}{\value{uiom@save@chap@num}}%
    \setcounter{part}{\value{uiom@save@part@num}}%
    \setcounter{figure}{\value{uiom@save@fig@num}}%
    \setcounter{table}{\value{uiom@save@tab@num}}%
    \let \partname = \uiom@orig@partname
    \global\uiom@in@appendixfalse
  \fi
  \global\uiom@in@paperfalse  \global\uiom@no@chapterfalse
}

\renewcommand{\part}{%
  \uiom@leave@paper
  \setcounter{section}{0}%
  \uiom@orig@part
}

\newif \ifuiom@no@chapter  \uiom@no@chapterfalse
\newcommand{\uionochapters}{\uiom@no@chaptertrue}
\newcommand{\uiowithchapters}{\uiom@no@chapterfalse}

\newcommand{\uiom@enter@paper}{%
  \ifuiom@in@paper \else
    \setcounter{uiom@save@chap@num}{\value{chapter}}%
    \setcounter{uiom@save@part@num}{\value{part}}%
    \setcounter{uiom@save@fig@num}{\value{figure}}%
    \setcounter{uiom@save@tab@num}{\value{table}}%
    \let \partname = \papername
    \setcounter{part}{\value{uiom@save@paper@num}}
  \fi
  \setcounter{chapter}{0}\setcounter{section}{0}%
  \setcounter{figure}{0}\setcounter{table}{0}%
  \global\uiom@in@papertrue  \global\uiom@in@appendixfalse
}

\newcommand{\uiopaper}[1][]{%
  \uiom@enter@paper
  \ifthenelse{\isempty{#1}}{\uiom@no@chapterfalse}{\uiom@no@chaptertrue}
  \uiom@orig@part
}

%% Define uioseparatorpage environment:
\newenvironment{uioseparatorpage}[1]
  {\cleardoublepage
   \uiom@leave@paper
   \addcontentsline{toc}{part}{#1}%
   \thispagestyle{empty}%
   \markboth{}{}%
   \null \vspace*{7cm}
   \begingroup
   \centering \sf {\Huge \textbf{#1}\par}
   \vspace{2cm}\Large
   }
  {\par\endgroup\newpage}

%% Redefine \appendix (after 'hyperref' has been loaded):
\newif \ifuiom@in@appendix  \uiom@in@appendixfalse
\AtBeginDocument{%
  \let \uiom@orig@appendix = \appendix
  \renewcommand{\appendix}{\uiom@in@appendixtrue
    \uiom@orig@appendix}}

%% Modify chapter and section numbering. We want
%%          In paper  In paper appendix  In main  In appendix
%% Chapter    II.5         II.B             3          B
%% Section    II.5.2       II.B.3           3.4        B.6   (ordinarily)
%% Section    II.2         II.B             3.4        B.6   (when no chapters)
%% Subsection etc as default

\def \thechapter {\ifuiom@in@paper \Roman{part}.\fi
  \ifuiom@in@appendix \Alph{chapter}\else \arabic{chapter}\fi}%
\def \thesection {\ifuiom@in@paper \Roman{part}.\fi
  \ifuiom@no@chapter
    \ifuiom@in@appendix \Alph{section}\else \arabic{section}\fi
  \else
    \ifuiom@in@appendix \Alph{chapter}\else \arabic{chapter}\fi .\arabic{section}%
  \fi}
\def \thefigure {\ifuiom@in@paper \Roman{part}.\fi \arabic{figure}}
\def \thetable {\ifuiom@in@paper \Roman{part}.\fi \arabic{table}}

%% Insert printed material:
\RequirePackage{pdfpages}
\newcommand{\uioincludepdf}[2][]{{%
  \let \ps@none = \ps@empty
  \def \ps@default {\let\@mkboth\@gobbletwo
    \let\@oddhead\@empty
    \def\@oddfoot{\reset@font\hfil\textsf{\thepage}\hspace*{-2cm}}%
    \let\@evenhead\@empty
    \def\@evenfoot{\reset@font\hspace*{-2cm}\textsf{\thepage}\hfil}}%
  \def \ps@low {\let\@mkboth\@gobbletwo
    \let\@oddhead\@empty
    \def\@oddfoot{\reset@font\hfil\raisebox{-1cm}{\textsf{\thepage}}\hspace*{-2cm}}%
    \let\@evenhead\@empty
    \def\@evenfoot{\reset@font\hspace*{-2cm}\raisebox{-1cm}{\textsf{\thepage}}\hfil}}%
  \def \uiom@ps {default}
  \setkeys{uiom@keys}{#1}
  \cleardoublepage
  \includepdf[pages={-},pagecommand={\thispagestyle{\uiom@ps}}]{#2}}}
\define@key{uiom@keys}{numbers}{\def \uiom@ps {#1}}

%% Redefine the table of contents and lists of figures and tables:
%% We need to hack the \addcontents command to modify the .toc file.
%% We must do this after all packages have been loaded, as
%% 'hyperref' redefines the command.
\AtBeginDocument{%
\let \uiom@orig@addcontentsline = \addcontentsline
\renewcommand{\addcontentsline}[3]{%
  \ifthenelse{\equal{#2}{part}}
  {\uiom@orig@addcontentsline{#1}{#2}{\ifuiom@in@paper \partname~\fi #3}}
  {\uiom@orig@addcontentsline{#1}{#2}{#3}}}
}
\RequirePackage{titletoc}
\contentsmargin{1.1cm}
\titlecontents{part}[0.0em]{\addvspace{2.25em plus 1pt}\large\sf\bfseries}{}{}
  {\hfill\contentspage}
\titlecontents{chapter}[2.5em]{\sf}{\contentslabel{2.5em}}{\hspace*{-2.5em}}
  {\titlerule*[1pc]{.}\contentspage}
\titlecontents{section}[5.5em]{\sf}{\contentslabel{3.0em}}{\hspace*{-3.0em}}
  {\titlerule*[1pc]{.}\contentspage}
\titlecontents{subsection}[9.0em]{\sf}{\contentslabel{3.5em}}{\hspace*{-3.5em}}
  {\titlerule*[1pc]{.}\contentspage}
\titlecontents{subsubsection}[13.0em]{\sf}{\contentslabel{4.0em}}{\hspace*{-4.0em}}
  {\titlerule*[1pc]{.}\contentspage}
\titlecontents{paragraph}[17.5em]{\sf}{\contentslabel{4.5em}}{\hspace*{-4.5em}}
  {\titlerule*[1pc]{.}\contentspage}
\titlecontents{subparagraph}[22.5em]{\sf}{\contentslabel{5.0em}}{\hspace*{-5.0em}}
  {\titlerule*[1pc]{.}\contentspage}
\titlecontents{figure}[3.0em]{\sf}{\contentslabel{3.0em}}{\hspace*{-3.0em}}
  {\titlerule*[1pc]{.}\contentspage}
\titlecontents{table}[3.0em]{\sf}{\contentslabel{3.0em}}{\hspace*{-3.0em}}
  {\titlerule*[1pc]{.}\contentspage}

%% Redefine \begin{abstract}...\end{abstract} and
%% define \begin{xabstract}[heading] ... \end{xabstract}
% First, we need a modified quotation environment
% with no indentation of the first line:
\newenvironment{uiom@noindent@quotation}
  {\list{}{%
     \listparindent = 1.5em\relax
     \rightmargin = \leftmargin
     \parsep \z@ \@plus\p@}%
     \item\relax}
  {\endlist}
% Then, we need an environment for formatting the abstract:
\newenvironment{uiom@abstract}[1][\abstractname]
  {\begin{center}\small\textsf{\textbf{#1}}\end{center}\uiom@noindent@quotation}
  {\enduiom@noindent@quotation}             
\renewenvironment{abstract}[1][\abstractname]
  {\cleardoublepage \pagestyle{empty}\vspace*{5\baselineskip}
    \uiom@abstract[#1]}
  {\enduiom@abstract}
% We also define an environment for a second abstract:
\newenvironment{xabstract}[1][\abstractname]
  {\cleardoublepage \vspace*{5\baselineskip}
    \uiom@abstract[#1]}
  {\enduiom@abstract}              

%% Redefine \maketitle:
\renewcommand{\maketitle}[1][]{\begin{titlepage}
    \setkeys{uiophd@keys}{#1}
    \let\footnotesize = \small
    \let\footnoterule = \relax
    \let \footnote = \thanks
    \sf\large
    \def \and {\\}
    \begin{flushleft}
      \includegraphics[height=12.8mm]{uio-thesis-name}\par
      \vskip 8ex
      {\Large \lineskip = 3ex
	\@author\par}
      \vskip 2ex
      {\LARGE
        \textbf{\@title}\par}
      \ifthenelse{\equal{\uiomfp@subtitle}{}}{}
        {\vskip 1ex {\Large\uiomfp@subtitle\par}}
      \vskip 5ex
      {\Large\textbf{Thesis submitted for the degree of\\
          Philosophiae Doctor}\par}
      \vskip 3ex
      \ifthenelse{\equal{\uiophd@dept}{}}{}
        {\uiophd@dept\par}
      \ifthenelse{\equal{\uiophd@fac}{}}{}
        {\uiophd@fac\par}
      \vskip 3ex
      \def \and {, }
      \ifthenelse{\equal{\uiophd@supervisors}{}}
        {\ifthenelse{\equal{\uiophd@supervisor}{}}{}
	  {Supervisor: \uiophd@supervisor\par}}
	{Supervisors: \uiophd@supervisors\par}
      \ifthenelse{\equal{\uiophd@info}{}}{}
        {\uiophd@info\par}
      \vfill
      \uiophd@year\hfill\includegraphics[height=23.7mm]{uio-thesis-segl}
    \end{flushleft}
  \end{titlepage}
  % Add empty backside
  \mbox{}
  \thispagestyle{empty}
  \clearpage
  \setcounter{page}{1}
}

\define@key{uiophd@keys}{dept}{\def \uiophd@dept {#1}}%
\define@key{uiophd@keys}{fac}{\def \uiophd@fac {#1}}%
\define@key{uiophd@keys}{info}{\def \uiophd@info {#1}}%
\define@key{uiophd@keys}{supervisor}{\def \uiophd@supervisor {#1}}%
\define@key{uiophd@keys}{supervisors}{\def \uiophd@supervisors {#1}}%
\define@key{uiophd@keys}{year}{\def \uiophd@year {#1}}%
\date{}
\def \uiophd@dept {}
\def \uiophd@fac {}
\def \uiophd@info {}
\def \uiophd@supervisor {}
\def \uiophd@supervisors {}
\def \uiophd@year {\the\year}
% Subtitles may be inhereted from the uiomastrfp package:
\define@key{uiophd@keys}{subtitle}{\def \uiomfp@subtitle {#1}}%
\providecommand{\subtitle}[1]{\def \uiomfp@subtitle {#1}}
\providecommand{\uiomfp@subtitle}{}

%% Define \begin{preface}
\newenvironment{preface}{%
  \chapter*{\prefacename}
  \markboth{\prefacename}{}
  }
  {}

%% Headers and footers:
\RequirePackage{fancyhdr}
\fancyhead{}
\setlength{\headheight}{15pt}
\fancyhead[LE]{\textsf{\small \nouppercase{\leftmark}}}
\fancyhead[RO]{\textsf{\small \nouppercase{\rightmark}}}
\renewcommand{\headrulewidth}{0pt}
\fancyfoot{}
\fancyfoot[LE,RO]{\textsf{\thepage}}
\renewcommand{\footrulewidth}{0pt}
\pagestyle{fancy}
\fancypagestyle{plain}{\fancyhead{}}

%% Figure and table captions
\RequirePackage[labelfont=sf,font=small]{caption}

%% Document parts:
\providecommand{\frontmatter}{\cleardoublepage \pagenumbering{roman}}
\providecommand{\mainmatter}{\cleardoublepage \pagenumbering{arabic}}
\providecommand{\backmatter}{\cleardoublepage}

\endinput
