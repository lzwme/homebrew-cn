class Shub < Formula
  include Language::Python::Virtualenv

  desc "Scrapinghub command-line client"
  homepage "https://shub.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/ff/1c/02b628a398b06d3f2c34c5e413d61f92300064da01bbf212fe056d9eea0d/shub-2.14.5.tar.gz"
  sha256 "241b31dc4c2a96aa0915cf40f0e8d371fe116cd8d785ce18c96ff5bc4c585a73"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/scrapinghub/shub.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b5cc68616be7190ab5d78abf1c7a3e90173022dadf8cc4556e44edf4677d4424"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2df96756dd2f64fa29409290d0996c18aafefd6ee9419f991f68074701d732b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03a2fe47111723659bb629b8d7e8bea555ecc793761f82dc26b4f2bf10f70c31"
    sha256 cellar: :any_skip_relocation, sonoma:         "e2e50fa2a044c8fde03fbe1e0c6a282075abfdf63c38f5c2ed9979875f76e5d3"
    sha256 cellar: :any_skip_relocation, ventura:        "ed11416cfa5a57359f8b749455e9cb9a52438ec862322d45e6495283a4ad25ec"
    sha256 cellar: :any_skip_relocation, monterey:       "d7d196967ef1f15c57bb3bd7abc8fded7dfdfd51997cd7f57de0b8380ba3ad6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e74ac8c2e23e7e83138c681b9c36cd81b0302ec948c57c3b97450c54773f201b"
  end

  depends_on "python-certifi"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/f0/73/f7c9a14e88e769f38cb7fb45aa88dfd795faa8e18aea11bababf6e068d5e/docker-6.1.3.tar.gz"
    sha256 "aa6d17830045ba5ef0168d5eaa34d37beeb113948c413affe1d5991fc11f9a20"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "retrying" do
    url "https://files.pythonhosted.org/packages/ce/70/15ce8551d65b324e18c5aa6ef6998880f21ead51ebe5ed743c0950d7d9dd/retrying-1.3.4.tar.gz"
    sha256 "345da8c5765bd982b1d1915deb9102fd3d1f7ad16bd84a9700b85f64d24e8f3e"
  end

  resource "scrapinghub" do
    url "https://files.pythonhosted.org/packages/a4/5e/83f599af82e467a804da77824e2301ff253c6251c31ac56d0f70bac9e9ce/scrapinghub-2.4.0.tar.gz"
    sha256 "58b90ba44ee01b80576ecce45645e19ca4e6f1176f4da26fcfcbb71bf26f6814"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/9c/97/6627aaf69c42a41d0d22a54ad2bf420290e07da82448823dcd6851de427e/tqdm-4.55.1.tar.gz"
    sha256 "556c55b081bd9aa746d34125d024b73f0e2a0e62d5927ff0e400e20ee0a03b9a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/44/34/551f30cbdc0515c39c2e78ef5919615785cd370844e40ada82367c1fab3f/websocket-client-1.6.3.tar.gz"
    sha256 "3aad25d31284266bcfcfd1fd8a743f63282305a364b8d0948a43bd606acc652f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shub version")

    assert_match "Error: Missing argument 'SPIDER'.",
      shell_output("#{bin}/shub schedule 2>&1", 2)
  end
end