class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/b3/92/a35f29614659ae0addedbf6f31e6340b41780ca09617a0de9456061e0017/ansible_creator-25.7.1.tar.gz"
  sha256 "860d2433d36066612509b7993fbe81fcc9fb2e1c9df60ae13086291bdfac7ee0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "51c900f8168f7ed93066226601e1cd2c24fdbc97c78a3a73c3912dd8feafcd07"
    sha256 cellar: :any,                 arm64_sonoma:  "a5109c58556558b1f435d4db0221ea92df66356b35afa83756616b2f38b234cc"
    sha256 cellar: :any,                 arm64_ventura: "d3c07d272a7b584ba3978872ffccdd75c607ff57be36a9e100434a1d3c837716"
    sha256 cellar: :any,                 sonoma:        "95aca1d3d3dac220cd5b41a1edead7697c425190c5941e9bff59f0d536154e2d"
    sha256 cellar: :any,                 ventura:       "00131f411e64c94ee05119e45ebbe3f3c23971acaefa42c4f12841abd17a90fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28dd836f55297e7ff3688ed7144c0015086afdd9b989be6de04b151c35ce5767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21f7495c4ce0b90ec2700472a33065a2788100d9bcbbb480264b68354fe98ca3"
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