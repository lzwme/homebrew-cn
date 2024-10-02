class SonarScanner < Formula
  desc "Launcher to analyze a project with SonarQube"
  homepage "https:docs.sonarqube.orglatestanalysisscansonarscanner"
  url "https:binaries.sonarsource.comDistributionsonar-scanner-clisonar-scanner-cli-6.2.1.4610.zip"
  sha256 "d45e09eecb2fe867ce7548be59d54317192c79944ef7e54c691423c832a8208f"
  license "LGPL-3.0-or-later"
  head "https:github.comSonarSourcesonar-scanner-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "64219f0b6138017bced084185550e6d402a43fa4c2f9e01d59c0b8629e461563"
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