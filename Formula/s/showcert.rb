class Showcert < Formula
  include Language::Python::Virtualenv

  desc "X.509 TLS certificate reader and creator"
  homepage "https://github.com/yaroslaff/showcert"
  url "https://files.pythonhosted.org/packages/2f/38/b33b9b7312d26e92a87fcd61f08c5ddac6fe1e7fbd294c81e924f1ac75fd/showcert-0.4.11.tar.gz"
  sha256 "89b5feab4963d697935c36e9cc5b970d163b0e6042d7e20e017a348f6a5a5313"
  license "MIT"
  head "https://github.com/yaroslaff/showcert.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc702087fd5c74be784d0bdf6238d9021dd7770fc34a059d52ab8665e74e5e8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc702087fd5c74be784d0bdf6238d9021dd7770fc34a059d52ab8665e74e5e8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc702087fd5c74be784d0bdf6238d9021dd7770fc34a059d52ab8665e74e5e8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "35a138b7ba2486268394e2675833ec94944e70f3ba16323aee60f9ea50088c39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "914f2c841d3a4b7cfaf3d26645d3f4d6e91216a52322bacd490c00f151e9e5b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "914f2c841d3a4b7cfaf3d26645d3f4d6e91216a52322bacd490c00f151e9e5b4"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libmagic" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[certifi cryptography]

  resource "pem" do
    url "https://files.pythonhosted.org/packages/05/86/16c0b6789816f8d53f2f208b5a090c9197da8a6dae4d490554bb1bedbb09/pem-23.1.0.tar.gz"
    sha256 "06503ff2441a111f853ce4e8b9eb9d5fedb488ebdbf560115d3dd53a1b4afc73"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/80/be/97b83a464498a79103036bc74d1038df4a7ef0e402cfaf4d5e113fb14759/pyopenssl-25.3.0.tar.gz"
    sha256 "c981cb0a3fd84e8602d7afc209522773b94c1c2446a3c710a75b06fe1beae329"
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