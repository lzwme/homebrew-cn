class Verapdf < Formula
  desc "Open-source industry-supported PDFA validation"
  homepage "https:verapdf.orghome"
  url "https:github.comveraPDFveraPDF-appsarchiverefstagsv1.25.244.tar.gz"
  sha256 "1f3dc61ea4ec21fc65eed774177179e0a6598de55e90867b140482a678333c48"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https:github.comveraPDFveraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c741023bff1b2fb59e49a8c1dc05938664c4019fa38368619df860949bda0c0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fcd46797438d330694e81edc511847b995cb587bb89ad28bd595b655d5345610"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "734e3b1da44cbbba3db0a0529a44fd9fefe5b63c20755d6942de0ffb7ec95147"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e4a56e886ce1fdc641c4d05a8c3eb35dd491e5fb56bd4cad9bfe1f5b14c66bb"
    sha256 cellar: :any_skip_relocation, ventura:        "634559946cdff8d69d1951b9fe00a781332f777193acdabc7f0b2d88e7481f0a"
    sha256 cellar: :any_skip_relocation, monterey:       "deae6ceb8ff6ee97a9336cc98f19c3c5a1bc21c78824026523bc791ac6eb9ee7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "485e6654b5bef0a6af844c6fc753caf5c99f81021bdc61ceaaab81095cacc08e"
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