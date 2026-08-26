class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "https://plantuml.com/"
  url "https://ghfast.top/https://github.com/plantuml/plantuml/releases/download/v1.2026.7/plantuml-1.2026.7.jar"
  sha256 "33aa7ed0ca843e300690230d09268e1f526fdde7e86fecdfa39fb80412cafcde"
  license "GPL-3.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d6d7320fd3a4bdf207a874d23c1a14bb481f5842cfb27d13b05dfab54258ba0b"
  end

  depends_on "graphviz"
  depends_on "openjdk"

  def install
    jar = "plantuml.jar"
    libexec.install "plantuml-#{version}.jar" => jar
    (bin/"plantuml").write <<~BASH
      #!/bin/bash
      if [[ "$*" != *"-gui"* ]]; then
        VMARGS="-Djava.awt.headless=true"
      fi
      GRAPHVIZ_DOT="#{formula_opt_bin("graphviz")}/dot" exec "#{formula_opt_bin("openjdk")}/java" $VMARGS -jar #{libexec}/#{jar} "$@"
    BASH
    chmod 0755, bin/"plantuml"
  end

  test do
    system bin/"plantuml", "-testdot"
  end
end