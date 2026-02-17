class Showcert < Formula
  include Language::Python::Virtualenv

  desc "X.509 TLS certificate reader and creator"
  homepage "https://github.com/yaroslaff/showcert"
  url "https://files.pythonhosted.org/packages/ba/18/897ef38eb950e333cfbc7bace15a2c11c28535b1ec68de65a29fbed21aa9/showcert-0.4.14.tar.gz"
  sha256 "7310f3fda1f617e224ee358ce00108ece1ce6009f07d988256f6cbc603578d70"
  license "MIT"
  head "https://github.com/yaroslaff/showcert.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59f6a609cdebb7d92fdb6e2a1900a11bb296687f4f1fef2bb3f5b41ed4ac2229"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59f6a609cdebb7d92fdb6e2a1900a11bb296687f4f1fef2bb3f5b41ed4ac2229"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59f6a609cdebb7d92fdb6e2a1900a11bb296687f4f1fef2bb3f5b41ed4ac2229"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d6892c7b6ea61b97aa90635a83fee77f25457c75f9ad67a12a2069c829fec0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40daa592664e11f7d6bf1fcd5f43ff0d57ae3df424b2c9a04a92bc8432c9e0a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40daa592664e11f7d6bf1fcd5f43ff0d57ae3df424b2c9a04a92bc8432c9e0a5"
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