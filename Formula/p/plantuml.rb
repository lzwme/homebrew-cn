class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "https:plantuml.com"
  url "https:github.complantumlplantumlreleasesdownloadv1.2024.0plantuml-1.2024.0.jar"
  sha256 "29c2c9004a4145711f258daea1aea97dea3559bd8b2471252870aa1672b8cfd6"
  license "GPL-3.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0ac445578bb0fbe86bd7579fbfb6450c8966f72bed56606a34eba761875edca1"
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