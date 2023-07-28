class SonarScanner < Formula
  desc "Launcher to analyze a project with SonarQube"
  homepage "https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/"
  url "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.0.2966.zip"
  sha256 "1552987ca036d85b83ba68b815d641e26df04afff02570c6b72bec0fe4adea37"
  license "LGPL-3.0-or-later"
  head "https://github.com/SonarSource/sonar-scanner-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5710f7fd39d850b2a93e726a3b4f04bb98be8aa6cce882a06adca5c5c3ff37ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5710f7fd39d850b2a93e726a3b4f04bb98be8aa6cce882a06adca5c5c3ff37ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5710f7fd39d850b2a93e726a3b4f04bb98be8aa6cce882a06adca5c5c3ff37ff"
    sha256 cellar: :any_skip_relocation, ventura:        "5710f7fd39d850b2a93e726a3b4f04bb98be8aa6cce882a06adca5c5c3ff37ff"
    sha256 cellar: :any_skip_relocation, monterey:       "5710f7fd39d850b2a93e726a3b4f04bb98be8aa6cce882a06adca5c5c3ff37ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "5710f7fd39d850b2a93e726a3b4f04bb98be8aa6cce882a06adca5c5c3ff37ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28d18dfd58026db06df33087e46d7d0418b7e264bef2f12b3e75feb28119e201"
  end

  depends_on "openjdk"

  def install
    rm_rf Dir["bin/*.bat"]
    libexec.install Dir["*"]
    bin.install libexec/"bin/sonar-scanner"
    etc.install libexec/"conf/sonar-scanner.properties"
    ln_s etc/"sonar-scanner.properties", libexec/"conf/sonar-scanner.properties"
    bin.env_script_all_files libexec/"bin/",
                              SONAR_SCANNER_HOME: libexec,
                              JAVA_HOME:          Formula["openjdk"].opt_prefix
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sonar-scanner --version")
  end
end