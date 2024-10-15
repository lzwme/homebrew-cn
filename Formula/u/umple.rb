class Umple < Formula
  desc "Modeling toolprogramming language that enables Model-Oriented Programming"
  homepage "https:www.umple.org"
  url "https:github.comumpleumplereleasesdownloadv1.35.0umple-1.35.0.7523.c616a4dce.jar"
  version "1.35.0"
  sha256 "493b637b7432396418ebf9dcd90f4b08ec0f91a0a3247de8dbb326e0a0f80bb3"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8f29200d94979325078d9073338ed60413e7cde1392125b72d43e1e2105e8d3a"
  end

  depends_on "openjdk"

  def install
    filename = File.basename(stable.url)

    libexec.install filename
    bin.write_jar_script libexecfilename, "umple"
  end

  test do
    (testpath"test.ump").write("class X{ a; }")
    system bin"umple", "test.ump", "-c", "-"
    assert_predicate testpath"X.java", :exist?
    assert_predicate testpath"X.class", :exist?
  end
end