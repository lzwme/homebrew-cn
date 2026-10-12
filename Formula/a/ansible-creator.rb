class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/b3/a1/74bbbc43d3c0b195060a91a69dabeb30462125a057d2d2d27601ce62b5c9/ansible_creator-26.9.0.tar.gz"
  sha256 "8f8d47009ebc33852e23137654c612532c78be0d97c1958432b6f6aa70d99d7c"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "8beb9ffce6459afec3357b0ae9aab503784c7302f23099e7758691cab1897087"
    sha256 cellar: :any, arm64_tahoe:       "f8540645278b4420806ef87890c4d2c9fcd9557d7819cdacb4cb61e4d512c7db"
    sha256 cellar: :any, arm64_sequoia:     "d349416e729dffcf7fa7990b8a8bf70903a9ad3cc56ac9fb12c1dcb14eba6226"
    sha256 cellar: :any, arm64_linux:       "c9e1bc033515b5df28f91762a06e894625c4af3f484fbe30f5384f253117b807"
    sha256 cellar: :any, x86_64_linux:      "94da60590ae712a412b4fa820a0ef166d0ae4950d62ce22ffdc06cb6f7abae35"
  end

  depends_on "libyaml"
  depends_on "python@3.15"

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
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