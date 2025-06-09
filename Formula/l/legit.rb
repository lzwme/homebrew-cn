class Legit < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for Git, optimized for workflow simplicity"
  homepage "https:frostming.github.iolegit"
  url "https:files.pythonhosted.orgpackagescbe48cc5904c486241bf2edc4dd84f357fa96686dc85f48eedb835af65f821bflegit-1.2.0.post0.tar.gz"
  sha256 "949396b68029a8af405ab20c901902341ef6bd55c7fec6dab71141d63d406b11"
  license "BSD-3-Clause"
  revision 8
  head "https:github.comfrostminglegit.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e42ca33477abbbd0614ebe49a653974aeeda576e2ea6341f47c6c8a871eed61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e42ca33477abbbd0614ebe49a653974aeeda576e2ea6341f47c6c8a871eed61"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7e42ca33477abbbd0614ebe49a653974aeeda576e2ea6341f47c6c8a871eed61"
    sha256 cellar: :any_skip_relocation, sonoma:        "aeceabb740479fc3464b46e9fc3e88bfdfa3e893615637cc7d001ad76a5122ee"
    sha256 cellar: :any_skip_relocation, ventura:       "aeceabb740479fc3464b46e9fc3e88bfdfa3e893615637cc7d001ad76a5122ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9257305158412190881553a43bb05030c1660044521defd3aec90c009acc1393"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e42ca33477abbbd0614ebe49a653974aeeda576e2ea6341f47c6c8a871eed61"
  end

  depends_on "python@3.13"

  resource "args" do
    url "https:files.pythonhosted.orgpackagese51cb701b3f4bd8d3667df8342f311b3efaeab86078a840fb826bd204118cc6bargs-0.1.0.tar.gz"
    sha256 "a785b8d837625e9b61c39108532d95b85274acd679693b71ebb5156848fcf814"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "clint" do
    url "https:files.pythonhosted.orgpackages3db441ecb1516f1ba728f39ee7062b9dac1352d39823f513bb6f9e8aeb86e26dclint-0.5.1.tar.gz"
    sha256 "05224c32b1075563d0b16d0015faaf9da43aa214e4a2140e51f08789e7a4c5aa"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "crayons" do
    url "https:files.pythonhosted.orgpackagesb86b12a1dea724c82f1c19f410365d3e25356625b48e8009a7c3c9ec4c42488dcrayons-0.4.0.tar.gz"
    sha256 "bd33b7547800f2cfbd26b38431f9e64b487a7de74a947b0fafc89b45a601813f"
  end

  resource "gitdb" do
    url "https:files.pythonhosted.orgpackages190dbbb5b5ee188dec84647a4664f3e11b06ade2bde568dbd489d9d64adef8edgitdb-4.0.11.tar.gz"
    sha256 "bf5421126136d6d0af55bc1e7c1af1c397a34f5b7bd79e776cd3e89785c2b04b"
  end

  resource "gitpython" do
    url "https:files.pythonhosted.orgpackagesb6a1106fd9fa2dd989b6fb36e5893961f82992cf676381707253e0bf93eb1662GitPython-3.1.43.tar.gz"
    sha256 "35f314a9f878467f5453cc1fee295c3e18e52f1b99f10f6cf5b1682e968a9e7c"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "smmap" do
    url "https:files.pythonhosted.orgpackages8804b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baasmmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  def install
    virtualenv_install_with_resources
    bash_completion.install "extrabash-completionlegit"
    zsh_completion.install "extrazsh-completion_legit"
    man1.install "extramanlegit.1"
  end

  test do
    (testpath".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS
    system "git", "init"
    (testpath"foo").write("woof")
    system "git", "add", "foo"
    system "git", "commit", "-m", "init"
    system "git", "remote", "add", "origin", "https:github.comgitgit.git"
    system "git", "branch", "test"
    inreplace "foo", "woof", "meow"
    assert_match "test", shell_output("#{bin}legit branches")
    output = shell_output("#{bin}legit switch test")
    assert_equal "Switched to branch 'test'", output.strip.lines.last
    assert_equal "woof", (testpath"foo").read
    system "git", "stash", "pop"
    assert_equal "meow", (testpath"foo").read
  end
end