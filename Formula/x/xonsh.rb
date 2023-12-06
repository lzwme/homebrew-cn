class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh/"
  url "https://files.pythonhosted.org/packages/d0/6c/abfc08e1eddbb5a5e9d67ff98635fc928c498d88c1b1bf0e627601ad189f/xonsh-0.14.3.tar.gz"
  sha256 "a46d6613f8de7f5beba6c5b222ec3767404b678b4b707f52ab66a327ea9b3964"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8be451acdb62d38e6e1a31c211c60dbd8234a0dfc60746effba2135090a46337"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b568543eaaa9e8661486196663c67cccf9d86390ff113abe14dd557d71be729"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4fd8100a3fa0a13da7517f0b7656e149c040721786c67fe526b5181aa6bee2f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "08047ab2ee32821a18016da39fb82776c8a170df547fd1c71231b68733df6d87"
    sha256 cellar: :any_skip_relocation, ventura:        "6e4a09e423c0a183deb9611ee990e3d198cbea08221015ff60acf90a13b378b1"
    sha256 cellar: :any_skip_relocation, monterey:       "5b15ef4c475d25341643cf25285d8331d2869bcf323266ac732dfaeb274d9dc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "269e46ad6d9b9677f3af9702cb1c722870f8bed112aac1e10384fa4c60447c8e"
  end

  depends_on "pygments"
  depends_on "python@3.12"

  # Resources based on `pip3 install xonsh[ptk,pygments,proctitle]`
  # See https://xon.sh/osx.html#dependencies

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/d9/7b/7d88d94427e1e179e0a62818e68335cf969af5ca38033c0ca02237ab6ee7/prompt_toolkit-3.0.41.tar.gz"
    sha256 "941367d97fc815548822aa26c2a269fdc4eb21e9ec05fc5d447cf09bad5d75f0"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/a7/2c/4c64579f847bd5d539803c8b909e54ba087a79d01bb3aba433a95879a6c5/pyperclip-1.8.2.tar.gz"
    sha256 "105254a8b04934f0bc84e9c24eb360a591aaf6535c9def5f29d92af107a9bf57"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/ff/e1/b16b16a1aa12174349d15b73fd4b87e641a8ae3fb1163e80938dbbf6ae98/setproctitle-1.3.3.tar.gz"
    sha256 "c913e151e7ea01567837ff037a23ca8740192880198b7fbb90b16d181607caae"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/d7/12/63deef355537f290d5282a67bb7bdd165266e4eca93cd556707a325e5a24/wcwidth-0.2.12.tar.gz"
    sha256 "f01c104efdf57971bcb756f054dd58ddec5204dd15fa31d6503ea57947d97c02"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end