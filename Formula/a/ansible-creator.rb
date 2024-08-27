class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/f4/cc/4933e56147b0c98d18507f563074d0a06eb46587e932a378795a5fef638b/ansible_creator-24.8.0.tar.gz"
  sha256 "51bd406fe06006657bdeb2ee48edb53082d564f06e2ed876be771ef20cf9b331"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2d09b550aacab6a9b530c59b2b8f8e60a6bd5ee60f4086a724d5df974c2a6837"
    sha256 cellar: :any,                 arm64_ventura:  "06d8e2af4851eda7535af8387604a183725891a330bba97064fd9019ab21f788"
    sha256 cellar: :any,                 arm64_monterey: "67ef35e9b6f66afcdfdab3b7c289d9c8451f8989771151438c8637a135b6b488"
    sha256 cellar: :any,                 sonoma:         "9ad62072008d0ddad44ca1021ef53540cbf14c5db7845c5cc5607858762ae7bc"
    sha256 cellar: :any,                 ventura:        "69995510a562de4a9fe39ac9c83c0212bce5e566217dc578ae2c831abb6a3bd9"
    sha256 cellar: :any,                 monterey:       "74d84a2bcd04e378fd08c817469a8fb8fe1864b66dfbb4cb4fb7016fb4974bad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb8b90b5145387e50fca7e84e7e5f309bcfc1890d2b316dc3cd0f33a60cfe6ae"
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