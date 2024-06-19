class YleDl < Formula
  include Language::Python::Virtualenv

  desc "Download Yle videos from the command-line"
  homepage "https:aajanki.github.ioyle-dlindex-en.html"
  url "https:files.pythonhosted.orgpackages4d6a60344980cdb6e40e93608ed81f31a844773cda5d3e90aa1e84f05308b54ayle_dl-20240429.tar.gz"
  sha256 "d1618505c41916f8620ae5704939b0a127dd653bc91afb20d0e6183e342cdb7c"
  license "GPL-3.0-or-later"
  revision 2
  head "https:github.comaajankiyle-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd66f8e6fee1901c759af79904bc3412615af15b81e54bed8f2c7bb268923621"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5cbb941b7431a5f119574b5cfeeefa4aa7c57093699d95c04ddc58fe9ef7f043"
    sha256 cellar: :any,                 arm64_monterey: "6f6024241da9df2f4e7a38493c63af11931ea42ef1bc6e42dd99eecf4599174d"
    sha256 cellar: :any_skip_relocation, sonoma:         "75980914dd024d668fb7d3fd6d33034590c3647615f38932f0bb6b759819c0fa"
    sha256 cellar: :any_skip_relocation, ventura:        "2f6b8ab84d87a75f69a15500c6290ecea173bb2b137e5e5e9b546889598e633d"
    sha256 cellar: :any,                 monterey:       "6b27e6e11650ebbe00136a99f683ac3c7a39594f0074eda45b639de6a322659c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f84bcd42f5f90fb54322dd0af7291c4f8f8cdf57411230ec33ca74a836244753"
  end

  depends_on "certifi"
  depends_on "ffmpeg"
  depends_on "python@3.12"
  depends_on "rtmpdump"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "configargparse" do
    url "https:files.pythonhosted.orgpackages708a73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783eConfigArgParse-1.7.tar.gz"
    sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackages63f7ffbb6d2eb67b80a45b8a0834baa5557a14a5ffce0979439e7cd7f0c4055blxml-5.2.2.tar.gz"
    sha256 "bb2dc4898180bea79863d5487e5f9c7c34297414bad54bcd0f0852aee9cfdb87"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}yle-dl --showtitle https:areena.yle.fi1-1570236")
    assert_match "Traileri:", output
    assert_match "2012-05-30T10:51", output
  end
end