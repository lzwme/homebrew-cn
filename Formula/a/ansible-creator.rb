class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/40/2f/93a08a9885c12a398d86b823c1b511f77be0950e2ab3280e403abd3982fa/ansible_creator-25.3.1.tar.gz"
  sha256 "bf4eb6443d20818a4d512bc3781428ab23b2d26fc87317c84b01b23309a7cf43"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "642b7e3829ecb6c2581db58bc24a4e84f469db05074df3c75383364e4a196d1b"
    sha256 cellar: :any,                 arm64_sonoma:  "a804387adb831355bc2c4aed559582739a2f136ae0311e2a35ede78a00123150"
    sha256 cellar: :any,                 arm64_ventura: "c031a91ab4a845f5f76437390ac49a3fb2e03e569423de9bf091dfa20b53fcc3"
    sha256 cellar: :any,                 sonoma:        "b1f329d6bd7ce63c7f02dbc58da1c97c23e81224677fef82577b180dc8be4656"
    sha256 cellar: :any,                 ventura:       "4b530be795955e13401edefff4fd6bc8b1144f63901412510f2724f5a31b97a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c32e3565ef4c323bb3d418c3c95dd22a2d1a56d04cf4f27ebc540bad4c0ed418"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f62be4a119cef6fd0501ee651035fc0234200cf5ca3fe2026541754cc9d0493"
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