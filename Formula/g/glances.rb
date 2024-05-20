class Glances < Formula
  include Language::Python::Virtualenv

  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://files.pythonhosted.org/packages/92/7f/8129e9adf7e8c0e2d7eca497a7f0e3978282508ad7b3b6997abd8a4a6092/glances-4.0.5.tar.gz"
  sha256 "8ae6929be7b972c3292ce9587d3f342fc0fd7f7789506fa403fa50109491a547"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "262984ce9a2bb0bf160800a8df188ba227dd8ff774cf30dfc1336d77b4f6e096"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a74f9bd93b3d10bd84f00faba716618e6b437e1015de509471db052777d7e0c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0246f2ac798b1bc9a61145590898e2fec227ab00d012e73233d38260b104f75"
    sha256 cellar: :any_skip_relocation, sonoma:         "e8d46b60bafbe9b9a1a431cbe478251df5e7ab36981f226502be99018143fe26"
    sha256 cellar: :any_skip_relocation, ventura:        "30c5858435ed687fad095748724596eacf552771e754e359e83a28acade3959f"
    sha256 cellar: :any_skip_relocation, monterey:       "3c8177c5cd1f2cf6bbd4d62ffb2308ec845effecd36a5dd612d121f14a2714ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8230c6920d9a4331d7923ecd910a6d3e4dfdc3e9ce14d9486e4885493ed294ad"
  end

  depends_on "python@3.12"

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/90/c7/6dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2/psutil-5.9.8.tar.gz"
    sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
  end

  resource "ujson" do
    url "https://files.pythonhosted.org/packages/f0/00/3110fd566786bfa542adb7932d62035e0c0ef662a8ff6544b6643b3d6fd7/ujson-5.10.0.tar.gz"
    sha256 "b3cd8f3c5d8c7738257f1018880444f7b7d9b66232c64649f562d7ba86ad4bc1"
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