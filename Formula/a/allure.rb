class Allure < Formula
  desc "Flexible lightweight test report tool"
  homepage "https:github.comallure-frameworkallure2"
  url "https:repo.maven.apache.orgmaven2ioqametaallureallure-commandline2.26.0allure-commandline-2.26.0.zip"
  sha256 "853c51bc18856c004b886ddd84c93b4edc34041f0597633a8082e520d6a5c742"
  license "Apache-2.0"

  livecheck do
    url "https:search.maven.orgremotecontent?filepath=ioqametaallureallure-commandlinemaven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)<version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d359bf94383022ba443bf511229c721388b40a89d9a5448b96a9947131546287"
  end

  depends_on "openjdk"

  def install
    # Remove all windows files
    rm_f Dir["bin*.bat"]

    prefix.install_metafiles
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
    system "#{bin}allure", "generate", "#{testpath}allure-results", "-o", "#{testpath}allure-report"
  end
end