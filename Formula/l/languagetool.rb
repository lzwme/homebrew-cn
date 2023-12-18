class Languagetool < Formula
  desc "Style and grammar checker"
  homepage "https:www.languagetool.org"
  url "https:github.comlanguagetool-orglanguagetool.git",
      tag:      "v6.3-branch",
      revision: "fb238b2a32bc72714632a399c9b47abbe9f1c0c1"
  version "6.3"
  license "LGPL-2.1-or-later"
  head "https:github.comlanguagetool-orglanguagetool.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)(-branch)?$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "43281f7997148a31749dc9d9b3a351225f657177093a5f0e36656175d04eaec2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "286ed2bfa59a9a1bbca24fb6fc07e375c3e0c06652f0ea2b29ea4bfac2cbacb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16b8b650732825a83278a32f3f3d6bd21a9778b38a3998b41d2bb8970c7ff636"
    sha256 cellar: :any_skip_relocation, sonoma:         "f0e6d9d3b3be033c1c1a1102c6928ee15c2bd0a2eb98a264d84f5c2a762baede"
    sha256 cellar: :any_skip_relocation, ventura:        "7c6947d74f32186972b382de9244257afe5a7fc7514cb53a405a0b8595f470fa"
    sha256 cellar: :any_skip_relocation, monterey:       "dcc44613b44ba5528525058d8d7746447267efce32fa9254bbdf544ef1704b7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae965ca476fe15b349e4fa0a85f7e1ce14a9961c2c1cbbbcd6d4c215aabeffc2"
  end

  depends_on "maven" => :build
  depends_on "openjdk@11"

  def install
    java_version = "11"
    ENV["JAVA_HOME"] = Language::Java.java_home(java_version)
    system "mvn", "clean", "package", "-DskipTests"

    # We need to strip one path level from the distribution zipball,
    # so extract it into a temporary directory then install it.
    mktemp "zip" do
      system "unzip", Dir["#{buildpath}languagetool-standalonetarget*.zip"].first, "-d", "."
      libexec.install Dir["**"]
    end

    bin.write_jar_script libexec"languagetool-commandline.jar", "languagetool", java_version: java_version
    bin.write_jar_script libexec"languagetool.jar", "languagetool-gui", java_version: java_version
    (bin"languagetool-server").write <<~EOS
      #!binbash
      export JAVA_HOME="#{Language::Java.overridable_java_home_env(java_version)[:JAVA_HOME]}"
      exec "${JAVA_HOME}binjava" -cp "#{libexec}languagetool-server.jar" org.languagetool.server.HTTPServer "$@"
    EOS
  end

  service do
    run [opt_bin"languagetool-server", "--port", "8081", "--allow-origin"]
    keep_alive true
    log_path var"loglanguagetoollanguagetool-server.log"
    error_log_path var"loglanguagetoollanguagetool-server.log"
  end

  test do
    (testpath"test.txt").write <<~EOS
      Homebrew, this is an test
    EOS
    output = shell_output("#{bin}languagetool -l en-US test.txt 2>&1")
    assert_match(Message: Use \Wa\W instead of \Wan\W, output)
  end
end