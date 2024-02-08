class Verapdf < Formula
  desc "Open-source industry-supported PDFA validation"
  homepage "https:verapdf.orghome"
  url "https:github.comveraPDFveraPDF-appsarchiverefstagsv1.25.191.tar.gz"
  sha256 "f22fae8cb5dca87460c9ef813b1df93488001f2b17f37496505895222bb4c2a1"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https:github.comveraPDFveraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "49aa916402dd13743fb75e07b09a3f98bd21cdcdf0469e962d77978f6dea96c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60e71d74da057ba9c4ccb2af43f822581ef46cb5400dc6d7c3e1b6754cfaa89e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46ea11dbe5ce7cedccde87875aaaa7736a515c2372f7ea056c8e481eebf25c8e"
    sha256 cellar: :any_skip_relocation, sonoma:         "c08c844a827ca1c20dbcd660181d1d57f7ee9bb51d87ea9adc92b22d6b65374e"
    sha256 cellar: :any_skip_relocation, ventura:        "d4c886686db94e3e14a484e5f842d88442bd954e8c69a2134543a1d6f243d926"
    sha256 cellar: :any_skip_relocation, monterey:       "4b8dbe9bcedebf64cc1164040fe740e0740ff5fe04e68ed26962445c5612e44a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "333e7f34410e6d6b778ce812ee8d7b1d1390512693cdb4f8f72a6ff16ab68f36"
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