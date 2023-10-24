class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.82.tar.gz"
  sha256 "e718dc26367ab2bd36cfb5e93c645dd52028cb90a7ace86d8ccc45a8f5544f11"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9fa8fa9daaccc8f51e4115f08af3190a7237681d9402d1587392b1673fdf7f43"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c89f859d9a691864f8fd7347c9b7e407e4b7c61fe675f7e95ac0bfcf3658539c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc88aeb8be5ad378b5b1fd315db3b046f1002d5997506b12ff047a06fb144ca2"
    sha256 cellar: :any_skip_relocation, sonoma:         "59760cf1490492a02c8b7fd6ce867f2144ee0bf2acb424adecf05a6735d912f6"
    sha256 cellar: :any_skip_relocation, ventura:        "4d1c3a499fd9697da6d70a97ddbb127d1e6bdabcc76b45ad0959c6de786f3dd7"
    sha256 cellar: :any_skip_relocation, monterey:       "f579e1b2f6ad2844c5c394a079e34676d8f8157bba876cb921a9045b281d5c51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a44928c40c6bb7728024d75d518174b043faa0e3ed54ddbbe8b6ca78db550ab5"
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