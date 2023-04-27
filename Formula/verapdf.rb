class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.180.tar.gz"
  sha256 "f431bfa5f363df66bab93930cc663840a11daf7155cb9f596e2968dd2b86074f"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4d7336863e767fd93f97bacc36cf5b15ac78530fc773fd80e47ca9047d2bbb9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3a3887273461dfe9fdbe9e771a5c3eeb21459525c7f3189a0fd87aa92b7072c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9193fea92c72fd097319c08cde315aca46126361668d54058df48ad17b64c0e"
    sha256 cellar: :any_skip_relocation, ventura:        "367705156340737bc8b587057318656568355c66d5878aeaa63a89840af95b70"
    sha256 cellar: :any_skip_relocation, monterey:       "39e3727bfe3519083edefe43f5c84e776b8a4758adf31a8a136ce950fb3500bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "34dc01845f65108a9c6a738e4af1f21d9a5944f503d7201194d5b1b5f627b91f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5c39c05640ac54f25b7192eab79773335427804c28970451150f96bda8fd2ec"
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