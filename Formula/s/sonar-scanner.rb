class SonarScanner < Formula
  desc "Launcher to analyze a project with SonarQube"
  homepage "https:docs.sonarqube.orglatestanalysisscansonarscanner"
  url "https:binaries.sonarsource.comDistributionsonar-scanner-clisonar-scanner-cli-6.1.0.4477.zip"
  sha256 "6928d282b22381d37865c725293f8d03613f81104bc2461ed3318fac2f345cdc"
  license "LGPL-3.0-or-later"
  head "https:github.comSonarSourcesonar-scanner-cli.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "a10087db59cb0d0d6b3badbd8de1250781122107fc6c36fb7a84046bc58e9ffb"
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
                              JAVA_HOME:          Formula["openjdk"].opt_prefix
  end

  test do
    assert_match version.to_s, shell_output("#{bin}sonar-scanner --version")
  end
end