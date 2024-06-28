class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/49/85/be475bcc37aef4a755731ac3cd479855fadc65dda569050adcdfea7792b4/ansible_creator-24.6.1.tar.gz"
  sha256 "fc3caad7e0bda4a23718c5fd1c803af558e5d82c4eeed92ad98f746e3e101955"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b724cf2e144f92060e8394f993987c7f2045e9a6850240473b79b2ce681cc4a8"
    sha256 cellar: :any,                 arm64_ventura:  "6a9bdf751f04e33dfec716128bee91601a5f02883bd656b2c181e995f09ba034"
    sha256 cellar: :any,                 arm64_monterey: "6fb23d30ba63f963b06e475bcc1384d9d6d743d24622238ba2adb1e467ff0e7d"
    sha256 cellar: :any,                 sonoma:         "19fecb25f3afdc1f48eeea1c822d3fd4c8e0e2593ae27e41e28030c338220931"
    sha256 cellar: :any,                 ventura:        "2ff2114789b39c26193cc417ba89023b958b53bbfc26eb2055e74ce89c2952b3"
    sha256 cellar: :any,                 monterey:       "bd46dbbb41d75a350d966c3bfed1a564eb10fe494fb80624876b7d7ad422fe76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2781634907b4d8c968aebd9648a114906d7e3c0afdcd0ccf8b22ff1500babb1"
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