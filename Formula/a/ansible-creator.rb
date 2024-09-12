class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/6e/1c/46c00f69a398f1d6de633706502de146428243c3280df71901794b873ca7/ansible_creator-24.9.0.tar.gz"
  sha256 "ae3dbdf0550aef77da8866c6e297816016f32e43c53b402eb02f6553952e89bc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "01c373f6066de75b0cbd3a9102db9a7d0cf43a6e6c16f2462e4da1906483a8e0"
    sha256 cellar: :any,                 arm64_sonoma:   "03f7fb850cd67c6c16727c6c259110190dcdfee338e34072b34b9f1e89cb3729"
    sha256 cellar: :any,                 arm64_ventura:  "b1f37a20232e7151fcb32997826bf6052d82aa3b73dcfb7d683fd9f5b66b2498"
    sha256 cellar: :any,                 arm64_monterey: "7206a94c85b85c55b5a46dfc2ed6893e4d695cb26d803a478b9d6e73015475ba"
    sha256 cellar: :any,                 sonoma:         "316dfa1615a516a13e64f2d1eb257d3497d2f454426e2e4dd978d425c562475b"
    sha256 cellar: :any,                 ventura:        "8800ce1c19d6dfc7ac60201d044718f83f3137a3568fe8195858694d64383116"
    sha256 cellar: :any,                 monterey:       "abd7998a866c73600c61650fc97e24145837f26489826f33e5af53c12cc03da3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "667983a812e9e604e64d8af9a9ac1f422d7a37385d1957ea1cbfd71220cd4121"
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
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
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