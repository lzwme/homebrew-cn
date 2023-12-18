class Ipython < Formula
  include Language::Python::Virtualenv

  desc "Interactive computing in Python"
  homepage "https:ipython.org"
  url "https:files.pythonhosted.orgpackagesb1b93ba6c45a6df813c09a48bac313c22ff83efa26cbb55011218d925a46e2adipython-8.18.1.tar.gz"
  sha256 "ca6f079bb33457c66e233e4580ebfc4128855b4cf6370dddd73842a9563e8a27"
  license "BSD-3-Clause"
  head "https:github.comipythonipython.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a2022e4319b4f928669baae1602cd566719abe2fb0707f93739dbbbd8d5da59"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24b0d1977de9d03c178eca24f2f0d994aff7550d9d39d81ef5828e100cc34cf0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13dfe2347a433703b994507736eb60f453540354284c91802942b5b5759787b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "a231f85e2aa94414b8d2f4aaae06cd0509d02c0fe2ecd28a1a3803317b4d9993"
    sha256 cellar: :any_skip_relocation, ventura:        "9c51c610b59f31500ea2e11c39c5d80e49ee6a8f73f89bf9deb865cd2ab587eb"
    sha256 cellar: :any_skip_relocation, monterey:       "1c0e00321adde2c8854ebc03349671e612eaf6d01709f9c038e978f043ac0b27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "499a6aebaba09aead77cd1fd9319ae96cbf1819b74a0c34115ce2af64ecc727d"
  end

  depends_on "pygments"
  depends_on "python@3.12"
  depends_on "six"

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
    url "https:files.pythonhosted.orgpackagesd97b7d88d94427e1e179e0a62818e68335cf969af5ca38033c0ca02237ab6ee7prompt_toolkit-3.0.41.tar.gz"
    sha256 "941367d97fc815548822aa26c2a269fdc4eb21e9ec05fc5d447cf09bad5d75f0"
  end

  resource "ptyprocess" do
    url "https:files.pythonhosted.orgpackages20e516ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4eptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pure-eval" do
    url "https:files.pythonhosted.orgpackages975a0bc937c25d3ce4e0a74335222aee05455d6afa2888032185f8ab50cdf6fdpure_eval-0.2.2.tar.gz"
    sha256 "2b45320af6dfaa1750f543d714b6d1c520a1688dec6fd24d339063ce0aaa9ac3"
  end

  resource "stack-data" do
    url "https:files.pythonhosted.orgpackages28e355dcc2cfbc3ca9c29519eb6884dd1415ecb53b0e934862d3559ddcb7e20bstack_data-0.6.3.tar.gz"
    sha256 "836a778de4fec4dcd1dcd89ed8abff8a221f58308462e1c4aa2a3cf30148f0b9"
  end

  resource "traitlets" do
    url "https:files.pythonhosted.orgpackages5a0bb825ac58e20a6fef55c94ba9c7c96f1777f9a3b7e34b3b43b6d54185ec2atraitlets-5.13.0.tar.gz"
    sha256 "9b232b9430c8f57288c1024b34a8f0251ddcc47268927367a0dd3eeaca40deb5"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackagesd71263deef355537f290d5282a67bb7bdd165266e4eca93cd556707a325e5a24wcwidth-0.2.12.tar.gz"
    sha256 "f01c104efdf57971bcb756f054dd58ddec5204dd15fa31d6503ea57947d97c02"
  end

  def install
    virtualenv_install_with_resources

    # Install man page
    man1.install libexec"sharemanman1ipython.1"
  end

  test do
    assert_equal "4", shell_output("#{bin}ipython -c 'print(2+2)'").chomp
  end
end