let pluralize =
    (signular, plural, quantity) => {
        if(quantity === 1){
            return signular
        }else {
            return plural
        }
    }

const dom = document.getElementById("market");
dom.innerText = pluralize("Mango", "Mangoes", 3);
