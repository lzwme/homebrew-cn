class SonarScanner < Formula
  desc "Launcher to analyze a project with SonarQube"
  homepage "https:docs.sonarqube.orglatestanalysisscansonarscanner"
  url "https:binaries.sonarsource.comDistributionsonar-scanner-clisonar-scanner-cli-7.0.2.4839.zip"
  sha256 "ef72465a66f519e5da9f1d0731de073d35755a9893591cae4821faebb6e58dd8"
  license "LGPL-3.0-or-later"
  head "https:github.comSonarSourcesonar-scanner-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6818088ece404c7fa78dd3f704886d1735b821a23d422a2e39e44bbae7a737a9"
  end

  depends_on "openjdk"

  def install
    rm_r(Dir["bin*.bat"])
    libexec.install Dir["*"]
    bin.install libexec"binsonar-scanner"
    etc.install libexec"confsonar-scanner.properties"
    ln_s etc"sonar-scanner.properties", libexec"confsonar-scanner.properties"
    bin.env_script_all_files libexec"bin",
                              SONAR_SCANNER_HOME: libexec,
                              JAVA_HOME:          Language::Java.overridable_java_home_env[:JAVA_HOME]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}sonar-scanner --version")
  end
end