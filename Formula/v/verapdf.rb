class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.41.tar.gz"
  sha256 "7ddce54d060f8a8512b1c630ad445bae6953f6f56763fb0f7fd4fbcfa6e64489"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16911b619c5d2c90e268bcd73aaa445e5c3761f70302d0cd24c3a18f9d670e85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9aa912d3569f4bbe41b4f30159fb2ed5ac6fc2a467f7580ff7f8447e064cb181"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a1ae20f205b8ac1ddc3098cedb48c67d4a307b1ed109bc9226e0e5322c41ba3"
    sha256 cellar: :any_skip_relocation, ventura:        "954fdb846b2b2fd2ca949996bd0316c5bd88a755af18804ae78c875c6c8c807e"
    sha256 cellar: :any_skip_relocation, monterey:       "a50588c96dd8437fa32ac98c0752be0b348068356c26f879d61c614d96fd9fa3"
    sha256 cellar: :any_skip_relocation, big_sur:        "205c859adbc120b3a53dc32b6da33fee3fac0acfd1460498f31534958ca23bec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76231bd2b5f47b19d675e19945e84fe8e94c62366ae61df3a8b683bdbc583ecb"
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