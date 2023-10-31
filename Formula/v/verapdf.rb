class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.92.tar.gz"
  sha256 "9da1eae89f37134d7b6e41666e53d577f65c672817f42b3e23672ba5ef1270f0"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "75af4b501bd18cbfc86dd034b6365037724b5da5b14e37159fa8415b8fa5963d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95212a0af6aefa1e43a30c0a3f0eb52a994c221d0ca657ed636e86d32b8213dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f575c69e9b67cb2658654e6ca49fbda7357f93dce37838e849f5e3b2e2184ae1"
    sha256 cellar: :any_skip_relocation, sonoma:         "1f7476f804912e87a77a4bf8672a69be6c2a7eefd86ead9d31a7d0eef1af0ac4"
    sha256 cellar: :any_skip_relocation, ventura:        "a52204f346abbd293af10ef06e0b3139ddb7c76a5e064ed96b28c60f00fe415a"
    sha256 cellar: :any_skip_relocation, monterey:       "d2142340185b0bc8b7f60662a4825d05b308b749586ea0d9b1d19c738f3c746a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e78002a37a8de2599247824d4aee2b2ff413cf5865632eba20870fb04d2b2cc"
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