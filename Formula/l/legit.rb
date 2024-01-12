class Legit < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for Git, optimized for workflow simplicity"
  homepage "https:frostming.github.iolegit"
  url "https:files.pythonhosted.orgpackagescbe48cc5904c486241bf2edc4dd84f357fa96686dc85f48eedb835af65f821bflegit-1.2.0.post0.tar.gz"
  sha256 "949396b68029a8af405ab20c901902341ef6bd55c7fec6dab71141d63d406b11"
  license "BSD-3-Clause"
  revision 8
  head "https:github.comfrostminglegit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bf35a1a6e1101029ee08f9713ba1cef4ddd887916d8e902e90da1204e51a820f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97d187dbdb136475b548a0384c50dfc030d1252bec131fde0496e4fd3f1b8e2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ee5c11f90b94c2a083ea512c1db4f7bd77d115ac6237c2c1f268040f3bcced1"
    sha256 cellar: :any_skip_relocation, sonoma:         "65773708c583bac2bd6aa3838e05433355261092462f772ee99378366c96dddb"
    sha256 cellar: :any_skip_relocation, ventura:        "8ce625e22f6c4349fb622e04edd1d0f82af62c117cf82c808175e9cfe9d400e8"
    sha256 cellar: :any_skip_relocation, monterey:       "92ee73aafdc66c86179ea298fcdd9b2128c92da9ea80c549feb2e87b21ba4cc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d437ba4c8c5adf904a328ed44c5bc6e30de0c097fb7ec5500fcafa6996b4638a"
  end

  depends_on "python@3.12"
  depends_on "six"

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
    url "https:files.pythonhosted.orgpackagese5c26e3a26945a7ff7cf2854b8825026cf3f22ac8e18285bc11b6b1ceeb8dc3fGitPython-3.1.41.tar.gz"
    sha256 "ed66e624884f76df22c8e16066d567aaa5a37d5b5fa19db2c6df6f7156db9048"
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