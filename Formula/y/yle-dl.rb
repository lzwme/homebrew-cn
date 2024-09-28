class YleDl < Formula
  include Language::Python::Virtualenv

  desc "Download Yle videos from the command-line"
  homepage "https:aajanki.github.ioyle-dlindex-en.html"
  url "https:files.pythonhosted.orgpackages4063b0883346f67d8e30eaea48c717f54f07d97e962aeae99fca7e3ed373e787yle_dl-20240927.tar.gz"
  sha256 "ac5d6b73b1bf1816c6a03c736048286b20b2a9d8e67785c689bd3464e6252ecb"
  license "GPL-3.0-or-later"
  head "https:github.comaajankiyle-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e49882140da40fd1734f0eadf76e77500e53e8f9edacc12e606e59a50854af5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "699d3485abdee3ca4c869fd651215b49070effa67f786773e87148285c8b9b3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d15e03d7008c2f29ac031640be52e0f6e10194d9a699056c1a6e640c7d7ee88"
    sha256 cellar: :any_skip_relocation, sonoma:        "245376553d923eb97c7e5beacd403dec079123d4b8c9804df865f53534e80c5c"
    sha256 cellar: :any_skip_relocation, ventura:       "c59b71dbb05064b2d33c3df6e5a4565a31f0703f6aee4c3382ffb29bd0ba503e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8cd4cd512988ae4b1402f0b33292296718fb35916cb3b32c0f559e855d45113"
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
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackagese76b20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
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