class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.39.tar.gz"
  sha256 "9b3e44420827e8505a99f5f03efb9d4cf45588e431be3f8b4eff41c7ea4e562e"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4621579350af15d77d84646564493a79e0b10a0f8c2810b26db6573affb51830"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2aef9c29cdc33d2bbde063c8c512cecfcb2e8682865274282b61432590d792b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5622c8c7e2a365c0bf57b324baac4a6f7f0a644a74976dbf56cde5dbb9cf55e9"
    sha256 cellar: :any_skip_relocation, ventura:        "6b44e29796cdea824caf67b05bf5f0deed9da17ea1c045fb1e74b21787e9f01c"
    sha256 cellar: :any_skip_relocation, monterey:       "e30e8ee3b617750e7a475793f6c35cd0bbf546e470b8f051ca1dffdbc9a818f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c95f3de2ddc5b624e08b273ebbe78bc6d7bcddbb13b65ce78313c807a2be0c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "998944209d26dcbfdffbe4cbeca323df03cc11a9d75a6693d7cfcb05870a85d3"
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