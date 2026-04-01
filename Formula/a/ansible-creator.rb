class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/8b/50/5a58ccf5abdd546b27e1af07b42115d2c230ae29584bfa9bfcd9a8be7cce/ansible_creator-26.3.3.tar.gz"
  sha256 "07e81c7e8436e4379039f189de7ddc48a0b3d21dd2b312202ec5953c6252890a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3f29cd17ed5a362196a2a8235765b3fea359121cf215a8cb6c41896f5570e08c"
    sha256 cellar: :any,                 arm64_sequoia: "0026d909b39c294366cf3a061b935ced90f95b3bc8347135891aeeca5779912e"
    sha256 cellar: :any,                 arm64_sonoma:  "17ed8329f477c3c383d4eeda6ff9ce5689733e8fe8194d85d44e33d2b37b4cd8"
    sha256 cellar: :any,                 sonoma:        "095027e7f4b8e7d97f4b5ec38f4a72abed4fd835b903014995e55bcd8cd367f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7749f1a28bf3b5f783aee2903cf204b79084d578e77cd334327492d324a8d6f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "538e919d5999005b353a8d267fcb7c993457b96f337dd927138260dcd8120d81"
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