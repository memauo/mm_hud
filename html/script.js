window.addEventListener('message', (event) => {
    const data = event.data;
    if (data.action === 'update') {
        const hp = document.getElementById('hp');
        const armour = document.getElementById('armour');
        const hunger = document.getElementById('hunger');
        const thirst = document.getElementById('thirst');
        const stamina = document.getElementById('stamina');
        hp.style.width = data.healthGlobal + "%";
        armour.style.width = data.armourGlobal + "%";
        hunger.style.width = data.hungerGlobal + "%";
        thirst.style.width = data.thirstGlobal + "%";
        stamina.style.width = (100 - data.stm) + "%";
    }
    if (data.action === 'cinema') {
        if (data.showC==1){
            const cn = document.getElementById('cn');
            cn.style.display = 'block'
            const cn2 = document.getElementById('cn2');
            cn2.style.display = 'block'
            const bxs = document.getElementById('bxs');
            bxs.style.display = 'none'
            const speedb = document.getElementById('speedb');
            speedb.style.display = 'none'
            const h2 = document.getElementById('h2');
            h2.style.display = 'none'
        } else {
            const cn = document.getElementById('cn');
            cn.style.display = 'none'
            const cn2 = document.getElementById('cn2');
            cn2.style.display = 'none'
            const bxs = document.getElementById('bxs');
            bxs.style.display = 'flex'
            const speedb = document.getElementById('speedb');
            speedb.style.display = 'flex'
            const h2 = document.getElementById('h2');
            h2.style.display = 'flex'
        }
        
    }
    if (data.action == 'vehSp'){
        const spdTxt = document.getElementById('spdTxt');
        spdTxt.innerText = Math.round(data.speed);
        const sps = document.getElementById('sps');
        sps.style.width = data.speed * 1.2
        const fl = document.getElementById('fl');
        fl.style.width = data.fuel + '%'
        const engine = document.getElementById('engine');
        engine.style.width = (data.eng /10) + '%'
        if (data.speed>30){
            sps.style.backgroundColor = 'rgba(133, 44, 44, 1)';
            if (data.speed>60){
                sps.style.backgroundColor = 'rgba(194, 79, 51, 1)';
                if (data.speed>100){
                    sps.style.backgroundColor = 'rgba(216, 65, 28, 1)';
                    if (data.speed>160){
                        sps.style.backgroundColor = 'gold';
                    }
                }
            }
        } else {
            sps.style.backgroundColor = 'rgb(92, 34, 34)';
        }

    }
    if (data.action == 'playerVeh'){
        if (data.vehHud==1){
            const speedb = document.getElementById('speedb');
            speedb.style.display = 'flex'
        }else{
            const speedb = document.getElementById('speedb');
            speedb.style.display = 'none'
        }
    }
    if (data.action =='hud2') {
        document.getElementById('street').innerHTML = data.street;
        document.getElementById('job').innerHTML = data.job;
        document.getElementById('money').innerHTML = data.money;
    }
});
