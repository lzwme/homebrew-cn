class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/b4/5d/e712b0e27afca77fce327fab0c77ee6413dcce76b28a35dad189e7142070/ansible_creator-25.10.0.tar.gz"
  sha256 "328332df0da015f2a895cf9f17ce6af95b205644131f04c246aeb7b70f4487ee"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e8b7ff5333f87cc19cdbe8aef9dcca050324efe05d9b9971b725a833837a1a80"
    sha256 cellar: :any,                 arm64_sequoia: "688d1cfe893ab071529ee90354bcf083e8f76bb59fd9c0722192facbf35b4846"
    sha256 cellar: :any,                 arm64_sonoma:  "bac74ec1926b8e873a31d78a9b917919592c952f1734efd5f45e13aac409699f"
    sha256 cellar: :any,                 sonoma:        "41f057ae8f79ff0358fa71caff73b019767f849c583c1c341d6b8a11daf2dbda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "757f35f5e25e320ad10235d770134b326104c6c5c9e5a279a8f4b46a24fdd34f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2eacd170bc4e37f5fefb347443b52ed0fec7df8a5ebe75c7ae527a8025a8defd"
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