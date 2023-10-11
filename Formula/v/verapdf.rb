class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.69.tar.gz"
  sha256 "ecba8f9d1088be0be1ba215dfc825e27cdc91d5d0f734e86b3b426a7da1d298d"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e42f1c8cbca96f4876ab94e6d7b4e52b63e6ec9cb64a3ffb578bc597bac985d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cc65e39d5ac0ce03f19e9b62881505e7606fca9060042fe42052a8c80c5b547"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87dd3e4b99d17fa0d292b99c39d7a79ac5187fe5fa030cbcb031310dbd05cdbd"
    sha256 cellar: :any_skip_relocation, sonoma:         "29559524d568c5d305f20f82d9b44a8c41a6ff6aa90bc8bad63576f093c75f1a"
    sha256 cellar: :any_skip_relocation, ventura:        "053b0ddc51e77325bd150af7a4fa5b13a9d95cf0ade96b59a8eb0f37ffcedfef"
    sha256 cellar: :any_skip_relocation, monterey:       "7b4d7da4722e1e5ff7490452418b182d6b3cd35050a1231095ebe0dcab7de4e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77830db7eefbcf822c3f0406b308687d69c677509f9deb55a44b2b200652f188"
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