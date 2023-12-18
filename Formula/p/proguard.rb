class Proguard < Formula
  desc "Java class file shrinker, optimizer, and obfuscator"
  homepage "https:www.guardsquare.comenproductsproguard"
  url "https:github.comGuardsquareproguardreleasesdownloadv7.4.1proguard-7.4.1.tar.gz"
  sha256 "d3a83be58eb2a4a9baf8c462d8c2774a9b473a4afc66c3aa0da83811ef5db889"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d4381b02979eeeca25d3a9876fa4578e55ba9542725f080e3acbecd00c0b1a8a"
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
    assert_equal expect, shell_output("#{bin}proguard", 1)

    expect = <<~EOS
      Picked up _JAVA_OPTIONS: #{ENV["_JAVA_OPTIONS"]}
      Usage: java proguard.retrace.ReTrace [-regex <regex>] [-allclassnames] [-verbose] <mapping_file> [<stacktrace_file>]
    EOS
    assert_match expect, pipe_output("#{bin}retrace 2>&1")
  end
end