class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.72.tar.gz"
  sha256 "f9d350dbf5a8c58584181404b9a752ef0ea4a598cfa094262f47f1e4ba9b0078"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f15d1b97b9f101ed364d94e7654393c4fb91bb3e421d87a0b17159a14b47af2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bea4d9b40ad565916b2a5feac1ea8b8e7930776674a75141fb5ea4403d6f6006"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "927c24acfcd690932565536d6dcbcf423b6e87958183ccb944be037ba617a40e"
    sha256 cellar: :any_skip_relocation, sonoma:         "c7e668f935444f99073f17f7ef133f511019364a85706d52cd60ee6a6cd1a9b7"
    sha256 cellar: :any_skip_relocation, ventura:        "60e6d3de7d2af83f455fa448fc122d6099c7a6e63853e0199b9a6ce21993884d"
    sha256 cellar: :any_skip_relocation, monterey:       "28eedfb5b2c0f132a9179b3f7e8575cefd348cd4debfc5e9691c5450a186fe63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a7fa2582880541f45a5c09640ec0cdae4696644571a2de0fc687810be7a8702"
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