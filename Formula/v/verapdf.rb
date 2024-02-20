class Verapdf < Formula
  desc "Open-source industry-supported PDFA validation"
  homepage "https:verapdf.orghome"
  url "https:github.comveraPDFveraPDF-appsarchiverefstagsv1.25.200.tar.gz"
  sha256 "c210bbdacefc6a094b9132e0ad780279275ddc315218217a52b24ec8df2483c7"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https:github.comveraPDFveraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee7c7a0151ba2148d4d99029391be8b5b0aa0d6ab7820e0bec462446ab5841c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0bcaaa0b8a8a16d350e388d15b3d58f2b2ed85d0794220b2f30e5a49064515e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e73fea0d973db31d879d008a632ca5b19e88026c1926dc1e3b7a2131569d1a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "2436df05f5724789b141a10b47d5fcdaf7d6c492bb3d58e31ad681d74fcfaed9"
    sha256 cellar: :any_skip_relocation, ventura:        "58767485e329ae98edabf0f129892efd133f7768d97a122129be313f40923760"
    sha256 cellar: :any_skip_relocation, monterey:       "c21d3869bb5c5b98d425e77158dc04bc394bb071b5d14f9bc2b60ac769bf8b8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "238e743ee3d9f491f635d6510b43380d3984125f38d4bd85144ec4df01756700"
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