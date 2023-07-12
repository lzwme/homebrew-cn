class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.16.tar.gz"
  sha256 "5c4561ddaeaca44f30cbd9cf373f1d459d808fd581a43c6f45fd4943b6626b95"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c1f00ad5746b2a0590de8c219102539328a4284f77b2ac25ebd80bcd4008d0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ae5cd89dd0889b5938d9a0760b9e2893fe46dc1e7bce099b3a7dba12bf66228"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9586be9f25e7a4a9926d9528a2818ce6d5ec178d16ecf220392fb7dbaef5c933"
    sha256 cellar: :any_skip_relocation, ventura:        "ff8d0b103df555171fdd57e979dc917c40e0f40f28c46a7eb4ada6bdb6b59618"
    sha256 cellar: :any_skip_relocation, monterey:       "314835f4d516befeabdddd0ef5eabe4263c2c176534215136e6c8a51438b903d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c332c6aeb9b082e5707a2322383bd6f523c846e86898c0503f02eedc89f01ca9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da7b2210a31cc47d7a70fc9753bb541ca0dc205e5d9afa9468d76b3633a76621"
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