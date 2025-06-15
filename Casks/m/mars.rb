cask "mars" do
  version "4.5.1"
  sha256 "ac340b676ba2b62246b9df77e62f81ad4447bcfd329ab539716bcd09950b7096"

  url "https:github.comdpetersandersonMARSreleasesdownloadv.#{version}Mars#{version.major_minor.dots_to_underscores}.jar",
      verified: "github.comdpetersandersonMARS"
  name "MARS"
  desc "Mips Assembly and Runtime Simulator"
  homepage "https:computerscience.missouristate.edumars-mips-simulator.htm"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-10-15", because: :unmaintained

  container type: :naked

  artifact "Mars#{version.major_minor.dots_to_underscores}.jar", target: "#{appdir}Mars.jar"

  caveats do
    depends_on_java "9+"
  end
end