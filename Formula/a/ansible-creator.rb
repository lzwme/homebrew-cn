class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/d2/39/f8b94327f041d7755b9dd59a6c5792740b831a80659303aa12a4cf3739ca/ansible_creator-26.3.1.tar.gz"
  sha256 "22440fbf329720b0b82e0bcb66d0e688f87ca66b6f5cff73c7baeda59227e195"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2f25c2167ad49272fccef8df358f8bc5e073537a78c4e7c537d1b7a023ced623"
    sha256 cellar: :any,                 arm64_sequoia: "1710606c3cc3a68b19ccceaa5907c2f57100e01e0c8c97a563ba163931b8c24b"
    sha256 cellar: :any,                 arm64_sonoma:  "39d63a44fa98b4bb0ee6b327af0de9216bfcabf1f97ff6e955d8f8026c327930"
    sha256 cellar: :any,                 sonoma:        "db722a1f0f36d38c905e33366b063ed97ad4901bdbe3435dc527b59758cd5c52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3603e98df4796395ef80779b0c6a78b2a1e090f864646f1036724bb3104055b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "839b4dd868da0a85213baf6a7b18d123299fdd5f8563c43ebfc50e67919cefbd"
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