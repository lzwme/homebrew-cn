class Verapdf < Formula
  desc "Open-source industry-supported PDFA validation"
  homepage "https:verapdf.orghome"
  url "https:github.comveraPDFveraPDF-appsarchiverefstagsv1.25.194.tar.gz"
  sha256 "1e2d7c8adce2e2546f52a254e9cfaa004f1758ac477e9fa57ec8fe5ce5d771d6"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https:github.comveraPDFveraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "263ca7620baebd6fca90e71836da360585453324385be52efe4a738d43c0e33a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3eeab376db6dc97f82ff40723b440b082805ca4eb7e0411b7f4ed9cff6d594fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75d108128c5347568ea0ecd9fc238979cd9860f79f00dbb5890b100483720b0d"
    sha256 cellar: :any_skip_relocation, sonoma:         "d000f0117982cf4ab1d864168dc08bbb95b431297f2ba8c34b8b1d8cd6427f8a"
    sha256 cellar: :any_skip_relocation, ventura:        "dd45fbfb7d16fbb71b57938612ce8ed99850b879ed02a5d3b09f58e837c55e32"
    sha256 cellar: :any_skip_relocation, monterey:       "388e9cb04efa4b52d0d269263a258f357670fedf9423d055baec53d55165ea19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a5663416a61dbaab99fa63cb66148c3c40f82b0c40ac96f0d0b231bf14a1aab"
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