class SonarScanner < Formula
  desc "Launcher to analyze a project with SonarQube"
  homepage "https:docs.sonarqube.orglatestanalysisscansonarscanner"
  url "https:binaries.sonarsource.comDistributionsonar-scanner-clisonar-scanner-cli-6.2.0.4584.zip"
  sha256 "6f3ddd5e273a65cfc9df88ef1e5991bc5aa984533edbc3880cb045b73e62bce8"
  license "LGPL-3.0-or-later"
  head "https:github.comSonarSourcesonar-scanner-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "220d6a45b4827b17901d6dfd08651cb03eecb6947a6ccaa967c3258e8fc9d678"
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