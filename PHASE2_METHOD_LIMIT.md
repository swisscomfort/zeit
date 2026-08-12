# Zeitdrift – methodische Grenze des IPTA-Pulsartests

## Status
Offizielles IPTA-Clock-Paper-Datenpaket gesichert.

- Quelle: https://ipta4gw.org/files/data/ipta_clock_v1.tar.gz
- SHA-256: `ab799809307221049e3cd2c72f330516ea4003650a9b56499f235d78515c8c59`
- Lokaler Pfad: `/home/emil/zeitdrift-ipta/ipta_clock_v1.tar.gz`
- Extraktion: `/home/emil/zeitdrift-ipta/ipta-clock-paper-v1`

## Entscheidung
Der IPTA-Pulsartest wird nur für **nichtquadratische gemeinsame Clock-Störungen**
verwendet.

Eine säkulare Hypothese, bei der sich die Rate einer Referenzzeit gleichmäßig mit
der Zeit ändert, erzeugt im Zeitoffset einen quadratischen Term. Genau dieser Term
ist im Standard-Pulsar-Timing nicht beobachtbar, weil für jeden Pulsar
Spinfrequenz und Spin-down angepasst werden. Das Clock-Paper entfernt daher einen
bestangepassten quadratischen Anteil aus der rekonstruierten Clock-Waveform.

## Konsequenz
- Pulsare sind eine unabhängige Kontrolle auf gemeinsame irreguläre Clock-Fehler.
- Sie sind in diesem Setup **kein gültiger direkter Test** einer universellen,
  gleichmäßig zunehmenden Zeitbeschleunigung.
- Der nächste physikalisch sinnvolle Zweig muss eine relative, dimensionslose oder
  dynamisch unabhängige Observable verwenden, z. B. unterschiedliche
  Frequenzverhältnisse oder präzise Solar-System-Dynamik mit explizitem
  Alternativmodell.

## Primärquellen
- IPTA Data Release / Clock Paper:
  https://ipta4gw.org/data-release/
- Hobbs et al., MNRAS 491 (2020), "A pulsar-based time-scale from the International Pulsar Timing Array":
  https://academic.oup.com/mnras/article/491/4/5951/5612203
