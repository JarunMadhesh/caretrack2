class Symptoms {
  String patientId;
  String time;
  double points;

  double fever;
  double cough;
  double soreThroat;
  double shortnessOfBreath;
  double lossOfSmell;
  double lossOfTaste;
  double headache;
  double fatique;
  double muscleAches;
  double sneezing;
  double diarrhea;
  double stomachAche;
  double vomiting;
  double rednessOfEyes;
  bool skinRash;
  double oxygen;
  double pulse;
  double temperature;

  Symptoms({
    this.patientId,
    this.time,
    this.points,
    this.fever,
    this.cough,
    this.soreThroat,
    this.shortnessOfBreath,
    this.lossOfSmell,
    this.lossOfTaste,
    this.headache,
    this.fatique,
    this.muscleAches,
    this.sneezing,
    this.diarrhea,
    this.stomachAche,
    this.vomiting,
    this.rednessOfEyes,
    this.skinRash,
    this.oxygen,
    this.pulse,
    this.temperature,
  });
}
