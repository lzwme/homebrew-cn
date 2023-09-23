class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.53.tar.gz"
  sha256 "a9842a166d4521738c941f39cbddb35515efcaf8fe1a977192fa603f848c49a1"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6732ee32f993cd3c9ca623285f9ce38b70c6f1516d5bed5cf7d709090a0cc59"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "684b2be7d54b2de119bb18ec2a44da8638c3ca5ffbe79658aa57fa00ef966594"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2cebd502b56bcb6ebb8829410a36c1da3531c6f32b2c1db7e8286e771f8a49b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5f352711b75d2989259758b00652acece9cd19b7aeeb237af9d6df0f0b547ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "b402e117160ba8689e7b155160b834f18d68c549fe4c0e8f7c26f67418dd5c51"
    sha256 cellar: :any_skip_relocation, ventura:        "e1a6df1a66388ad661bb7dea6e89af982079f74b5ec9d0c2fd47e6d1ab4405b1"
    sha256 cellar: :any_skip_relocation, monterey:       "a785ea900e840ee08cbcd48da1c5234a51e684bc3c025b5c4cc79f8fec36e763"
    sha256 cellar: :any_skip_relocation, big_sur:        "4cfbfac8b210f077aff382019331abe0092bcde2369cd198a15416ed2fd67c98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b85c3dd76d37f0fc3fc79d587d04459fddb119f02686cb302b3bd5811e745350"
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