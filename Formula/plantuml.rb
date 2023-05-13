class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "https://plantuml.com/"
  url "https://ghproxy.com/https://github.com/plantuml/plantuml/releases/download/v1.2023.7/plantuml-1.2023.7.jar"
  sha256 "4626bf6e2f11fc04ad8360b627210f40c9260b435c6f509cef6d01a39c8fbc6d"
  license "GPL-3.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92fd77be5b7e270d5ec33ea4b43f28558b865860f9283b17ba2c65e9a8106535"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92fd77be5b7e270d5ec33ea4b43f28558b865860f9283b17ba2c65e9a8106535"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92fd77be5b7e270d5ec33ea4b43f28558b865860f9283b17ba2c65e9a8106535"
    sha256 cellar: :any_skip_relocation, ventura:        "92fd77be5b7e270d5ec33ea4b43f28558b865860f9283b17ba2c65e9a8106535"
    sha256 cellar: :any_skip_relocation, monterey:       "92fd77be5b7e270d5ec33ea4b43f28558b865860f9283b17ba2c65e9a8106535"
    sha256 cellar: :any_skip_relocation, big_sur:        "92fd77be5b7e270d5ec33ea4b43f28558b865860f9283b17ba2c65e9a8106535"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1a20504cff4b994e379444cb8594ae1748d46188a915e98d70a9937cbd89a56"
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