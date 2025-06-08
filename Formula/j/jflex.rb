class Jflex < Formula
  desc "Lexical analyzer generator for Java, written in Java"
  homepage "https:jflex.de"
  url "https:github.comjflex-dejflexreleasesdownloadv1.9.1jflex-1.9.1.tar.gz"
  sha256 "e0c1e9eef91ff6df04d73fa5eaff13f3a02b679fee1474e5ccae007224df6df6"
  license "BSD-3-Clause"

  livecheck do
    url "https:jflex.dedownload.html"
    regex(href=.*?jflex[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "0e6a95ad6f0aa8fbe269ef4f17eb27227c43456e925a39baafa5bca7e25c151f"
  end

  depends_on "openjdk"

  def install
    pkgshare.install "examples"
    libexec.install "libjflex-full-#{version}.jar" => "jflex-#{version}.jar"
    bin.write_jar_script libexec"jflex-#{version}.jar", "jflex"
  end

  test do
    system bin"jflex", "-d", testpath, pkgshare"examplescup-javasrcmainjflexjava.flex"
    assert_match "public static void", (testpath"Scanner.java").read
  end
end