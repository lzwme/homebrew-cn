class Flit < Formula
  include Language::Python::Virtualenv

  desc "Simplified packaging of Python modules"
  homepage "https://github.com/pypa/flit"
  url "https://files.pythonhosted.org/packages/b1/a6/e9227cbb501aee4fa4a52517d3868214036a7b085d96bd1e4bbfc67ad6c6/flit-3.9.0.tar.gz"
  sha256 "d75edf5eb324da20d53570a6a6f87f51e606eee8384925cd66a90611140844c7"
  license "BSD-3-Clause"
  head "https://github.com/pypa/flit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1aa14bf6c56f01c1ea9ae8c7a3acc9491c1a29a79857e247af0a60434eb1a656"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1299fd59c36959159404df7e2da6158323c9c62b6c65ddba75df685d0ca07da1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7500f06123545db522632ff1b133b9d9346dbdd993b120740e2e6add97ad1a15"
    sha256 cellar: :any_skip_relocation, ventura:        "d03d6bed46c9023fc8a09ab8398e0a2c257574cfcc48eb1689e1b5ed0e6bfcc0"
    sha256 cellar: :any_skip_relocation, monterey:       "87fc80516f89a7c8d47ce3429dbaa2333377191014ea0a1ac3244403776f3230"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c125bddfb1ded9e34c3a0dc45aa6846dfaedd3e2345d691e31fe01533fc675d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca336136d70c153ca3386ef7446ca8bdf630376539fc7e9d5be330a7234e1a00"
  end

  depends_on "docutils"
  depends_on "python@3.11"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/c4/e6/c1ac50fe3eebb38a155155711e6e864e254ce4b6e17fe2429b4c4d5b9e80/flit_core-3.9.0.tar.gz"
    sha256 "72ad266176c4a3fcfab5f2930d76896059851240570ce9a98733b658cb786eba"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e0/69/122171604bcef06825fa1c05bd9e9b1d43bc9feb8c6c0717c42c92cc6f3c/requests-2.30.0.tar.gz"
    sha256 "239d7d4458afcb28a692cdd298d87542235f4ca8d36d03a15bfc128a6559a2f4"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/49/05/6bf21838623186b91aedbda06248ad18f03487dc56fbc20e4db384abde6c/tomli_w-1.0.0.tar.gz"
    sha256 "f463434305e0336248cac9c2dc8076b707d8a12d019dd349f5c1e382dd1ae1b9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/fb/c0/1abba1a1233b81cf2e36f56e05194f5e8a0cec8c03c244cab56cc9dfb5bd/urllib3-2.0.2.tar.gz"
    sha256 "61717a1095d7e155cdb737ac7bb2f4324a858a1e2e6466f6d03ff630ca68d3cc"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"sample.py").write <<~END
      """A sample package"""
      __version__ = "0.1"
    END
    (testpath/"pyproject.toml").write <<~END
      [build-system]
      requires = ["flit_core"]
      build-backend = "flit_core.buildapi"

      [tool.flit.metadata]
      module = "sample"
      author = "Sample Author"
    END
    system bin/"flit", "build"
    assert_predicate testpath/"dist/sample-0.1-py2.py3-none-any.whl", :exist?
    assert_predicate testpath/"dist/sample-0.1.tar.gz", :exist?
  end
end