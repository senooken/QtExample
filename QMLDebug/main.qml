import QtQuick 2.9

QtObject {
    Component.onCompleted: {
        print("print")
        console.log("log")
        console.debug("debug")
        console.info("info")
        console.warn("warn")
        console.error("error")

        console.count("count")
        console.trace()  // stack trace
        console.exception("exception: message & stack trace")
        console.assert(true, "assert:true")
        console.assert(false, "assert:false message & stack trace")

        console.time("time")
        console.timeEnd("time")
        console.profile("profile")
        console.profileEnd("profile")
    }
}
