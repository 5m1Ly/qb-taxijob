class Meter {
    constructor() {
        this.started = false;
        this.currentFare = 0;
        this.distanceTraveled = 0;
        this.defaultPrice = 0;
        this.elements = {
            meter: document.querySelectorAll(".container")[0],
            totalPrice: $("#total-price"),
            totalDistance: $("#total-distance"),
            toggleMeterBtn: $(".toggle-meter-btn"),
            toggleMeterBtnText: $(".toggle-meter-btn p"),
        }
    }

    setCurrentFare(fare) {
        this.currentFare = fare;
    }

    setDistanceTraveled(distance) {
        this.distanceTraveled = distance;
    }

    setDefaultPrice(price) {
        this.defaultPrice = price;
    }

    update() {
        this.elements.totalPrice.html("€ " + this.currentFare.toFixed(2));
        this.elements.totalDistance.html(
            (this.distanceTraveled / 1000).toFixed(1) + " km"
        );
    }

    start() {
        this.started = true;
        this.elements.toggleMeterBtnText.html("Started");
        this.elements.toggleMeterBtnText.css({ color: "rgb(51, 160, 37)" });
    }

    stop() {
        this.started = false;
        this.elements.toggleMeterBtnText.html("Stopped");
        this.elements.toggleMeterBtnText.css({ color: "rgb(231, 30, 37)" });
    }

    toggleFare() {
        this.started ? this.stop() : this.start();
        $.post("https://qb-taxijob/enableMeter", JSON.stringify({
            enabled: this.started,
        }));
    }

    open() {
        $(this.elements.meter).fadeIn(150);
        $("#total-price-per-100m").html("€ " + Math.round(this.defaultPrice));
    }

    close() {
        $(this.elements.meter).fadeOut(150);
    }
}

$(document).ready(function () {

    const meter = new Meter();
    meter.close();

    window.addEventListener("message", (event) => {

        const name = event.data.name;
        const data = event.data.data;

        switch (name) {
            case "meter:open":
                meter.open();
                break;
            case "meter:close":
                meter.close();
                break;
            case "meter:toggle-fare":
                meter.toggleFare();
                break;
            case "meter:update":
                const { currentFare, distanceTraveled, defaultPrice } = data;

                meter.setCurrentFare(currentFare);
                meter.setDefaultPrice(defaultPrice);
                meter.setDistanceTraveled(distanceTraveled);

                meter.update();
                break;
            default:
                console.log("unregistered event name: " + name)
                break;
        }
    });
});
