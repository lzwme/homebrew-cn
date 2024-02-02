class Proguard < Formula
  desc "Java class file shrinker, optimizer, and obfuscator"
  homepage "https:www.guardsquare.comenproductsproguard"
  url "https:github.comGuardsquareproguardreleasesdownloadv7.4.2proguard-7.4.2.tar.gz"
  sha256 "f5d88ec3074ef4578cd7b1250b511b45d6bca89e734bc175d671e4a0aaa95ae0"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5898f4ffddb2131970b05be96d09e23f2a3f7f238a0edc78764c51689f10127c"
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