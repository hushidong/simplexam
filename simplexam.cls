%%
%% ---------------------------------------------------------------
%% simplexam.cls --- A simple class for chinese exam paper
%% 一个简单试卷文档类 simplexam
%% based on exsheets bundles
%% Maintained by huzhenzhen
%% E-mail: hzzmail@163.com
%% Released under the LaTeX Project Public License v1.3c or later
%% ---------------------------------------------------------------
%%


\NeedsTeXFormat{LaTeX2e}
\RequirePackage{expl3}
\ProvidesExplClass {simplexam} {2022/11/10} {v1.0c} {a simple exam}%同时开启latex3语法
\RequirePackage{ xparse,xtemplate,l3keys2e,etoolbox}

\xdef\unitname{section}
\xdef\paperprintname{double}
\xdef\papersizename{A4}
\bool_new:N   \l__simplexam_prtanswer_bool  %判断打印答案用的boolean
\bool_new:N   \l__simplexam_scoretab_bool  %判断打印得分表用的boolean
\bool_new:N   \l__simplexam_scratch_bool  %判断输出草稿纸用的boolean
\bool_new:N   \l__simplexam_sealrule_bool %判断输出密封线用的boolean
\bool_new:N   \l__simplexam_headfoot_bool %判断输出页眉页脚用的boolean
\bool_new:N   \l__simplexam_scoreshow_bool %boolean选项用来设置是否显示评分表中的分值
\bool_set_true:N \l__simplexam_scratch_bool %默认输出草稿纸
\bool_set_true:N \l__simplexam_sealrule_bool %默认输出密封区和线
\bool_set_true:N \l__simplexam_headfoot_bool %默认输出页眉页脚
\bool_set_false:N \l__simplexam_scoreshow_bool %默认不显示评分表中的分值

\bool_new:N   \l__simplexam_inanswersheet_bool %判断是否在单独的答案表中的，若在那么一些命令的逻辑要做修改，比如\answerpoints就不能再执行了。
\bool_set_false:N \l__simplexam_inanswersheet_bool %默认不在答案表中

\int_new:N \l_temp_answer_int %临时变量
\tl_new:N \l__simplexam_tempans_tl %临时变量

\newtoggle{auxinfoused}
\togglefalse{auxinfoused}

