class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/4c/f8/28768467e23a783b668d6c13067e31c2062887c5fff3c1a08722055939c5/ansible_creator-26.3.0.tar.gz"
  sha256 "5869bd30c7a72a8f3c0e54597cafc9805d6bbe0d19d4b8f5b42bbc7400d9b92d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a8a18f1ace1320008b78c347f1e6c553ff26cb45fe3ebfa113cab4d244a69093"
    sha256 cellar: :any,                 arm64_sequoia: "ef46df984930d0b11bed8d045f7a59921c593ec41b2145900779a70f1a11b0bb"
    sha256 cellar: :any,                 arm64_sonoma:  "75b8d683853ce249674ea8cfc70bfc084c63608b9f95225c124cf632a7d969b8"
    sha256 cellar: :any,                 sonoma:        "ceb8d34466e35b1ec4c1b35329b73860a0d07d98b1a689092790b022e611659c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e6c424de4e9ebbecae510d36326f4a1594d7451f55ff9bb9e150d1249bcd173"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1c60a33a747843bef9072ab17c11c9aeb70827daf7e8f1c1bdaf25f8a4df4f6"
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