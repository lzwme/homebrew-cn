class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.27.tar.gz"
  sha256 "74cbfc78d13a8e172752045466ebedffd47e445e1514f71db67d22ef44cd6172"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "357474524ca4e710ab2f33cac6f6b1bb4e245629cdc0e6307ebda17447dedc18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e24a661b125817e91b15a2ddbe97d5a4f9f57ed1ec6a5b37dec3125b3a87586e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36fd3d6bf108262f76753e26a6f28cddeb471997c169b4350f7445f77b200e79"
    sha256 cellar: :any_skip_relocation, ventura:        "aa1bb3231633645c78594ef6b3acc0aa9756fdd008e8ebddd716960efcba738e"
    sha256 cellar: :any_skip_relocation, monterey:       "bf37f2521d47e256d52c7232deb72376c632d8c08de0e3206236308ffd61cdce"
    sha256 cellar: :any_skip_relocation, big_sur:        "d889e799916a3c2c906c4b825448da1a0830a24a37a8e49b69caae1ce47ab326"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b78d06751ca1cb8174c623d71b00e9c14a1279adb9d8c0ea46a9840f059cca62"
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