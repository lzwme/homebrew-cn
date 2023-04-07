class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.158.tar.gz"
  sha256 "cd5dbc93bce3e634a48b01d962dc52cc0ea4971f142ec29905288a558368f39a"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc92e5f8ca60b9760e44ec9ff89122ede23267093c59dccb413d4e50a9fb935c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63c19385bcee08466498655f703a9a2171e3f7bdc94508e24d433fc6945d1899"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "edd73aa9c6576c1950d7740cd4124de9501cea074b7966ffa84f500760c55b25"
    sha256 cellar: :any_skip_relocation, ventura:        "d98bb872d68e5780a57328c7201f0b6eb60f8ee7964394ac04bc0257aedef481"
    sha256 cellar: :any_skip_relocation, monterey:       "635216924743e704902e0fa1af5f7cf55ecae7f7b5cce712b8d38837d3993312"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9467e93c95eb1b03cf24c0ac48cec34d7d4ecf5f593646196348f3b5e708078"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df1f718f13f39e41ceb10b42a52ca457e7bbec707ba180e9ebb2768a505d9f01"
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