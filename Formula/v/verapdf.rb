class Verapdf < Formula
  desc "Open-source industry-supported PDFA validation"
  homepage "https:verapdf.orghome"
  url "https:github.comveraPDFveraPDF-appsarchiverefstagsv1.26.2.tar.gz"
  sha256 "f5577313bcbc5b5c6a282c1b61226d0862f6fa68b1e87b71ac3fe529fffa646d"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https:github.comveraPDFveraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(^v?(\d+\.\d*[02468]\.\d+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "452391aaa751bfbeb3a2e5f8deee7270f63b50eb00a98a6f20212a53c3d06493"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "786a5a666e461fa73dfefb962ac63694937e6a5165dfc1ae916e59edf1172c66"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c55e15630106a5fa6e09117fc5da6f34f83a7a762af947aaef8f6c33de83c9a"
    sha256 cellar: :any_skip_relocation, sonoma:         "b6964fa150b66b49aa7196a29efcc5a6f287a9f131def39faac07024cd8cec82"
    sha256 cellar: :any_skip_relocation, ventura:        "0080b800c79ff5d16c755e57def27b2f9148e440f5a5a82d1811d2c7f413576f"
    sha256 cellar: :any_skip_relocation, monterey:       "f1050f50a04955d2b815bd7adda2b0b4ca6e5c5f6a00bfc841278bd9ffbf18d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72375730df9e7736dd0060345d3158172fa2b20628fa61adb41b54a4091ed6cd"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home
    system "mvn", "clean", "install", "-DskipTests"

    installer_file = Pathname.glob("installertargetverapdf-izpack-installer-*.jar").first
    system "java", "-DINSTALL_PATH=#{libexec}", "-jar", installer_file, "-options-system"

    bin.install libexec"verapdf", libexec"verapdf-gui"
    bin.env_script_all_files libexec, Language::Java.overridable_java_home_env
    prefix.install "tests"
  end

  test do
    with_env(VERAPDF: "#{bin}verapdf", NO_CD: "1") do
      system prefix"testsexit-status.sh"
    end
  end
end