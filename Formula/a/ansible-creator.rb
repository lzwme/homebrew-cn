class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/b3/a1/74bbbc43d3c0b195060a91a69dabeb30462125a057d2d2d27601ce62b5c9/ansible_creator-26.9.0.tar.gz"
  sha256 "8f8d47009ebc33852e23137654c612532c78be0d97c1958432b6f6aa70d99d7c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d4933c2f33a837b83e2579e53fd01db4a60b752b4b46a9d6c54089dfe26cdd9e"
    sha256 cellar: :any, arm64_tahoe:       "b7df404feaf71519ecfd71337d66ca308083a53a2626ea7f71b797598362906e"
    sha256 cellar: :any, arm64_sequoia:     "6e396391a3e5ff60b02b4c1ce58f2686b93cd00418e4040a8720d08a5997ce74"
    sha256 cellar: :any, arm64_linux:       "3043c1662926dd48f2eb2ab20f6cc652fce972c006d95f764f3bf687201dbdb9"
    sha256 cellar: :any, x86_64_linux:      "cabc0d85a51bf77226ccf22d6da35999aa630c01d4a50c834f8fdac277daba27"
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