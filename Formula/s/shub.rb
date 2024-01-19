class Shub < Formula
  include Language::Python::Virtualenv

  desc "Scrapinghub command-line client"
  homepage "https:shub.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackages4b48df85a1fdbd6c3928f70c6384ab9bd9197abaad8dbe302e19fba58ce6b7ffshub-2.15.2.tar.gz"
  sha256 "bf529b3d1777b6d9dbb65cd1afe55791af1a66bacdfa857079a9255462c4df1a"
  license "BSD-3-Clause"
  head "https:github.comscrapinghubshub.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d4431c039fe678954020edc8b842ad9def5df34360df2b5d59925493d8b2744"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a042b0aa2b2daaf72cf97b4d96f380a149d5814a2cb5b1d09f26c19da72a3591"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96f721e92e85e7ef3b5738329bf2258183e835dadff69db489f8887f2654fea3"
    sha256 cellar: :any_skip_relocation, sonoma:         "090ef07d9507fd0095b89c39249ec17700c34113704d06c32e38fbe5556533e4"
    sha256 cellar: :any_skip_relocation, ventura:        "22b88704045ca54fcde3918f19c06bf20b0821ac5ba8d90c8e90021bb04f9972"
    sha256 cellar: :any_skip_relocation, monterey:       "7882a7c2f6e1f6fd1bdb220f2803a380e505b39a8de349a1449411aafdec231c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03e6700f99b1daceeaa6a2eae10587325afca78bb494497e9b13f119eaeee1d6"
  end

  depends_on "python-certifi"
  depends_on "python-packaging"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "docker" do
    url "https:files.pythonhosted.orgpackages25147d40f8f64ceca63c741ee5b5611ead4fb8d3bcaf3e6ab57d2ab0f01712bcdocker-7.0.0.tar.gz"
    sha256 "323736fb92cd9418fc5e7133bc953e11a9da04f4483f828b527db553f1e7e5a3"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "retrying" do
    url "https:files.pythonhosted.orgpackagesce7015ce8551d65b324e18c5aa6ef6998880f21ead51ebe5ed743c0950d7d9ddretrying-1.3.4.tar.gz"
    sha256 "345da8c5765bd982b1d1915deb9102fd3d1f7ad16bd84a9700b85f64d24e8f3e"
  end

  resource "scrapinghub" do
    url "https:files.pythonhosted.orgpackagesa45e83f599af82e467a804da77824e2301ff253c6251c31ac56d0f70bac9e9cescrapinghub-2.4.0.tar.gz"
    sha256 "58b90ba44ee01b80576ecce45645e19ca4e6f1176f4da26fcfcbb71bf26f6814"
  end

  resource "toml" do
    url "https:files.pythonhosted.orgpackagesbeba1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3ctoml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackages9c976627aaf69c42a41d0d22a54ad2bf420290e07da82448823dcd6851de427etqdm-4.55.1.tar.gz"
    sha256 "556c55b081bd9aa746d34125d024b73f0e2a0e62d5927ff0e400e20ee0a03b9a"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages36dda6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin"shub", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}shub version")

    assert_match "Error: Missing argument 'SPIDER'.",
      shell_output("#{bin}shub schedule 2>&1", 2)
  end
end