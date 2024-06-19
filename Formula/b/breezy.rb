class Breezy < Formula
  include Language::Python::Virtualenv

  desc "Version control system implemented in Python with multi-format support"
  homepage "https://www.breezy-vcs.org/"
  url "https://files.pythonhosted.org/packages/94/15/6246755badf310cd8397cfc8b0e6cc454db6eec2a42d7a926ad2f72b4482/breezy-3.3.7.tar.gz"
  sha256 "e70e03277ffa97e1bc27a24b30539bd3132e6d0ad9512b91db6dd499c254980d"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "acc5e61e499526ca3dd0508fd0cca969722ce9a654825281df5f3e57770cfc76"
    sha256 cellar: :any,                 arm64_ventura:  "9b3260a8a19c24d0165063bc210f453c689779f251a586ef78fa2cd7a952d777"
    sha256 cellar: :any,                 arm64_monterey: "5efda26917990910f02c5d385f82c29cf9f717045ba6e99cf61cab8a578d9457"
    sha256 cellar: :any,                 sonoma:         "2439fcb60d8cd39e7bb6ebc9a1af0cadfe2b6ff343664abfb260b0b1e80979e0"
    sha256 cellar: :any,                 ventura:        "b69f346ef0f7b2493be6420b19db572a543e64e9c83c943906ca55233e3af935"
    sha256 cellar: :any,                 monterey:       "0e429466f9584326d10cda03effa737f938f1a5ffe253b64b03ff2680ee1142e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5e34be5aa5b67834d84077b3a87f120018a50851cbe5c4419a32996a3fe5f72"
  end

  depends_on "gettext" => :build
  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/cf/ac/cf6420b90832c4ffbc88b92962dd0167c58632c2b8d508d5baf4ecb0c61d/dulwich-0.22.1.tar.gz"
    sha256 "e36d85967cfbf25da1c7bc3d6921adc5baa976969d926aaf1582bd5fd7e94758"
  end

  resource "fastbencode" do
    url "https://files.pythonhosted.org/packages/5c/15/98e1cbac7871d9b12823c5869d942715b022c9091ce19a3ff6eb29dbff2b/fastbencode-0.3.1.tar.gz"
    sha256 "5fe0cb7d1736891af61d2ade40ce948941d46e908b16f5383f55f127848da197"
  end

  resource "merge3" do
    url "https://files.pythonhosted.org/packages/91/e1/fe09c161f80b5a8d8ede3270eadedac7e59a64ea1c313b97c386234480c1/merge3-0.0.15.tar.gz"
    sha256 "d3eac213d84d56dfc9e39552ac8246c7860a940964ebeed8a8be4422f6492baf"
  end

  resource "patiencediff" do
    url "https://files.pythonhosted.org/packages/19/51/828577f3b7199fc098d6f440d9af41fbef27067ddd1b60892ad0f9a2d943/patiencediff-0.2.15.tar.gz"
    sha256 "d00911efd32e3bc886c222c3a650291440313ee94ac857031da6cc3be7935204"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/aa/60/5db2249526c9b453c5bb8b9f6965fcab0ddb7f40ad734420b3b421f7da44/setuptools-70.0.0.tar.gz"
    sha256 "f211a66637b8fa059bb28183da127d4e86396c991a942b028c6650d4319c3fd0"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/04/d3/c19d65ae67636fe63953b20c2e4a8ced4497ea232c43ff8d01db16de8dc0/tzlocal-5.2.tar.gz"
    sha256 "8d399205578f1a9342816409cc1e46a93ebd5755e39ea2d85334bea911bf0e6e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
    bin.each_child do |f|
      f.unlink
      f.write_env_script libexec/"bin"/f.basename, PATH: "#{libexec}/bin:$PATH"
    end
    man1.install_symlink Dir[libexec/"man/man1/*.1"]

    # Replace bazaar with breezy
    bin.install_symlink "brz" => "bzr"
  end

  test do
    brz = "#{bin}/brz"
    whoami = "Homebrew <homebrew@example.com>"
    system brz, "whoami", whoami
    assert_match whoami, shell_output("#{bin}/brz whoami")

    # Test bazaar compatibility
    system brz, "init-repo", "sample"
    system brz, "init", "sample/trunk"
    touch testpath/"sample/trunk/test.txt"
    cd "sample/trunk" do
      system brz, "add", "test.txt"
      system brz, "commit", "-m", "test"
    end

    # Test git compatibility
    system brz, "init", "--git", "sample2"
    touch testpath/"sample2/test.txt"
    cd "sample2" do
      system brz, "add", "test.txt"
      system brz, "commit", "-m", "test"
    end
  end
end