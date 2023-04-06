class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.157.tar.gz"
  sha256 "9f91825446258f4686ce88e9287cf36318ec94857f08c00b7f7e99cae6053559"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c37dc11fac53dfca1d901fa357ba392b528cf8d91593eee2062b961d4199913a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27ec727f18cc084bdf6dd27259ea1e714f11097e21e39098003683a77963e897"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2150a1af384ee399de10c0f5e1f3d7be6a5cffba61379cd69f2a514073d29cd"
    sha256 cellar: :any_skip_relocation, ventura:        "ad8edb19e882fe150b2e385ec333d22b586bae7c1aa20915d0408b6387c9b6e1"
    sha256 cellar: :any_skip_relocation, monterey:       "c36c1eef3b8b98df9319f1e723c32a40e17432b419e96fb8ce182c763bbe0953"
    sha256 cellar: :any_skip_relocation, big_sur:        "23c5e43aa65f77fac1e17eda85269a6f90f41984859068966f0042e6f3a6839b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0bb7ac86f4651d0ce3cf863dadf993dcaf0f37a21cae0560f286b834993fd19"
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