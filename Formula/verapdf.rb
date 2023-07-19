class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.24.tar.gz"
  sha256 "bdfc8c015dd50b6fd61634ae431acb0ef777a1a15b3373cae595e81043dc780c"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81cf73c1b9926804fba22fd51527cff4fcb0a153f5c60643d20b180f8ce9381e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc16bf9144c33bc93e9ea87f49887b5c047cfdedd6911c38829a683451c6f5c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e9053683efba01b7f61f13a8014ae640817c32ff69eefd94dcb1641f56e8655"
    sha256 cellar: :any_skip_relocation, ventura:        "6eb8ffe64a0954f2498a1c07c4976d4baeff2ee23d54c7780306d28b75a7fbff"
    sha256 cellar: :any_skip_relocation, monterey:       "0dddc1b14bc9f819823d4c8cbf9d580d05b0edb03e966757789919b6fd4eeb54"
    sha256 cellar: :any_skip_relocation, big_sur:        "7157471417d7356e6a6c7d5d71556ee7c5203c0441f965aa08b01cc4e57e9943"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a1887e69ba045f9d918a5a5a55ba3643769367b6e184a54c52937d3dfc5463a"
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