class GitCola < Formula
  include Language::Python::Virtualenv

  desc "Highly caffeinated git GUI"
  homepage "https:git-cola.github.io"
  url "https:files.pythonhosted.orgpackages211324757dd737e347c4a528ee467568ad32b7afbca704e6e55945d2f7b9ddd6git-cola-4.6.1.tar.gz"
  sha256 "b9dd4b7026a21c79918a4f6b07c19ac11717379f43f218f65d928e89a906cbf4"
  license "GPL-2.0-or-later"
  head "https:github.comgit-colagit-cola.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a06d8758a0051d98d10a7c3cfd26f162a0530a92ea19d5eb7da8f376ca8097f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08616ba14ecb3d20487f3b13803555c506d720c0027b561dc4beb0f283df2048"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "472c4e61a9b2a51b54c6b2f81f724d8467558e86e985dfcf524132656f11f60c"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ac92b479884c285d65f22904f358ef2311f0e61fe3046be5f5280545b71de5d"
    sha256 cellar: :any_skip_relocation, ventura:        "71114eb7bb8d6ad2399e004a481e9ddda961e90b6ce5baea353ce2be79c1c81e"
    sha256 cellar: :any_skip_relocation, monterey:       "05817ed297c9c77c7ff0635fcb84af370b04d40f186793a3e3f18137d48a6315"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0ce21a6058923e7b47b82f24f96441437f4309fb5ce34469ae55232dc833ab7"
  end

  depends_on "pyqt"
  depends_on "python@3.12"

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesfb2b9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7bpackaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "polib" do
    url "https:files.pythonhosted.orgpackages109a79b1067d27e38ddf84fe7da6ec516f1743f31f752c6122193e7bce38bdbfpolib-1.2.0.tar.gz"
    sha256 "f3ef94aefed6e183e342a8a269ae1fc4742ba193186ad76f175938621dbfc26b"
  end

  resource "qtpy" do
    url "https:files.pythonhosted.orgpackageseb9a7ce646daefb2f85bf5b9c8ac461508b58fa5dcad6d40db476187fafd0148QtPy-2.4.1.tar.gz"
    sha256 "a5a15ffd519550a1361bdc56ffc07fda56a6af7292f17c7b395d4083af632987"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin"git-cola", "--version"
  end
end