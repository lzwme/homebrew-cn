class Sbt < Formula
  desc "Build tool for Scala projects"
  homepage "https://www.scala-sbt.org/"
  url "https://ghproxy.com/https://github.com/sbt/sbt/releases/download/v1.9.7/sbt-1.9.7.tgz"
  mirror "https://sbt-downloads.cdnedge.bluemix.net/releases/v1.9.7/sbt-1.9.7.tgz"
  sha256 "23543bc4597b552e8e2c27d695fe672ec235ab8a64f766b37828fb68c6d9d910"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "90c3eb6212a0505e0b5100d63ac169bf12ef92d61adb0a30cc9106a2ca8ca7cb"
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