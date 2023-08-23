class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.37.tar.gz"
  sha256 "3ab4b672a19b9b157cee95266c1f8b150cd2044233c12c3d83236aaa14b1f0a5"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c2f3091252c3ac55e077d1e1a2f2f533fa701c8f90e6d06ddc286c68686be96"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0846e69765263bd5753e6391b42707980a595c7a84bb2900a784c506c2a46f63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98a7ea05f52db805b5f38ac2506ce85483222e062070417bb7ad6d24c56cf78e"
    sha256 cellar: :any_skip_relocation, ventura:        "8d9d431ae444b98711c26d592aa5e304f94acdf7b53d3d992c18037e14fa6e15"
    sha256 cellar: :any_skip_relocation, monterey:       "aadfd17f6e7910578d0091f65964d148402157a06a53da3671f2c69b50bbb186"
    sha256 cellar: :any_skip_relocation, big_sur:        "96a15f67723510eeabbdc5aa8fef0748db00745bc05bbd5157f93a4aaa38a0eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "177191e9ab06880bf52f7824c2dad0f4777e68199cacc35bfef1d4048bd45e98"
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