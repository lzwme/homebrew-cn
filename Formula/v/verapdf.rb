class Verapdf < Formula
  desc "Open-source industry-supported PDFA validation"
  homepage "https:verapdf.orghome"
  url "https:github.comveraPDFveraPDF-appsarchiverefstagsv1.25.234.tar.gz"
  sha256 "ebaadda7270c9916b37ffa26b3455b801443ae3f31176b02b9a31db250117c62"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https:github.comveraPDFveraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "43adb2e0bebab58c867b82bf2a51ac7a1f3e8bd4e1160d711852f3111df633ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2d98dddf7edafee6813ac802717e073b59fb846c61aba215fedd2e3932883af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "199819871bfc8557e2681d46bf98c52a216df1a1ebe3c1041ccc78dbbddfb8f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "f8497924249e9af75e745af86eb0946851840f7e95c4340713b178a4a2b34dbc"
    sha256 cellar: :any_skip_relocation, ventura:        "30873d7c49bc6ed5658833b181baea80b4c2650a9ab6a606a36ec0f4ebb198bb"
    sha256 cellar: :any_skip_relocation, monterey:       "aa7149a1be86ea9af1cc290b39376247e1ace3a614f57de6bbd75c88f2968f40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f892a1374a790312174a89a5c22648aae18f55ed9318bd5cd17a910de3a0763c"
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