class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.80.tar.gz"
  sha256 "53e1f446dc3b2e796a62e147414e4b3adf33050cd2dc3c4b057b5ef059e0390a"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "abad71c215fa7a46fe30a25f2d76765103ef7852deb999845a7fe34e4698ffa2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9db3b20673afa6422e21ecf988cbb24b1ee2642352d30cc25284e441407d577"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a79e5b4047174fc16309158e3dfa33a01c4425f06c0d2354b96a4aa02167acd9"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8441b0a09c55b01688eb7cdbf39c857cf300cd0d00c7ee31da283a515d499dc"
    sha256 cellar: :any_skip_relocation, ventura:        "a0f93bf0c8d315b3f7078ba16deef3ef54e3c8c39455331f111f7d6c2ae4b92b"
    sha256 cellar: :any_skip_relocation, monterey:       "181e6e2b3ba6a3c103cf549732ca5630e97bedd444bd60af936f5c7002f8a5a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef231b43595cc82b29dfdf8f9d30e6326686457f6b218a220a66d02b3c8cab2f"
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