class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.204.tar.gz"
  sha256 "91311810e27ef5dc9cd83dfd6f04ac784da9cabf9ef8c5d1edcf8a1cf6dfc0ab"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a850ebe1dbd6950d2129026a2f675a9ac8f22e94f4d325d3a11fa8591270c17c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "749473eb5c836d7357e13215b666952cbabb84bcf0d0d78d7e0e00d89c4a53e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c62ad146c438e32eb117c06fbe66f5714fb902b706ac953d009a570ac8a8c284"
    sha256 cellar: :any_skip_relocation, ventura:        "1200c5440357a24f5257c2d1082263bbf7ff6f533547be2baa4d53f222176905"
    sha256 cellar: :any_skip_relocation, monterey:       "1aeb29498256a378c62b6733537c0db8e31c208b696dd57493516a446b492fb8"
    sha256 cellar: :any_skip_relocation, big_sur:        "acc44b56ac1c6c09462db3b640b060df71f44d09ea6ba633784382d2b5273665"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "767fdd4836f185e6737cf923d32e66b502fa74733ecf4b9d68dae0755cc0196a"
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