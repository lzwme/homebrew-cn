class Verapdf < Formula
  desc "Open-source industry-supported PDFA validation"
  homepage "https:verapdf.orghome"
  url "https:github.comveraPDFveraPDF-appsarchiverefstagsv1.25.157.tar.gz"
  sha256 "53da40bf942e2707e63799f3b2e0e514e186aef1b14c2640520d3ec9a3d276c0"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https:github.comveraPDFveraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d561c83cd2e3a63a7023a1c01d1cf7ed31e1b330ff805ca932b5ba66a24a539a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6c706526ca1cab601a0656eee71adfb5dcb7d2ea15645c94c3efa6f0278cd9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15614acd486c2d647e03d450e797de59214c81d11d3ed94b58a53babdc1d3678"
    sha256 cellar: :any_skip_relocation, sonoma:         "26ff6bc9a263b5dfacab0c63dda67497bea0bde3ceda7a38c2a7c245b1d08d37"
    sha256 cellar: :any_skip_relocation, ventura:        "e6621480a19bd5829a696caedcaa5fbad3e8f408ed8765ef34c9fcd1bf51a35d"
    sha256 cellar: :any_skip_relocation, monterey:       "cd6262e32fc4c79d32056b4738c6828bed7f0789e8099b487f04bba8e35afd46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e826d507d4a8e5db4b1a085bd17633c07187daafb0a22a27a870fe59ca847f9b"
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