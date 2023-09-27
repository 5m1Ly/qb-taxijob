function calculateTotal(coupon) {
    let total = 0;
    total += coupon.delivery;
    total += coupon.transport;
    total += coupon.used;
    return total;
}

function createTicket(
    used = false,
    transport = false,
    single = false,
    first = false,
    last = false,
    coupon
) {
    const ticket = document.createElement('div');
    const couponEl = document.querySelector('.coupon');
    ticket.classList.add('ticket');
    if (single) {
        ticket.classList.add('single-ticket');
    }
    if (!single && first) {
        ticket.classList.add('first-ticket');
    }
    if (!single && last) {
        ticket.classList.add('last-ticket');
    }
    if (!single && !first && !last) {
        ticket.classList.add('middle-ticket');
    }
    if (!used) {
        ticket.innerHTML = transport ? 'free ride' : 'free delivery';
        ticket.classList.add(transport ? 'ride' : 'delivery');
        ticket.addEventListener('click', event => useTicket(event, coupon));
    } else {
        ticket.classList.add('in-use');
    }
    if (coupon.gold) {
        couponEl.style.borderColor = "#d4af37";
        couponEl.style.background = "#292929";
        ticket.style.borderColor = "#d4af37";
        ticket.style.background = "#292929";
        ticket.style.color = "#d4af37";
    } else {
        couponEl.style.background = "rgb(254, 184, 28)";
        ticket.style.background = "rgb(254, 184, 28)";
        ticket.style.color = "rgb(0, 0, 0)";
    }
    return ticket;
}

function createTickets(coupon) {
    const tickets = document.querySelector('#tickets');
    const ticketList = [];
    let transport = 0;
    let delivery = 0;
    let used = 0;
    for (let i = 0; i < coupon.total; i++) {
        console.log(coupon.transport)
        ticketList.push(
            createTicket(
                coupon.used > 0,
                coupon.transport > 0,
                coupon.total === 1,
                i === 0,
                i === coupon.total - 1,
                coupon
            )
        );
        if (coupon.used > 0) {
            coupon.used--;
            used++;
            continue;
        }
        if (coupon.transport > 0) {
            coupon.transport--;
            transport++;
            continue;
        }
        if (coupon.delivery > 0) {
            coupon.delivery--;
            delivery++;
            continue;
        }
    }
    coupon.transport = transport;
    coupon.delivery = delivery;
    coupon.used = used;
    tickets.replaceChildren(...ticketList)
}

let canUseTicket = true;

function useTicket(event, coupon) {
    if (!canUseTicket) return;
    canUseTicket = false;
    if (event.target.classList.contains('used')) {
        return;
    }
    if (event.target.classList.contains('delivery')) {
        coupon.delivery--;
    }
    if (event.target.classList.contains('ride')) {
        coupon.transport--;
    }
    coupon.used++;
    event.target.classList.add('used');
    setTimeout(closeCoupon, 2000);
}

function openCoupon(coupon) {

    coupon.total = calculateTotal(coupon);
    coupon.gold = coupon.total > 4;

    const couponBox = document.querySelector('.coupon-box');
    const images = document.querySelector('.coupon-img');

    images.children[0].style.display = coupon.gold ? 'none' : 'block';
    images.children[1].style.display = coupon.gold ? 'block' : 'none';

    couponBox.style.opacity = 1;

    createTickets(coupon);
}

function closeCoupon() {
    const coupon = document.querySelector('.coupon-box');
    coupon.style.opacity = 0;
    canUseTicket = true;
}

openCoupon({
    delivery: 2,
    transport: 2,
    used: 0
});
