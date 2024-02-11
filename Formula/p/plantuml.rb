class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "https:plantuml.com"
  url "https:github.complantumlplantumlreleasesdownloadv1.2024.1plantuml-1.2024.1.jar"
  sha256 "f3201e97b536e3fc32f11eebb4f20d3d907f636fd6f64302b0b0aa3b9c598005"
  license "GPL-3.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3f9404a546ff9e549e1b640e77515b3815819a4b36239fc9b17effe8135c65e3"
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