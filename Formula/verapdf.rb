class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.10.tar.gz"
  sha256 "43a57fb5454eebbeeaa5724e95f80889972068813055442dcbda85cf8d72b5f5"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df18c525891f6ce2283f9e09baca0c4958ed93b9f873641719523b095db960f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c47a849d8a2389b00434ab87b0e7fe11e6c0e68598ac9e220853dae258a71ab6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1cc20a042b11ad1b3a8aabda354250eb5e1c86f55fa67285d9aa510f2e656040"
    sha256 cellar: :any_skip_relocation, ventura:        "66c3fa1f77258f6980e956d7f720a2754a4ffe3dab485e67161bfaccafbd2fab"
    sha256 cellar: :any_skip_relocation, monterey:       "3a410133aaa3f7fb22566ca965cfe8bfb838e567cd6c01692e494f2a52bb27fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf7c7ca3a5727b4ea505b1239295db10e652ad807aed7abe58e051d2e3c7da9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41fa4496d4059282af1b6a75711808b9b87173a15b0a418e6cd19fdbcf348a49"
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