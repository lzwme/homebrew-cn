class GitCola < Formula
  include Language::Python::Virtualenv

  desc "Highly caffeinated git GUI"
  homepage "https:git-cola.github.io"
  url "https:files.pythonhosted.orgpackages48a3e1e2eade3fa89e1483eff8f47aac47e76379797152d2a4f26a3f73024435git_cola-4.10.0.tar.gz"
  sha256 "ee6b71d6cb7d3edf6b06124826b88a0a82276f6283e2463615b055d098192b07"
  license "GPL-2.0-or-later"
  head "https:github.comgit-colagit-cola.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f5b9621a23cceaaa044eb7c76b8e6d38f50408cddc22b491ca182aabe6d6463"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f5b9621a23cceaaa044eb7c76b8e6d38f50408cddc22b491ca182aabe6d6463"
    sha256 cellar: :any_skip_relocation, sonoma:        "31bbd61e706af1d931a67fd97327ff59a6c737358a724a99a34c73dda2d7ef40"
    sha256 cellar: :any_skip_relocation, ventura:       "31bbd61e706af1d931a67fd97327ff59a6c737358a724a99a34c73dda2d7ef40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f5b9621a23cceaaa044eb7c76b8e6d38f50408cddc22b491ca182aabe6d6463"
  end

  depends_on "pyqt"
  depends_on "python@3.12"

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