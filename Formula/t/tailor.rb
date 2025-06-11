class Tailor < Formula
  desc "Cross-platform static analyzer and linter for Swift"
  homepage "https:sleekbyte.github.iotailor"
  url "https:github.comsleekbytetailorreleasesdownloadv0.12.0tailor-0.12.0.tar"
  sha256 "ec3810b27e9a35ecdf3a21987f17cad86918240d773172264e9abbb1a7efc415"
  license "MIT"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "ff96b6b585afcd69215b88d8a797bfc4115c987b6dbd58c1e844c8d7ff268fec"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    (bin"tailor").write_env_script libexec"bintailor", JAVA_HOME: Formula["openjdk"].opt_prefix
    man1.install libexec"tailor.1"
  end

  test do
    (testpath"Test.swift").write "import Foundation\n"
    system bin"tailor", testpath"Test.swift"
  end
end