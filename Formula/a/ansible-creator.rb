class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/91/22/16b3dd85d5162a0810b390791567e063203ae56c8fb3f4d34d7f7ac8c352/ansible_creator-25.7.0.tar.gz"
  sha256 "3c7885b09ee82eae81141c0ef860c8727276166bfb2e4bbce1bcc7eca135537c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4ae9878d59121a3ea785cee529b61bab0f4197b1504e867e79cfbc795adfac53"
    sha256 cellar: :any,                 arm64_sonoma:  "25b3f364c8c527de7172416142da7e1698b2d4933f62b9c5b25d12bd4bfe2ec7"
    sha256 cellar: :any,                 arm64_ventura: "3f2b939d63fe13f7fd09ce42b3882f4d16726cdc5200da2d6541c4894527597d"
    sha256 cellar: :any,                 sonoma:        "7acaaa8d71cd498f0a955053263b1e48365b0710f015e6410d525ee37947a049"
    sha256 cellar: :any,                 ventura:       "de0b1f97fe9c4735a71b3ef2994a1dafccee2c34852ec36fc32272f7f869afb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea6b485a85343666c78386d32a7b7ea6e562b6b5e8dded4f6a2bf083c99bc11e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6d72a538e343fef718b25ff747ee7e380c37ce276cbbbf2c2e16c87880a0dfd"
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