class Verapdf < Formula
  desc "Open-source industry-supported PDFA validation"
  homepage "https:verapdf.orghome"
  url "https:github.comveraPDFveraPDF-appsarchiverefstagsv1.25.153.tar.gz"
  sha256 "c48d6d21b62393da8dc7b1b1dce5a772adcdea2f50d4050fc849d026cae7fb10"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https:github.comveraPDFveraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "70cd311e00b25a37b5c00d2196c7712484dd29be20f48f2e5bbf64d23e5a3192"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac75d35625c79120e43dc0f2cf9e6d190739ae7ceab44c920ddfc1cc769db477"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2592f2fb744fac6d53ae1be34b15fde99b9c4b5dceb0e5be64e4bdae2d10c7cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "76fb8196faa37a7e84dfde25551807f2036529aab2f5b22c2bd191232ee6ac4b"
    sha256 cellar: :any_skip_relocation, ventura:        "34de33d8f740538896d376ce4c86312dd192074c4b936dbb3b8483da4174bdff"
    sha256 cellar: :any_skip_relocation, monterey:       "307b3738f1d8f498b2b7d1649aa3e796e9ffd5c0e4d741eb00250c5c749d9456"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c56d7fe4ae9f80d7fc500bfbe7a2827d37ccfbab7be2bf32ab6519e4e4d3616"
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