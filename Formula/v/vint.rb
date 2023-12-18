class Vint < Formula
  include Language::Python::Virtualenv

  desc "Vim script Language Lint"
  homepage "https:github.comVimjasvint"
  url "https:files.pythonhosted.orgpackages9cc7d5fbe5f778edee83cba3aea8cc3308db327e4c161e0656e861b9cc2cb859vim-vint-0.3.21.tar.gz"
  sha256 "5dc59b2e5c2a746c88f5f51f3fafea3d639c6b0fdbb116bb74af27bf1c820d97"
  license "MIT"
  revision 2
  head "https:github.comVimjasvint.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1319077794aae2570266011f32f314e0bce928260c3483fc3e8028cfd5b0cf67"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da095f3c3d7bf27d006250c11af9146b99e2be722b042c85b86cd233ac5ded12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d3589692befc631c2ea8d474df1df078748a5993c9a5ff21d8800d00f34ad49"
    sha256 cellar: :any_skip_relocation, sonoma:         "d41e154871646df72a558e72d6e9d0d385e3a304faee61e275f843d22c35c243"
    sha256 cellar: :any_skip_relocation, ventura:        "748682bc4aa982f38f04302e83a1e9e17ecd640dceb5ab8f4cb59d5b21f37902"
    sha256 cellar: :any_skip_relocation, monterey:       "5128d9f27ec3a1c69f3b0bfc0d09e41c7e755824066da0e2b88d98969dadfc02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c0c1dc2caf33492d3808738a46aa2fe536b0b8b712f17e5b7e8749bff2de117"
  end

  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "pyyaml"

  resource "ansicolor" do
    url "https:files.pythonhosted.orgpackages7974630817c7eb1289a1412fcc4faeca74a69760d9c9b0db94fc09c91978a6acansicolor-0.3.2.tar.gz"
    sha256 "3b840a6b1184b5f1568635b1adab28147947522707d41ceba02d5ed0a0877279"
  end

  resource "chardet" do
    url "https:files.pythonhosted.orgpackages31a212c090713b3d0e141f367236d3a8bdc3e5fca0d83ff3647af4892c16c205chardet-5.0.0.tar.gz"
    sha256 "0368df2bfd78b5fc20572bb4e9bb7fb53e2c094f60ae9993339e8671d0afb8aa"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin"vint", "--help"
    (testpath"bad.vim").write <<~EOS
      not vimscript
    EOS
    assert_match "E492", shell_output("#{bin}vint bad.vim", 1)

    (testpath"good.vim").write <<~EOS
      " minimal vimrc
      syntax on
      set backspace=indent,eol,start
      filetype plugin indent on
    EOS
    assert_equal "", shell_output("#{bin}vint good.vim")
  end
end