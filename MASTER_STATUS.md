# Zeitdrift – kanonischer Prüfstand

## Phase 1 — Erdrotation vs. Atomzeit
**Status:** PASS

- IERS 1962-01-01 bis 2026-07-11
- 2006-08-10 → 2026-07-11: Δ(UT1−TAI) = −4.1690230 s
- LOD-Integral-Kontrolle = −4.1688342 s
- Interpretation: relative Änderung Erdrotation/Atomzeit nachgewiesen; kein Nachweis universeller Zeitbeschleunigung.

## Phase 2 — Pulsare
**Status:** PASS WITH METHOD LIMIT

- IPTA DR1: 163361 erkannte TOAs
- Zeitspanne: 1984-11-20 bis 2014-11-19
- Quadratischer säkularer Clock-Term ist mit Pulsar-Spin/Spin-down degeneriert.
- Verwendbar für nichtquadratische gemeinsame Clock-Störungen, nicht als direkter Test einer linearen Zeitbeschleunigung.

## Phase 3 — Atomare Frequenzverhältnisse
**Status:** PASS

- 4 publizierte Langzeitvergleiche
- Alle Drifts < 2σ
- Beste 95%-Hülle: 2.150e-17 / Jahr (171Yb+ E3/E2)
- 20-Jahres-Wert 4.300e-16 ist nur Modell-Extrapolation, keine direkte 2006–2026-Messung.

## Phase 4 — Pioneer / astronomische Dynamik
**Status:** PASS

- Historischer phenomenologischer Clock-Acceleration-Term: 2.800e-18 s^-1
- Entspräche nach 20 Jahren ~0.557694 s kumulierter Abweichung
- Universelle Clock-Acceleration-Deutung wurde durch Planeten-/Uhrtests verworfen.
- Pioneer-Anomalie später durch thermischen Rückstoß erklärt.

## Phase 5 — Radioaktiver Zerfall
**Status:** PASS WITH SCOPE LIMIT

- Prozessklasse: Kernzerfall
- 14 Metrologielabore; Serien bis 4–5 Jahrzehnte
- Beste publizierte Grenze auf gemeinsame jährliche Modulationsamplitude: 6.000e-06
- Keine gemeinsame jährliche bzw. Wochen-/Monats-Modulation nachgewiesen.
- Keine direkte Schranke auf einen monotonen 2006–2026-Drift aus diesen publizierten Analysen ableitbar.

## Gesamtstand
1. Relative Änderungen zwischen bestimmten Uhren/Prozessen sind messbar.
2. Eine merkliche gemeinsame relative Beschleunigung verschiedener Atomprozesse wurde nicht gefunden.
3. Ein Pioneer-artiger astronomischer Effekt der erforderlichen Größenordnung wurde geprüft und anders erklärt.
4. Kernzerfallsdaten liefern eine weitere unabhängige Nullkontrolle für periodische Änderungen.
5. Eine exakt universelle Reskalierung **aller** physikalischen Prozesse bleibt prinzipiell intern unbeobachtbar.

## Nächster notwendiger Test
Direkte moderne Solar-System-Ranging-/Ephemeridenanalyse mit einem expliziten zusätzlichen säkularen Zeitdriftparameter oder einem physikalisch äquivalenten dimensionslosen Parameter.

<!-- PHASE6_START -->
## Phase 6 — Solar-System-Dynamik / Kepler-Proxy
**Status:** PASS WITH MODEL LIMIT

- LLR: 27,485 Normal Points, April 1970 bis April 2020.
- Publiziert: Gdot/G = (-5.0 ± 9.6)e-15 / Jahr.
- Konservative 95%-Hülle im lokalen Proxy: 2.382e-14 / Jahr.
- Kepler-Frequenz-Proxy: |a_t| < 3.773e-22 s^-1.
- Daraus modellhaft nach 20 Jahren: < 7.516e-05 s kumulierte Abweichung.
- INPOP20a konservativer mudot/mu-Bereich: ~2.280e-13 / Jahr.
- Entsprechender Kepler-Proxy: |a_t| < 3.612e-21 s^-1.
- Pioneer-artiger a_t = 2.8e-18 s^-1 wäre gegenüber dem LLR-Proxy etwa
  7420-mal größer.

