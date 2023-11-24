class TrashCli < Formula
  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/1e/2b/267cd091c656738fd7fb2f60d86898698c5431c0565f87917f8eb6abb753/trash-cli-0.23.11.10.tar.gz"
  sha256 "606ca808cd2e285820874bb8b4287212485de6b01959e448f92ebad3eaa4cef8"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c74da1b996ca66afaf6c0576824d97148088a710c8233e83905bb480915d18b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24aba57f58ff2afd7522f0fd1c36106e0eca99c7de9218c3efd7c8d96b38bc6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a85abbc5876f21b2b1ca5a8760513c1f9b4e0ccfb3876d95febe2967cbbdfb7a"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b8319713f2fa13d0af076e59dfceda507e3a24ec61996ffcf0e730e039f4820"
    sha256 cellar: :any_skip_relocation, ventura:        "83a0d44e6e1a19f9f330a2ca2530ca65f6203c8e469f7aedd6d0e9bab7e768fc"
    sha256 cellar: :any_skip_relocation, monterey:       "8198c6a95b2d3f243ef6dd1d8c5a8d0fba481eebd822fe946c413acb37c23ff0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2d547aed5a0794b2785e3d0a539fa6d2ffdf0435acb1675b12964ec6056d3d3"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-psutil"
  depends_on "python@3.12"
  depends_on "six"

  conflicts_with "macos-trash", because: "both install a `trash` binary"
  conflicts_with "trash", because: "both install a `trash` binary"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    touch "testfile"
    assert_predicate testpath/"testfile", :exist?
    system bin/"trash-put", "testfile"
    refute_predicate testpath/"testfile", :exist?
  end
end