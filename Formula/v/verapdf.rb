class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.123.tar.gz"
  sha256 "5569d9ebe4c89a7720af6715e5ce64ea4dcaed5b7f213fa50eba53a4feb8b51e"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9443e6f84771ec1e09f4ff9a5e09137815a6806d2d3e31496758aeb48d75cc81"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c56281cf74f1e583117034d110d4bd87d40b0d2f69f4917664cb421966a75ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d9d8a51dc4a42fbc3d61311e3f2311f87eaad05b8e09b91d0fbf30d33476cfc"
    sha256 cellar: :any_skip_relocation, sonoma:         "c90c7cc75761276cf20e36be0627ed21ef4eaa82b5ab281006d0dbe7e4ded6db"
    sha256 cellar: :any_skip_relocation, ventura:        "56a7310a1b04cafc4e2807b5d675c7e64c4484cb20d44658a80f31fbd14aac3f"
    sha256 cellar: :any_skip_relocation, monterey:       "ff74c81de4824b22c5d9e2c235d2eaf5800a5be74fe0628cbf231d4cb39ee0a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a226ee18fc45eebff7572262fe6635b2ccecf8faea29db91fdd5b7812b542a06"
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