\keys_define:nn {simplexam} %设置文档类选项，没用子组/subgroup
  {
    answer .bool_set:N = \l__simplexam_prtanswer_bool, %选项answer用来设置boolean
    answer .default:n = true, %默认设置值为true
    answer .value_required:n = false, %可以不给出设置值

    countunit .code:n = {\xdef\unitname{#1}}, %定义大题单元所依赖的划分，是section还是chapter还是none
    countunit .default:n = section, %默认设置值为section
    countunit .value_required:n = false,%可以不给出设置值

    paperprint .code:n ={\xdef\paperprintname{#1}},%双面打印
    paperprint .default:n = {double}, %默认设置值为double，single
    paperprint .value_required:n = false, %可以不给出设置值

    scoretable .bool_set:N = \l__simplexam_scoretab_bool, %选项用来设置boolean
    scoretable .default:n = true, %默认设置值为true
    scoretable .value_required:n = false, %可以不给出设置值

    scoreshow .bool_set:N = \l__simplexam_scoreshow_bool, %boolean选项用来设置是否显示评分表中的分值
    scoreshow .default:n = true, %默认设置值为true
    scoreshow .value_required:n = false, %可以不给出设置值

    sheetsize.code:n ={\xdef\papersizename{#1}},%纸张大小，用sheet而不是paper，因为paper和papersize两个选项geometry宏包已经用了。
                                                                         %若使用paper和papersize会报选项错误。
    sheetsize.default:n = {A4}, %默认设置值为A4,A3
    sheetsize.value_required:n = false, %可以不给出设置值

    scratchpaper.bool_set:N = \l__simplexam_scratch_bool, %选项scratchpaper用来设置输出草稿纸
    scratchpaper.default:n = true, %默认设置值为true
    scratchpaper.value_required:n = false, %可以不给出设置值

    sealrule.bool_set:N = \l__simplexam_sealrule_bool, %选项sealrule用来设置输出密封线
    sealrule.default:n = true, %默认设置值为true
    sealrule.value_required:n = false, %可以不给出设置值

    headfoot.bool_set:N = \l__simplexam_headfoot_bool, %选项sealrule用来设置输出密封线
    headfoot.default:n = true, %默认设置值为true
    headfoot.value_required:n = false, %可以不给出设置值

  }

\ProcessKeysOptions { simplexam }

\ifcsstring{unitname}{chapter}%当以章为单位时，采用book类。
{\LoadClass[openany] { book }
%\let\cleardoublepage=\clearpage
}
{\LoadClass { article }}


\RequirePackage
  {
    geometry,
    xcolor,
    xpinyin,
    amssymb,
    mwe,
    graphicx,
  }


\ifcsstring{papersizename}{A4}
{\ifcsstring{paperprintname}{double}
    {\geometry{a4paper,twoside,left=30mm,right=20mm,top=20mm,bottom=15mm}}
    {\geometry{a4paper,left=30mm,right=20mm,top=20mm,bottom=15mm}}
}
{\ifcsstring{paperprintname}{double}
    {\geometry{a3paper,twoside,landscape,twocolumn,columnsep=40mm,left=40mm,right=30mm,top=20mm,bottom=15mm}}
    {\geometry{a3paper,landscape,twocolumn,columnsep=40mm,left=35mm,right=35mm,top=20mm,bottom=15mm}}
}
%\geometry{showframe}


\RequirePackage[tbtags]{amsmath}
\RequirePackage{scalerel}%缩放公式大小
\RequirePackage{fontspec}% fontset=sourcesans,
\RequirePackage[zihao=-4]{ctex}% fontset=sourcesans,
\RequirePackage[math-style=ISO, bold-style=ISO]{unicode-math}
\everymath{\displaystyle}



\DeclareMathOperator{\dif}{\mathop{}\!\mathrm{d}}
\DeclareMathOperator{\upe}{\operatorname{e}}
\DeclareMathOperator{\cov}{\operatorname{cov}}
\DeclareMathOperator{\upi}{\operatorname{i}}
\DeclareMathOperator{\sgn}{\operatorname{sgn}}
\DeclareMathOperator{\grad}{\operatorname{grad}}

\newcommand{\abs}[1]{\left| #1 \right|}

\renewcommand{\Re}{\operatorname{Re}}
\renewcommand{\Im}{\operatorname{Im}}
\renewcommand{\le}{\leqslant}
\renewcommand{\leq}{\leqslant}
\renewcommand{\ge}{\geqslant}
\renewcommand{\geq}{\geqslant}


\RequirePackage[pagestyles]{titlesec}
\titleformat{\section}{\zihao{4}\heiti}{\chinese{section} 、}{0em}{}%
[
\bool_if:NTF \l__simplexam_scoretab_bool {%当需要打印评分表时
\ifcsstring{unitname}{section}{%当大题以section为单位时
\iftoggle{auxinfoused}{\assesstabunit{\thesection}}{}}{}
}
]
\titlespacing*{\section}{0pt}{0.5\baselineskip}{0.5\baselineskip}[0pt]
%得分表可以使用手动命令完成，也可以如这里般用章节命令
\ifcsstring{unitname}{chapter}%当以章为单位时，设置chapter格式。
{
    \titleformat{\chapter}{\zihao{4}\heiti}{\chinese{chapter} 、}{0em}{}%
    [
    \bool_if:NTF \l__simplexam_scoretab_bool {%当需要打印评分表时
    \ifcsstring{unitname}{chapter}{%当大题以section为单位时
    \iftoggle{auxinfoused}{\assesstabunit{\thechapter}}{}}{}
    }
    ]
    \titlespacing*{\chapter}{0pt}{0.5\baselineskip}{0.5\baselineskip}[0pt]
}{}

%页面页脚样式
%设置页面页脚线存在bug不能直接设置\setheadrule{~pt}默认的宽度会冲掉它
%所以使用下面的两句重定义命令进行修改
\renewcommand\headrule{\setheadrule{0.4pt}}
\renewcommand\footrule{\setfootrule{0pt}}

\def\pageheadingudf{试\hspace{4em}卷\hspace{4em}标\hspace{4em}题}
\def\pagefootingudf{第\thepage 页 共\totalpage 页; 时间:\ \today}
\def\pageheading#1{\def\pageheadingudf{#1}}
\def\pagefooting#1{\def\pagefootingudf{#1}}

\def\totalpage{0}
\newpagestyle{main}{ %%内容奇数页左,偶数页右
\sethead[]%偶数页左
[\pageheadingudf]%偶数页中
[]%偶数页右
{}%奇数页左
{\pageheadingudf}%奇数页中
{}%奇数页右
\setfoot{}{\pagefootingudf}{}%
\headrule%
\footrule}%
\bool_if:NTF \l__simplexam_headfoot_bool
{\pagestyle{main}}
{\pagestyle{empty}}

\RequirePackage{exsheets}%所有题目都用question环境，便于从题库中主动/随机选择
\DeclareInstance{exsheets-heading}{runin-simple}{default}{%定制question的heading
    runin = true ,
    %title-format = \rmfamily,%\large\scshape
    number-format = \color{blue}\bfseries,%\itshape
    %points-format = \rmfamily,%\large\bfseries
    number-pre-code ={},%\color{blue}\itshape\rmfamily\mdseries
    number-post-code =\space,
    join ={main[r,vc]number[r,vc](0pt,0pt) ;},
    attach ={main[r,vc]points[l,vc](\linewidth,0pt)}
}

\DeclareInstance{exsheets-heading}{runin-nonumber}{default}{%定制question的heading
    runin = true ,
    number-pre-code ={},
    number-post-code =\space,
    %join ={main[r,vc]number[r,vc](0pt,0pt) ;},
    attach ={main[r,vc]points[l,vc](\linewidth,0pt)}
}

\DeclareInstance{exsheets-heading}{block-simple}{default}{%定制question的heading
    attach = {main[l,vc]title[l,vc](0pt,0pt)},
}

%划分单元处理
\ifcsstring{unitname}{none}
{\xdef\counterwithinunit{}}
{\ifcsstring{unitname}{chapter}
    {\xdef\counterwithinunit{chapter}}
    {\xdef\counterwithinunit{section}}
}

\SetupExSheets{
    counter-format=qu[1].,
    counter-within={\counterwithinunit},
    headings ={runin-simple},
    headings-format=\normalsize,
    solution/headings=block-simple,
    solution/name={\textcolor{blue}{答:}},
}
\bool_if:NT \l__simplexam_prtanswer_bool {
    \SetupExSheets{
        solution/print=true,
    }
}
\SetupExSheets[points]{name=分,format=\color{blue}}%format=\textcolor{blue}\bfseries


%增加一个新的计分系统
\newcounter{questionold}
\newcounter{questionnew}
\setcounter{questionold}{0}
\newcounter{secunit}

%
%设置可以改变的默认分数
%
\fp_new:N \simplexam_default_pts_fp
\def\Setquestiondefaultpts#1{%
\fp_gset:Nn \simplexam_default_pts_fp {#1}
}
\Setquestiondefaultpts{3}

%
% 修改该宏，以增加独立于exsheets外的一套计分系统
% #1: instance
% #2: title
% #3: number
% #4: points
% #5: bonus
% #6: id
\cs_set_protected:Npn \exsheets_use_heading:nnnnnn #1#2#3#4#5#6
  {
    \IfInstanceExistTF {exsheets-heading} {#1}
      { \UseInstance {exsheets-heading} {#1} }
      {
        \msg_warning:nnx {exsheets} {headings} {#1}
        \UseInstance {exsheets-heading} {block}
      }
    {#2} {#3} {#4} {#5} {#6}
    %增加的题目统计和计分系统
        \ifcsstring{unitname}{none}{\setcounter{secunit}{1}}%当unitname为none的时候把所有的题都放到第一节中
            {\setcounter{secunit}{\value{\unitname}}}
        \def\unitnumber{\number\numexpr\thesecunit-1}
        \setcounter{questionnew}{\thequestion}
        \ifnum\value{questionold}<\value{questionnew}%当old大于等于new的时候说明单元变化
            \setcounter{questionold}{\thequestionnew}
        \else
            \ifcsundef{unit\unitnumber qus}%%因为solution同样应用这个宏，也会做处理，可能会覆盖前面的定义
            %因此当题数已经定义，那么就不再做处理了。
            {\csxdef{unit\unitnumber qus}{\thequestionold}%利用xdef将计数器的值先展开并取出
            }{}
            \setcounter{questionold}{\thequestionnew}
        \fi
        \ifcsundef{unit\thesecunit qu\thequestionnew}%
            {%因为solution同样应用这个宏，也会做处理，可能会覆盖前面的定义
                %因此当分数已经定义，那么就不再做分数处理了。
                \fp_compare:nNnTF {#4} = {0} %当未给出分数时则使用默认的分值
                {\csxdef{unit\thesecunit qu\thequestionnew}{\fp_use:N \simplexam_default_pts_fp}}
                {\csxdef{unit\thesecunit qu\thequestionnew}{\fp_use:N #4}}
            }{}
        %测试代码
        %numberofsec:\unitnumber : \csuse{unit\unitnumber qus} -\csuse{unit3qus}\par
        %pointofsec:\thesecunit  qu: \thequestionnew : \csuse{unit\thesecunit qu\thequestionnew}
  }


%重定义__exsheets_solution:环境，增加一个必选参数
%这个必选参数传递给__exsheets_solution_internal:当做可选参数
\renewenvironment {__exsheets_solution:} [2]
  {
    \tl_clear:N \l__exsheets_use_solution_tl
    % \prop_show:N \l__exsheets_class_prop
    \prop_map_inline:Nn \l__exsheets_class_prop
      {
        \use:c {__exsheets_solutions_use_##1:}
        \bool_if:nTF
          {
            \l__exsheets_solutions_use_bool
            &&
            (
              !\bool_if_p:c {g__exsheets_use_##1_bool}
                ||
              \bool_if_p:c {l__exsheets_##2_active_bool}
            )
          }
          { \tl_put_right:Nn \l__exsheets_use_solution_tl {y} }
          { \tl_put_right:Nn \l__exsheets_use_solution_tl {n} }
      }
    % verwende, wenn ein Ja dabei war:
    \tl_if_in:NnT \l__exsheets_use_solution_tl {y}
      { \bool_set_true:N \l__exsheets_solutions_use_bool }
    \bool_if:NT \l__exsheets_questions_deactivate_bool
      { \bool_set_false:N \l__exsheets_solutions_use_bool }
    \bool_if:NT \l__exsheets_solutions_use_bool
      {
        \bool_set_true:N \l__exsheets_inside_solution_bool
        \IfNoValueF {#1} { \keys_set:nn {exsheets/solution} {#1} }
      }
    \tl_if_blank:VT \l__exsheets_solution_heading_instance_tl
      {
        \tl_set_eq:NN
          \l__exsheets_solution_heading_instance_tl
          \l__exsheets_heading_instance_tl
      }
    %当传递的参数值为空时，
    %注意参数值为空不同与参数为空，参数为空即无参数用\IfNoValueTF判断
    \tl_if_blank:nTF {#2}
    {\csxdef{unit\thesecunit ans\thequestion}{\csuse{unit\thesecunit qu\thequestion}}}
    {
        \IfNoValueTF {#2}
        {\csxdef{unit\thesecunit ans\thequestion}{\csuse{unit\thesecunit qu\thequestion}}}
        {\csxdef{unit\thesecunit ans\thequestion}{#2}}
    }
    \__exsheets_solution_internal:
  }
  { \end__exsheets_solution_internal: }

%重定义solution环境，增加一个大括号参数G{}
%使其可以向\__exsheets_solution传递第二参数，这个大括号包围的参数值默认为空
%该值就是实际的得分
\cs_set_protected:Npn \__exsheets_renew_qu_sol_pair:nnnnnn #1#2#3#4#5#6
  {
    \RenewDocumentEnvironment {#1} { O{}G{} }
      { \keys_set:nn {exsheets} {#3} \__exsheets_question: {#2,##1} {##2} }
      { \end__exsheets_question: }
    \RenewDocumentEnvironment {#4} { O{}G{} }
      { \keys_set:nn {exsheets} {#6} \__exsheets_solution: {#5,##1} {##2}}
      { \end__exsheets_solution: }
  }

%重新生成{question}和{solution}环境
\RenewQuSolPair {question} {solution}


%根据bool，来确定是否在question中输出blank中的答案
\cs_set_protected:Npn \exsheets_blank:n #1
  {
    \box_clear:N \l__exsheets_blank_box
    \mode_if_math:TF
      { \hbox_set:Nn \l__exsheets_blank_box { $ \m@th \mathpalette{}{#1} $ } }
      { \hbox_set:Nn \l__exsheets_blank_box {#1} }
    \bool_if:NTF \l__simplexam_prtanswer_bool
    %\bool_if:NTF \l__exsheets_inside_solution_bool
      { \exsheets_write_blank:n {\ \ #1\ \ } }
      {
        \bool_if:NTF \l__exsheets_blank_width_bool
          { \__exsheets_blank_skip:N \l__exsheets_blank_dim }
          {
            \__exsheets_blank_skip:n
              { \box_wd:N \l__exsheets_blank_box }
          }
      }
  }


%
% 给出<#1>宽度的下划线
%
\NewDocumentCommand \answerfill { G{4em} }
  {
    \group_begin:
    \tl_if_blank:nTF {#1}{\def\answerfillspace{4em}}
      {\def\answerfillspace{#1}}
      \mode_if_vertical:TF
        {
          \noindent
          \exsheets_blank:n {\hspace{\answerfillspace}}
        }
        { \exsheets_blank:n {\hspace{\answerfillspace}}}
    \group_end:
  }


%所有题目的总分值
\NewDocumentCommand{\pointsall}{}{%
    \ifcsundef{pointsprtall}{0}{\csuse{pointsprtall}}
}

%某大题的总分值
\NewDocumentCommand{\pointsunit}{m}{%
    \ifcsundef{pointsprtunit#1}{0}{\csuse{pointsprtunit#1}}
}

%某小题的总分值
\NewDocumentCommand{\pointsques}{mm}{%
    \ifcsundef{pointsprtunit#1qu#2}{0}{\csuse{pointsprtunit#1qu#2}}
}

%所有题目的总得分
\NewDocumentCommand{\ansptsall}{}{%
    \ifcsundef{ansptsprtall}{0}{\csuse{ansptsprtall}}
}

%某大题的总得分
\NewDocumentCommand{\ansptsunit}{m}{%
    \ifcsundef{ansptsprtunit#1}{0}{\csuse{ansptsprtunit#1}}
}

%某小题的得分
\NewDocumentCommand{\ansptsques}{mm}{%
    \ifcsundef{ansptsprtunit#1qu#2}{0}{\csuse{ansptsprtunit#1qu#2}}
}

%大题的数量
\NewDocumentCommand{\questionsunitall}{}{%其实是大题的数量
    \ifcsundef{quesnumall}{0}{\csuse{quesnumall}}
}

%某大题的小题数量
\NewDocumentCommand{\questionsunit}{m}{%
    \ifcsundef{quesnumunit#1}{0}{\csuse{quesnumunit#1}}
}

  %
  % 将分数解析记录到宏中的命令，注意到因为该命令写入到aux文件中，读取后是在一个编组中，因此要使用其中的信息，必须在其内容部做全局的定义，比如gdef、csgdef
  % <#1>表示大题号，等于0则表示总分
  % <#2>表示小题号，等于0表示当前大题的总分
  % <#3>表示分数
  \def\pointstoparse#1#2#3{
    \ifnum#1=0\relax
        \gdef\pointsprtall{#3}
    \else
        \ifnum#2=0\relax
            \csgdef{pointsprtunit#1}{#3}
        \else
            \csgdef{pointsprtunit#1qu#2}{#3}
        \fi
    \fi
  }

  %答案的分数
  \def\ansptstoparse#1#2#3{
    \ifnum#1=0\relax
        \gdef\ansptsprtall{#3}
    \else
        \ifnum#2=0\relax
            \csgdef{ansptsprtunit#1}{#3}
        \else
            \csgdef{ansptsprtunit#1qu#2}{#3}
        \fi
    \fi
  }

  %
  % 将题目数量解析记录到宏中的命令
  % <#1>表示大题号，等于0则用于表示大题的数量
  % <#2>表示题目的数量
  \def\quesnumtoparse#1#2{
    \ifnum#1=0\relax
        \gdef\quesnumall{#2}
    \else
        \csgdef{quesnumunit#1}{#2}
    \fi
  }

%临时变量，用于记录题目和分数
\int_new:N \l_countTMPA_int
\int_new:N \l_countTMPB_int
\int_new:N \l_countTMPC_int
\int_new:N \l_countTMPD_int

\fp_new:N \l_pointTMPA_fp
\fp_new:N \l_pointTMPB_fp
\fp_new:N \l_pointTMPC_fp
\fp_new:N \l_pointTMPD_fp


%
%分数统计和记录放到文档最后
%
\AtEndDocument
  {
    %最后一个单元的题目数量无法通过question变化的逻辑来实现
    %因此利用此处代码完成最后一个单元的题目数量统计
    \ifcsstring{unitname}{none}{\setcounter{secunit}{1}}%当unitname为none的时候把所有的题都放到第一节中
        {\setcounter{secunit}{\value{\unitname}}}
    \csxdef{unit\thesecunit qus}{\thequestionold}
    \setcounter{questionold}{0}
    \csxdef{unitnums}{\thesecunit}

    \ifbool{@filesw}{

        %根据定义的命令信息获取大题(分节)总数
        \int_gset:Nn \l_countTMPC_int {\csuse{unitnums}}

        \iow_now:cx {@auxout}{%记录当前总的大题数量
               \string\global\string\toggletrue{auxinfoused}
                \string\quesnumtoparse{0}{\int_use:N \l_countTMPC_int}%
            }%

        %遍历各个大题
        %根据定义的命令信息进行统计
        \int_gset:Nn \l_countTMPA_int {1}
        \fp_gset:Nn \l_pointTMPA_fp {0.0}
        \fp_gset:Nn \l_pointTMPC_fp {0.0}

        \int_while_do:nNnn {\l_countTMPA_int } <{\l_countTMPC_int + 1}

        {
            %loopsec:\int_use:N \l_countTMPA_int \par

            %第\l_countTMPA_int大题的题目数
            \int_gset:Nn \l_countTMPD_int {\csuse{unit\int_use:N \l_countTMPA_int qus}}

            %记录当前大题的题目总数\@mainaux
            \iow_now:cx {@auxout}{
                \string\quesnumtoparse{\int_use:N \l_countTMPA_int}{\int_use:N \l_countTMPD_int}%
            }%

            %循环变量
            \int_gset:Nn \l_countTMPB_int {1}
            %用于统计当前的大题的总分数
            \fp_gset:Nn \l_pointTMPB_fp {0.0}
            \fp_gset:Nn \l_pointTMPD_fp {0.0}

            %遍历当前大题的所有题目
            \int_while_do:nNnn {\l_countTMPB_int } <{\l_countTMPD_int + 1}

            {
                %loopinsec: \int_use:N \l_countTMPA_int qu: \int_use:N \l_countTMPB_int points:\csuse{unit\l_countTMPA_int qu\l_countTMPB_int}\par
                \ifcsundef{unit\int_use:N \l_countTMPA_int qu\int_use:N \l_countTMPB_int}%如果没有给出题目分数，以题目的默认的分数作为后备
                    {Warning:~undefined~points~for~QUESTION:~unit\int_use:N \l_countTMPA_int qu\int_use:N \l_countTMPB_int \par
                    \csxdef{unit\int_use:N \l_countTMPA_int qu\int_use:N \l_countTMPB_int}{\fp_use:N \simplexam_default_pts_fp}}
                    {}

                \iow_now:cx {@auxout}{%记录当前题目的分数
                    \string\pointstoparse{\int_use:N \l_countTMPA_int}{\int_use:N \l_countTMPB_int}{\csuse{unit\int_use:N \l_countTMPA_int qu\int_use:N \l_countTMPB_int}}%
                    }%

                \ifcsundef{unit\int_use:N \l_countTMPA_int ans\int_use:N \l_countTMPB_int}%如果没有给出答案分数，以题目的分数作为后备
                    {Warning:~undefined~points~for~ANSWER:~ unit\int_use:N \l_countTMPA_int ans\int_use:N \l_countTMPB_int \par
                    \csxdef{unit\int_use:N \l_countTMPA_int ans\int_use:N \l_countTMPB_int}{\csuse{unit\int_use:N \l_countTMPA_int qu\int_use:N \l_countTMPB_int}}}
                    {}

                \iow_now:cx {@auxout}{%记录当前题目的实际得分
                    \string\ansptstoparse{\int_use:N \l_countTMPA_int}{\int_use:N \l_countTMPB_int}{\csuse{unit\int_use:N \l_countTMPA_int ans\int_use:N \l_countTMPB_int}}%
                    }%
                %unit: \int_use:N \l_countTMPA_int qu: \int_use:N \l_countTMPB_int :pts: \csuse{unit\int_use:N \l_countTMPA_int ans\int_use:N \l_countTMPB_int} \par

                \fp_add:Nn \l_pointTMPB_fp {\csuse{unit\int_use:N \l_countTMPA_int qu\int_use:N \l_countTMPB_int}}

                \fp_add:Nn \l_pointTMPD_fp {\csuse{unit\int_use:N \l_countTMPA_int ans\int_use:N \l_countTMPB_int}}

                \int_gincr:N  \l_countTMPB_int
            }

        \iow_now:cx {@auxout}{%记录当前大题的分数
                \string\pointstoparse{\int_use:N \l_countTMPA_int}{0}{\fp_use:N \l_pointTMPB_fp}%
        }%

        \iow_now:cx {@auxout}{%记录当前大题的实际分数
                \string\ansptstoparse{\int_use:N \l_countTMPA_int}{0}{\fp_use:N \l_pointTMPD_fp}%
        }%

        %统计所有大题加在一起的总分
        \fp_gadd:Nn \l_pointTMPA_fp {\l_pointTMPB_fp}

        \fp_gadd:Nn \l_pointTMPC_fp {\l_pointTMPD_fp}

        \int_gincr:N  \l_countTMPA_int
        }

        %记录所有题目的总分
        \iow_now:cx {@auxout}{
                \string\pointstoparse{0}{0}{\fp_use:N \l_pointTMPA_fp}%
        }%

        %记录所有题目的总分
        \iow_now:cx {@auxout}{
                \string\ansptstoparse{0}{0}{\fp_use:N \l_pointTMPC_fp}%
        }%

        \iow_now:cx {@auxout}{
                \string\csgdef{totalpage}{\thepage}%
        }%

    }{}
  }

%
%
%重定义__exsheets_solution_internal:环境，用于当不给出答案时输出空白
%这里的空间增加时调出来的。
\newlength{\heightofsolution}
\RenewEnviron { __exsheets_solution_internal: }
  {
    \bool_if:nT
      { \g__exsheets_questions_use_bool && \l__exsheets_solutions_use_bool }
      { \bool_if:NTF \l__exsheets_solutions_print_bool
        {\__exsheets_save_solution:V \BODY}
        {\settoheight{\heightofsolution}{\parbox{\linewidth}{\BODY}}
        \addtolength{\heightofsolution}{3.92\baselineskip}
        \examspace{\heightofsolution}
        }
        %\csxdef{savedansunit\thesecunit qu\thequestion}{\BODY} %当有includegrphics时有问题
        %\csgdef{savedansunit\thesecunit qu\thequestion}{\BODY} %结果输出有问题
        %\protected@csxdef{savedansunit\thesecunit qu\thequestion}{\BODY} %没有问题
        \global\cslet{savedansunit\thesecunit qu\thequestion}{\BODY} %没有问题
      }
  }

\newcounter{countTMPA}

%输出各大题(节)的大题号，用于tabular环境中
\def\ForEachunit{
        \int_gset:Nn \l_countTMPA_int {1}
        \int_gset:Nn \l_countTMPB_int {\questionsunitall}
        %\int_use:N \l_countTMPB_int
        \int_while_do:nNnn {\l_countTMPA_int } < {\l_countTMPB_int + 1}
        {
          \setcounter{countTMPA}{\int_use:N \l_countTMPA_int}
          \chinese{countTMPA} \int_gincr:N \l_countTMPA_int &
        }
 }



 %输出<#1>大题中各小题的题号，用于tabular环境中
  \def\ForEachquinunit#1{
        \int_gset:Nn \l_countTMPA_int {1}
        \int_gset:Nn \l_countTMPB_int {\questionsunit{#1}}
        \int_while_do:nNnn {\l_countTMPA_int } <{\l_countTMPB_int + 1}
            {
               \int_use:N \l_countTMPA_int \int_gincr:N  \l_countTMPA_int &
            }
 }


%输出<#1>大题中各小题的分值，用于tabular环境中
\def\ForEachquinunitpoints#1{
    \int_gset:Nn \l_countTMPA_int {1}
    \int_gset:Nn \l_countTMPB_int {\questionsunit{#1}}
    \int_while_do:nNnn {\l_countTMPA_int } <{\l_countTMPB_int + 1}
        {
            \pointsques{#1}{\int_use:N \l_countTMPA_int}
            \int_gincr:N  \l_countTMPA_int &
        }
}

%输出<#1>大题中各小题的空分值，用于tabular环境中
\def\ForEachquinunitNOpts#1{
    \int_gset:Nn \l_countTMPA_int {1}
    \int_gset:Nn \l_countTMPB_int {\questionsunit{#1}}
    \int_while_do:nNnn {\l_countTMPA_int } <{\l_countTMPB_int + 1}
        {
            \int_gincr:N  \l_countTMPA_int &
        }
}

%输出各大题(节)的分值，用于tabular环境中
\def\ForEachunitpoints{
    \int_gset:Nn \l_countTMPA_int {1}
    \int_gset:Nn \l_countTMPB_int {\questionsunitall}
    \int_while_do:nNnn {\l_countTMPA_int } <{\l_countTMPB_int + 1}
        {
           \pointsunit{\int_use:N \l_countTMPA_int}
            \int_gincr:N  \l_countTMPA_int &
        }
}

%输出各大题(节)的空值，用于tabular环境中
\def\ForEachunitNOpts{
    \int_gset:Nn \l_countTMPA_int {1}
    \int_gset:Nn \l_countTMPB_int {\questionsunitall}
    \int_while_do:nNnn {\l_countTMPA_int } <{\l_countTMPB_int + 1}
        {
            \int_gincr:N  \l_countTMPA_int &
        }
}

%输出<#1>大题中各小题的得分，用于tabular环境中
 \def\ForEachquinunitanspts#1{
        \int_gset:Nn \l_countTMPA_int {1}
        \int_gset:Nn \l_countTMPB_int {\questionsunit{#1}}
        \int_while_do:nNnn {\l_countTMPA_int } <{\l_countTMPB_int + 1}
            {
                \bool_if:NT \l__simplexam_prtanswer_bool
                {\ansptsques{#1}{\int_use:N \l_countTMPA_int}}
                \int_gincr:N  \l_countTMPA_int &
            }
 }

%输出各大题(节)的得分，用于tabular环境中
 \def\ForEachunitanspts{
        \int_gset:Nn \l_countTMPA_int {1}
        \int_gset:Nn \l_countTMPB_int {\questionsunitall}
        \int_while_do:nNnn {\l_countTMPA_int } <{\l_countTMPB_int + 1}
            {
                \bool_if:NT \l__simplexam_prtanswer_bool
                {\ansptsunit{\int_use:N \l_countTMPA_int}}
                \int_gincr:N  \l_countTMPA_int &
            }
 }

\RequirePackage{multirow,array}
\newcounter{columntmp}

%
%用于输出全部大题的得分表
%
\def\assesstaball{%
\iftoggle{auxinfoused}{%
\noindent\begingroup\kaishu\large
\setcounter{columntmp}{\questionsunitall}
\addtocounter{columntmp}{2}
\bool_if:NTF \l__simplexam_scoreshow_bool
    {\begin{tabular}{|l|*{\questionsunitall}{>{\centering}p{0.8cm}|}c|>{\centering\arraybackslash}p{2cm}|}
    \hline
    大题 & \ForEachunit  总计 & 阅卷人\\ \hline
    分值 & \ForEachunitpoints \pointsall & \multirow {2}{2cm}{}\\ \cline{1-\thecolumntmp}
    得分 & \ForEachunitanspts \bool_if:NT \l__simplexam_prtanswer_bool{\ansptsall} & \\ \hline
    \end{tabular}}
    {\begin{tabular}{|l|*{\questionsunitall}{>{\centering}p{0.8cm}|}c|>{\centering\arraybackslash}p{2cm}|}
    \hline
    大题 & \ForEachunit  总计 & 阅卷人\\ \hline
    分值 & \ForEachunitpoints \pointsall  & \multirow {2}{2cm}{}\\ \cline{1-\thecolumntmp}
    得分 & \ForEachunitNOpts  & \\ \hline
    \end{tabular}}
\endgroup
}{}}



%
%用于输出各大题的小题得分表
%<#1>是大题的序号
\def\assesstabunit#1{%
\kaishu%
\setcounter{columntmp}{\questionsunit{#1}}
\addtocounter{columntmp}{2}
\bool_if:NTF \l__simplexam_scoreshow_bool
    {\begin{tabular}{|l|*{\questionsunit{#1}}{>{\centering}p{0.5cm}|}c|>{\centering\arraybackslash}p{2cm}|}
    \hline
    小题 & \ForEachquinunit{#1}  总计 & 阅卷人\\ \hline
    分值 & \ForEachquinunitpoints{#1} \pointsunit{#1} & \multirow {2}{1cm}{}\\ \cline{1-\thecolumntmp}
    得分 & \ForEachquinunitanspts{#1} \bool_if:NT \l__simplexam_prtanswer_bool{\ansptsunit{#1}} & \\ \hline
    \end{tabular}}
    {\begin{tabular}{|l|*{\questionsunit{#1}}{>{\centering}p{0.5cm}|}c|>{\centering\arraybackslash}p{2cm}|}
    \hline
    小题 & \ForEachquinunit{#1}  总计 & 阅卷人\\ \hline
    分值 & \ForEachquinunitpoints{#1} \pointsunit{#1}  & \multirow {2}{1cm}{}\\ \cline{1-\thecolumntmp}
    得分 & \ForEachquinunitNOpts{#1}  & \\ \hline
    \end{tabular}}
}

%
%用于输出各大题的答案，以表格的形式
%<#1>是表格的答案列的宽度，<#2>大题的序号
\newcommand{\answerstabunit}[2][\@empty]{
\bool_set_true:N \l__simplexam_inanswersheet_bool %给一些命令比如\answerpoints做标记，避免在给出单独的答案表时重做
\ifcsundef{unit#2qus}{\csxdef{unit#2qus}{\thequestionold}}{}
\renewcommand{\baselinestretch}{2.0}
\noindent \medskip\textbf{\heiti 第#2大题答案:}\\\medskip
\ifx#1\@empty
\begin{tabular}{|l|c|}
\else
\xdef\tabsetcolumn{#1}
\begin{tabular}{|l|m{\tabsetcolumn}|}
\fi
\hline
小题 & 答案  \\ \hline
\ForEachquinunitanswers{#2}
\end{tabular}\par
\bool_set_false:N \l__simplexam_inanswersheet_bool
}

%输出<#1>大题中各小题的答案，用于tabular环境中
\def\ForEachquinunitanswers#1{
    \int_gset:Nn \l_countTMPA_int {1}
    \int_gset:Nn \l_countTMPB_int {\csuse{unit#1qus}}
    \int_while_do:nNnn {\l_countTMPA_int } <{\l_countTMPB_int + 1}
        {
\int_use:N \l_countTMPA_int & \csuse{savedansunit#1qu\int_use:N \l_countTMPA_int} \int_gincr:N  \l_countTMPA_int \\ \hline
        }
}

%
%用于输出各大题的答案，以正文的形式
%<#1>是表格的答案列的宽度，<#2>大题的序号
\newcommand{\answersinfounit}[2][\@empty]{%
\bool_set_true:N \l__simplexam_inanswersheet_bool %给一些命令比如\answerpoints做标记，避免在给出单独的答案表时重做
\ifcsundef{unit#2qus}{\csxdef{unit#2qus}{\thequestionold}}{}
\renewcommand{\baselinestretch}{2.0}
\noindent\textbf{\heiti 第#2大题答案:}\\ %\medskip
\ifx#1\@empty
\xdef\tasksetcolumn{3cm}
\else
\xdef\tasksetcolumn{#1}
\fi
\int_gset:Nn \l_countTMPA_int {1}
\int_gset:Nn \l_countTMPB_int {\csuse{unit#2qus}}%\questionsunit{#2}
\int_while_do:nNnn {\l_countTMPA_int } <{\l_countTMPB_int + 1}
    {\parbox{\tasksetcolumn}{%
    \int_use:N \l_countTMPA_int :\ \csuse{savedansunit#2qu\int_use:N \l_countTMPA_int}\hfill}\space
    \int_gincr:N  \l_countTMPA_int
    }
\par
\bool_set_false:N \l__simplexam_inanswersheet_bool
}


\RequirePackage{pifont}
%
%判断和选择题答案填写命令
%加上实际得分的处理
%%\answer[score]{<right|right|A,B,C,D>}%两个nobreak使换行后仍右对齐
\NewDocumentCommand{\answer}{o m}{%
\nolinebreak\hfill\nolinebreak\hfill\nolinebreak\hfill%
\makebox{(\space\makebox[3em]{%
\bool_if:nTF {\l__simplexam_prtanswer_bool}%
    {\color{blue}\str_case:nnTF {#2}{%
        {right} {\char"221A}%\ding{52}
        {wrong} {\char"00D7}%\ding{56}
        }{}{#2}%
    }{}%
    }\space)\par}%
    \tl_if_blank:nTF {#1}
    {\csxdef{unit\thesecunit ans\thequestion}{\csuse{unit\thesecunit qu\thequestion}}}
    {
        \IfNoValueTF {#1}
        {\csxdef{unit\thesecunit ans\thequestion}{\csuse{unit\thesecunit qu\thequestion}}}
        {\csxdef{unit\thesecunit ans\thequestion}{#1}}
    }
\csgdef{savedansunit\thesecunit qu\thequestion}{\str_case:nnTF {#2}{%
        {right} {\char"221A}%\ding{52}
        {wrong} {\char"00D7}%\ding{56}
        }{}{#2}}%将信息记录到一个命令中
}

%
%填空题答案填写命令
%加上实际得分的处理
%\answer[score]{<answer contents}
\NewDocumentCommand{\answerblank}{o m}{%
    \begingroup\color{blue}\blank{#2}\endgroup
    \tl_if_blank:nTF {#1}
    {\csxdef{unit\thesecunit ans\thequestion}{\csuse{unit\thesecunit qu\thequestion}}}
    {
        \IfNoValueTF {#1}
        {\csxdef{unit\thesecunit ans\thequestion}{\csuse{unit\thesecunit qu\thequestion}}}
        {\csxdef{unit\thesecunit ans\thequestion}{#1}}
    }
\ifcsundef{savedansunit\thesecunit qu\thequestion}{%
    \tl_gset:Nn \l__simplexam_tempans_tl {#2}
    \csgdef{savedansunit\thesecunit qu\thequestion}{#2}%将信息记录到一个命令中
    }{
    \tl_gput_right:Nn \l__simplexam_tempans_tl {；#2}
    \csxdef{savedansunit\thesecunit qu\thequestion}{\tl_use:N \l__simplexam_tempans_tl}%
    }%
}

%
%填空题答案填写命令
%加上实际得分的处理
%\answerpoints[score]
\NewDocumentCommand{\answerpoints}{o}{%
    \bool_if:NTF \l__simplexam_inanswersheet_bool
    {}
    {
        \tl_if_blank:nTF {#1}
        {\csxdef{unit\thesecunit ans\thequestion}{\csuse{unit\thesecunit qu\thequestion}}}
        {
            \IfNoValueTF {#1}
            {\csxdef{unit\thesecunit ans\thequestion}{\csuse{unit\thesecunit qu\thequestion}}}
            {\csxdef{unit\thesecunit ans\thequestion}{#1}}
            %unit:\thesecunit :qu \thequestion :pts: \csuse{unit\thesecunit ans\thequestion}
        }
    }
}

\RequirePackage{tasks}%选择题的选项，利用tasks环境
\settasks{
  %counter-format={tsk[A].}, %tasks v1.0 版本已经弃用，改用下面的label的形式。
  %item-indent={1pt}, %弃用counter-format indent的机制也变为list的机制所以设置该值时要考虑label-width和label-offset
  label= \alph*.,
  label-align=left,
  label-width = {1em},
  label-offset={0.4em},
  %%注意这里indent做了更多的缩进使其与题目内容对齐，若要让标签与题目数字对齐则修改为1.4em即可
  item-indent={2.75em},
  column-sep={2pt},
  before-skip={-0.7em},
  after-skip={-0.7em},
  %after-item-skip = 1ex plus 1ex minus 1ex %  default skip
  after-item-skip = -2pt plus 2pt minus 2pt
}


%
%设置一个记号列表，用于选择题选项的设置和处理
%
\tl_new:N \l__simplexam_tasks_tl
\newlength{\lenoftask}
\newlength{\lenoftaskold}


%
%递归处理指定数量的{}包围的参数
%可以看到内部函数的选项规范不一定要写的非常清楚，比如这里deal后面加上:NN
%
\cs_new:Npn \simplexam_options_deal #1#2
{\settowidth{\lenoftask}{\makebox{#2}}
%\the\lenoftask
\if_dim:w \the\lenoftask > \the\lenoftaskold
    \setlength{\lenoftaskold}{\lenoftask}
\fi:
\tl_put_right:Nn \l__simplexam_tasks_tl {\task #2 }
\if_int_compare:w #1>1\relax%\z@
\exp_after:wN \use_i:nn
\else:
\exp_after:wN \use_ii:nn
\fi:
{\exp_after:wN\simplexam_options_deal\exp_after:wN{\number\numexpr#1-1}}%
{\tl_put_right:Nn \l__simplexam_tasks_tl {\end{tasks}}
\if_dim:w \the\lenoftaskold > 0.48\linewidth
\tl_set:Nn \l__simplexam_tempb_tl {1}
\else:
\if_dim:w \the\lenoftaskold > 0.21\linewidth
\tl_set:Nn \l__simplexam_tempb_tl {2}
\fi:
\fi:
\l__simplexam_tasks_tl}%
}

%
%\options[<#1>]
%#1为缺省的选项个数
%
\tl_new:N \l__simplexam_tempa_tl %用于记录选项的数量
\tl_new:N \l__simplexam_tempb_tl %用于设置选项排列的列数
\NewDocumentCommand{\options}{O{4}}{%
\tl_if_blank:nTF {#1}
{ \tl_set:Nn \l__simplexam_tempa_tl {4} }
{ \tl_set:Nn \l__simplexam_tempa_tl {#1} }
\tl_set:Nn \l__simplexam_tempb_tl {4}
\setlength{\lenoftaskold}{0pt}
\tl_set:Nn \l__simplexam_tasks_tl {\par\begin{tasks}(\l__simplexam_tempb_tl)}
\simplexam_options_deal \l__simplexam_tempa_tl
}


%
% 解答或证明题中的评分标准
%
\newcommand{\cdotfill}{\leavevmode\xleaders\hbox to 0.5em{\hss$\cdot$\hss}\hfill\kern0pt\relax}
\newcommand{\myscore}[1]{\textcolor{blue}{#1\kern0.2em 分}}
\newcommand{\scoretext}[1]{\cdotfill\myscore{#1}\par\noindent\ignorespaces}
\newcommand{\scoreeqno}[1]{\eqno{\cdots\cdots\text{\myscore{#1}}}}
\newcommand{\scoretag}[1]{\tag*{$\cdots\cdots$\myscore{#1}}}

\newrobustcmd{\score}[1]{%
  \ifbool{mmode}{%
    \ifdefstrequal{\tag}{\dft@tag}{\scoreeqno{#1}}{\scoretag{#1}}%
  }{%
    \scoretext{#1}%
  }%
}

\RequirePackage{ccaption}
%使用\tabcaptionfix命令产生在浮动体外与默认caption一致的标题
\newfixedcaption{\tabcaption}{table}
\newfixedcaption{\figcaption}{figure}
\newenvironment{insertfig}[2]%%定义的非浮动插图环境
{\par\begingroup\def\figcaptioninfo{#1}\def\figlabelinfo{#2}\centering\addvspace{0.5ex}
\renewcommand{\baselinestretch}{0.9}}%
{\figcaption{\figcaptioninfo}\label{\figlabelinfo}\par\endgroup\vspace{1ex}}
\newenvironment{inserttab}[2]%%定义的非浮动表格环境
{\par\begingroup\renewcommand{\baselinestretch}{0.9}\tabcaption{#1}\label{#2}\par\noindent\centering}%
{\par\vspace{1ex}\endgroup\vspace{1ex}}


\ExplSyntaxOff

\setmainfont{CMU Serif}%带空格的字体设置不能放在latex3的环境中
\setCJKmainfont{SourceHanSerifSC-Regular.otf}

%tikz的usetikzlibrary不能放在latex3语法环境中，
%或者采用打补丁的方法，补丁后则可以放置，详见tex.se
%\RequirePackage{pgf}
\RequirePackage{tikz}
\usetikzlibrary{shapes,snakes}
\tikzset{
    milines/.style={very thin,dash pattern=on 0.1em off 0.1em, blue!50},
    mibox/.style={thin},
}

\def\pagestudentudf{学院:\underline{\hspace{5em}}班级:\underline{\hspace{5em}}
  姓名:\underline{\hspace{5em}}学号:\underline{\hspace{5em}}}
\def\pagesealingudf{学\\[1em]生\\[1em]答\\[1em]卷\\[1em]不\\[1em]要\\[1em]超\\[1em]过\\[1em]此\\[1em]线}
\def\pagestudent#1{\def\pagestudentudf{#1}}
\def\pagesealing#1{\def\pagesealingudf{#1}}

\newcommand{\drawcomposition}[3][0.8]{
    \begingroup
    \centering
    \begin{tikzpicture}[scale=#1]
      % 包含#2*#3个方格的边框框
      % x方向由#2列单位为1的格子，y方向为#3行单位为1的格子，每行格子之间间隔0.4
      \draw[line width = 0.8pt](0,0)rectangle(#2,{#3 *1.4});

      % 画#2-1条竖线，与边框构成，#2列
      \foreach \m in {1,2,...,\numexpr#2-1}\draw(\m,0) -- (\m,{#3 *1.4});

      % 画#3个代表0.4间隔的横矩形，把间隔内部的线覆盖
      \foreach \n in {1,2,..., \the\numexpr#3 }\draw[fill=white,line width=0.4pt](0,{1.4*\n-0.4})rectangle(#2 ,{1.4*\n});
    \end{tikzpicture}\par
    \endgroup
}

\RequirePackage{everypage}
\newcommand{\sealruleleft}{%
\def\1{\\[50mm]}\def\2{\\[15mm]}%
\begin{tikzpicture}[remember picture,overlay,very thick,font=\large]
  \path (current page.south west) +(1.5cm,1cm)  coordinate (a1);
  \path (current page.north west) +(1.5cm,-1cm) coordinate (a2);
  \path (current page.south west) +(2.5cm,1cm)  coordinate (b1);
  \path (current page.north west) +(2.5cm,-1cm) coordinate (b2);
  \draw[dashed] (a1) -- node[left=1mm,text width=1em]{装\1订\1线}
     node[right=1mm,text width=1em]{\pagesealingudf} (a2);
  \draw (b1) -- (b2);
\end{tikzpicture}}

\newcommand{\sealareainfo}{%
\def\1{\\[50mm]}\def\2{\\[15mm]}%
\begin{tikzpicture}[remember picture,overlay,very thick,font=\large]
  \path (current page.south west) +(1.5cm,1cm)  coordinate (a1);
  \path (current page.north west) +(1.5cm,-1cm) coordinate (a2);
  \path (current page.south west) +(2.5cm,1cm)  coordinate (b1);
  \path (current page.north west) +(2.5cm,-1cm) coordinate (b2);
  \draw[dashed] (a1) -- node[left=1mm,text width=1em]{
  \rotatebox{90}{\parbox{34em}{\pagestudentudf}}}%
     node[right=1mm,text width=1em]{\pagesealingudf} (a2);
  \draw (b1) -- (b2);
\end{tikzpicture}}

\newcommand{\sealruleright}{%
\def\1{\\[50mm]}\def\2{\\[15mm]}%
\begin{tikzpicture}[remember picture,overlay,very thick,font=\large]
  \path (current page.south east) +(-1.5cm,1cm)  coordinate (a1);
  \path (current page.north east) +(-1.5cm,-1cm) coordinate (a2);
  \path (current page.south east) +(-2.5cm,1cm)  coordinate (b1);
  \path (current page.north east) +(-2.5cm,-1cm) coordinate (b2);
  \draw[dashed] (a1) -- node[right=1mm,text width=1em]{装\1订\1线}
     node[left=1mm,text width=1em]{\pagesealingudf} (a2);
  \draw (b1) -- (b2);
\end{tikzpicture}}

\newcommand{\scratchpaper}{%
\begin{tikzpicture}[remember picture,overlay,font=\sffamily\fontsize{72pt}{72pt}\selectfont]
  \node[text=lightgray!20] at (current page.center) {草\quad 稿\quad 纸};
\end{tikzpicture}}

\ExplSyntaxOn

\bool_if:NT \l__simplexam_sealrule_bool
{\AddEverypageHook{
\ifnumequal{\value{page}}{1}{\sealareainfo}{
    \ifcsstring{paperprintname}{double}
    {\ifnumodd{\value{page}}{\sealruleleft}{\sealruleright}}
    {\sealruleleft}}
}}

\bool_if:NT \l__simplexam_scratch_bool {
% 在 twocolumn 文档中，\newpage 可能是到下一栏，\clearpage 才能保证到下一页
\AtEndDocument{
\clearpage\pagestyle{empty}\scratchpaper\clearpage\scratchpaper\addtocounter{page}{-2}
}
%\preto{\@enddocumenthook}{\clearpage\pagestyle{empty}\caogaozhi\clearpage\caogaozhi\addtocounter{page}{-2}}
}

%
%用于输出拼音和米子格的汉字的处理
\str_new:N \l__simplexam_hanzi_str
\def\hanzimibox{\tikz{%米字格形状
    \def\xst{0}
    \def\yst{0}
    \def\xed{1em}
    \def\yed{1.05em}
    \draw[mibox](\xst,\yst) rectangle (\xed,\yed);
    \draw[milines](\xst,\yst) -- (\xed,\yed);
    \draw[milines](\xst,\yed) -- (\xed,\yst);
    \draw[milines](\xst,\yed/2) -- (\xed,\yed/2);
    \draw[milines](\xed/2,\yst) -- (\xed/2,\yed);
    }}
\def\hanzibox{\tikz{%覆盖盒子形状用于覆盖汉字
    \def\xst{0}
    \def\yst{0}
    \def\xed{1em}
    \def\yed{1.05em}
    \draw[mibox,fill=white](\xst,\yst) rectangle (\xed,\yed);
    }}

\cs_new:Npn \simplexam_boxadd_hanzi:N #1%为当前汉字加上米子格
{
    \CJKglue\rlap{\lower 0.18em \hbox{\hanzimibox}}#1
}

\cs_new:Npn \simplexam_boxadd_hanzihide:N #1%覆盖当前汉字再加上米字格
{
    #1\llap{\lower 0.18em \hbox{\hanzibox}}\llap{\lower 0.18em \hbox{\hanzimibox}}\CJKglue
}

\cs_new:Nn \simplexam_map_boxadd_hanzi:N%
{
    \str_set:Nn \l__simplexam_hanzi_str {#1}
    \str_map_function:NN \l__simplexam_hanzi_str \simplexam_boxadd_hanzi:N
}
\cs_new:Nn \simplexam_map_boxadd_hanzihide:N%
{
    \str_set:Nn \l__simplexam_hanzi_str {#1}
    \str_map_function:NN \l__simplexam_hanzi_str \simplexam_boxadd_hanzihide:N
}

\NewDocumentCommand{\answerpinyinbox}{m}{
\begingroup
%\color{blue}
    \bool_if:NTF \l__simplexam_prtanswer_bool
        {\xpinyin*{\simplexam_map_boxadd_hanzi:N {#1}}}
        {\simplexam_map_boxadd_hanzi:N {#1}}
\ifcsundef{savedansunit\thesecunit qu\thequestion}{%
    \tl_gset:Nn \l__simplexam_tempans_tl {#1}
    \csgdef{savedansunit\thesecunit qu\thequestion}{\xpinyin*{#1}}%将信息记录到一个命令中
    }{
    \tl_gput_right:Nn \l__simplexam_tempans_tl {；#1}
    \csxdef{savedansunit\thesecunit qu\thequestion}{\xpinyin*{\tl_use:N \l__simplexam_tempans_tl}}%
    }%
\endgroup
}

\NewDocumentCommand{\answerpinyin}{m}{
\begingroup
%\color{blue}
    \bool_if:NTF \l__simplexam_prtanswer_bool
        {\xpinyin*{#1}}
        {\simplexam_map_boxadd_hanzi:N {#1}}
\ifcsundef{savedansunit\thesecunit qu\thequestion}{%
    \tl_gset:Nn \l__simplexam_tempans_tl {#1}
    \csgdef{savedansunit\thesecunit qu\thequestion}{\xpinyin*{#1}}%将信息记录到一个命令中
    }{
    \tl_gput_right:Nn \l__simplexam_tempans_tl {；#1}
    \csxdef{savedansunit\thesecunit qu\thequestion}{\xpinyin*{\tl_use:N \l__simplexam_tempans_tl}}%
    }%
\endgroup
}


\NewDocumentCommand{\answerhanzi}{m}{
\begingroup
%\color{blue}
    \bool_if:NTF \l__simplexam_prtanswer_bool
        {\xpinyin*{\simplexam_map_boxadd_hanzi:N {#1}}}
        {\xpinyin*{\simplexam_map_boxadd_hanzihide:N {#1}}}
\ifcsundef{savedansunit\thesecunit qu\thequestion}{%
    \tl_gset:Nn \l__simplexam_tempans_tl {#1}
    \csgdef{savedansunit\thesecunit qu\thequestion}{#1}%将信息记录到一个命令中
    }{
    \tl_gput_right:Nn \l__simplexam_tempans_tl {；#1}
    \csxdef{savedansunit\thesecunit qu\thequestion}{\tl_use:N \l__simplexam_tempans_tl}%
    }%
\endgroup
}

\ExplSyntaxOff
