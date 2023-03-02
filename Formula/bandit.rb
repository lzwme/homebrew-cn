class Bandit < Formula
  include Language::Python::Virtualenv

  desc "Security-oriented static analyser for Python code"
  homepage "https://github.com/PyCQA/bandit"
  url "https://files.pythonhosted.org/packages/39/36/a37a2f6f8d0ed8c3bc616616ed5019e1df2680bd8b7df49ceae80fd457de/bandit-1.7.4.tar.gz"
  sha256 "2d63a8c573417bae338962d4b9b06fbc6080f74ecd955a092849e1e65c717bd2"
  license "Apache-2.0"
  head "https://github.com/PyCQA/bandit.git", branch: "main"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07fdc41db4bce2fdc153c47337a1109a7ebdce8b3efa733a09aa4076218ab47c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1473ba42ebb0cf7ccc01c2e27a45847c7159a99dab56a52c7abb0368e358c35"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1aeb9aac2d424bb759d5ff9e64498116b37dfb66abce49732361d5da1fc9b090"
    sha256 cellar: :any_skip_relocation, ventura:        "14fb71a5213aa505cc0f4d7b6ebc8fca7666ec2e9b8bd220a06f73099376e198"
    sha256 cellar: :any_skip_relocation, monterey:       "7028e989b7b8a3e3486ecdc6b173169a7f2a3a6925326c41988b05e5923ecc59"
    sha256 cellar: :any_skip_relocation, big_sur:        "f48b01cab5be42c2198088d8eb122798a9038f3bdb8200a4ec7325ab4afc911e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "344efa052fd0a3a6dc54730e4502f85f7ecc7f30338b6b5dd6eb9196a98ed2f9"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/4b/47/dc98f3d5d48aa815770e31490893b92c5f1cd6c6cf28dd3a8ae0efffac14/gitdb-4.0.10.tar.gz"
    sha256 "6eb990b69df4e15bad899ea868dc46572c3f75339735663b81de79b06f17eb9a"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/ef/8d/50658d134d89e080bb33eb8e2f75d17563b5a9dfb75383ea1a78e1df6fff/GitPython-3.1.30.tar.gz"
    sha256 "769c2d83e13f5d938b7688479da374c4e3d49f71549aaf462b646db9602ea6f8"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/02/d8/acee75603f31e27c51134a858e0dea28d321770c5eedb9d1d673eb7d3817/pbr-5.11.1.tar.gz"
    sha256 "aefc51675b0b533d56bb5fd1c8c6c0522fe31896679882e1c4c63d5e4a0fccb3"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/66/c0/26afabea111a642f33cfd15f54b3dbe9334679294ad5c0423c556b75eba2/stevedore-4.1.1.tar.gz"
    sha256 "7f8aeb6e3f90f96832c301bff21a7eb5eefbe894c88c506483d355565d88cc1a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write "assert True\n"
    output = JSON.parse shell_output("#{bin}/bandit -q -f json test.py", 1)
    assert_equal output["results"][0]["test_id"], "B101"
  end
end