class Showcert < Formula
  include Language::Python::Virtualenv

  desc "X.509 TLS certificate reader and creator"
  homepage "https://github.com/yaroslaff/showcert"
  url "https://files.pythonhosted.org/packages/e8/89/d8d4a604543eb56e302dac2cb1832c930fb57c7e5dcb56321220054e7a7e/showcert-0.4.6.tar.gz"
  sha256 "6b945324abfe79ef6f045e74b5b54c2bb9a1bba33f104fc18eb421f45c670f31"
  license "MIT"
  head "https://github.com/yaroslaff/showcert.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a5427c1639548cf0b47fdc72f3518ff1ca96d6834952f68906b3588f0f8e2d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a5427c1639548cf0b47fdc72f3518ff1ca96d6834952f68906b3588f0f8e2d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a5427c1639548cf0b47fdc72f3518ff1ca96d6834952f68906b3588f0f8e2d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b68cb62f39b4e29fb7a97e2d4ff56c81b5ef8381ffefa7c69eb3083db5984e32"
    sha256 cellar: :any_skip_relocation, ventura:       "b68cb62f39b4e29fb7a97e2d4ff56c81b5ef8381ffefa7c69eb3083db5984e32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2755c1946bd0f2940ddf204d8ccab3e57a4f01121fddbfbbec483bd6cedc9631"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2755c1946bd0f2940ddf204d8ccab3e57a4f01121fddbfbbec483bd6cedc9631"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libmagic"
  depends_on "python@3.13"

  resource "pem" do
    url "https://files.pythonhosted.org/packages/05/86/16c0b6789816f8d53f2f208b5a090c9197da8a6dae4d490554bb1bedbb09/pem-23.1.0.tar.gz"
    sha256 "06503ff2441a111f853ce4e8b9eb9d5fedb488ebdbf560115d3dd53a1b4afc73"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/04/8c/cd89ad05804f8e3c17dea8f178c3f40eeab5694c30e0c9f5bcd49f576fc3/pyopenssl-25.1.0.tar.gz"
    sha256 "8d031884482e0c67ee92bf9a4d8cceb08d92aba7136432ffb0703c5280fc205b"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/da/db/0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130/python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/showcert -h")

    assert_match "O=Let's Encrypt", shell_output("#{bin}/showcert brew.sh")

    assert_match version.to_s, shell_output("#{bin}/gencert -h")

    system bin/"gencert", "--ca", "Homebrew"
    assert_path_exists testpath/"Homebrew.key"
    assert_path_exists testpath/"Homebrew.pem"
  end
end