class Apkleaks < Formula
  include Language::Python::Virtualenv

  desc "Scanning APK file for URIs, endpoints & secrets"
  homepage "https://github.com/dwisiswant0/apkleaks"
  url "https://files.pythonhosted.org/packages/8e/7f/95822c947138c8fc127d88128fb8fa9b0ed37a7fddf0b840685075ee288e/apkleaks-2.6.1.tar.gz"
  sha256 "47eea4683a9916e4099d05776be2ec3892791f5fd854f49cb5ed489cc9867c62"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c43bdd892cd83f9c27958b30655f419d2b8af1f9fcaf4ce529471b19e5f0980"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df4aee641334907e439140a7640c8aee046bc4f15a23d206625d2afa0dba954f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efb05e2117c82deddabaa566c4b05cfd0fd6fda68b7b62109737524cf6664a7d"
    sha256 cellar: :any_skip_relocation, sonoma:         "a8153cb2b92fbfafe4c332a0bdebd102aac565f481d0c24816b68b39d9a95bf7"
    sha256 cellar: :any_skip_relocation, ventura:        "4db43c5527230b6b7602b4e488ac99a42d1785fbe0e06e7818445e651e2232b8"
    sha256 cellar: :any_skip_relocation, monterey:       "3ea73b3e545b925eff2a45766a5d3fae48905ecf0418aa456a7ec3a2ad25442c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e452964c171dd29cdb50651872aef32cf2981a110149b34b795022991c98fa4"
  end

  depends_on "jadx"
  depends_on "python-click"
  depends_on "python-lxml"
  depends_on "python-setuptools"
  depends_on "python@3.12"

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/de/cf/d547feed25b5244fcb9392e288ff9fdc3280b10260362fc45d37a798a6ee/asn1crypto-1.5.1.tar.gz"
    sha256 "13ae38502be632115abf8a24cbe5f4da52e3b5231990aff31123c805306ccb9c"
  end

  resource "pyaxmlparser" do
    url "https://files.pythonhosted.org/packages/58/7f/327c19329f535c332451b5f1f906bff5f952fe3070d00376b75e67052f35/pyaxmlparser-0.3.28.tar.gz"
    sha256 "c482826380fd84ce1a6386183861f2a6728017241a230c13d521e3e7737e803e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    resource "homebrew-test.apk" do
      url "https://ghproxy.com/https://raw.githubusercontent.com/facebook/redex/fa32d542d4074dbd485584413d69ea0c9c3cbc98/test/instr/redex-test.apk"
      sha256 "7851cf2a15230ea6ff076639c2273bc4ca4c3d81917d2e13c05edcc4d537cc04"
    end

    testpath.install resource("homebrew-test.apk")
    output = shell_output("#{bin}/apkleaks -f #{testpath}/redex-test.apk")
    assert_match "Decompiling APK...", output
    assert_match "Scanning against 'com.facebook.redex.test.instr'", output

    assert_match version.to_s, shell_output("#{bin}/apkleaks -h 2>&1")
  end
end