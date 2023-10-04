class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.65.tar.gz"
  sha256 "fde6ed7d786f281b52460581dbf9f719e41766edebcd9de23a6653b7dba48f34"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db31df38f205d0b1bea53fc02e6e3101a2c8889b8145d78a80e71a9fbe846b72"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3caa2fcff432d7cd1d1f6f76966fc8176c4e8a5ecb8b29bd13528bc2b641ffa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08fd03866d82a11bccbf9b58240fb6e56f5b36c772759628e25d77c867de0b25"
    sha256 cellar: :any_skip_relocation, sonoma:         "50ac0a053c71e5d0efb2deecef89e18b95dc249315fb5c886936fd5e4bf73d25"
    sha256 cellar: :any_skip_relocation, ventura:        "eed9db4a183764e4bd1c0e675455bc8c4819f16ced240c291af5c9669d07e462"
    sha256 cellar: :any_skip_relocation, monterey:       "18017466fca99c3d98a9fba3dedd1802fe31b15efe02be0b07dce3c4105be198"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "347c526f45f75988a2cb29622c477aeaa662c98cd3fd6d95cffdde240265784a"
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