class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.34.tar.gz"
  sha256 "3d00f15751e2b2d2a4ac4d83e5643ba332066a3e8599b17f22cafeab2ea016c4"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "339f97113a2668c409002ed5dd19227c044f455d852234922f18ea79809c8163"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "094f2ffc0e3b48041943a976922a22d67dea953c3e78b21606613c97e51f5279"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "587feb995bbd1d22accee56c14d9138c5fb367e996cc8a54390bb39f96a82228"
    sha256 cellar: :any_skip_relocation, ventura:        "c7f29826770fa5e9fb07de13c8b3af329a9c63f09c381e65e278156f4909a65a"
    sha256 cellar: :any_skip_relocation, monterey:       "175a7c69ef3ac3f770d6a362439959035d62a3813246b86f634bf3cdf43237ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ed0323bbf69bcefb4ab98046bb6617d855d2da88d7b2ddd7583f8ec4dc36caf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8df50af000d39bbd2e1b5658bfc8bbd1cba9db102b7529ae44f6ffde911697d5"
  end

  depends_on "maven" => :build
  depends_on "openjdk@17"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("17")
    system "mvn", "clean", "install"

    installer_file = Pathname.glob("installer/target/verapdf-izpack-installer-*.jar").first
    system "java", "-DINSTALL_PATH=#{libexec}", "-jar", installer_file, "-options-system"

    bin.install libexec/"verapdf", libexec/"verapdf-gui"
    bin.env_script_all_files libexec, Language::Java.overridable_java_home_env("17")
    prefix.install "tests"
  end

  test do
    with_env(VERAPDF: "#{bin}/verapdf", NO_CD: "1") do
      system prefix/"tests/exit-status.sh"
    end
  end
end