### Methodische Grenze
Die verwendete Beziehung apparent_(mudot/mu) ≈ -2 a_t ist nur ein
Kepler-Frequenz-Proxy. Eine echte Transformation tau=t+0.5*a_t*t^2 verändert
auch Geschwindigkeits-/Beschleunigungsterme sowie die Lichtlaufzeit. Daher ist
dies **kein direkter Fit einer universellen Zeitbeschleunigung**.

### Nächster notwendiger Schritt
Ein vollständiger Alternativ-Ephemeridenfit muss tau(t) konsistent in
1. Beobachtungs-Zeitstempeln,
2. Lichtlaufzeit,
3. Bewegungs-Gleichungen und
4. Parameterschätzung
einführen.
<!-- PHASE6_END -->

<!-- PHASE7_START -->
## Phase 7 — Direkter publizierter Zeitmodell-Test
**Status:** PASS

- Anderson et al. testeten ausdrücklich driftende Stationsuhren und eine
  quadratische Zeitaugmentation in der IAT–ET-Transformation.
- Die Modelle konnten Doppler teilweise gut/fair fitten.
- Der Drifting-Clock-Ansatz scheiterte an Galileo-/Ulysses-Range-Daten.
- Die quadratische IAT–ET-Zeitaugmentation fitete Range sehr schlecht.
- Die untersuchten Zeitmodelle wurden wegen schlechter Fits oder inkonsistenter
  Lösungen zwischen Raumsonden verworfen.

### Bedeutung
Dies ist ein direkter publizierter Test derselben Modellklasse wie
`tau = t + 0.5*a_t*t^2`, nicht nur ein Kepler-Proxy.

### Grenze
Die historische Analyse ersetzt keinen neuen vollständigen 2006–2026-Fit mit
DE440/INPOP und aktuellen Beobachtungsdaten. Moderne Ephemeridentests verlangen
eine konsistente Änderung von Zeitdefinition, Lichtlaufzeit, Dynamik und
Parameterschätzung.

### Forschungsstand
- Nachweis einer merklichen relativen Zeitbeschleunigung: **NEIN**
- Historischer direkter quadratischer Zeitmodell-Fit: **VERWORFEN**
- Moderner vollständiger tau(t)-Ephemeridenfit 2006–2026: **NOCH NICHT AUSGEFÜHRT**
<!-- PHASE7_END -->

<!-- PHASE8_START -->
## Phase 8 — Offener Vollfit-Unterbau
**Status:** PASS

- PEP Commit: `480ed0cfc9e97ec9057521165383214bd54df162`
- Build-Toolchain: `gcc@sha256:19b31d0b2b263047b173e4e253d91f199d99c082973f13604d2913252c13309e`
- Compiler: `GNU Fortran (GCC) 10.5.0`
- Build: PASS
- Bigtest: PASS_REVIEW_OUTPUT_DIFF, RC=0
- Kanonische PEP-Arbeitskopie sauber: YES
- INPOP21a Referenzlösung archiviert, SHA-256 `7b0bd873f144dad407343893a478b9e53989e63cdb214f934d50d47e0f73e692`

### Noch nicht ausgeführt
Kein `a_t`-Fit und keine Änderung der Physik.

### Nächster notwendiger Schritt
Eine unveränderte öffentliche Range-Baseline mit PEP reproduzieren. Erst danach
wird `tau=t+0.5*a_t*t^2` konsistent in Zeitargument, Lichtlaufzeit, Dynamik und
partielle Ableitungen eingebaut.
<!-- PHASE8_END -->

<!-- PHASE9A_START -->
## Phase 9A — PEP radiometrische Regression-Baseline
**Status:** REVIEW

- PEP Commit: `480ed0cfc9e97ec9057521165383214bd54df162`
- `tv1`: Standard Viking Doppler Tests
- `tv2`: Standard Viking RAD Tests, RAD-Routinen + Phase Delay
- Zwei vollständige Läufe bit-identisch: NO
- `tv2.out` SHA-256: `8f1beb33a8020f2c39e75de1568b631190b33326a52819f47d11c0182f6d0f2e`

### Methodische Einordnung
Die PEP-Eingaben markieren ausdrücklich `WRITE DUMMY OBS ON OBSLIB`.
Phase 9A validiert deshalb die radiometrische Rechenkette und ihre
Reproduzierbarkeit, ist aber **keine externe Range-Messreihe**.

