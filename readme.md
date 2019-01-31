<b>Date of last change: 2019-01-25 to version v1.0a</b>

# һ�����Ծ��ĵ��� simplexam

---------------------------------------------------------------

simplexam.cls --- A simple class for chinese exam paper
based on exsheets bundles
Maintained by huzhenzhen
E-mail: hzzmail@163.com
Released under the LaTeX Project Public License v1.3c or later

---------------------------------------------------------------
   

## ����

һ���򵥵��Ծ�ģ���� simplexam���Ծ���д𰸺��޴�����ģʽ��ʹ��ѡ�� answer ���ơ�
���������ͳ�Ʊ�ʱ��answerѡ��Ҳ����ʵ�ʵ÷�ͳ�ƣ�����ӡ��ʱ����÷�ͳ�ƣ����������
�Ծ�����⻮�ֱ��ʹ��chapter��section�������ĵ��½����Ĭ��ʹ��section�����Ҫʹ��chapter����������countunit=chapter

�Ծ������Ŀȫ����question��������������һ����ѡ�ı�ѡ����������Ŀ���÷�ֵ�����磺
```
\begin{question}{5}
question contents
\end{question}
```

�ж������\answer{right}��\answer{wrong}��ʾ�Ժʹ����Դ���ѡ������ʾʵ�ʵ÷ֱ���\answer[1]{right}
ѡ�������\answer{ѡ��ѡ��}��ʾ��ѡ�е�ѡ������������������Դ���ѡ������ʾʵ�ʵ÷ֱ���\answer[1]{A}��ѡ����ѡ�������tasks�������ã�Ҳ����ͨ��options�������á����磺
```
  \begin{tasks}(4)
    \task �����Ȼ����
	\task ��Ч����
	\task һ�¹���
  \end{tasks}
```
��
```
\options[3]{�����Ȼ����}
	{��Ч����}
	{һ�¹���}
```
���У�tasks������(4)��ָ��һ���з���ѡ�����������options����������[3]��ָ��ѡ��ĸ�����һ���е��������Զ�������

��������\answerblank{������}��ʾ�����Դ���ѡ������ʾʵ�ʵ÷ֱ���\answerblank[2]{A}
�����������\answerhanzi{��������}��ʾ�𰸡�ƴ���������\answerpinyin{��������}��ʾ�𰸡�
����\answerhanzi��\answerpinyin����Ƚϸ��ӣ�һ�����п��ܳ��ֶ������˲�����ѡ������ʾ�÷֡�
�����Ŀ��������������\answerpoints[3]������
�������solution������ʾ������÷���һ���������ŵĿ�ѡ������ʾ������:
```
\begin{solution}{5}
answer contents
\end{solution}
```

simplexam ����Ҫ���������º��:
latex3 kernel��etoolbox��ctex��xpinyin��amsmath��unicode-math��titlesec��exsheets��tasks��
tikz��xcolor��ccaption��subfigure��mwe

����ʵ�ֲο���:
sd44 �� danexam��
Jianrui Lyu �� jnuexam��
htharoldht �� USTBExam��
Charles Bao �� BHCexam
���ܶ��� CMC �ȡ�
���ڿ��ٹ���ʵ�ֿ��ǣ����ִ���ֱ�ӽ��ã�����л!

## ѡ��˵����

* answer ��ӡ�Ծ��
	answer=true��answer�����ӡ�𰸣�
	answer=false���򲻴�ӡ��
* countunit ����С��ļ����������֣�
	countunit=chapter��������Ÿ���chapter���м���
	countunit=section��countunit��������Ÿ���section���м���
	countunit=none���������ȫ��ͳһ����
* sheetsize �����Ծ��ֽ�Ŵ�С
	sheetsize=A4��sheetsize���Ծ�ֽ��ΪA4
	sheetsize=A3���Ծ�ֽ��ΪA3
* paperprint �����Ծ��Ƿ�˫���ӡ
	paperprint=double��paperprint���Ծ�ֽ��˫���ӡ
	paperprint=single���Ծ�ֽ�ŵ����ӡ
* scoretable �����Ƿ��������ͳ�Ʊ�/���ֱ�
	scoretable=true��scoretable���������ͳ�Ʊ�
	scoretable=false�����������ͳ�Ʊ�

## ��Ҫ�ص�

* �����ѡ�����
* ֽ�Ŵ�С��ѡ�����
* ��˫���ӡ��ͬ����(����ֽ�ź��ܷ���)��ѡ�����
* ���ⵥԪ��ͬ���õ�ѡ�����
* ��Ŀ��������ѡ��
* �Զ��Ĵ����ȫ�ּƷֱ�(��ֵ�͵÷ֵķ���)
* ��Ŀ��ʽ�ֲ�������
* �򻯵��������ƴ����
* �Զ���ҳüҳ�źͲݸ�ҳ
* ѡ����ѡ���������tasks�ֶ�����Ҳ������options�����Զ�����
* ����ӡ��ʱ�Զ������ʵ��հ��Ա���д��


## �÷�

* ��Ϊ�ĵ�������
* ����ֱ����center��������
* ���ⷽ���ο�ʾ���Ծ�
* ����ҳ�����Ԫ�ذ���༭
* �����������ѧ���尴������
* ����xelatex����


## need to do

* ֮ǰ���ڹ���ʵ�ֿ��ǣ����ִ���δ��latex3ʵ�֣����ڿ�������exsheets��task��ȫ��latex3ʵ�֡�
* һЩϸ�����д����ơ�


# ������ʷ
* 2018-12-01 to version v1.0
* 2019-01-25 to version v1.0a
