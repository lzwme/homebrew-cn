class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "https://plantuml.com/"
  url "https://ghproxy.com/https://github.com/plantuml/plantuml/releases/download/v1.2023.2/plantuml-1.2023.2.jar"
  sha256 "35c05c9f5d146c7f0fb7a3321482520c5260855dd07cc22b111c97665e63709c"
  license "GPL-3.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d50d8baa4997519fc1f5362be3ba152dca793bde71686df12aff101cfd0f3bdd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d50d8baa4997519fc1f5362be3ba152dca793bde71686df12aff101cfd0f3bdd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d50d8baa4997519fc1f5362be3ba152dca793bde71686df12aff101cfd0f3bdd"
    sha256 cellar: :any_skip_relocation, ventura:        "d50d8baa4997519fc1f5362be3ba152dca793bde71686df12aff101cfd0f3bdd"
    sha256 cellar: :any_skip_relocation, monterey:       "d50d8baa4997519fc1f5362be3ba152dca793bde71686df12aff101cfd0f3bdd"
    sha256 cellar: :any_skip_relocation, big_sur:        "d50d8baa4997519fc1f5362be3ba152dca793bde71686df12aff101cfd0f3bdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfbd60dc5243e9e924941073aa076728a4231922c1855fdbc8cbde2cdbc65773"
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