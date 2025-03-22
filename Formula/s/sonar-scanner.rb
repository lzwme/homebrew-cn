class SonarScanner < Formula
  desc "Launcher to analyze a project with SonarQube"
  homepage "https:docs.sonarqube.orglatestanalysisscansonarscanner"
  url "https:binaries.sonarsource.comDistributionsonar-scanner-clisonar-scanner-cli-7.1.0.4889.zip"
  sha256 "491ff8c3502742cf67e5566b0f7c4329f375c31e836cdd7e0b202551bbc3f27b"
  license "LGPL-3.0-or-later"
  head "https:github.comSonarSourcesonar-scanner-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9a1a6aadf31d5a50d94bbfbba6988fcd308564774b6a5142bbc392feca0c8c85"
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