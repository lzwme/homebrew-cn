class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.107.tar.gz"
  sha256 "8486495945329b319296d27e563c13be29462174ba33e658afc9c8f9459bca3f"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6dc67f18aa8459081b9a53e0f03079d3dc9ae693e7901de9f7879fca715d27b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a34a63b7fd2be2c8059823fc3ab463cfcdea1ec65ca98e4818be71dc2ff10ae9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b37fba7104791cffe9178f78a411ae50df4b17765cd6c5188f4882a3deeee569"
    sha256 cellar: :any_skip_relocation, sonoma:         "97ac04e63102a5cda7934a611b3362c0e04b249d063793e633d69307969a79c5"
    sha256 cellar: :any_skip_relocation, ventura:        "aa0d67dffef9aed870f39e1f835a8898c8fcd97c614ec373fba80b13fcd1abed"
    sha256 cellar: :any_skip_relocation, monterey:       "1cf663bfc86e3f8866b67653b3acd6e7d47cb229bfab0f8de1cde64c6f0346dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8517d3cb2e689d22ef465e9a2383d0ca34fd10290d26e0b250f0af34a578848b"
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