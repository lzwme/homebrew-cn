class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/f2/cb/fcfbbb78792835a95d223a50e9bbd9bc66b12c6d46b21566f1a3a3bf47e7/ansible_creator-24.7.0.tar.gz"
  sha256 "f30bd039a7b39b6963a1b897b4c684eb69cba3fa1d175dbbf154669c2bfe3aab"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "012cc77c97452bc107a326a940dd25fd48f8bf35b0362ea140856da74574cc2c"
    sha256 cellar: :any,                 arm64_ventura:  "0d356c29412fdab32a4fec46a2972325a375c7c0154d682197b05dcfcfd6ed33"
    sha256 cellar: :any,                 arm64_monterey: "95da35737e255f6cdb263cc7832a2c9aa289493d2c6bf0173042e60902bdf408"
    sha256 cellar: :any,                 sonoma:         "112682d68f8173f906b9ab9d1ac570965487610f10cbe810f25b5c331f372ff3"
    sha256 cellar: :any,                 ventura:        "8238df48f5542b61c59e605bb923a1cf21984a319f060197ceee680774c16c5c"
    sha256 cellar: :any,                 monterey:       "76560ed2889f08621f41099fc1b7210260bafe0affba3ce8d6b1a2505677d5f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e186f8e4c8619fd8a23ca11bf8bb0318fb6acb731f71a20aa1da6da6a684104b"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["ANSIBLE_REMOTE_TEMP"] = testpath/"tmp"
    system bin/"ansible-creator", "init", "examplenamespace.examplename",
      "--init-path", testpath/"example"
    assert_predicate testpath/"example/galaxy.yml", :exist?

    assert_match version.to_s, shell_output("#{bin}/ansible-creator --version")
  end
end