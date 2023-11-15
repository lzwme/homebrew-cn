class Asitop < Formula
  include Language::Python::Virtualenv

  desc "Perf monitoring CLI tool for Apple Silicon"
  homepage "https://tlkh.github.io/asitop/"
  url "https://files.pythonhosted.org/packages/93/bc/8755d818efc33dd758322086a23f08bee5e1f7769c339a8be5c142adbbbc/asitop-0.0.24.tar.gz"
  sha256 "5df7b59304572a948f71cf94b87adc613869a8a87a933595b1b3e26bf42c3e37"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59ccc7576dbd652b5f0e830573f0e8051a2d068c5057eaaa0fbee7150c527aaf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1332975b0e14cfcaff9174d94af5166d33cacbfbe5f398253c45fa7cb7f5d03b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2c02496f76a70c1116e8cda3fce262427df4cd4c1c1288d047bda2d29627c10"
  end

  depends_on "python-setuptools" => :build
  depends_on arch: :arm64
  depends_on :macos
  depends_on "python-psutil"
  depends_on "python@3.12"
  depends_on "six"

  resource "blessed" do
    url "https://files.pythonhosted.org/packages/25/ae/92e9968ad23205389ec6bd82e2d4fca3817f1cdef34e10aa8d529ef8b1d7/blessed-1.20.0.tar.gz"
    sha256 "2cdd67f8746e048f00df47a2880f4d6acbcdb399031b604e34ba8f71d5787680"
  end

  resource "dashing" do
    url "https://files.pythonhosted.org/packages/bd/01/1c966934ab5ebe5a8fa3012c5de32bfa86916dba0428bdc6cdfe9489f768/dashing-0.1.0.tar.gz"
    sha256 "2514608e0f29a775dbd1b1111561219ce83d53cfa4baa2fe4101fab84fd56f1b"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/2e/1c/21f2379555bba50b54e5a965d9274602fe2bada4778343d5385840f7ac34/wcwidth-0.2.10.tar.gz"
    sha256 "390c7454101092a6a5e43baad8f83de615463af459201709556b6e4b1c861f97"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/asitop 2>&1", 1)
    # needs sudo permission to run
    assert_match "You are recommended to run ASITOP with `sudo asitop`", output
    assert_match "Performance monitoring CLI tool", shell_output("#{bin}/asitop --help")
  end
end