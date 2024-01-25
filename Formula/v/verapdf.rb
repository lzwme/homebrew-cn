class Verapdf < Formula
  desc "Open-source industry-supported PDFA validation"
  homepage "https:verapdf.orghome"
  url "https:github.comveraPDFveraPDF-appsarchiverefstagsv1.25.177.tar.gz"
  sha256 "59d0afe26bc684a9cccfff3c74f83ed9d594d874f430af0f94638edd30edb0ba"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https:github.comveraPDFveraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab261b010699c085bbac00f3a0b02cb0c97e6c9bbb0d048bab99942d6c4db403"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3ffe5266ff11d5fa82daa20bf6093084e7a38455634237678ea13c4c32b9dc3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2400fd06b90ef53a28d14afd91c717beab105ccfb1e2c72ab58a55efcb2a27ee"
    sha256 cellar: :any_skip_relocation, sonoma:         "1f59721e74bd0f08fba8e1f745c1962c9f5203d119cad5ee04ffc5b99924a72b"
    sha256 cellar: :any_skip_relocation, ventura:        "20d70f1ec9d68bd85e3cea2bc6b9def892644fc52331e4b048183d811191b64e"
    sha256 cellar: :any_skip_relocation, monterey:       "58c59a6db711e5811d135fb85a5bcf1c4ae9060ee2772610ea4bd5a8cc0bd9b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af5f610f68d812461e7c39be4b9272643cf2e259ac0ae3171843b8fa250cb9b5"
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