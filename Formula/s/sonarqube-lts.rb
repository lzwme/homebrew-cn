class SonarqubeLts < Formula
  desc "Manage code quality"
  homepage "https://www.sonarqube.org/"
  url "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.3.79811.zip"
  sha256 "fa415cc69437843c6701ff93961c2fe298bef659e97c442b1bf9f88a858f5f45"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://www.sonarsource.com/page-data/products/sonarqube/downloads/page-data.json"
    regex(/SonarQube\s+v?\d+(?:\.\d+)+\s+LTS.*?sonarqube[._-]v?(\d+(?:\.\d+)+)\.zip/im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b988b2236f3050b0a112d2d870443292adb735495cc1c6e4fa205b41751106d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b988b2236f3050b0a112d2d870443292adb735495cc1c6e4fa205b41751106d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b988b2236f3050b0a112d2d870443292adb735495cc1c6e4fa205b41751106d"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b988b2236f3050b0a112d2d870443292adb735495cc1c6e4fa205b41751106d"
    sha256 cellar: :any_skip_relocation, ventura:        "2b988b2236f3050b0a112d2d870443292adb735495cc1c6e4fa205b41751106d"
    sha256 cellar: :any_skip_relocation, monterey:       "2b988b2236f3050b0a112d2d870443292adb735495cc1c6e4fa205b41751106d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "904ad293008fd6b7183268cc86ec1e4a6b8ecdb787693726f615d453061526ad"
  end

  depends_on "openjdk@17"

  conflicts_with "sonarqube", because: "both install the same binaries"

  def install
    # Delete native bin directories for other systems
    remove, keep = if OS.mac?
      ["linux", "macosx-universal"]
    else
      ["macosx", "linux-x86"]
    end

    rm_rf Dir["bin/{#{remove},windows}-*"]

    libexec.install Dir["*"]

    (bin/"sonar").write_env_script libexec/"bin/#{keep}-64/sonar.sh",
      Language::Java.overridable_java_home_env("17")
  end

  service do
    run [opt_bin/"sonar", "start"]
  end

  test do
    ENV["SONAR_JAVA_PATH"] = Formula["openjdk@17"].opt_bin/"java"
    assert_match "SonarQube", shell_output("#{bin}/sonar status", 1)
  end
end