### Nächster notwendiger Schritt
Phase 9B nimmt einen unabhängig archivierten öffentlichen Raumsonden-
Ranging-Datensatz unverändert auf und erzeugt zuerst Standardmodell-Residuals.
Erst danach darf `tau=t+0.5*a_t*t^2` implementiert werden.
<!-- PHASE9A_END -->

<!-- PHASE9A_DIAG_START -->
## Phase 9A — Determinismusdiagnose
**Status:** REVIEW

- Klassifikation: `STRUCTURAL_DIFFERENCES`
- Metadaten-Differenzzeilen: 0
- Numerische Differenzzeilen: 2
- Strukturelle Differenzzeilen: 7
- Phase-9B-Gate: HOLD

Die Diagnose verändert weder PEP noch das Physikmodell. Details stehen in
`/home/emil/zeitdrift-ipta/phase9-range-baseline/PHASE9A_DIFF_DETAILS.txt` und maschinenlesbar in `/home/emil/zeitdrift-ipta/phase9-range-baseline/PHASE9A_DIFF_DIAG.json`.
<!-- PHASE9A_DIAG_END -->

<!-- PHASE9A_FINAL_START -->
## Phase 9A — PEP radiometrische Regression-Baseline
**Status:** PASS

Die zuvor gemeldeten Run-zu-Run-Differenzen betreffen ausschließlich
Ausführungsuhrzeit, Real-/Task-Time und deren Quotienten. Die fachlichen
Vergleichsartefakte `tv1.verout`, `tv2.verout`, `tv1.abc` und `tv2.abc`
sind bit-identisch.

Klassifikation: `PASS_METADATA_ONLY`
<!-- PHASE9A_FINAL_END -->

<!-- PHASE9B_START -->
## Phase 9B — Externer realer LLR-Dateningest
**Status:** OK

- Quelle: EUROLAS Data Center (DGFI-TUM)
- Datensatz: Apollo 15, McDonald Observatory, 10.12.2006
- Format: CSTG Normal Point
- Rohdaten SHA-256: `7ca60f9eac15fda1eb0f9b218eb36ff4195266708d2a1d49c53d220ce4032329`
- PEP-Konverter: `peputil/prepmnpt`
- PEP OBSLIB zweimal identisch erzeugt: YES
- `cpyobs` liest reale Beobachtungen: 2
- Station `MLR2`: YES
- Reflektor `AP15`: YES

### Grenze
Damit ist erstmals ein **externer realer Messdatensatz** in der PEP-Kette.
Noch nicht vorhanden ist ein für 2006 gültiger unveränderter dynamischer
Residual-Fit. `a_t` wurde weiterhin nicht eingebaut.

### Nächster notwendiger Schritt
2006-fähige Standardmodell-Ephemeride/Lichtlaufzeit gegen diese OBSLIB-Daten
reproduzieren. Erst danach wird der zusätzliche Parameter
`tau=t+0.5*a_t*t^2` implementiert.
<!-- PHASE9B_END -->

<!-- PHASE9B_FINAL_START -->
## Phase 9B — Externer realer LLR-Dateningest
**Status:** PASS

- Quelle: EUROLAS Data Center (DGFI-TUM), Tagesarchiv 10.12.2006
- Ziel: Apollo 15
- Station: McDonald Observatory `70802419`
- Dataset 53067: 13:31:59, 1 Normalpunkt, offizieller CSTG-Record MATCH
- Dataset 53069: 14:09:51, 1 Normalpunkt, offizieller CSTG-Record MATCH
- Gesamt: 2 reale Normalpunkte
- Rohdaten SHA-256: `7ca60f9eac15fda1eb0f9b218eb36ff4195266708d2a1d49c53d220ce4032329`
- PEP-OBSLIB zweimal bit-identisch: YES
- `cpyobs` gelesene Beobachtungen: 2

### Ergebnis
Die Zahl `2` ist korrekt und keine Doppelzaehlung. Das Live-Tagesarchiv enthaelt
zwei getrennte EDC-Datensaetze.

### Naechster notwendiger Schritt
Phase 9C erzeugt fuer beide realen 2006-Messpunkte zuerst eine unveraenderte
Standardmodell-O-C-Residual-Baseline. `a_t` bleibt bis dahin unberuehrt.
<!-- PHASE9B_FINAL_END -->

<!-- PHASE9C_START -->
## Phase 9C — Standardmodell-Residual-Baseline
**Status:** PREFLIGHT PASS

