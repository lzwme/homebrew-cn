class Verapdf < Formula
  desc "Open-source industry-supported PDFA validation"
  homepage "https:verapdf.orghome"
  url "https:github.comveraPDFveraPDF-appsarchiverefstagsv1.26.4.tar.gz"
  sha256 "49521570d3f9e4c7a05ffa1dc3e6a4ea6e80106e12f52b3a036d57dae6266232"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https:github.comveraPDFveraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(^v?(\d+\.\d*[02468]\.\d+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9051a37603c5015a93936fe2a2dc9c4d544384c6f0ed78d46f494a6422fa0f78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a5c53172ee15fad9843e14f25e08b591dd4229c80c95bedc84d0e2d3a497549"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42936a1cc8eb773bcc546a41f8b2a7bde09f295b058488acc1ccca394ea7298b"
    sha256 cellar: :any_skip_relocation, sonoma:        "46ef89506038222ca5657a20e3f3c65a59080d4e81df24b0e9633107df9180c6"
    sha256 cellar: :any_skip_relocation, ventura:       "12209fdee769cf0197b5535c76a8b235a4f01da73505d1ab05d92a710c106a9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "813670751be9f037f1c081e118744a8389fc101394a4c9966025cb5c46f54f49"
  end

  depends_on "maven" => :build
  depends_on "openjdk@21"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@21"].opt_prefix
    system "mvn", "clean", "install", "-DskipTests"

    installer_file = Pathname.glob("installertargetverapdf-izpack-installer-*.jar").first
    system "java", "-DINSTALL_PATH=#{libexec}", "-jar", installer_file, "-options-system"

    bin.install libexec"verapdf", libexec"verapdf-gui"
    bin.env_script_all_files libexec, Language::Java.overridable_java_home_env("21")
    prefix.install "tests"
  end

  test do
    with_env(VERAPDF: bin"verapdf", NO_CD: "1") do
      system prefix"testsexit-status.sh"
    end
  end
end