class Proguard < Formula
  desc "Java class file shrinker, optimizer, and obfuscator"
  homepage "https:www.guardsquare.comenproductsproguard"
  url "https:github.comGuardsquareproguardreleasesdownloadv7.6proguard-7.6.0.tar.gz"
  sha256 "33c0aafe65f58464f82b9080c5a18312ae0c6e2fc6a133aedf3ae13a37bbf9d9"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e086732f3d577c6c3cc3c53270091aa9649a3b6582cde21f11da36fcb618927a"
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