- Zielzeit: JD 2454080 (10.12.2006)
- Oeffentliche PEP-Bigtest-Tapes mit 2006-Abdeckung: 0
- PEP-Bigtest daher fuer 2006-Residualbaseline geeignet: NO
- Geoazur/OCA-Seite abrufbar: PASS
- Gefundene Formulare: 0
- Residual-Begriff Treffer: 0
- Residual-Schnittstelle: NO

### Harte Grenze
Es wurde noch kein O-C-Wert erzeugt und `a_t` wurde nicht veraendert.
Die historische PEP-Testephemeride wird nicht auf 2006 extrapoliert.

### Naechster Schritt
Die inventarisierte offizielle OCA/INPOP-Residualschnittstelle wird exakt auf
die beiden EDC-Normalpunkte 53067 und 53069 gebunden.
<!-- PHASE9C_END -->

<!-- PHASE9C_MLRS_AUDIT_START -->
## Phase 9C — NASA/ILRS MLRS-Lunar-Code-Audit
**Status:** PASS (Source Audit)

- Erwerb: `ILRS_GSFC_LIVE`
- Archiv SHA-256: `0d7469b92f2b5e69577cd8d1a730dca34bb56a9f5faa0ff52b7a83d8726669a9`
- Dateien: 294
- Range-Dateien: 32
- Ephemeriden-Dateien: 33
- Residual-Dateien: 31
- Fit-Dateien: 18
- Range+Ephemeriden-Kandidat: YES
- Direkte Residual-Marker: YES
- Fit-Marker: YES

### Grenze
Noch kein Build, kein O-C-Residual und keine Aenderung von `a_t`.

### Naechster Schritt
Nur wenn der Audit Range+Ephemeriden-/Residualfunktion belegt, wird das
NASA/ILRS-Paket reproduzierbar gebaut und gegen einen mitgelieferten
Referenzfall validiert.
<!-- PHASE9C_MLRS_AUDIT_END -->

<!-- PHASE9C_MLRS_BUILD_START -->
## Phase 9C — MLRS Build-/Referenz-Gate
**Status:** OK

- Build-System-Dateien: 8
- Make-Wurzeln: 7
- Erfolgreiche Build-Wurzeln: 2
- Fehlgeschlagene Build-Wurzeln: 5
- Build-Klassifikation: `PARTIAL_OR_FULL_BUILD_SUCCESS`
- Laufzeit-nahe Executables: 16
- Referenzfall-Verzeichnisse: 2
- Referenz-Klassifikation: `REFERENCE_CANDIDATE_IDENTIFIED`
- Vendor-Quellen unveraendert: YES

### Grenze
Noch kein Referenzfall wurde ausgefuehrt, keine 2006-O-C-Baseline erzeugt
und `a_t` wurde nicht veraendert.
<!-- PHASE9C_MLRS_BUILD_END -->

<!-- PHASE9C_MLRS_TARGET_DIAG_START -->
## Phase 9C — MLRS Target-Diagnose
**Status:** PASS

- Erfolgreiche Build-Wurzeln: 2
- Fehlgeschlagene Build-Wurzeln: 5
- Fehler nur GUI/System-Abhaengigkeiten: NO
- Executables: 16
- Referenzverzeichnisse: 2
- Referenz-Runner-Kandidaten: 0
- Gate: `REFERENCE_DATA_IDENTIFIED_RUNNER_UNRESOLVED`

Noch kein Referenzfall, keine O-C-Baseline und keine Aenderung von `a_t`.
<!-- PHASE9C_MLRS_TARGET_DIAG_END -->

<!-- PHASE9C_MLRS_COMPAT_START -->
## Phase 9C — MLRS Fortran-Kompatibilitaetsprobe
**Status:** PASS (Build Probe)

- Erfolgreiche Build-Wurzeln: 2
- Fehlgeschlagene Build-Wurzeln: 5
- Verbleibende `f77`-Fehler: 0
- Undefined-reference-Fehler: 0
- `write_crd.o` gebaut: YES
- `npt_test.sh` gefunden: YES
- `npt_test.sh` ausgefuehrt: NO
- Vendor-Quellen unveraendert: YES
- Gate: `BUILD_STILL_BLOCKED`

