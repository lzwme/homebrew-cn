class Verapdf < Formula
  desc "Open-source industry-supported PDFA validation"
  homepage "https:verapdf.orghome"
  url "https:github.comveraPDFveraPDF-appsarchiverefstagsv1.25.155.tar.gz"
  sha256 "c75b4997125b468c175ee2527f3e552c65cdc6be51377475b000e1b7cc4f599e"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https:github.comveraPDFveraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5867235f5188b194e3edc8ed4aa248f088e4b1f7bf821cebd3ed609d9207c851"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78e1a33d04b76685db816f94be791fc26c1e6575d7668cee40f06eee61bdbf04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cabf585424aeabe57a15dbba036a26759b2a648c69e357da008999de0b297bc5"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ae1d2ec9e13b96072565755949752a244fd7e873f4c5669407c0196ff123e87"
    sha256 cellar: :any_skip_relocation, ventura:        "82dbcc7c1845e50b830c1326ad116bd5073555bf118195726d90f1f2434b8408"
    sha256 cellar: :any_skip_relocation, monterey:       "da0dff32fe8119b0ba8cbb6291eaed722baf856e932f6e45cd8d56b75193f31d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb95a3fb8d589f58a5cdb48196789e3a78d42252a642a7d5e3e7e837f1711674"
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