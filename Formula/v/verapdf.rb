class Verapdf < Formula
  desc "Open-source industry-supported PDFA validation"
  homepage "https:verapdf.orghome"
  url "https:github.comveraPDFveraPDF-appsarchiverefstagsv1.25.192.tar.gz"
  sha256 "d482ffeed9dc3169c4c49d29c78e6d141f9afd676869393430174aad441b9577"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https:github.comveraPDFveraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d982aeddff651c2f14685095a6b9477c39a95c78eec46cf2829aaeb6f526e87"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd38748d8de45c070249a0248ce319b7436a34d6fd35e2e1afdb12c65b3d0d94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a844a62fe4e07cc9401e7744a72488d0a47639e5cc65ce809a0f502a311045f"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f6892515bdb8d5b16efbb2e9ab79a59e5890e9e43b56beb3232efa505971e8d"
    sha256 cellar: :any_skip_relocation, ventura:        "61a117c2eebe32b2490004e92bb22af908eb5689c96871fae5c598af1e9e8edb"
    sha256 cellar: :any_skip_relocation, monterey:       "4f35b4375ccf56a8dc7537a143420624bf3ec05b8be0bc8a851e27940ff6e1cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88a78a41e5bd7f37a83501585b428ea66aa21e803dfbae7405a22d184c78aeef"
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