Noch keine Standardmodell-O-C-Baseline und keine Aenderung von `a_t`.
<!-- PHASE9C_MLRS_COMPAT_END -->

<!-- PHASE9C_MLRS_EXACT_FAILURES_START -->
## Phase 9C — MLRS exakte Build-/Referenzdiagnose
**Status:** PASS (Diagnose)

- Erfolgreiche Build-Wurzeln: 2
- Fehlgeschlagene Build-Wurzeln: 5
- `npt_test.sh` Befehle: 8
- Explizite `diff/cmp`-Vergleiche: 4
- Referenzklassifikation: `REFERENCE_SCRIPT_DEPENDENCIES_RESOLVED`
- Mitgelieferte ELF-Binaries: 7
- Fehlende Runtime-Library-Zeilen: 3

Noch kein Referenztest ausgefuehrt, keine 2006-O-C-Baseline und keine
Aenderung von `a_t`.
<!-- PHASE9C_MLRS_EXACT_FAILURES_END -->

<!-- PHASE9C_MLRS_LDB_STATIC_START -->
## Phase 9C — `ldb_crd` statische Aufloesung
**Status:** PASS (Static Audit)

- Interpreter: `/bin/csh -f`
- Aufgerufene Paketprogramme: 5
- Referenzsessions: 2
- Sollvergleiche: 4
- Gate: `REFERENCE_RUNTIME_COMPAT_REQUIRED`

Der Hersteller-Referenztest wurde weiterhin nicht ausgefuehrt.
Keine 2006-O-C-Baseline und keine Aenderung von `a_t`.
<!-- PHASE9C_MLRS_LDB_STATIC_END -->

<!-- PHASE9C_MLRS_REFERENCE_START -->
## Phase 9C — unveraenderter MLRS-Hersteller-Referenztest
**Status:** REVIEW

- Legacy-Runtime: `gcc:6.3.0`
- `csh`: YES
- `libgfortran.so.3`: YES
- Alle 5 benoetigten Binaries ohne fehlende Libraries: YES
- Testlauf 1 RC: 2
- Testlauf 2 RC: 2
- Soll-`diff` PASS: 0/4
- Run-to-run bit-identisch: 0/4
- Nichtleere `.errorc`: 4
- Klassifikation: `FAIL`
- Vendor unveraendert: YES

### Grenze
Dies validiert nur die unveraenderte Hersteller-Reduktionskette.
Die externen EDC-Messpunkte von 2006 wurden noch nicht angewendet und es
existiert weiterhin keine 2006-Standardmodell-O-C-Baseline. `a_t` ist
unveraendert.
<!-- PHASE9C_MLRS_REFERENCE_END -->

<!-- PHASE9C_MLRS_REFERENCE_FAILURE_DIAG_START -->
## Phase 9C — MLRS Referenzfehler-Diagnose
**Status:** PASS (Diagnose)

- Run-1 Session 1: `NORMALPOINT_LLR_NPT_N_FAILED`
- Run-1 Session 2: `NORMALPOINT_LLR_NPT_N_FAILED`
- Run-2 Session 1: `NORMALPOINT_LLR_NPT_N_FAILED`
- Run-2 Session 2: `NORMALPOINT_LLR_NPT_N_FAILED`
- Fehlerstufe reproduzierbar: YES
- Statische TTY-Treffer: 125

Keine neue MLRS-Ausfuehrung wurde gestartet. Keine 2006-O-C-Baseline und
keine Aenderung von `a_t`.
<!-- PHASE9C_MLRS_REFERENCE_FAILURE_DIAG_END -->

<!-- PHASE9C_MLRS_JPLEPH_AUDIT_START -->
## Phase 9C — fehlende JPL-Ephemeride
**Status:** PASS (Audit)

- Erwarteter Pfad: `data/pred/jpleph`
- Datei vorhanden: NO
- Im originalen ILRS-Archiv enthalten: YES
- Explizite DE-Versionen gefunden: 2
- Kandidat: DE111
- Konfidenz: `DOMINANT_EXPLICIT_VERSION`
- Gate: `JPLEPH_SHIPPED_BUT_EXTRACTION_OR_PATH_PROBLEM`

Der Referenztest wurde nicht erneut ausgefuehrt. Es wurde keine
Ersatz-Ephemeride eingesetzt und `a_t` blieb unveraendert.
<!-- PHASE9C_MLRS_JPLEPH_AUDIT_END -->
