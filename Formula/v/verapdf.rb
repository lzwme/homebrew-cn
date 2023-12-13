class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.141.tar.gz"
  sha256 "7ad09980cfc9d68c58d0c4c259c90611fd53980bd73469d168cbeb8886cc38b3"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f135c248d8974f2b819ddb8443c4c8c8ffd25e9a5b363d68daa9ccccdcad1cf8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21fee0dcd96fc842d57af3155adda08e85c2dee55e995425a39759a9c1039c6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9740ea6083d7be2f0b5096cf18ca669cd7eeccd3b23d5ef5fffef20a71088b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d6b7b054280bfde32d31c634cf497d02f71aa59f0b893118480ba4b85355741"
    sha256 cellar: :any_skip_relocation, ventura:        "9141acddac091bb0431b94253c6231f327e556a85b6886f7d1f770477183fb25"
    sha256 cellar: :any_skip_relocation, monterey:       "f0ed9353f6a7dd6799b3bab419e9fa4a85b3eecc127c39903410cfec79261ed4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75237a1cdf28bd4318b61f693f92e24b72a7eb54f214f494b1a2c5add1276989"
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