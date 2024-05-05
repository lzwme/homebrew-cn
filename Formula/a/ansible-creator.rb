class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/51/91/5eede24e37b6d6699ce0748bbe7d2c6e74ff5ac0c6fa424ad684086c562d/ansible_creator-24.5.0.tar.gz"
  sha256 "dd814ed610b6fc44e8bd193530b2e547b309dd34ae5268d9fafeccbf14d9aedf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dea093fad581358a3aba951f8744a53fe1d3141081f97e874b7563e868048b6f"
    sha256 cellar: :any,                 arm64_ventura:  "76e5b5f435c4d28639636ae34db70a0e4e9e21ad146772b2b2e34cef4f057935"
    sha256 cellar: :any,                 arm64_monterey: "a2c9a610f5d0f3ff4d7ce42273168217f0988a786e19c2d9d65d3e4ce362a55f"
    sha256 cellar: :any,                 sonoma:         "0d9e2d4292c7139d901e432b29e6c485c51a89d0383d0e264f3183b2f02da223"
    sha256 cellar: :any,                 ventura:        "3350a568063a5bbfbff631f789186b7aa46d049dc12e606f717feb6ba7d9b699"
    sha256 cellar: :any,                 monterey:       "5eb27bef7da672d2d67cb0ba68860d8527ab6cc176d58c2f8ed3c2bd2ec39183"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ffb42a59d9fd3838d8d279af3bec065e16e1d9e2012e5fe9309b9372efa60d1"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/b2/5e/3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1/Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["ANSIBLE_REMOTE_TEMP"] = testpath/"tmp"
    system bin/"ansible-creator", "init", "exampleNamespace.exampleName",
      "--init-path", testpath/"example"
    assert_predicate testpath/"example/galaxy.yml", :exist?
  end
end