class Verapdf < Formula
  desc "Open-source industry-supported PDFA validation"
  homepage "https:verapdf.orghome"
  url "https:github.comveraPDFveraPDF-appsarchiverefstagsv1.25.162.tar.gz"
  sha256 "8f7ce620a658211011f581958a82a1786e86d605ce1204a4c6ba42cdbbbdc52f"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https:github.comveraPDFveraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ee8bceffcdabb432c040816449936e35d17d06fcdc8392180f466864986af82"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "509259a4d40b7b7b8a760ffa80b2d78f7aa949b3fa589ee17c36d8b1f32df530"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f8cdf4a019d5d682baf68899bc5e390cbd3ec94edeb52e0cf9a3aae7aedd75b"
    sha256 cellar: :any_skip_relocation, sonoma:         "801f576e2f0d69696cc8a8740f24727673f0bb3d3ce4042dee1b1446f8beff13"
    sha256 cellar: :any_skip_relocation, ventura:        "c5250a015bc4c8c6d91eed64cbc1e9adf9e8c2930015aabcda183e95a04dda63"
    sha256 cellar: :any_skip_relocation, monterey:       "989110cfc8c1f15f5e59f38433e8629c0b8dce6bb60072fe41ed14fff1fc0246"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fff300cf00cc3e29c35a019659e3184c31b5a1009d8138c3293fd27ddf8f375e"
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