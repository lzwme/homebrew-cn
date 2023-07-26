class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.28.tar.gz"
  sha256 "85a549eab79e4823deddfb2c28e651a45d012d3f48782bdf831fa086fbab4276"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60eff8b42567680de8264b7570edcf8c6207d4faac469bfdf66a394be72d655e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ea20e8f6ec4edb6db04b2fbb593cb7352ec242b30fec9e8e8c98c6b3cd28a4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c858ea8feaf7229894c1698957b843693236e2f7adfd89505933f6e0182dda9"
    sha256 cellar: :any_skip_relocation, ventura:        "96918aa2cc41314f24db60fbefc64f8b31fc7ff2bb1b0fd070d15159c69624a6"
    sha256 cellar: :any_skip_relocation, monterey:       "17ac649819e5ce208f4921646fe9bd33971df8e2efc9750b708e96eaed8f3e30"
    sha256 cellar: :any_skip_relocation, big_sur:        "8779c79374a4570512fd5e3b84d13f1e223707e0df61e030a113f17050c20a00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "adbb4d2f5cb4405fc2325693c3a66bac03e8032b9a091e65f9a0b9022ea7133d"
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