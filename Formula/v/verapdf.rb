class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.46.tar.gz"
  sha256 "525ddf389fae2106ea334ad986a7e6708a1237839be13537cf0756c6e0c6065c"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4ec57b6eaa4cb558a59b5f43ba58883440d218fd05d8269ab8f4f52a3ec6be9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1da98c0fcc04a3cee9e461f0b1075a67aec6d006020eaa1d6f15a1608c108747"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4120cc9ee78246bc658bb850aa5d7474e797e803d56f8b90e19ae77507aff7e0"
    sha256 cellar: :any_skip_relocation, ventura:        "b7d67b44edc9341292073998fc823efdb948617a68f8479af3267236802fa7a8"
    sha256 cellar: :any_skip_relocation, monterey:       "3180d658ba1e948a2f2c15aa7e0f4d5e866634f7871460eb555280c54f9a8f78"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f7adf16f3840b87acb38d76784ba2a7ea6f2ca112a5e0fd7788562a1c756685"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ea94695619b67963c26d9f69283f404a5865916d78fcf4a6431630e57fc81d3"
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