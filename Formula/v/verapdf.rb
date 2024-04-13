class Verapdf < Formula
  desc "Open-source industry-supported PDFA validation"
  homepage "https:verapdf.orghome"
  url "https:github.comveraPDFveraPDF-appsarchiverefstagsv1.25.243.tar.gz"
  sha256 "ff26d8ba33e9874e8b946133da340b572cbe09484f5dd40b3932013fb05210c4"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https:github.comveraPDFveraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "046fff386acd0258d68dd8de746989c721ce0edb2eb75e80c795ab921b5214b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "527f6089ea515b1a9860156874dc53eb2b18e40a33afe5d0686876176282fe91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70f9efd5eddb0117937827a0d99b85d22980a692bb780cbdf2a260fc5b5c54b3"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c851530a3de74b40a9f8f0ca19b1ea656360810bf5983aa966ae413e5da1088"
    sha256 cellar: :any_skip_relocation, ventura:        "278e05397a139c8496ea0a22a74e2e3fb1934d4d0ba17127ea9984f715e8d47e"
    sha256 cellar: :any_skip_relocation, monterey:       "e444ae62b29ccaf15b3d6295b449c26efeaaeb3912de9622507bc6caa4603951"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d57b6d1c42b90554cfcb53a53ddae5db99c0aa436c211d037859cbeac0ba6aac"
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