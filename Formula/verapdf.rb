class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.196.tar.gz"
  sha256 "044424a335805a0d10a0b16fe401cdad9962b468829225117b298c5880b623a6"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "524081f3d0dcbdffdf134e6cb3a6093c0dbf5508946d31cdb7f3790025f53d1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bba2e8f0297095d4283cc4ac2b2704dadd7b0dc1f5846e864ebbb70bc353726"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f20ce9322648f01b1504ba407d17f2f02481a9f740b2d9a3e5274ba9d15be71e"
    sha256 cellar: :any_skip_relocation, ventura:        "b468a884c7bdd278964d44e13a8143990b28cba058197087a17e7ac8377f7c87"
    sha256 cellar: :any_skip_relocation, monterey:       "114f92faa6e178f6a907e82530412145ef0515313920d8e3c17b47dfac6d578d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c834b145bd1eaafd1b4a17f93606dda237d91a0e9d090a55f1c6c2270841c0d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fa1dceca4693fb34d3f1028b8aa127bf00ea4149a57be4a35a7c1cd5e772981"
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