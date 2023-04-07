@echo off

git config --local user.name "luorily"
git config --local user.email "luorily@mail.hfut.edu.cn"

set input="只是一点微小的贡献"
echo Default:只是一点微小的贡献
set /p input=git commit -m 

git add *
git commit -m "%input%"
git push

pause