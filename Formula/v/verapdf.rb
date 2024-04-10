class Verapdf < Formula
  desc "Open-source industry-supported PDFA validation"
  homepage "https:verapdf.orghome"
  url "https:github.comveraPDFveraPDF-appsarchiverefstagsv1.25.239.tar.gz"
  sha256 "c8629d9eb72dacdc3445fdb201c3611458b870a3c6b8854b45d26393c33b430d"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https:github.comveraPDFveraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "65164cd36ee3406d8b8ff6df8f4e30b608ef02a1c95d2dfef5118ac7070da4ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5ebc9ed179dcbc2f7b327f3560bd65197a4cc3c1b89fca77e54faf604b12f70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "026f7887b2d7882a2f5aeb24f411bab9279666728aefe8742d9b960b19eef4d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "96284888fb651b5a33cae9efdc053544a73ac0df5ecae97ec2145df87f5d8b81"
    sha256 cellar: :any_skip_relocation, ventura:        "e46f42610657bf26879ca1ccb9147c74d02cacfab9b205711f6916ae8646564c"
    sha256 cellar: :any_skip_relocation, monterey:       "3bc7bbbaaae8c28d99b2eee9f850d2d83723430a23626b1993977816828e5702"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "131e009f1036ab6b8da1b5407ed07e88d8ab065f492ce6d44f1386ad0f57a4e6"
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