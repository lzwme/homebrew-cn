class Verapdf < Formula
  desc "Open-source industry-supported PDFA validation"
  homepage "https:verapdf.orghome"
  url "https:github.comveraPDFveraPDF-appsarchiverefstagsv1.25.170.tar.gz"
  sha256 "002ff0571debf409c495b6b69247b4f887e7937cce8115aad624b95941fbfe82"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https:github.comveraPDFveraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5e42fb8ab9496815fdda43fe1d65486d9ea85c8a571e2856e8f5407308a84794"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "820e4461320eda6c0cf5dd29cd8dd512c712bb60c059c0a3779d33f3d148d742"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b95916b67a421aeea5c8dc7207211fc343571c2de4c213308055ecfad5cc10d"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae0355216e90a3cdd012626902b60cc172ce30acc44a6399d22960d2c40276e6"
    sha256 cellar: :any_skip_relocation, ventura:        "052e5401ab29468646196e7f24ae8a7302f7387092a2557d2a22557d2accdc9b"
    sha256 cellar: :any_skip_relocation, monterey:       "890e2ddf7f72b337273b620cfb5082db87ec2ca7e49eb4a15022851a0534a99c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c04331df0e1d2d43b48ec9eafb8d032ac30409eac526f2d1554a1c67c01d3e91"
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