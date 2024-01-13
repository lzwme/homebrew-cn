class Verapdf < Formula
  desc "Open-source industry-supported PDFA validation"
  homepage "https:verapdf.orghome"
  url "https:github.comveraPDFveraPDF-appsarchiverefstagsv1.25.169.tar.gz"
  sha256 "156f55a1b6b206f8d430915ea276e0d62ab5c2af62e1086f3107c0baed8d58bf"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https:github.comveraPDFveraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d816f5dca7e04a7e773fbf6356ea88f5ae2966d18e4c14f29ef59086dff16878"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75b09ef03d41736de75b79784149ae11068556c14337821141619155657bbb49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ed38d5b84d35fd2a6fbb17d82842396bc91fd5a9704fa2b8e9ed0ff3e444db1"
    sha256 cellar: :any_skip_relocation, sonoma:         "973d1d7b7fb237c28d5de9e4a991efb6eeee520cc498b6f9234a6b687cc4f815"
    sha256 cellar: :any_skip_relocation, ventura:        "506584c6789de5d7aa312f3472badf797b3958bcffc98802f2a1fd391fef3ce0"
    sha256 cellar: :any_skip_relocation, monterey:       "d610c5684913e09fcadf13d1083bbf33d21313e8f5beb39e4494e082d286aeba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67d1e60da6d00999b4659bcd9c2d14001c4abd04ea233a9678532be985be07aa"
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