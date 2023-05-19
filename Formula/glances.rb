class Glances < Formula
  include Language::Python::Virtualenv

  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://files.pythonhosted.org/packages/fb/35/6d71d977fac90bd6644b487615824178b7f1783dbc1ef878a21075cd5379/Glances-3.4.0.2.tar.gz"
  sha256 "859f863bd9a961c5022c29f24898c02ec15a043034e664a9f8bc7dc1ca794e71"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2821aebd099b3a28e213763a95090d3e233c95c750bc9eb9d33fb6005a15860c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a81b5bda257aecc5db66cb36197a4be33adf2282bb05c59b552bcb7ccc2b1401"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd42e21eb77581db94a51d7376f4d8073e683ad92c04e47562fa1b4b78d1f44a"
    sha256 cellar: :any_skip_relocation, ventura:        "7553e5b7972fff4639b00036e38d1efeba75e0f0bbdf567c7e6d77c8630f2198"
    sha256 cellar: :any_skip_relocation, monterey:       "89fe26cc51d254b39b33b39d305afe1f1da9891df70dd43d00f8ad2c39433443"
    sha256 cellar: :any_skip_relocation, big_sur:        "fdba3928939ecfe5da08b0b86b354f9e2915f908bb2d49fdc0d1b4948c5857e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c9424b7fee2dbc1cf9e451feb1c470ee0dcb82e75c5f68fb39c318f6b007731"
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