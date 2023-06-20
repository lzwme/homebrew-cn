class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.238.tar.gz"
  sha256 "a5f25c408dbfc5bdfeb2e33cb4761851c7bdb619a4d9906713dd6ec5e9b11f63"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25a3ab53814c6ec48f4918ad7a26c7b875293317dc1157927facaa3d105fb6c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cbe5bab6bd6528dd15635f3d9ab1f18165f5047a896eba8570e5746dbeb6e05"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed0bb97b841e9675e17dfc39300dc743137ad8262857364cd902b069d16c610a"
    sha256 cellar: :any_skip_relocation, ventura:        "5a4b617865dcb46288fa5139f932d24b4ee36157e907ea8d73da983d637c930b"
    sha256 cellar: :any_skip_relocation, monterey:       "66a16bf7e4d7a7ed7f9576146e2b0e71cecfc822809a9ed1a7e73bd9f3d4f6e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "15de7ee0abb4e6d28ce0d4c0b66e6cb4d2aaa023e62488b5bbdf7eee0edce0f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "debe22e409151b0694fa14031e0b4550254a6bd7eb42b219a50d8837d79cc1e9"
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