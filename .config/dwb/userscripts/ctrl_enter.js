//!javascript

var sig = -1;
gui.entry.connect("focus-in-event", function() {
    sig = signals.connect("keyPress", function(wv, event) {
        if (event.name == "Return")
        {
            if (event.state == Modifier.Control)
                gui.entry.text += ".com";
            if (event.state == (Modifier.Control | Modifier.Shift))
                gui.entry.text += ".org";
        }
    });
});
gui.entry.connect("focus-out-event", function() {
    signals.disconnect(sig);
});