class GitCola < Formula
  include Language::Python::Virtualenv

  desc "Highly caffeinated git GUI"
  homepage "https:git-cola.github.io"
  url "https:files.pythonhosted.orgpackages7decb620520f3f94c8a6ed704062321641e04af6b3c627764e358c391bdf4165git_cola-4.10.1.tar.gz"
  sha256 "c3c7e63099d60347528fbbc6f565aef02d62ebf1df8c372666faec9bf8aa19eb"
  license "GPL-2.0-or-later"
  revision 1
  head "https:github.comgit-colagit-cola.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41fdb0ff9d944644af17df1b3362a6710c813640d8bd455a725cd1e21eab7824"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "41fdb0ff9d944644af17df1b3362a6710c813640d8bd455a725cd1e21eab7824"
    sha256 cellar: :any_skip_relocation, sonoma:        "9924a781606241fe258463d4dc2d2a73e33f474ca01b91807636668833e96ab4"
    sha256 cellar: :any_skip_relocation, ventura:       "9924a781606241fe258463d4dc2d2a73e33f474ca01b91807636668833e96ab4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41fdb0ff9d944644af17df1b3362a6710c813640d8bd455a725cd1e21eab7824"
  end

  depends_on "pyqt"
  depends_on "python@3.13"

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesd06368dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106dapackaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "polib" do
    url "https:files.pythonhosted.orgpackages109a79b1067d27e38ddf84fe7da6ec516f1743f31f752c6122193e7bce38bdbfpolib-1.2.0.tar.gz"
    sha256 "f3ef94aefed6e183e342a8a269ae1fc4742ba193186ad76f175938621dbfc26b"
  end

  resource "qtpy" do
    url "https:files.pythonhosted.orgpackagese51051e0e50dd1e4a160c54ac0717b8ff11b2063d441e721c2037f61931cf38dqtpy-2.4.2.tar.gz"
    sha256 "9d6ec91a587cc1495eaebd23130f7619afa5cdd34a277acb87735b4ad7c65156"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin"git-cola", "--version"
  end
end