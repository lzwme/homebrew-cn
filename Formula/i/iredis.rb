class Iredis < Formula
  include Language::Python::Virtualenv

  desc "Terminal Client for Redis with AutoCompletion and Syntax Highlighting"
  homepage "https:iredis.xbin.io"
  url "https:files.pythonhosted.orgpackagese1f9c302b8bdfcc55159e32999a4d6d9eb252ed91333a7ca7b34bd9e61d240efiredis-1.14.0.tar.gz"
  sha256 "821336ab54e4cea7169ac51bd94f3daa45a3b9843b1adee1bf2ea3dd3230f184"
  license "BSD-3-Clause"
  head "https:github.comlaixintaoiredis.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d4adcb980f5f33e53cae99805e6483b0b7620e0c1a223b783927968b7c39657"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56e342299ebaa116ec27d33fb29651c855e89226bf6643f7573206863fd6d444"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80bc79bcd38112397ca7886900beba0ac2a9c77c98d7123ebe4418d11aa7fd47"
    sha256 cellar: :any_skip_relocation, sonoma:         "c2880d15fd643763aa6d786267310124b194efe8673f03408484c4c3f18dc6b5"
    sha256 cellar: :any_skip_relocation, ventura:        "112ac36f18085a098b72b130c6e6760d21c4d223b17cfdd4c01e29f450bd14ea"
    sha256 cellar: :any_skip_relocation, monterey:       "c9fdd9bd53d739663797559c01fa7b2e41b033ce5d2d54522b5b40c7d608bb0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a2c4f1a253d019bb0fb4b077e76676db4df79534e03cc39fab4b2e094b7b349"
  end

  depends_on "python-setuptools" # for undeclared distutils
  depends_on "python@3.12"

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "configobj" do
    url "https:files.pythonhosted.orgpackagescb8717d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fbconfigobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "mistune" do
    url "https:files.pythonhosted.orgpackagesefc8f0173fe3bf85fd891aee2e7bcd8207dfe26c2c683d727c5a6cc3aec7b628mistune-3.0.2.tar.gz"
    sha256 "fc7f93ded930c92394ef2cb6f04a8aabab4117a91449e72dcc8dfa646a508be8"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesfb2b9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7bpackaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "pendulum" do
    url "https:files.pythonhosted.orgpackagesdb156e89ae7cde7907118769ed3d2481566d05b5fd362724025198bb95faf599pendulum-2.1.2.tar.gz"
    sha256 "b06a0ca1bfe41c990bbf0c029f0b6501a7f2ec4e38bfec730712015e8860f207"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackagesccc625b6a3d5cd295304de1e32c9edbcf319a52e965b339629d37d42bb7126caprompt_toolkit-3.0.43.tar.gz"
    sha256 "3527b7af26106cbc65a040bcc84839a3566ec1b051bb0bfe953631e704b0ff7d"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages55598bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages4cc413b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytzdata" do
    url "https:files.pythonhosted.orgpackages67624c25435a7c2f9c7aef6800862d6c227fc4cd81e9f0beebc5549a49c8ed53pytzdata-2020.1.tar.gz"
    sha256 "3efa13b335a00a8de1d345ae41ec78dd11c9f8807f522d39850f2dd828681540"
  end

  resource "redis" do
    url "https:files.pythonhosted.orgpackages4a4c3c3b766f4ecbb3f0bec91ef342ee98d179e040c25b6ecc99e510c2570f2aredis-5.0.1.tar.gz"
    sha256 "0dab495cd5753069d3bc650a0dde8a8f9edde16fc5691b689a566eda58100d0f"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages259d0acbed6e4a4be4fc99148f275488580968f44ddb5e69b8ceb53fc9df55a0wcwidth-0.1.9.tar.gz"
    sha256 "ee73862862a156bf77ff92b09034fc4825dd3af9cf81bc5b360668d425f3c5f1"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12")

    # Switch build-system to poetry-core to avoid rust dependency on Linux.
    # Remove when mergedreleased: https:github.comsdispaterpytzdatapull13
    resource("pytzdata").stage do
      inreplace "pyproject.toml", 'requires = ["poetry>=1.0.0"]', 'requires = ["poetry-core>=1.0"]'
      inreplace "pyproject.toml", 'build-backend = "poetry.masonry.api"', 'build-backend = "poetry.core.masonry.api"'
      venv.pip_install_and_link Pathname.pwd
    end

    venv.pip_install resources.reject { |r| r.name == "pytzdata" }
    venv.pip_install_and_link buildpath
  end

  test do
    port = free_port
    output = shell_output("#{bin}iredis -p #{port} info 2>&1", 1)
    assert_match "Connection refused", output
  end
end