class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.232.tar.gz"
  sha256 "b13f971ebcea4e505866c81ae81fcfae5967c5ed534624d0797f1984aeb7d4b0"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b749e01829e173a00f306aa613b6aa658610ef61e024cfe8aab92c2c20ccffc3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a996c1a9dc251f3d3a098bf15e4b592c5864ee2e0465058f81fb01330b816465"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2862b1ad5ba9e91823e3dff8e89eb73cccb6a60035e33efd8d116bc1c64e61d0"
    sha256 cellar: :any_skip_relocation, ventura:        "6464511896acc01a5959365455e3eaf836345667d7e068bb61e2d97b8b83d7c9"
    sha256 cellar: :any_skip_relocation, monterey:       "410e63783e948779e5652fe0aad33e69cac0d11f32111ed46599041d3008f16a"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ef02e777724f5920d3f5ff8f5ea215fda5b3d3f6c7d499d96fa64510f814479"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0e1fd372ae3068bb25e0eece7efa1ae465ff067a3fcf14ffffdf33bbc05a1eb"
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