class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "https://plantuml.com/"
  url "https://ghfast.top/https://github.com/plantuml/plantuml/releases/download/v1.2025.9/plantuml-1.2025.9.jar"
  sha256 "280f4aa97f4f3b7af39358dd0d79f65e353b54a1630b5f121a13b1651162185d"
  license "GPL-3.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "404927df092a96d048a18dfdc14eb3655db0c8ac727b770563dd43d3cb69d0fd"
  end

  depends_on "graphviz"
  depends_on "openjdk"

  def install
    jar = "plantuml.jar"
    libexec.install "plantuml-#{version}.jar" => jar
    (bin/"plantuml").write <<~EOS
      #!/bin/bash
      if [[ "$*" != *"-gui"* ]]; then
        VMARGS="-Djava.awt.headless=true"
      fi
      GRAPHVIZ_DOT="#{Formula["graphviz"].opt_bin}/dot" exec "#{Formula["openjdk"].opt_bin}/java" $VMARGS -jar #{libexec}/#{jar} "$@"
    EOS
    chmod 0755, bin/"plantuml"
  end

  test do
    system bin/"plantuml", "-testdot"
  end
end