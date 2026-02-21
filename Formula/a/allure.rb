class Allure < Formula
  desc "Flexible lightweight test report tool"
  homepage "https://github.com/allure-framework/allure2"
  url "https://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/2.37.0/allure-commandline-2.37.0.zip"
  sha256 "26893d59351572d837d122e2557e681cc7dc7813e180432e531e6087ab2c1e6d"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=io/qameta/allure/allure-commandline/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f21f5d386aec9793834f8564c0d02685b05636b5630e0303b887f1578f4335f7"
  end

  depends_on "openjdk"

  def install
    # Remove all windows files
    rm(Dir["bin/*.bat"])

    libexec.install Dir["*"]
    bin.install libexec.glob("bin/*")
    bin.env_script_all_files libexec/"bin", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    (testpath/"allure-results/allure-result.json").write <<~JSON
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
    JSON
    system bin/"allure", "generate", testpath/"allure-results", "-o", testpath/"allure-report"
  end
end