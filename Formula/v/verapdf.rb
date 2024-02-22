class Verapdf < Formula
  desc "Open-source industry-supported PDFA validation"
  homepage "https:verapdf.orghome"
  url "https:github.comveraPDFveraPDF-appsarchiverefstagsv1.25.209.tar.gz"
  sha256 "941e4948fd460ddbe8523e290bb437e5506f9b6db3f226d15c0181233873c31d"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https:github.comveraPDFveraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee7609a434771e59ca7261aaacfc653218e4496382935be85f46e01e24d5c7ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cdea9523317eb1fb60d226009c4abd9500809f455f0c7a869f1ef747e9c18a36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c30f97ef083b3a5957534b5ae899edb13e5096d7a0cdf5cc1d5edd794d2d0ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "c2d410d4059f4a2f4cae7a0a76ddd8073d3bdd0e5acd8f34b347a7e89602a8c5"
    sha256 cellar: :any_skip_relocation, ventura:        "06905c48d3953630fe0da9f8df866eaa49222a8ec1ba50bc9eb9568739bb1813"
    sha256 cellar: :any_skip_relocation, monterey:       "00e9ee9e4f5d2d8d2e2baa5d94370336b0c656329173d90ce393ff709b555c1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddeb2404376abaec11b9667d1d73b782b3cf66af3e8440d5e135e174eb6993fc"
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