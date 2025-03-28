class Breezy < Formula
  include Language::Python::Virtualenv

  desc "Version control system implemented in Python with multi-format support"
  # homepage "https:www.breezy-vcs.org" # https:bugs.launchpad.netbrz+bug2102204
  homepage "https:github.combreezy-teambreezy"
  url "https:files.pythonhosted.orgpackages15b14d7fe9b01f072bd18bf4c6c4bf546b9f18ad4c3890f3f11fbb4d20f5bdbfbreezy-3.3.10.tar.gz"
  sha256 "8e61aeb4800048d6f8fe43f701e510b571255387e64a999624caf46227b58cf7"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "953f2c4518d03c78707d4d40798f2a55c4e0d0a63dd2803d5ebcb314441a3959"
    sha256 cellar: :any,                 arm64_sonoma:  "8f32fda16f6689a564a25e036047c418595c3a06cdcf04e0b51074571e26f147"
    sha256 cellar: :any,                 arm64_ventura: "ad0652299906d2bc0bd95b1acae8c3ca9e2b76d3746545f21c73ad9992931b99"
    sha256 cellar: :any,                 sonoma:        "9e54ebb52a8576b7983f42d7f3ae27bbb430bb4e5b881e8bd3ba689b6ae01777"
    sha256 cellar: :any,                 ventura:       "67d191b07ab1963849658db4d4c3f6a757b3ddf6522b1aae449e4ba89905e9d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "955b1346b70d2ad83c1ce2ad175d5dea82fbaa6efbb434949318c8dcc41aafe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be768800e32cba68921581984289cbbf3d247036196caa888fb994ff6bf9f312"
  end

  depends_on "gettext" => :build
  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "configobj" do
    url "https:files.pythonhosted.orgpackagesf5c4c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "dulwich" do
    url "https:files.pythonhosted.orgpackagesd48b0f2de00c0c0d5881dc39be147ec2918725fb3628deeeb1f27d1c6cf6d9f4dulwich-0.22.8.tar.gz"
    sha256 "701547310415de300269331abe29cb5717aa1ea377af826bf513d0adfb1c209b"
  end

  resource "fastbencode" do
    url "https:files.pythonhosted.orgpackages5c1598e1cbac7871d9b12823c5869d942715b022c9091ce19a3ff6eb29dbff2bfastbencode-0.3.1.tar.gz"
    sha256 "5fe0cb7d1736891af61d2ade40ce948941d46e908b16f5383f55f127848da197"
  end

  resource "merge3" do
    url "https:files.pythonhosted.orgpackages91e1fe09c161f80b5a8d8ede3270eadedac7e59a64ea1c313b97c386234480c1merge3-0.0.15.tar.gz"
    sha256 "d3eac213d84d56dfc9e39552ac8246c7860a940964ebeed8a8be4422f6492baf"
  end

  resource "patiencediff" do
    url "https:files.pythonhosted.orgpackages1951828577f3b7199fc098d6f440d9af41fbef27067ddd1b60892ad0f9a2d943patiencediff-0.2.15.tar.gz"
    sha256 "d00911efd32e3bc886c222c3a650291440313ee94ac857031da6cc3be7935204"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaa63e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  # Apply Ubuntu patch for timezone bug introduced from switching tzlocal to zoneinfo
  # Issue ref: https:bugs.launchpad.netbrz+bug2103478
  patch do
    url "http:archive.ubuntu.comubuntupooluniversebbreezybreezy_3.3.10-1ubuntu1.debian.tar.xz"
    sha256 "8ef13e6117dbcc0ad4022a3456306c043223d3380f47db62c8754d904bee99d2"
    apply "patches20_fix_timezone_retrieval"
  end

  def install
    virtualenv_install_with_resources
    bin.each_child do |f|
      f.unlink
      f.write_env_script libexec"bin"f.basename, PATH: "#{libexec}bin:$PATH"
    end
    man1.install_symlink Dir[libexec"manman1*.1"]

    # Replace bazaar with breezy
    bin.install_symlink "brz" => "bzr"
  end

  test do
    whoami = "Homebrew <homebrew@example.com>"
    system bin"brz", "whoami", whoami
    assert_match whoami, shell_output("#{bin}brz whoami")

    # Test bazaar compatibility
    system bin"brz", "init-repo", "sample"
    system bin"brz", "init", "sampletrunk"
    touch testpath"sampletrunktest.txt"
    cd "sampletrunk" do
      system bin"brz", "add", "test.txt"
      system bin"brz", "commit", "-m", "test"
    end

    # Test git compatibility
    system bin"brz", "init", "--git", "sample2"
    touch testpath"sample2test.txt"
    cd "sample2" do
      system bin"brz", "add", "test.txt"
      system bin"brz", "commit", "-m", "test"
    end
  end
end