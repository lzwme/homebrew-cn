class Proguard < Formula
  desc "Java class file shrinker, optimizer, and obfuscator"
  homepage "https:www.guardsquare.comenproductsproguard"
  url "https:github.comGuardsquareproguardreleasesdownloadv7.6.1proguard-7.6.1.tar.gz"
  sha256 "672ef62a3154474a6172cbfde9a2f09da1642a17a80e1c7b79a6cc58953fbe06"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "358c58112336b1909bdf8c5f550caf781a584ea98514716ac80dd20f5f8f2ca8"
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