class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/aa/09/7106d9168736c544d4b1873c15c35ad96fb5daa4cda7803cc7b842aeb7d7/ansible_creator-26.2.0.tar.gz"
  sha256 "2afadfd9bb34e884c2ec2d49857c826efb10c2a06a385ecb8e297f5b115e7ebc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0dff250a365cbca6164bb2df14f569f4a49af59a1cd4035c096119f65f202936"
    sha256 cellar: :any,                 arm64_sequoia: "76700bfbb8a2c2d23e62d1d4a86691eb5198bef4a046f220e1a083727b924d60"
    sha256 cellar: :any,                 arm64_sonoma:  "036ecd3bb3ea840c91b576f178239e7151eb6121f76c3287133695602ccbe6a2"
    sha256 cellar: :any,                 sonoma:        "9e29a1dbcfb874cc890746419e9a9fd1006c04f9dc1c3ac223e24c21e886b847"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9a3c01385d60665d5b4d999c74a935048e065ef96c94d4034ada7af9b76e968"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6c68a95b3f773d8f32bb5bcf2956ed118e015a391599061b37b44ce7c6aa39f"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["ANSIBLE_REMOTE_TEMP"] = testpath/"tmp"
    system bin/"ansible-creator", "init", "examplenamespace.examplename",
      "--init-path", testpath/"example"
    assert_path_exists testpath/"example/galaxy.yml"

    assert_match version.to_s, shell_output("#{bin}/ansible-creator --version")
  end
end