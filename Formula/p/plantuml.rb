class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "https:plantuml.com"
  url "https:github.complantumlplantumlreleasesdownloadv1.2024.6plantuml-1.2024.6.jar"
  sha256 "5a8dc3b37fe133a4744e55be80caf6080a70350aba716d95400a0f0cbd79e846"
  license "GPL-3.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "efb042dbbcbfb644b892216d947ed6328ff26fea2a8b23f76567f7dd0982a74d"
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