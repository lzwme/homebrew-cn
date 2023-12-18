class Shub < Formula
  include Language::Python::Virtualenv

  desc "Scrapinghub command-line client"
  homepage "https:shub.readthedocs.ioenstable"
  url "https:files.pythonhosted.orgpackagesff1c02b628a398b06d3f2c34c5e413d61f92300064da01bbf212fe056d9eea0dshub-2.14.5.tar.gz"
  sha256 "241b31dc4c2a96aa0915cf40f0e8d371fe116cd8d785ce18c96ff5bc4c585a73"
  license "BSD-3-Clause"
  revision 3
  head "https:github.comscrapinghubshub.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf7d183086d6b6709477f88d66ac46ea06230856b88cd938900c056942f41d97"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c763c57ac1809639f995a6380ee80352607c6760e38e7432ef1576303ee2412c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1b075a2d6a6a2d6d0f27491f3fd1901b20c3869075c6c59aeb2f51087e201f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f4fa974b66374592a5268c04c5810b707bd493956b4c90c49c4978b888a9594"
    sha256 cellar: :any_skip_relocation, ventura:        "b59ab9ac596f0c84d7293efa172463c7de9ae05b4ced0111ef1e332addc1d4f2"
    sha256 cellar: :any_skip_relocation, monterey:       "5bc31fae53101b816002ffd5fcf053ec3d05d651c2b19cf5dfaf758a812c4b7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ed0f1a36241b90f9510dd4f4feac90bdcf56a7de600d152c0fc13c681ab5369"
  end

  depends_on "python-certifi"
  depends_on "python-packaging"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagescface89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "docker" do
    url "https:files.pythonhosted.orgpackagesf073f7c9a14e88e769f38cb7fb45aa88dfd795faa8e18aea11bababf6e068d5edocker-6.1.3.tar.gz"
    sha256 "aa6d17830045ba5ef0168d5eaa34d37beeb113948c413affe1d5991fc11f9a20"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages8be143beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
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
    url "https:files.pythonhosted.orgpackagesaf47b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3curllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  resource "websocket-client" do
    url "https:files.pythonhosted.orgpackagescbeb19eadbb717ef032749853ef5eb1c28e9ca974711e28bccd4815913ba5546websocket-client-1.6.4.tar.gz"
    sha256 "b3324019b3c28572086c4a319f91d1dcd44e6e11cd340232978c684a7650d0df"
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