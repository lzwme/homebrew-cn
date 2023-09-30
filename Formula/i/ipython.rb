class Ipython < Formula
  include Language::Python::Virtualenv

  desc "Interactive computing in Python"
  homepage "https://ipython.org/"
  url "https://files.pythonhosted.org/packages/bc/7f/33ab8dfcf529b9bd0220792a26378b722999fc2b857ce4b06f6e0030ed98/ipython-8.16.0.tar.gz"
  sha256 "7a1b2e1e6a3ec5baa466163c451335081f31859883889ff0289c6b21f7a095e2"
  license "BSD-3-Clause"
  head "https://github.com/ipython/ipython.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5657da4d5990a9122c975a4687b5ee67253c34b6c5164f97a1ca3602b560632f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d224020796d08b5d40c7f99b2cc6409596ce18fbcb801a212be667d8cbd113a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c543918f11847deb3ea5033425004a4f789207fba5209ddf7fcd853ce3f0670"
    sha256 cellar: :any_skip_relocation, sonoma:         "b622b39c716f8e9363b23f86682a8d88ca04e392467c9cc6bad8d09e669ec830"
    sha256 cellar: :any_skip_relocation, ventura:        "a8534ab8890f7d65b02c43a775bd7909ecc8eed22faf13c0a95c52cabfd54a61"
    sha256 cellar: :any_skip_relocation, monterey:       "e1bb6041e02417da7a65a55c7e4f9a233fa405766387e1c546703514e817a80a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5560788dc89ed2e99b336b25bb5722f8465f8b4c808a599fd392c3a3b1b901e5"
  end

  depends_on "pygments"
  depends_on "python@3.11"
  depends_on "six"

  resource "appnope" do
    url "https://files.pythonhosted.org/packages/6a/cd/355842c0db33192ac0fc822e2dcae835669ef317fe56c795fb55fcddb26f/appnope-0.1.3.tar.gz"
    sha256 "02bd91c4de869fbb1e1c50aafc4098827a7a54ab2f39d9dcba6c9547ed920e24"
  end

  resource "asttokens" do
    url "https://files.pythonhosted.org/packages/ed/e0/7e5af07a090b9ef4f88e29b6edb8db8ca3366a0d7736ae9c3a6522fae140/asttokens-2.4.0.tar.gz"
    sha256 "2e0171b991b2c959acc6c49318049236844a5da1d65ba2672c4880c1c894834e"
  end

  resource "backcall" do
    url "https://files.pythonhosted.org/packages/a2/40/764a663805d84deee23043e1426a9175567db89c8b3287b5c2ad9f71aa93/backcall-0.2.0.tar.gz"
    sha256 "5cbdbf27be5e7cfadb448baf0aa95508f91f2bbc6c6437cd9cd06e2a4c215e1e"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "executing" do
    url "https://files.pythonhosted.org/packages/8f/ac/89ff37d8594b0eef176b7cec742ac868fef853b8e18df0309e3def9f480b/executing-1.2.0.tar.gz"
    sha256 "19da64c18d2d851112f09c287f8d3dbbdf725ab0e569077efb6cdcbd3497c107"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/57/38/4ac6f712c308de92af967142bd67e9d27e784ea5a3524c9e84f33507d82f/jedi-0.19.0.tar.gz"
    sha256 "bcf9894f1753969cbac8022a8c2eaee06bfa3724e4192470aaffe7eb6272b0c4"
  end

  resource "matplotlib-inline" do
    url "https://files.pythonhosted.org/packages/d9/50/3af8c0362f26108e54d58c7f38784a3bdae6b9a450bab48ee8482d737f44/matplotlib-inline-0.1.6.tar.gz"
    sha256 "f887e5f10ba98e8d2b150ddcf4702c1e5f8b3a20005eb0f74bfdbd360ee6f304"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/a2/0e/41f0cca4b85a6ea74d66d2226a7cda8e41206a624f5b330b958ef48e2e52/parso-0.8.3.tar.gz"
    sha256 "8c07be290bb59f03588915921e29e8a50002acaf2cdc5fa0e0114f91709fafa0"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/e5/9b/ff402e0e930e70467a7178abb7c128709a30dfb22d8777c043e501bc1b10/pexpect-4.8.0.tar.gz"
    sha256 "fc65a43959d153d0114afe13997d439c22823a27cefceb5ff35c2178c6784c0c"
  end

  resource "pickleshare" do
    url "https://files.pythonhosted.org/packages/d8/b6/df3c1c9b616e9c0edbc4fbab6ddd09df9535849c64ba51fcb6531c32d4d8/pickleshare-0.7.5.tar.gz"
    sha256 "87683d47965c1da65cdacaf31c8441d12b8044cdec9aca500cd78fc2c683afca"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/9a/02/76cadde6135986dc1e82e2928f35ebeb5a1af805e2527fe466285593a2ba/prompt_toolkit-3.0.39.tar.gz"
    sha256 "04505ade687dc26dc4284b1ad19a83be2f2afe83e7a828ace0c72f3a1df72aac"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pure-eval" do
    url "https://files.pythonhosted.org/packages/97/5a/0bc937c25d3ce4e0a74335222aee05455d6afa2888032185f8ab50cdf6fd/pure_eval-0.2.2.tar.gz"
    sha256 "2b45320af6dfaa1750f543d714b6d1c520a1688dec6fd24d339063ce0aaa9ac3"
  end

  resource "stack-data" do
    url "https://files.pythonhosted.org/packages/db/18/aa7f2b111aeba2cd83503254d9133a912d7f61f459a0c8561858f0d72a56/stack_data-0.6.2.tar.gz"
    sha256 "32d2dd0376772d01b6cb9fc996f3c8b57a357089dec328ed4b6553d037eaf815"
  end

  resource "traitlets" do
    url "https://files.pythonhosted.org/packages/3a/ae/362f1733cbd3160771fa059beb0e2bdab442b7065e7651465b01bc5e4ffa/traitlets-5.10.1.tar.gz"
    sha256 "db9c4aa58139c3ba850101913915c042bdba86f7c8a0dda1c6f7f92c5da8e542"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/7c/67/31b3c1411efeb4b95e0a1c63c263c07676c49f59375d31a21b11ff16f9dc/wcwidth-0.2.7.tar.gz"
    sha256 "1b6d30a98ddd5ce9bbdb33658191fd2423fc9da203fe3ef1855407dcb7ee4e26"
  end

  def install
    python3 = "python3.11"
    venv = virtualenv_create(libexec, python3)
    res = resources.reject { |r| r.name == "appnope" && OS.linux? }
    venv.pip_install res
    venv.pip_install_and_link buildpath

    # Install man page
    man1.install libexec/"share/man/man1/ipython.1"
  end

  test do
    assert_equal "4", shell_output("#{bin}/ipython -c 'print(2+2)'").chomp
  end
end