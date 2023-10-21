class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "https://plantuml.com/"
  url "https://ghproxy.com/https://github.com/plantuml/plantuml/releases/download/v1.2023.12/plantuml-1.2023.12.jar"
  sha256 "c49cb7f61a6e723cf02af7666fd451532d320ad04321dbcd098341d8321d77be"
  license "GPL-3.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "229043c5d61ce31dede74fed3439d0642a642c1898505e865d748ecb93dca728"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "229043c5d61ce31dede74fed3439d0642a642c1898505e865d748ecb93dca728"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "229043c5d61ce31dede74fed3439d0642a642c1898505e865d748ecb93dca728"
    sha256 cellar: :any_skip_relocation, sonoma:         "229043c5d61ce31dede74fed3439d0642a642c1898505e865d748ecb93dca728"
    sha256 cellar: :any_skip_relocation, ventura:        "229043c5d61ce31dede74fed3439d0642a642c1898505e865d748ecb93dca728"
    sha256 cellar: :any_skip_relocation, monterey:       "229043c5d61ce31dede74fed3439d0642a642c1898505e865d748ecb93dca728"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10269b8f65203cf78ecf15629522c26b4f7d429e40604810c4c8065cba5c06b4"
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