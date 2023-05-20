class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.218.tar.gz"
  sha256 "ced6f2c3a3705e09d8ef0e098e6341656640f595d57f52255b233810d4eabb3e"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2460ab05617a8207dd3a67b7091ebbf6b4994d5524dad872b3ebd33da08aad77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d015f402874006d13ac4c229049a6cc88387fbb59f00000443c4016adcbf5af5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b829dc95d7254d7fc3360df95cea14f629bb6d20504bacf63e0b7a191e858ba4"
    sha256 cellar: :any_skip_relocation, ventura:        "93b1d6bf04c59113f023a0cf25b91b10987d4a491a30bef6a2a9f9da90c95a18"
    sha256 cellar: :any_skip_relocation, monterey:       "dcc2d62cc3771902f711624bf4e3986fc761f6883f9f72097870afb29702e000"
    sha256 cellar: :any_skip_relocation, big_sur:        "64208566a46c4c0ae6cd130b0b513cf7686d77584c7e637da6756cc6d66abc07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9f395d892ab6935ce9caa4d28ca21a73fb74c5fde9361dd67dd1d142bdad8a5"
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