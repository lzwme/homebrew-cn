class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/54/a1/3de42a85245b0f1748ead3c24b45cbd1a8ceb7af616f5fa8025b3f38a230/ansible_creator-25.8.0.tar.gz"
  sha256 "286e93bf93aa7388587fdaffe733a206f41246e8691dbba39b491ebfcced460d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "28e881c4b229e59fd052cba3a84ebe9b126e1fece3d3de29faf0ca8588fba8bc"
    sha256 cellar: :any,                 arm64_sonoma:  "69ffaacbc65803c3691152d300a59f5b3757a4dad08bf52281241d6b2451e541"
    sha256 cellar: :any,                 arm64_ventura: "12f737e1a9dadd3c95fd9f9108c05934839f3f7363a0859f7739fcb0651dd214"
    sha256 cellar: :any,                 sonoma:        "ee0a676eb7f57925603fc02c15e9bc1e7351eb0da5668d1c49728b9b208af576"
    sha256 cellar: :any,                 ventura:       "fc0c58e14f8bfe593f9e89071e432b6be2cd871f208ffbf0bc46e84425ffbdab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2750a74f0319c0f7fe14507d698ad0677781fa3bb2196a676cf6ad2b7857c046"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9ca066c9779be1c89ec4d7f2a339434d4b07e98c064422ea80a8057f824ef5f"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
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