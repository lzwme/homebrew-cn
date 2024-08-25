class Proguard < Formula
  desc "Java class file shrinker, optimizer, and obfuscator"
  homepage "https:www.guardsquare.comenproductsproguard"
  url "https:github.comGuardsquareproguardreleasesdownloadv7.5proguard-7.5.0.tar.gz"
  sha256 "48b1d6bd104acc12c9218250e88b3422815c86510cdd3c8c572a0386ac289376"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "ac525f08798f112758472da89d5a386913263d80fc81f6622ab83b9b8ed5e5ce"
  end

  depends_on "openjdk"

  def install
    libexec.install "libproguard.jar"
    libexec.install "libproguardgui.jar"
    libexec.install "libretrace.jar"
    bin.write_jar_script libexec"proguard.jar", "proguard"
    bin.write_jar_script libexec"proguardgui.jar", "proguardgui"
    bin.write_jar_script libexec"retrace.jar", "retrace"
  end

  test do
    expect = <<~EOS
      ProGuard, version #{version}
      Usage: java proguard.ProGuard [options ...]
    EOS
    assert_equal expect, shell_output(bin"proguard", 1)

    expect = <<~EOS
      Picked up _JAVA_OPTIONS: #{ENV["_JAVA_OPTIONS"]}
      Usage: java proguard.retrace.ReTrace [-regex <regex>] [-allclassnames] [-verbose] <mapping_file> [<stacktrace_file>]
    EOS
    assert_match expect, pipe_output("#{bin}retrace 2>&1")
  end
end