class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.21.tar.gz"
  sha256 "533fe5e142c09f9967f28c802fb51fb2ec1b42ae266caed231e514dafc585895"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4018299897bdad3a9d5c226167b060701f8cf071faffce9b358beccacb27e6dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d4f16e7abeee30ab1f723ac33aa5bc34b4f8ead3b00c667b0c0bfee1897e4ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22acbf0e3bc3d90d8760cbd04ec238f568a0294579c58e1b65e6baa86bd50141"
    sha256 cellar: :any_skip_relocation, ventura:        "babdedc431c50120cdbd649bd9d406111389826a2d747a9ad2416bc9d3358869"
    sha256 cellar: :any_skip_relocation, monterey:       "33d5034f2a7f514e154afbe0b67aa277179ef7bcd3c9e23b1294ea4e45d2a324"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed6386ab55abacfb3d921baf8846f0e565ebb6eefb942e0a5c68dfd1d03da69e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d56970932573f93dd43fa43322b1ccf86bcc54623b56e28f09c3c3e4adcc7eea"
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