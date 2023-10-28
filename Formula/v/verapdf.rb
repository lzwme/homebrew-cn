class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.89.tar.gz"
  sha256 "b56e609e820f29bb3f5460e40e1b5736246a48336779003ff4e6b1d94ca32cb7"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f851b033f908803e3a3e38406d6bf47f128cbc86026df999ae33e3a7c91e4a4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04af13ed00799c72913f0e04fe7d01ac858cb86bbfb9ce829c90cbce7870b9ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b31169f218204881b5f6ab69eb6a04502740c752f73d32d9caf5d150bd4cf2d"
    sha256 cellar: :any_skip_relocation, sonoma:         "a63244edd7bb7c2bcbec1959bb4a07d2b296cd83678b1ee804b0e0a22219d78c"
    sha256 cellar: :any_skip_relocation, ventura:        "408eb7ea963817cc6a800213cebbae19e83b49d960670b9b269a842043802b9d"
    sha256 cellar: :any_skip_relocation, monterey:       "b95f5a161d19f09f489371e6268af2fabe23d90f23a74d07dc139f58adc72696"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9750f448125eb3eb30ac2fd43f6d95db89c1ab845b7cc127bddba0f0eb810b59"
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