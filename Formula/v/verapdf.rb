class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.100.tar.gz"
  sha256 "6419baec35cad6142d626c5e3d9de2982b740d6fba1377034a4197e3de5eb00a"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7ff69bd58ef925710ea25c107cafe441b9cfeea4e1c35a0d9a77753e79073e3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55e1cb940824ba23d0e48820bb54b073bf29d69677ae191de7928ffc003843b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b61a2987c8e8b512030d576d5596ed74452930c01bbea1b08310bdbc8efbeba5"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa1451691f32020835e307a3ddb456d42abae2e49202945a0827a86461e56e9a"
    sha256 cellar: :any_skip_relocation, ventura:        "b8a488ce2c829a170abafada297151ed5f0b36f667b12f9bf3cb56d25ce1b509"
    sha256 cellar: :any_skip_relocation, monterey:       "c3ef7de95d24f3496d2434f2eb786ab98de653e7ccd50f36220425f3a0879df1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2600b67a9891b406e434db1adf9c477f598fa6ce08a5917c2d02984df683d59e"
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