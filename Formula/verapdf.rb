class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.230.tar.gz"
  sha256 "e3ebd03fa57c65feb2125f5aae34194f3c47357ad9d56c5cbc958caa79013363"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59eaa234626faf6ed6592610c14955fc34ef34f501b1144798d74677e2e29b73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "204294e15081bab444a40b8e369ef67f0dbbfeef534d9fc2607836cad2653c29"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf995c8dc761f970de47196d3326bb71d5df3825a168de4152b81ad1ee8cb8be"
    sha256 cellar: :any_skip_relocation, ventura:        "88f51e9d3d1af39f2533fc8131df20b99774958084951dcf5ff6dc0878afcd0a"
    sha256 cellar: :any_skip_relocation, monterey:       "67cf1a2e3e0981a38dc85f2948b934969ca5d8520f5bedd812d9fdf2ec3d5217"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c52bede7d2d17625286229f911b148c3c77004c5d8efa5e312f2415ddfd9492"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea00d7d87a82388a552d280eaa22c5fdef1aa75c97b696100a2caa2667f8e0b7"
  end

  depends_on "maven" => :build
  depends_on "openjdk@17"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("17")
    system "mvn", "clean", "install"

    installer_file = Pathname.glob("installer/target/verapdf-izpack-installer-*.jar").first
    system "java", "-DINSTALL_PATH=#{libexec}", "-jar", installer_file, "-options-system"

    bin.install libexec/"verapdf", libexec/"verapdf-gui"
    bin.env_script_all_files libexec, Language::Java.overridable_java_home_env("17")
    prefix.install "tests"
  end

  test do
    with_env(VERAPDF: "#{bin}/verapdf", NO_CD: "1") do
      system prefix/"tests/exit-status.sh"
    end
  end
end