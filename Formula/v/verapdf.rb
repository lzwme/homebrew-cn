class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.106.tar.gz"
  sha256 "2d901fa2c81e48e6b363c68ce9266cb527520da2fd529e591016c2d7bc86ad4d"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "432c212df17702da755cf0f1d16b0634edd09f0cb34836d80ca460171772b06e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72a1a36ad5b474828af2bd2b0d1c5e3cb6d852facc40ba2e5dd716070135414c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc31e83cbbc28e8e9742215adb6743ba779b484de425603ce92db862a76bf0fd"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba8fab065f9c03638757fd92778e52b2e4a0bd23f02a825769053331227e80aa"
    sha256 cellar: :any_skip_relocation, ventura:        "98188c9d7afff9a2dab9c3389870722f246ec90c9925f01cd37123117c943134"
    sha256 cellar: :any_skip_relocation, monterey:       "065b81ab5eb32f402bf7e7f0a6f4fedd49c27a0be97674910a7ff4351a73c5f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "395123ef699100716fe5b9f153e06460bf062af9f43e41df7d96a223d1227e82"
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