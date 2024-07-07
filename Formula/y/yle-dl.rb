class YleDl < Formula
  include Language::Python::Virtualenv

  desc "Download Yle videos from the command-line"
  homepage "https:aajanki.github.ioyle-dlindex-en.html"
  url "https:files.pythonhosted.orgpackagesf7120e91744c461d577385274d4df87d3b99896b97ab1402b93f2557e43664dcyle_dl-20240706.tar.gz"
  sha256 "ebc2103d43b3bf76209469ba9a6cf8db0e2ec0483a85dc5c3430245c7e18f4ed"
  license "GPL-3.0-or-later"
  head "https:github.comaajankiyle-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ecb8dbdd7842a73894103b1697f2a4dcf77c347674482b7315fbd9cd549a669c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f7fe051d42d618e7cd0226f3c59e12d7245e7622f31abc0c879d6710350f9b4"
    sha256 cellar: :any,                 arm64_monterey: "07abd23278fe156885632b01a9fadc212eca43718d5c26de46d4e29c36c94a60"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee4157d0bd490457614baecdb7ffe4465cf658c0f91a113860ce312d432e2faa"
    sha256 cellar: :any_skip_relocation, ventura:        "86baa644bc8c035dd92e8735b8452fb2e8aa2ae00856f7b0d23c9729093119cc"
    sha256 cellar: :any,                 monterey:       "400ccff9d5fd37c08672caf9e6acf86804b6bc6bc3f14775e11033d20edd5f33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b0d97bfec25f8da8923161d6e50f10c65f51a5ab6b3f933c85b492e886e8624"
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