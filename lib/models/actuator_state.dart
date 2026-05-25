class ActuatorState {
  bool ledRed;
  bool ledYellow;
  bool ledGreen;
  bool buzzer;
  bool pump;
  bool fan;

  ActuatorState({
    this.ledRed = false,
    this.ledYellow = false,
    this.ledGreen = true,
    this.buzzer = false,
    this.pump = false,
    this.fan = false,
  });
}
