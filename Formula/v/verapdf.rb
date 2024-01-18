class Verapdf < Formula
  desc "Open-source industry-supported PDFA validation"
  homepage "https:verapdf.orghome"
  url "https:github.comveraPDFveraPDF-appsarchiverefstagsv1.25.172.tar.gz"
  sha256 "0ffc00eac14a6b8665956e2dfa2c951393b37167e8611f74791fad07c10acbec"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https:github.comveraPDFveraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d456af019632d6feb25253c33d1b12036542605eb92039e292a94802261b158a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf3b5223f8b2b90ddab256acc59f94aa92f735fecdbde6d23b214e83445eea04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f4001f57457c57e5da9fcc29984802327f8464671ba7827962aaef08cf22fa9"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc9613d426afa03ef8c6210ef5e691a5d3df93d415574cfd3601f3e4efc2fe3e"
    sha256 cellar: :any_skip_relocation, ventura:        "0aa76fabf157377197e2a82bcfd11a16cf6e3700205b0a2031d87ad25fd7a676"
    sha256 cellar: :any_skip_relocation, monterey:       "7354eb3d65c439e8e8888d914606e6513483261a6b830a2d1bf1fbeacc236b18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f5b36c5d9bd913446cfd31c9898dd505f7b8de8c5527d91f0e0ecdd1023efad"
  end

  depends_on "maven" => :build
  depends_on "openjdk@17"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("17")
    system "mvn", "clean", "install"

    installer_file = Pathname.glob("installertargetverapdf-izpack-installer-*.jar").first
    system "java", "-DINSTALL_PATH=#{libexec}", "-jar", installer_file, "-options-system"

    bin.install libexec"verapdf", libexec"verapdf-gui"
    bin.env_script_all_files libexec, Language::Java.overridable_java_home_env("17")
    prefix.install "tests"
  end

  test do
    with_env(VERAPDF: "#{bin}verapdf", NO_CD: "1") do
      system prefix"testsexit-status.sh"
    end
  end
end