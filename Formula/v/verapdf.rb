class Verapdf < Formula
  desc "Open-source industry-supported PDFA validation"
  homepage "https:verapdf.orghome"
  url "https:github.comveraPDFveraPDF-appsarchiverefstagsv1.25.167.tar.gz"
  sha256 "5da327d1e371d1a1143b60403975e735d8b35a07438d34dd8188888c4411827b"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https:github.comveraPDFveraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66f56ac33a48f6592393385eb3d4b74388af9bf7b24b187c9de55f0b5b4dc1a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c602c3af8a377ffc0aa6581f3f5cd957607681ce3dd7497d8a080146d9c65f51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0935329c30338151d32effd11fbf27ca29bc3580e4ca04267e185c24a42bc20e"
    sha256 cellar: :any_skip_relocation, sonoma:         "bfa103111e44d182904e8d6e59883dfcc2cbe82d6ca8f6e14ddd4f0ce0bb23c2"
    sha256 cellar: :any_skip_relocation, ventura:        "822f81bec778e4a19b57aebf1f77bdfd2bbd36327eb034d6ee05ca262c80f09b"
    sha256 cellar: :any_skip_relocation, monterey:       "961db1f30f17a86ef542beaf94eae4fb41aef5b2a3076364b7f91f8665dfa46e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ec78cf54dead42eb22c7da874025ad0ad203f27af3be3fbcf056b9776d15898"
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