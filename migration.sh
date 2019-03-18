#!/usr/bin/env php
<?php
/**
 * 简单的数据迁移,能够实现简单的数据迁移, 只是执行数据库数据
 * @todo 部分是需要修改的部分 
 * kun
 */
echo "数据迁移脚本开始执行...\n";
echo "****************************\n";
echo "****************************\n";
echo "\n\n";
//@todo ... 数据迁移文件目录,这里可以放在任意下, 当前目录需要读写的权限 
$migrationDir = './migration';

if (!file_exists($migrationDir)) {
   exit("数据迁移文件不存在!\n");      
}

//@todo ... 迁移执行文件
$logFile = $migrationDir.'/log.json';

if (!file_exists($logFile)) touch($logFile);

//数据操作 todo ...  数据库连接信息 dbname数据库 host数据服务地址  root数据库账号 root数据库密码
$db = new PDO("mysql:dbname=test;host=localhost", "root", "root");

if (!$db) exit("数据库连接错误\n");

$logs = file_get_contents($logFile);
$logLength = 0;
if (!empty($logs)) {
    $logs = json_decode($logs, true);
    $logs && $logLength = count($logs);
}
!$logLength && $logs = [];
//遍历迁移目录, 并且执行迁移文件
$fp = opendir($migrationDir);
$existsNewFile = false;
while (false !== ($file = readdir($fp))) {
    if (is_file($migrationDir.'/'.$file) && pathinfo($file, PATHINFO_EXTENSION) == 'sql') {
        if($logLength && in_array($file, $logs)) continue;
        $existsNewFile = true;
        $fileContent = file_get_contents($migrationDir.'/'.$file);
        
        echo $file." 执行中...\n";

        $affectedRow = $db->exec($fileContent);
        if ($affectedRow === false) {
            echo $file. $file. " 执行错误\n"; 
            echo "错误信息如下...\n";
            echo $db->errorInfo()[2]."\n";
            exit;
        }
                
        echo $file. "执行结束...\n";
        echo "---------------------------\n";
        //写入log
        array_push($logs, $file);
    }
}
closedir($fp);
if (!$existsNewFile) exit("没有新的数据迁移文件\n");

if ($existsNewFile) {
    file_put_contents($logFile, json_encode($logs));    
}


echo "\n\n";
echo "脚本执行结束....\n";
