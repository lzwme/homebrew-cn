class Sbt < Formula
  desc "Build tool for Scala projects"
  homepage "https:www.scala-sbt.org"
  url "https:github.comsbtsbtreleasesdownloadv1.10.4sbt-1.10.4.tgz"
  mirror "https:sbt-downloads.cdnedge.bluemix.netreleasesv1.10.4sbt-1.10.4.tgz"
  sha256 "0cbfe3bb66a8557d261b85546b2189cd5d6f1ffdb2999ca8cfc9451b853a31a4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "40dc67044b9225033cbd4df1f84029b7023839cd4c68e6681b24d5dd04f41d0b"
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
    # 3. `sbtn-universal-apple-darwin` (universal binary)
    (libexec"bin").glob("sbt{.bat,n-x86_64*,n-aarch64*,n-universal-apple-darwin}").map(&:unlink)
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