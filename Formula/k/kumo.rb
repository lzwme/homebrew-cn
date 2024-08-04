class Kumo < Formula
  desc "Word Clouds in Java"
  homepage "https:github.comkennycasonkumo"
  url "https:search.maven.orgremotecontent?filepath=comkennycasonkumo-cli1.28kumo-cli-1.28.jar"
  sha256 "43e4e2ea9da62a2230deed9151d8484f80bd6ae5fef304eaadf3301378f45fb6"
  license "MIT"

  livecheck do
    url "https:search.maven.orgremotecontent?filepath=comkennycasonkumo-climaven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)<version>}i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "964493ca566d7dc73ab4519fa820e7360981acd9d8d343920f843b83642cc008"
  end

  depends_on "openjdk"

  def install
    libexec.install "kumo-cli-#{version}.jar"
    bin.write_jar_script libexec"kumo-cli-#{version}.jar", "kumo"
  end

  test do
    system bin"kumo", "-i", "https:wikipedia.org", "-o", testpath"wikipedia.png"
    assert_predicate testpath"wikipedia.png", :exist?, "Wordcloud was not generated!"
  end
end