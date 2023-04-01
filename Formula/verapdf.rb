class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.155.tar.gz"
  sha256 "76c1296465ee03f867f988f09d8361ae25bae7ca926d10d8a51b9dcadb70391b"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8368958d27880ae46c24a5c44db0397a264db76972ffccde3df6f05c34bcdf9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a539c42d5abf5f57a1d804b1e1953599a582476b8048cb385dd0b2d655515644"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4d28a70d0fd6576e0cc0662e64a1a459985d8f31d268850b297c4795aa7a175"
    sha256 cellar: :any_skip_relocation, ventura:        "80de8cdf15b5630c8af96b587b8857e52a047900e2dc4c8e6953c896e708bdc8"
    sha256 cellar: :any_skip_relocation, monterey:       "8cbfb2c1e7872965d0b5c25e594209bac47c5e09b484beaced0394a6cfae486c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f0859a9d09c277d8f97e931cd90232c97786fef0658129c5f55a4d86d569114"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25a463d6e5b39ec4ff364f32fdc9945a7c16ea43d45b66f1df641ca18a2c16a9"
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