#!/bin/bash
# QQ群：111601117、钉钉群：35948877

# stage1
sudo `dirname ${BASH_SOURCE[0]}`/stage1/step1.sh
[ $? = 0 ] || exit 3
sudo `dirname ${BASH_SOURCE[0]}`/stage1/step2.sh
[ $? = 0 ] || exit 3

# stage2
sudo `dirname ${BASH_SOURCE[0]}`/stage2/step1.sh
[ $? = 0 ] || exit 3
sudo `dirname ${BASH_SOURCE[0]}`/stage2/step2.sh
[ $? = 0 ] || exit 3
sudo `dirname ${BASH_SOURCE[0]}`/stage2/step3.sh
[ $? = 0 ] || exit 3

# stage3
sudo `dirname ${BASH_SOURCE[0]}`/stage3/step1.sh
[ $? = 0 ] || exit 3
