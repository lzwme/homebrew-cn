class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/bb/a4/8f943e48e48cb3d953505313be4b4cc072e3c66ff3abcb2745ecf9a17676/ansible_creator-25.9.0.tar.gz"
  sha256 "f20e8ceb98606ddd0a60587118403f26916f2e53d01b6d42356e448c3e7fb76a"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e7f95da73ee7225f69646f98bc65a622671586865ef791db6a8175625e5c2135"
    sha256 cellar: :any,                 arm64_sequoia: "5a504978f04c1cc4d94087b0919f2c36d1dba931e860ada1273f3f659f1130bc"
    sha256 cellar: :any,                 arm64_sonoma:  "44e92b989165fde55a39ab1ccc644392a78d70f3f2b3c4ebccc7a564f50eb929"
    sha256 cellar: :any,                 sonoma:        "41047727afb4782394c49769d9f3909095045d5d52dda28168dfac1fd14ff3db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a87fabcb23c07bda20cd6fac50ef5fb36277ad5ede19d67534873c905c6b0b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c2a782354aeb1c84e8f6e4e80d105f72168f8f9deb7bf62ce31a63104f19b06"
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