class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "https:plantuml.com"
  url "https:github.complantumlplantumlreleasesdownloadv1.2025.1plantuml-1.2025.1.jar"
  sha256 "77e521f6136ee03df8e5b1ba8d19a01fa3e0c1355ff69048cc9f0bbe0ea9061f"
  license "GPL-3.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6b585a827683eb45419319a3387e755bad5d989df099942ccd85c83e4724a51c"
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