class Verapdf < Formula
  desc "Open-source industry-supported PDFA validation"
  homepage "https:verapdf.orghome"
  url "https:github.comveraPDFveraPDF-appsarchiverefstagsv1.25.241.tar.gz"
  sha256 "88eeb776977feaf1d7e8dea3cb33e9d634a7750e3d8415e3a3416dc38c67d267"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https:github.comveraPDFveraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66a598cb38bef9d7aa9cd4cd68082f058989ecd719bcfe77dbed021478871f91"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d27cced0a09a2e0d6fa2dd44043b9636a55f7dffa5fc212457e689a64078e7dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "993b1008568fa28f16b3df2db91cd8e2de2e4d8d2cccb45639df9ba15023d63b"
    sha256 cellar: :any_skip_relocation, sonoma:         "78b5bffcc944b0f24af4c3d5fbf5f46fb144c4281d4dba2e73e23aee16148352"
    sha256 cellar: :any_skip_relocation, ventura:        "12c34d954743d1142b334cb64b7dd1746306a8a45316bca5b7545e5aa0b238a7"
    sha256 cellar: :any_skip_relocation, monterey:       "801d744fbaaea32dcb16e22c4ecd8f7241c5eb5714d27cf932408f5e1a9df3df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7c16ab19876a53eca1ac5f799ece766a44414dd1d1399a9280f72be1b83cc8f"
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