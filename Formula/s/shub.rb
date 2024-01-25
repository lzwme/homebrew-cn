class Shub < Formula
  include Language::Python::Virtualenv

  desc "Scrapinghub command-line client"
  homepage "https:shub.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackages4ba327c88f9316fa079297719ba889ce24da7501856abe1077d5eae5b9b1cbaeshub-2.15.3.tar.gz"
  sha256 "4198819e636835e73f9e606a42d09e06821eb798bff6fdd13ec8a9776afa663a"
  license "BSD-3-Clause"
  head "https:github.comscrapinghubshub.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9643ac6a35d1a2bfe54e30d2669b8c7f7ac31b9de657b8a16722fb6d8d55208f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db5b05e733d1559957c62a5a3945d75cf90871e2d5e50b2ea37078c7af3440b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b6b4e324e48b2887c3e7ce279b7c75149c07f62fc9262436233d21bfe509e0a"
    sha256 cellar: :any_skip_relocation, sonoma:         "518bec1764986014ec70e06a8cee77fb4722da1f41a3d0a42e78ba53d7d39dad"
    sha256 cellar: :any_skip_relocation, ventura:        "610fc9d8ea17c2ad4f66bf1055c1dec6697aa5f466c100cd35bedaabbb791e1f"
    sha256 cellar: :any_skip_relocation, monterey:       "1bc06483d34f86e8df38f0c07ac230e40765f0494fb2dd67cba7f3413c1f5fac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94644ec70b12f8fbce2701b134a1ca9acb8dc82874da3376b1c19776c7138bb1"
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

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesfcc9b146ca195403e0182a374e0ea4dbc69136bad3cd55bc293df496d625d0f7setuptools-69.0.3.tar.gz"
    sha256 "be1af57fc409f93647f2e8e4573a142ed38724b8cdd389706a867bb4efcf1e78"
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