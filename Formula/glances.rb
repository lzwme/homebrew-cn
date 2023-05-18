class Glances < Formula
  include Language::Python::Virtualenv

  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://files.pythonhosted.org/packages/04/66/4a5cb00757451161fcb631518ffb5399be69d9ded687632106bbb1b1ac76/Glances-3.4.0.1.tar.gz"
  sha256 "d26fc6dee731e92a8c762726a9cbf37cb76dd8b827afdb91331931e50f3de173"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1414db47ad1e3296a184a44fc397146d25ea20782bceb29a117a5ff06828ede"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9864445dff359661aaa5a20f7403a8d7f810468fb1900c4f686f05a63ac8189a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7f58c0f1ec3f7830602796030cedefb828716c0ff177956bde5bb2e68af956f"
    sha256 cellar: :any_skip_relocation, ventura:        "27cc8e52d4a4606d1f989d46d55c6f2c6bb2234281c4abafd606ab43df8b2b28"
    sha256 cellar: :any_skip_relocation, monterey:       "7d2b430058a291a4950a8df18085e722517cce858f9bafde963342ac3178cc16"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f1a6d9e88451aba45a8389366e86581bed4d11732384e38116fd761fb471da9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9307197e62726dca976b9d1a4901967cbf9fc4571b193af9110b34af195f771"
  end

  depends_on "python@3.11"

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/d6/0f/96b7309212a926c1448366e9ce69b081ea79d63265bde33f11cc9cfc2c07/psutil-5.9.5.tar.gz"
    sha256 "5410638e4df39c54d957fc51ce03048acd8e6d60abc0f5107af51e5fb566eb3c"
  end

  resource "ujson" do
    url "https://files.pythonhosted.org/packages/43/1a/b0a027144aa5c8f4ea654f4afdd634578b450807bb70b9f8bad00d6f6d3c/ujson-5.7.0.tar.gz"
    sha256 "e788e5d5dcae8f6118ac9b45d0b891a0d55f7ac480eddcb7f07263f2bcf37b23"
  end

  def install
    virtualenv_install_with_resources
    prefix.install libexec/"share"
  end

  test do
    read, write = IO.pipe
    pid = fork do
      exec bin/"glances", "-q", "--export", "csv", "--export-csv-file", "/dev/stdout", out: write
    end
    header = read.gets
    assert_match "timestamp", header
  ensure
    Process.kill("TERM", pid)
  end
end