class Verapdf < Formula
  desc "Open-source industry-supported PDFA validation"
  homepage "https:verapdf.orghome"
  url "https:github.comveraPDFveraPDF-appsarchiverefstagsv1.25.205.tar.gz"
  sha256 "63b1daed23034b6ccc5af93b471d733c3e7c63d9d1ab1f1a07fefb09acdf9f65"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https:github.comveraPDFveraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c4cd38e4b5c8142ff97d69ed4e42c3e9a1724a49759ce8f591e36ba6bc94016"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34ab6882b043d826ae7f66335f9f53f0f959fd517b67b54a8f14787d06c3afef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee99f0f796423b65001df4003cc8c07dcabdc5ed967fd2c3d0c0e3c0ab67bd4f"
    sha256 cellar: :any_skip_relocation, sonoma:         "1fbe14537694538f2ab7f8a275292888cdd07eb1ef59ad05335d144d9851b1ad"
    sha256 cellar: :any_skip_relocation, ventura:        "40b94b80a57bf257c87edbe308ee5841a2105e218a65eeb3639ab205e8d54f4d"
    sha256 cellar: :any_skip_relocation, monterey:       "b92bf7c679a890749ac34d17e9daf89136eb36f23f3e3f7171189d8bcb36ff10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e835aa65d9ce75ccb1838a32cca03a8f6fb0ab6af15c536fedaafe708da21925"
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