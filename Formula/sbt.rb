class Sbt < Formula
  desc "Build tool for Scala projects"
  homepage "https://www.scala-sbt.org/"
  url "https://ghproxy.com/https://github.com/sbt/sbt/releases/download/v1.9.2/sbt-1.9.2.tgz"
  mirror "https://sbt-downloads.cdnedge.bluemix.net/releases/v1.9.2/sbt-1.9.2.tgz"
  sha256 "5dd43af46167a1ba0df63859bfae6e352fbed525e76622d8ebdc8914222532b2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eb268cdefebebbbd7c17927c901d730d1a3c959cf27cae6283dcbe46ac51a51b"
  end

  depends_on "openjdk"

  def install
    inreplace "bin/sbt" do |s|
      s.gsub! 'etc_sbt_opts_file="/etc/sbt/sbtopts"', "etc_sbt_opts_file=\"#{etc}/sbtopts\""
      s.gsub! "/etc/sbt/sbtopts", "#{etc}/sbtopts"
    end

    libexec.install "bin"
    etc.install "conf/sbtopts"

    # Removes:
    # 1. `sbt.bat` (Windows-only)
    # 2. `sbtn` (pre-compiled native binary)
    (libexec/"bin").glob("sbt{.bat,n-x86_64*,n-aarch64*}").map(&:unlink)
    (bin/"sbt").write_env_script libexec/"bin/sbt", Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      You can use $SBT_OPTS to pass additional JVM options to sbt.
      Project specific options should be placed in .sbtopts in the root of your project.
      Global settings should be placed in #{etc}/sbtopts

      The installation does not include `sbtn`.
    EOS
  end

  test do
    ENV.append "_JAVA_OPTIONS", "-Dsbt.log.noformat=true"
    system bin/"sbt", "--sbt-create", "about"
    assert_match version.to_s, shell_output("#{bin}/sbt sbtVersion")
  end
end