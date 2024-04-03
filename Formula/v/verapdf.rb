class Verapdf < Formula
  desc "Open-source industry-supported PDFA validation"
  homepage "https:verapdf.orghome"
  url "https:github.comveraPDFveraPDF-appsarchiverefstagsv1.25.233.tar.gz"
  sha256 "7280851178353911fe74782c540fb893cb5fcd715cb879146810b0c7466270b1"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https:github.comveraPDFveraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a16328096aa53c59c7486e5710f383b170cb11d0a22a88ba6515472e0a326fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a8bb19d4f7c0067018daa82ecfc00f6025e724995886ec292e85288a60905ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f70d5a93df77d24c7cff9bd3a9adf42ffaf9f28bfa74d0b810b98ce11cfb8d52"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9e2d1f1cb2acb366029b4be5470602a86ef4d04742ea6011776f452ab908c29"
    sha256 cellar: :any_skip_relocation, ventura:        "c47f819040f5ebd21d28742505bdb681ba468d466b2496f1ab59f97d88fba08c"
    sha256 cellar: :any_skip_relocation, monterey:       "1f2b7a6afc98c514921f2671e490d1455c33cc2274980b571e7da61c68c085f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d39c1b6b0d139ce8c5ae5d10ddfbd048c9fbb5f2ba8d9dcd008c84bcd43e6f6e"
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