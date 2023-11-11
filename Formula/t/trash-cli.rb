class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/1e/2b/267cd091c656738fd7fb2f60d86898698c5431c0565f87917f8eb6abb753/trash-cli-0.23.11.10.tar.gz"
  sha256 "606ca808cd2e285820874bb8b4287212485de6b01959e448f92ebad3eaa4cef8"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e21b161777b339cf84a4367c2646c47fddc0f7bb6bbc9667b780161fcf8bbc0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52a1d075aab4a6c72b6daf2ab0a0f275c15881fec4305fa79e034eca11e5c61f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19768510abac2823811d8550bb1d1f71fd47b1f2d419cf8589c7d57fc53b3a8d"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff8fd5e3f5bf5c357e94168e068588499ac3533f6c76eb2c2ad88c4e51eff15f"
    sha256 cellar: :any_skip_relocation, ventura:        "1fccd99d0325c45f9237adc6ee0edb8cd73a3d99de8c437017637d3b0b336545"
    sha256 cellar: :any_skip_relocation, monterey:       "d01412ff1ecd7219649f7e3b41aa5ced36d913f6536d258ae7b9b776f266acdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81018d03b91b3c19dff399bfc16634e45983ee04d2d29d0212c5096f7e482e3a"
  end

  depends_on "python-psutil"
  depends_on "python@3.12"
  depends_on "six"

  conflicts_with "macos-trash", because: "both install a `trash` binary"
  conflicts_with "trash", because: "both install a `trash` binary"

  def install
    virtualenv_install_with_resources
    man1.install_symlink libexec.glob("share/man/man1/trash*.1")
  end

  test do
    touch "testfile"
    assert_predicate testpath/"testfile", :exist?
    system bin/"trash-put", "testfile"
    refute_predicate testpath/"testfile", :exist?
  end
end