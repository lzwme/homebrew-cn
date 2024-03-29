class SbtAT013 < Formula
  desc "Build tool for Scala projects"
  homepage "https:www.scala-sbt.org"
  url "https:github.comsbtsbtreleasesdownloadv0.13.18sbt-0.13.18.tgz"
  sha256 "afe82322ca8e63e6f1e10fc1eb515eb7dc6c3e5a7f543048814072a03d83b331"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "062ba4d79200936c79c38aa382d7fe0732c8d73c042916309022b6f34a7cb749"
  end

  keg_only :versioned_formula

  disable! date: "2023-06-19", because: :unsupported

  depends_on "openjdk@8"

  def install
    inreplace "binsbt" do |s|
      s.gsub! 'etc_sbt_opts_file="etcsbtsbtopts"', "etc_sbt_opts_file=\"#{etc}sbtopts\""
      s.gsub! "etcsbtsbtopts", "#{etc}sbtopts"
    end

    libexec.install "bin", "lib"
    etc.install "confsbtopts"

    (bin"sbt").write <<~EOS
      #!binsh
      export JAVA_HOME="#{Language::Java.overridable_java_home_env("1.8")[:JAVA_HOME]}"
      if [ -f "$HOME.sbtconfig" ]; then
        echo "Use of ~.sbtconfig is deprecated, please migrate global settings to #{etc}sbtopts" >&2
        . "$HOME.sbtconfig"
      fi
      exec "#{libexec}binsbt" "$@"
    EOS
  end

  def caveats
    <<~EOS
      You can use $SBT_OPTS to pass additional JVM options to SBT:
         SBT_OPTS="-XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M"

      This formula uses the standard Lightbend sbt launcher script.
      Project specific options should be placed in .sbtopts in the root of your project.
      Global settings should be placed in #{etc}sbtopts
    EOS
  end

  test do
    ENV.append "_JAVA_OPTIONS", "-Dsbt.log.noformat=true"
    assert_match "[info] #{version}", shell_output("#{bin}sbt sbtVersion")
  end
end