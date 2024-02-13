class Verapdf < Formula
  desc "Open-source industry-supported PDFA validation"
  homepage "https:verapdf.orghome"
  url "https:github.comveraPDFveraPDF-appsarchiverefstagsv1.25.193.tar.gz"
  sha256 "f9ca198450654bb3cff038a15afec5e3517c5f2682215ab879a6663b9644aa19"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https:github.comveraPDFveraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "35e5d81fc62f46756749b620f475fadaa3ec690ac6103c8a0bbbf320bda5a989"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad3fc8841c7a0e4e641a014157137469650daedb9346385e097dc1e4a72a82dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e2161ab862281bb0f3d2c1e0e2ed06cbf9db180f809b81a785d1ab346c9ef98"
    sha256 cellar: :any_skip_relocation, sonoma:         "f72bbff8a09b5e3725f5987ce555b8cd913dc6f2f635de07f62c8957aaf790e2"
    sha256 cellar: :any_skip_relocation, ventura:        "3a0e291671ca358da4770fe0e30e8f777fe6d15f93d2085218d26b0167f41a5b"
    sha256 cellar: :any_skip_relocation, monterey:       "30c69d90eaaf22fa025cb5eca7f10424b8cd582cc2a26d1ef078f3d3688de020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd3acc697c289e048c756c758fa7271f6fbbe12fcd911c301c819c0c67b789d5"
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