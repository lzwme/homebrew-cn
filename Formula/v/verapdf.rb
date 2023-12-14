class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.146.tar.gz"
  sha256 "3e64f66e707028203f4a32fe05466096760313e66cbc26f3abc1f6e0a20194bc"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88140a74985265849b03706797d4204eaf476b4292f836a06afcec52073cbab4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8826107e64567799ba632b3cf2647c3958db06289e8ea9702c6b29137d69b71d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "857120f47888636978e721d2920cbabd793f268c2d266078826633bbdc20306b"
    sha256 cellar: :any_skip_relocation, sonoma:         "e18ad3593f490b9755902a874426c591e122047a4eac570d6fde4a49f52ee894"
    sha256 cellar: :any_skip_relocation, ventura:        "eeac56edbeb91658bf9564ec006b2ec53181716dbca64195ac4694b4d3aab9fd"
    sha256 cellar: :any_skip_relocation, monterey:       "b201f28138d07fdf1fc25dc1c0c8329b279f9b7e7e5d129f4c904870dfe20eb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9acba107c599ba6be5d3814dcc0fcd5518cafad2c0b658148320119b70fd5ea1"
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