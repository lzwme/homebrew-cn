class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.208.tar.gz"
  sha256 "68dcacf3e14bfeb089a4b8034dc282dc2c61353949a1ce45e45d383a8d428b20"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c13f3d648b64eea66195b2168db323b944913500befb004bcf32ee3bb4054af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b1adc6dfc6d2673648ab47eca332e342ea3e4ad6bb4653f15470e78aabaa4a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1fc60d8455e0d6322c2827a6e632fe04f25515eafab86d57cb5e1413f00ecf80"
    sha256 cellar: :any_skip_relocation, ventura:        "4bbbf577f7f9378a6f5514ed6b657ad93a8308516b0d8f1c2ab0e84b41fc2118"
    sha256 cellar: :any_skip_relocation, monterey:       "f644d96a0510d5702eb02e5f07faa79480d422cf3db42011c9e12163c791264a"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7f35bdd4dcf148990a98d72c5ca8844fb0d81da243e4408bb90b135fd8f6f55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26ffaa47f9a115d793f8543547ee1a837f14dc1c4289a1d388970b64bdba5ec5"
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