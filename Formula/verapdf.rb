class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.24.1.tar.gz"
  sha256 "fc1c8a8d3d269a018756f16d1ea2bcd47091b80e21f49b1d9a3ebbe02b0c6eba"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95baea214280b494736c1d805848ddb6f289d5288fc00928d7b21df653d20d1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e981cca43f1cdbde7ee00a8fa376a8e400b2aed64e1f37f01e6ab159537041d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9921421c1146c3b0a905ddcca39edf6be7d5527b28b5f8b08b043115f9107df9"
    sha256 cellar: :any_skip_relocation, ventura:        "9770579f944dff9395ea8896d940a454c0726123f7c7439e8326b4983d3b3548"
    sha256 cellar: :any_skip_relocation, monterey:       "bbb4ce667e8a186391ec6ceca44f93b59f2e64ac2912e5e62eb6415d5b767e59"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a2c51aa7850f3bab90985fd17a0829741f58e76e438d6cfb422c9a773883878"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b35a8fa21a0edb86796b85d39028272ea8f47061bceb1badd9854cb16745f8f5"
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