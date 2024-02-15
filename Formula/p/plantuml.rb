class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "https:plantuml.com"
  url "https:github.complantumlplantumlreleasesdownloadv1.2024.2plantuml-1.2024.2.jar"
  sha256 "629fbef4b52c174d37619a641287279afc960af68f63e4c59175147810f360a5"
  license "GPL-3.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "52e36831003553d4ad6e432be7e1919a56f1e9275821da260091d0d8c57f4ea6"
  end

  depends_on "graphviz"
  depends_on "openjdk"

  def install
    jar = "plantuml.jar"
    libexec.install "plantuml-#{version}.jar" => jar
    (bin"plantuml").write <<~EOS
      #!binbash
      if [[ "$*" != *"-gui"* ]]; then
        VMARGS="-Djava.awt.headless=true"
      fi
      GRAPHVIZ_DOT="#{Formula["graphviz"].opt_bin}dot" exec "#{Formula["openjdk"].opt_bin}java" $VMARGS -jar #{libexec}#{jar} "$@"
    EOS
    chmod 0755, bin"plantuml"
  end

  test do
    system bin"plantuml", "-testdot"
  end
end