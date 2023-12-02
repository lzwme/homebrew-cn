class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.118.tar.gz"
  sha256 "ae61746461e402f316433c1073c88c6c615de893e84677e166bdd04485a76185"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0229d6a6b24ae5246adb9c4c2a2b6a45f9683bf8794dbc2e78447f36d6cf21f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d909f0e3254e3eb56776e26a73eb64bf129e057b44ee496aeb8cb832e3567edd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b9d0b8aa4b032e69b8faac86430d9d56e592aca2a1128e10e066cbca8bd4878"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ab3420cb1c3e22cc4c456985d7d0b5d4fd57eff60e7cd8efe7f8958c9bf82ce"
    sha256 cellar: :any_skip_relocation, ventura:        "630534c3e4171a717fd182e2d6366d57eaf4c6a89da3b28fb516e817ce124af3"
    sha256 cellar: :any_skip_relocation, monterey:       "df2899b49e533eb57c94d24e834b862363d80bc6931feaae0c4a42d5c3bca0fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e8253162c29eac3ac61094a928226f8e9c76c23c23c874c680ccffd559da6b5"
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