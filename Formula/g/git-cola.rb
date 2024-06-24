class GitCola < Formula
  include Language::Python::Virtualenv

  desc "Highly caffeinated git GUI"
  homepage "https:git-cola.github.io"
  url "https:files.pythonhosted.orgpackages6b34fd3f893a2b58c8c51b22a3ea411d6f7040ba4816311b2befdfcc515e18b1git-cola-4.8.0.tar.gz"
  sha256 "86971d6f386a70e1e7d35e8c2f57cd586cb81986ec8ca099cb93412142bbfbf0"
  license "GPL-2.0-or-later"
  head "https:github.comgit-colagit-cola.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6aef417eb7419252c60d477676d3140851f293a57ed336d1295c48fd22afa793"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6aef417eb7419252c60d477676d3140851f293a57ed336d1295c48fd22afa793"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6aef417eb7419252c60d477676d3140851f293a57ed336d1295c48fd22afa793"
    sha256 cellar: :any_skip_relocation, sonoma:         "0c79cc0fc38f430ee823a6c90f2edd3e88250eed6a675b1ef79213de746a36da"
    sha256 cellar: :any_skip_relocation, ventura:        "0c79cc0fc38f430ee823a6c90f2edd3e88250eed6a675b1ef79213de746a36da"
    sha256 cellar: :any_skip_relocation, monterey:       "0c79cc0fc38f430ee823a6c90f2edd3e88250eed6a675b1ef79213de746a36da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4ab3043d96fab95baecb8d5f93410400515a3a34ee1d80c9827ffe3966a008a"
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