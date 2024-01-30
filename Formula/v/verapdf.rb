class Verapdf < Formula
  desc "Open-source industry-supported PDFA validation"
  homepage "https:verapdf.orghome"
  url "https:github.comveraPDFveraPDF-appsarchiverefstagsv1.25.179.tar.gz"
  sha256 "9e91cbef53f2532e63f14154d285a0bc587eb21d77ca4869a530d4ec5215bc24"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https:github.comveraPDFveraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1262f34c9e3e64f4984caaec4d012a490077243c5e98c8b85c2e4114bd1edaea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72399bdca135b8cf6a01fc72f3057cdf31b2b6231ac1db18b067c01b21fec80c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41993f9e4d9b59d572e3700690a57d80bbaf362900485c08b9c1a1f5ef259d86"
    sha256 cellar: :any_skip_relocation, sonoma:         "7d64b3939f244c94fc28083c08405ca46d88dcf5816220dc89574bc292bfd9e3"
    sha256 cellar: :any_skip_relocation, ventura:        "6502e6a6e449ff9960488d1e7ce7a5234f7b286b00c888df23a17ee66a3c874c"
    sha256 cellar: :any_skip_relocation, monterey:       "5fe34b15280218b6be7b8dbed49c1422c907865795294145ba69cb667765958f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e12abd5c75c7cdaf13a6bdeff527bbff4ac6b9cc3d610e852b7874bc119decd1"
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