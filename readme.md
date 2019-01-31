<b>Date of last change: 2019-01-25 to version v1.0a</b>

# 一个简单试卷文档类 simplexam

---------------------------------------------------------------

simplexam.cls --- A simple class for chinese exam paper
based on exsheets bundles
Maintained by huzhenzhen
E-mail: hzzmail@163.com
Released under the LaTeX Project Public License v1.3c or later

---------------------------------------------------------------
   

## 介绍

一个简单的试卷模板类 simplexam。试卷分有答案和无答案两种模式，使用选项 answer 控制。
当输出分数统计表时，answer选项也控制实际得分统计，当打印答案时输出得分统计，否则不输出。
试卷各大题划分标记使用chapter，section等正常文档章节命令。默认使用section，如果要使用chapter，则需设置countunit=chapter

试卷各个题目全部用question环境，可以利用一个可选的必选参数给该题目设置分值，比如：
```
\begin{question}{5}
question contents
\end{question}
```

判断题答案用\answer{right}和\answer{wrong}表示对和错。可以带可选参数表示实际得分比如\answer[1]{right}
选择题答案用\answer{选择选项}表示，选中的选项可以任意数量。可以带可选参数表示实际得分比如\answer[1]{A}。选择题选项可以用tasks环境设置，也可以通过options命令设置。比如：
```
  \begin{tasks}(4)
    \task 最大似然估计
	\task 有效估计
	\task 一致估计
  \end{tasks}
```
或
```
\options[3]{最大似然估计}
	{有效估计}
	{一致估计}
```
其中：tasks环境中(4)是指定一行中放置选项的栏数，而options命令后面给出[3]是指定选项的个数，一行中的栏数则自动调整，

填空题答案用\answerblank{答案内容}表示。可以带可选参数表示实际得分比如\answerblank[2]{A}
汉字填空题用\answerhanzi{汉字内容}表示答案。拼音填空题用\answerpinyin{汉字内容}表示答案。
由于\answerhanzi和\answerpinyin命令比较复杂，一个题中可能出现多个，因此不带可选参数表示得分。
这个题目给出分数用命令\answerpoints[3]给出。
简单题答案用solution环境表示。简单题得分用一个带花括号的可选参数表示，比如:
```
\begin{solution}{5}
answer contents
\end{solution}
```

simplexam 类主要依赖于如下宏包:
latex3 kernel，etoolbox，ctex，xpinyin，amsmath，unicode-math，titlesec，exsheets，tasks，
tikz，xcolor，ccaption，subfigure，mwe

代码实现参考了:
sd44 的 danexam、
Jianrui Lyu 的 jnuexam、
htharoldht 的 USTBExam、
Charles Bao 的 BHCexam
唐绍东的 CMC 等。
出于快速功能实现考虑，部分代码直接借用，深表感谢!

## 选项说明：

* answer 打印试卷答案
	answer=true或answer，则打印答案；
	answer=false，则不打印答案
* countunit 设置小题的计数关联划分：
	countunit=chapter，题名序号根据chapter进行计数
	countunit=section或countunit，题名序号根据section进行计数
	countunit=none，题名序号全文统一计数
* sheetsize 设置试卷的纸张大小
	sheetsize=A4或sheetsize，试卷纸张为A4
	sheetsize=A3，试卷纸张为A3
* paperprint 设置试卷是否双面打印
	paperprint=double或paperprint，试卷纸张双面打印
	paperprint=single，试卷纸张单面打印
* scoretable 设置是否输出分数统计表/评分表
	scoretable=true或scoretable，输出分数统计表
	scoretable=false，不输出分数统计表

## 主要特点

* 答案输出选项控制
* 纸张大小的选项控制
* 单双面打印不同设置(包括纸张和密封线)的选项控制
* 大题单元不同设置的选项控制
* 题目从题库随机选择
* 自动的大题和全局计分表(分值和得分的分离)
* 题目格式局部可设置
* 简化的填字题和拼音题
* 自动的页眉页脚和草稿页
* 选择题选项可以利用tasks手动给出也可以用options命令自动设置
* 不打印答案时自动留出适当空白以便填写答案


## 用法

* 作为文档类引入
* 标题直接用center环境输入
* 出题方法参考示例试卷
* 其它页面可视元素按需编辑
* 正文字体和数学字体按需设置
* 采用xelatex编译


## need to do

* 之前出于功能实现考虑，部分代码未用latex3实现，后期考虑类似exsheets和task完全用latex3实现。
* 一些细节仍有待完善。


# 更新历史
* 2018-12-01 to version v1.0
* 2019-01-25 to version v1.0a
