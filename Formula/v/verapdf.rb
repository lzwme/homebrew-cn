class Verapdf < Formula
  desc "Open-source industry-supported PDFA validation"
  homepage "https:verapdf.orghome"
  url "https:github.comveraPDFveraPDF-appsarchiverefstagsv1.25.189.tar.gz"
  sha256 "633913d18c3e1c191fd29ab048b2b29a42b29dad0cff716b0525b69b4290442b"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https:github.comveraPDFveraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "76338783d6bc9369c0e4837e063527e10c0d4b39f3dedc97bea67ebfac0b3931"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1f1e33b854ba3e3666a766b350e5689f05eba5b248b7e305bedf61fd4c29590"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23c846eed3e89cfad50d23a37e13fe41eafe37d170e99b7ec61ce036e819ba24"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e0dbe0d0b46d70af0db699e85a0dee4bab05b8dc3f9a07cad342f285241eba1"
    sha256 cellar: :any_skip_relocation, ventura:        "698d28ec91ba7b70973687f29b435498eb704aa04efa24cafab8afe46feae9bc"
    sha256 cellar: :any_skip_relocation, monterey:       "62ef519f72458acce1c9edd1080ef868c2456f2cec8a8ed74dddf9681cf4e308"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "778dc6165d1d9ba778baa8a607b7a150a3326b3eb8fcf9944bfa1703a21dec42"
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