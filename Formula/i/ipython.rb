class Ipython < Formula
  include Language::Python::Virtualenv

  desc "Interactive computing in Python"
  homepage "https:ipython.org"
  url "https:files.pythonhosted.orgpackagesd72ed578cafc51642bb0e4c626e29ca1d580c6a884f540049f744df405373f3aipython-8.23.0.tar.gz"
  sha256 "7468edaf4f6de3e1b912e57f66c241e6fd3c7099f2ec2136e239e142e800274d"
  license "BSD-3-Clause"
  head "https:github.comipythonipython.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "637bb1d3b865ec8ba3cb04bea47d4da9055fe51391cf3767eb5ba0eb705cc3d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "637bb1d3b865ec8ba3cb04bea47d4da9055fe51391cf3767eb5ba0eb705cc3d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "637bb1d3b865ec8ba3cb04bea47d4da9055fe51391cf3767eb5ba0eb705cc3d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "5bfa52d8125b83eee2169a1769a9d060ae99fafd3dc5eed662c64de646695170"
    sha256 cellar: :any_skip_relocation, ventura:        "5bfa52d8125b83eee2169a1769a9d060ae99fafd3dc5eed662c64de646695170"
    sha256 cellar: :any_skip_relocation, monterey:       "5bfa52d8125b83eee2169a1769a9d060ae99fafd3dc5eed662c64de646695170"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be6ea8905c6bdd5fb0fd1d747700b51ddf8b3b8767a3d8d091be7e7299ba7d75"
  end

  depends_on "python@3.12"

  resource "asttokens" do
    url "https:files.pythonhosted.orgpackages451df03bcb60c4a3212e15f99a56085d93093a497718adf828d050b9d675da81asttokens-2.4.1.tar.gz"
    sha256 "b03869718ba9a6eb027e134bfdf69f38a236d681c83c160d510768af11254ba0"
  end

  resource "decorator" do
    url "https:files.pythonhosted.orgpackages660c8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "executing" do
    url "https:files.pythonhosted.orgpackages084185d2d28466fca93737592b7f3cc456d1cfd6bcd401beceeba17e8e792b50executing-2.0.1.tar.gz"
    sha256 "35afe2ce3affba8ee97f2d69927fa823b08b472b7b994e36a52a964b93d16147"
  end

  resource "jedi" do
    url "https:files.pythonhosted.orgpackagesd69999b493cec4bf43176b678de30f81ed003fd6a647a301b9c927280c600f0ajedi-0.19.1.tar.gz"
    sha256 "cf0496f3651bc65d7174ac1b7d043eff454892c708a87d1b683e57b569927ffd"
  end

  resource "matplotlib-inline" do
    url "https:files.pythonhosted.orgpackagesd9503af8c0362f26108e54d58c7f38784a3bdae6b9a450bab48ee8482d737f44matplotlib-inline-0.1.6.tar.gz"
    sha256 "f887e5f10ba98e8d2b150ddcf4702c1e5f8b3a20005eb0f74bfdbd360ee6f304"
  end

  resource "parso" do
    url "https:files.pythonhosted.orgpackagesa20e41f0cca4b85a6ea74d66d2226a7cda8e41206a624f5b330b958ef48e2e52parso-0.8.3.tar.gz"
    sha256 "8c07be290bb59f03588915921e29e8a50002acaf2cdc5fa0e0114f91709fafa0"
  end

  resource "pexpect" do
    url "https:files.pythonhosted.orgpackages4292cc564bf6381ff43ce1f4d06852fc19a2f11d180f23dc32d9588bee2f149dpexpect-4.9.0.tar.gz"
    sha256 "ee7d41123f3c9911050ea2c2dac107568dc43b2d3b0c7557a33212c398ead30f"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackagesccc625b6a3d5cd295304de1e32c9edbcf319a52e965b339629d37d42bb7126caprompt_toolkit-3.0.43.tar.gz"
    sha256 "3527b7af26106cbc65a040bcc84839a3566ec1b051bb0bfe953631e704b0ff7d"
  end

  resource "ptyprocess" do
    url "https:files.pythonhosted.orgpackages20e516ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4eptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pure-eval" do
    url "https:files.pythonhosted.orgpackages975a0bc937c25d3ce4e0a74335222aee05455d6afa2888032185f8ab50cdf6fdpure_eval-0.2.2.tar.gz"
    sha256 "2b45320af6dfaa1750f543d714b6d1c520a1688dec6fd24d339063ce0aaa9ac3"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages55598bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "stack-data" do
    url "https:files.pythonhosted.orgpackages28e355dcc2cfbc3ca9c29519eb6884dd1415ecb53b0e934862d3559ddcb7e20bstack_data-0.6.3.tar.gz"
    sha256 "836a778de4fec4dcd1dcd89ed8abff8a221f58308462e1c4aa2a3cf30148f0b9"
  end

  resource "traitlets" do
    url "https:files.pythonhosted.orgpackages4f97d957b3a5f6da825cbbb6a02e584bcab769ea2c2a9ad67a9cc25b4bbafb30traitlets-5.14.2.tar.gz"
    sha256 "8cdd83c040dab7d1dee822678e5f5d100b514f7b72b01615b26fc5718916fdf9"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources

    man1.install libexec"sharemanman1ipython.1"
  end

  test do
    assert_equal "4", shell_output("#{bin}ipython -c 'print(2+2)'").chomp
  end
end