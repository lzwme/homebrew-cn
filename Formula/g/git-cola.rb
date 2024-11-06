class GitCola < Formula
  include Language::Python::Virtualenv

  desc "Highly caffeinated git GUI"
  homepage "https:git-cola.github.io"
  url "https:files.pythonhosted.orgpackages8a3421782e9cdd0dd67f2dc5f3e974322072f146cc343dc16e09abef8ab63d6egit_cola-4.9.0.tar.gz"
  sha256 "c237a3d7586973e4adbd3fcf3469a3c301fe052b450f908b487de334d1b566d4"
  license "GPL-2.0-or-later"
  head "https:github.comgit-colagit-cola.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b4d85853829eede5d5a40cc00437536ce5ff37d95497ab96602013d9c0afd26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b4d85853829eede5d5a40cc00437536ce5ff37d95497ab96602013d9c0afd26"
    sha256 cellar: :any_skip_relocation, sonoma:        "471528f3e2c239cd669887fe4822b72e5e40df1077dd935c972d18e4dfd2e8c8"
    sha256 cellar: :any_skip_relocation, ventura:       "471528f3e2c239cd669887fe4822b72e5e40df1077dd935c972d18e4dfd2e8c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b4d85853829eede5d5a40cc00437536ce5ff37d95497ab96602013d9c0afd26"
  end

  depends_on "pyqt"
  depends_on "python@3.12"

  resource "packaging" do
    url "https:files.pythonhosted.orgpackages516550db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
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