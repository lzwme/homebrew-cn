class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.14.tar.gz"
  sha256 "08aadbd7859c404a974a695aaf924b259b04215b7faebd7b6e318dad08a8cec0"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69066d83dcfc12a95a24d9c10a24e9b2245c73e27aa3342fff6419f2513cf561"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72ae4e75a0ac82d83211eb3f1b6386efb1ed41b9052ec345c98df6be77839c2c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c1f41e23e29bd17c382a27c5bf7df4fabde64025ff786b35c18eda6b1b5b6c84"
    sha256 cellar: :any_skip_relocation, ventura:        "70f3d1731a7cf42daee7a6cfd4d9e7b2d9aff55c5c96ef715ba65989c7e27708"
    sha256 cellar: :any_skip_relocation, monterey:       "b48a92b0dc560e9288aa79d24f23c6f299a521c6e5c852bcb8deb0d5fb2402ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "cdaca356666bf7835d64fe1a1a7f7fab502eb09f23c7235d98b1c820ad7b01d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf61a504f0d5161191cd9d859c3fb0164f12887fa31cb7ac61c2be8a8d4d5b5a"
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