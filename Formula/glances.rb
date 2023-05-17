class Glances < Formula
  include Language::Python::Virtualenv

  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://files.pythonhosted.org/packages/16/36/184662deb0ced6de6995ef0b01984343d9784914a60ec08a3a988496c63e/Glances-3.4.0.tar.gz"
  sha256 "0b910f377d37961f862eb13964b2a93d6ecf6815b96016c8ab78fe3e4ac4fe53"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d5105af9872c242d71a2ce590da43b519d6035dca0c12a3ae3830d5317c897b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20195cfda0049b130f26788a95d3f36b6496b69071eb6c15da11c54a55a0b140"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "114b95f3d74fd594c1dec9a5a687f175cbb19620528d752504c62a6f5bfa321c"
    sha256 cellar: :any_skip_relocation, ventura:        "738aa4e60d61d551a0d434a91162105bda32c1cd3cf6d9baba2da66d45719a4d"
    sha256 cellar: :any_skip_relocation, monterey:       "42edf32145f968f608b88c7a14813eb307b66c45f152489f1a5c18d2b00b84f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec4bdd879b2f7440092c8ccb3f2413db9f9891b27a833f795798db62dd8b5087"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2a8f87c54d3493cb8cb8a29084f105a2e14a94d5d1429e1af65a8499c4137a2"
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