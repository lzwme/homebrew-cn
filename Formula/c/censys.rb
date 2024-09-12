class Censys < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for the Censys APIs (censys.io)"
  homepage "https:github.comcensyscensys-python"
  url "https:files.pythonhosted.orgpackagesc3684ec109b934009dba49ef88f5a1bb5bfa5c5cb25cc3cb0685da44009876fccensys-2.2.14.tar.gz"
  sha256 "09df1cf86a72efb159c03de8dc35163f22dbe95f029f85042b3e63b38171255f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9a4d8d7c900dbf67d480ffcc4f7be0c4f44ee2e3789f1c05d95f4d044918cd59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a4d8d7c900dbf67d480ffcc4f7be0c4f44ee2e3789f1c05d95f4d044918cd59"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a4d8d7c900dbf67d480ffcc4f7be0c4f44ee2e3789f1c05d95f4d044918cd59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a4d8d7c900dbf67d480ffcc4f7be0c4f44ee2e3789f1c05d95f4d044918cd59"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d56c03ee58e1fbd341ce7881ae53f57f0a7c09322c042bdc8177b1f56919f33"
    sha256 cellar: :any_skip_relocation, ventura:        "8d56c03ee58e1fbd341ce7881ae53f57f0a7c09322c042bdc8177b1f56919f33"
    sha256 cellar: :any_skip_relocation, monterey:       "8d56c03ee58e1fbd341ce7881ae53f57f0a7c09322c042bdc8177b1f56919f33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e41bc31268d700964e3a37c2e968e454b2b885dc376f86d9d9241e9781f0e359"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackages7533a3d23a2e9ac78f9eaf1fce7490fee430d43ca7d42c65adabbb36a2b28ff6argcomplete-3.5.0.tar.gz"
    sha256 "4349400469dccfb7950bb60334a680c58d88699bff6159df61251878dc6bf74b"
  end

  resource "backoff" do
    url "https:files.pythonhosted.orgpackages47d75bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagese8ace349c5e6d4543326c6883ee9491e3921e0d07b55fdf3cce184b40d63e72aidna-3.8.tar.gz"
    sha256 "d838c2c0ed6fced7693d5e8ab8e734d5f8fda53a039c0164afb0b82e771e3603"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackages927640f084cb7db51c9d1fa29a7120717892aeda9a7711f6225692c957a93535rich-13.8.1.tar.gz"
    sha256 "8260cda28e3db6bf04d2d1ef4dbc03ba80a824c88b0e7668a0f23126a424844a"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "Censys Python Version: #{version}", shell_output("#{bin}censys --version").strip
    assert_match "401 (Error Code: unknown), Unauthorized", pipe_output("#{bin}censys asm config 2>&1", "test", 1)
  end
end