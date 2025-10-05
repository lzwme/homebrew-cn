class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "https://plantuml.com/"
  url "https://ghfast.top/https://github.com/plantuml/plantuml/releases/download/v1.2025.8/plantuml-1.2025.8.jar"
  sha256 "9662925aea230f963115ab59078955084a765f1f2002e0679337d6ab36e8c70d"
  license "GPL-3.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "776d42363e2aa02828e5384cf2fcecd6ceb62338e08274e791fbe4a0edbff49e"
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