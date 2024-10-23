class Allure < Formula
  desc "Flexible lightweight test report tool"
  homepage "https:github.comallure-frameworkallure2"
  url "https:repo.maven.apache.orgmaven2ioqametaallureallure-commandline2.31.0allure-commandline-2.31.0.zip"
  sha256 "8f89bfe5e4b0a33c967ce3bb8bab92f23d89d0722fbb29b734f5b11fe6133d53"
  license "Apache-2.0"

  livecheck do
    url "https:search.maven.orgremotecontent?filepath=ioqametaallureallure-commandlinemaven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)<version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2602402b80c9d6cad871cc4edc8dcc8a8adb84a8e41bba93712f38158a2da45a"
  end

  depends_on "openjdk"

  def install
    # Remove all windows files
    rm(Dir["bin*.bat"])

    libexec.install Dir["*"]
    bin.install Dir["#{libexec}bin*"]
    bin.env_script_all_files libexec"bin", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    (testpath"allure-resultsallure-result.json").write <<~EOS
      {
        "uuid": "allure",
        "name": "testReportGeneration",
        "fullName": "org.homebrew.AllureFormula.testReportGeneration",
        "status": "passed",
        "stage": "finished",
        "start": 1494857300486,
        "stop": 1494857300492,
        "labels": [
          {
            "name": "package",
            "value": "org.homebrew"
          },
          {
            "name": "testClass",
            "value": "AllureFormula"
          },
          {
            "name": "testMethod",
            "value": "testReportGeneration"
          }
        ]
      }
    EOS
    system bin"allure", "generate", "#{testpath}allure-results", "-o", "#{testpath}allure-report"
  end
end