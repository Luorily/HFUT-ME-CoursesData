chcp 65001
@echo off

set input="只是一点微小的贡献"
echo Default:只是一点微小的贡献
set /p input=git commit -m 

git add *
git commit -m %input%
git push

pause