运行程序：
1.运行模拟时打开demos.html, 取消浏览器安全警告，保证机子上安装了flash插件。
2.点击唯一的一个button后选择在同一目录下的data.xls(actionscript库对xlsx类型的文件支持不好，所以需要读取xls).
3.等待2-5秒即可看到全部的结果。
4.在graph部分，鼠标双击节点，可以隐藏非邻居节点。
再次点击同一节点可以恢复显示其它节点和边，当然也可以点击邻居节点来观察邻居节点的邻居节点。
5.平均最短路径是针对每个子图来算的，有两个节点自成一个子图，所以最后summary时，平均最短路径有两个。
查看源代码：
1.进入sourceview文件夹，打开index.html即可查看源代码。