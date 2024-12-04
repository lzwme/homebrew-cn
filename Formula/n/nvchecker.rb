class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https:github.comlilydjwgnvchecker"
  url "https:files.pythonhosted.orgpackages7b60fd880c869c6a03768fcfe44168d7667f036e2499c8816dd106440e201332nvchecker-2.15.1.tar.gz"
  sha256 "a2e2b0a8dd4545e83e0032e8d4a4d586c08e2d8378a61b637b45fdd4556f1167"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8ebf0ff1522e165f0ad02a3587f167b1693989c250466a1f8e5bd2f44fd4fa41"
    sha256 cellar: :any,                 arm64_sonoma:  "f28f5e85b361d4dc087c63bbcee868d7813b8a965dbf055c3591388c31395ef9"
    sha256 cellar: :any,                 arm64_ventura: "b21d37a8ab12c299c66e533ab6db67d618f0d6aaee4eea13963befdf3797c76e"
    sha256 cellar: :any,                 sonoma:        "a2141a9d4c0c780150198a4805f3b57f19af6b9fd194ea7920f866ac562369ac"
    sha256 cellar: :any,                 ventura:       "5ba8acc0639bd4c7a2987956ade345021c9f43727d7250f606419fb64c362c97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de8942f1972ca5570cc933da5c40096943902ca956f2ad8ee198d2f564487271"
  end

  depends_on "jq" => :test
  depends_on "curl"
  depends_on "openssl@3"
  depends_on "python@3.13"

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesd06368dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106dapackaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages13fc128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "pycurl" do
    url "https:files.pythonhosted.orgpackagesc95ae68b8abbc1102113b7839e708ba04ef4c4b8b8a6da392832bb166d09ea72pycurl-7.45.3.tar.gz"
    sha256 "8c2471af9079ad798e1645ec0b0d3d4223db687379d17dd36a70637449f81d6b"
  end

  resource "structlog" do
    url "https:files.pythonhosted.orgpackages78a3e811a94ac3853826805253c906faa99219b79951c7d58605e89c79e65768structlog-24.4.0.tar.gz"
    sha256 "b27bfecede327a6d2da5fbc96bd859f114ecc398a6389d664f62085ee7ae6fc4"
  end

  resource "tornado" do
    url "https:files.pythonhosted.orgpackages5945a0daf161f7d6f36c3ea5fc0c2de619746cc3dd4c76402e9db545bd920f63tornado-6.4.2.tar.gz"
    sha256 "92bad5b4746e9879fd7bf1eb21dce4e3fc5128d71601f80005afa39237ad620b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    file = testpath"example.toml"
    file.write <<~TOML
      [nvchecker]
      source = "pypi"
      pypi = "nvchecker"
    TOML

    out = shell_output("#{bin}nvchecker -c #{file} --logger=json | jq '.[\"version\"]' ").strip
    assert_equal "\"#{version}\"", out
  end
end