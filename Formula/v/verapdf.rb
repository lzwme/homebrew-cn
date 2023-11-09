class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.102.tar.gz"
  sha256 "fc85baa150be380f6392d4d1a335917a85dedc75a75e07125914c343c1d64ac8"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ad518424a238517e4494c70e02c7f9a69dee08433b53ac52d854dde601d3bf1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00cf01fcd659e7a0af68ca2c3c9b72516d409a01dfd8dd9cfdccf33cd0e7db72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "585c5f31950da1b65c88855ec5d33ec1dcca9b65d3c90d9b9e6c4c228a48ccd8"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5a624f839eef0fed0411a06058fdda9a2b79046017068681431b0d82ff18b45"
    sha256 cellar: :any_skip_relocation, ventura:        "5b8b5798960a83dae93b5be5dd9fb8f891e13583608b8de1654272a9b1987e88"
    sha256 cellar: :any_skip_relocation, monterey:       "f31b3248ef3823d20936bf585a9126ade1d8a4f83aeb5ce374bbd77c063295ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "191d5bd0be3fce0fceabfc385e669979d781d78c0a05b2d27b345351bb9d591d"
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