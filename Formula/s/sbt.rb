class Sbt < Formula
  desc "Build tool for Scala projects"
  homepage "https:www.scala-sbt.org"
  url "https:github.comsbtsbtreleasesdownloadv1.9.9sbt-1.9.9.tgz"
  mirror "https:sbt-downloads.cdnedge.bluemix.netreleasesv1.9.9sbt-1.9.9.tgz"
  sha256 "c57cae60c2122ca1bba77184dfb4d0d25fc6c18805394ab36ab6208b0c0f262f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fc96166a70f762c84b8ef5ed7e7e99d910c24208eb6ea946ef29724b9cdc9396"
  end

  depends_on "openjdk"

  def install
    inreplace "binsbt" do |s|
      s.gsub! 'etc_sbt_opts_file="etcsbtsbtopts"', "etc_sbt_opts_file=\"#{etc}sbtopts\""
      s.gsub! "etcsbtsbtopts", "#{etc}sbtopts"
    end

    libexec.install "bin"
    etc.install "confsbtopts"

    # Removes:
    # 1. `sbt.bat` (Windows-only)
    # 2. `sbtn` (pre-compiled native binary)
    (libexec"bin").glob("sbt{.bat,n-x86_64*,n-aarch64*}").map(&:unlink)
    (bin"sbt").write_env_script libexec"binsbt", Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      You can use $SBT_OPTS to pass additional JVM options to sbt.
      Project specific options should be placed in .sbtopts in the root of your project.
      Global settings should be placed in #{etc}sbtopts

      The installation does not include `sbtn`.
    EOS
  end

  test do
    ENV.append "_JAVA_OPTIONS", "-Dsbt.log.noformat=true"
    system bin"sbt", "--sbt-create", "about"
    assert_match version.to_s, shell_output("#{bin}sbt sbtVersion")
  end
end