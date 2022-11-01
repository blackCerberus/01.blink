import Foundation
import SwiftyGPIO

var signalReceived: sig_atomic_t = 0

let sleepON = UInt32(0.1 * 1e+6) // 0.1s
let sleepOFF = UInt32(2 * 1e+6)  // 2.0s

let gpio = SwiftyGPIO.GPIOs(for: .RaspberryPi4)

guard let helloLED = gpio[GPIOName.P17] else {
  fatalError("Could not initialise redLED on GPIO:17")
}
helloLED.direction = .OUT

signal(SIGINT) { signal in
  signalReceived = signal
}

print("Press CTRL-C to exit.")
while signalReceived == 0 {
  helloLED.value = 1
  usleep(sleepON)
  helloLED.value = 0
  usleep(sleepOFF)
}

print("Cleanup GPIO resources...")
helloLED.direction = .IN
print("Completed cleanup of GPIO resources.")
exit(signalReceived)
  