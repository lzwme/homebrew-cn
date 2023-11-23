class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/ac/fe/028d5b32d0a54fe3ecac1c170966757f185f84b81e06af98c820a546c691/virtualenv-20.24.7.tar.gz"
  sha256 "69050ffb42419c91f6c1284a7b24e0475d793447e35929b488bf6a0aade39353"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3672805de13556efdd37a147ab1a32f3f64b892f8142f47842225f1dbf3b8e44"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26c9811948d6f030449bd731a1b2f490e7dd4426421a1e8c5082690d7e794317"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b53df17e34dcf1778e17cfe4c5d4c43b2c99d207cb7b1ba241648f89ae3c3f23"
    sha256 cellar: :any_skip_relocation, sonoma:         "ced49a95edd57e1e11398568044b9f25a02787ab100b0437bcf23d2d73f3e922"
    sha256 cellar: :any_skip_relocation, ventura:        "4a7ee01dbf5d3c429b681970f45f1917cc7284cbc14a2fcfbe04da7a2a8941bd"
    sha256 cellar: :any_skip_relocation, monterey:       "410aa1f2d1d33ad1392817cd047e30e0029f795de229ddd01f40c013d794c004"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c1d652f899cfc1b543365994c0c7c884e86870796e480784ead3deaaee57dc8"
  end

  depends_on "python@3.12"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/29/34/63be59bdf57b3a8a8dcc252ef45c40f3c018777dc8843d45dd9b869868f0/distlib-0.3.7.tar.gz"
    sha256 "9dafe54b34a028eafd95039d5e5d4851a13734540f1331060d31c9916e7147a8"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/70/70/41905c80dcfe71b22fb06827b8eae65781783d4a14194bce79d16a013263/filelock-3.13.1.tar.gz"
    sha256 "521f5f56c50f8426f5e03ad3b281b490a87ef15bc6c526f168290f0c7148d44e"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/31/28/e40d24d2e2eb23135f8533ad33d582359c7825623b1e022f9d460def7c05/platformdirs-4.0.0.tar.gz"
    sha256 "cb633b2bcf10c51af60beb0ab06d2f1d69064b43abf4c185ca6b28865f3f9731"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end