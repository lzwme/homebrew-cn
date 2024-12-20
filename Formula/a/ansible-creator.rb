class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/2a/a9/b4ece27490fa6a94b9dd73cdedd16184ca09b8bd866c13fb2545b5d6e2e5/ansible_creator-24.12.1.tar.gz"
  sha256 "b739cb96ba17a76edc0bd2f5fcde76d75244ad7ed6afc63bb0cdb5385ba5234b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a528a20df14d7c8a02ed7b44b5b182fcaf9c3d388bfb93ef6cc99f796f2780e6"
    sha256 cellar: :any,                 arm64_sonoma:  "03e6e125d3c89d972227853ba1103a53f15e49864bd96c0bfe43f8541c707345"
    sha256 cellar: :any,                 arm64_ventura: "275776d0566ccb621660a4522ded6562de2ad92b3e995d584653a15cbafdeaf5"
    sha256 cellar: :any,                 sonoma:        "762597911fb7d6162523c2c2a4184329a240cc8af430298776ee828af1167878"
    sha256 cellar: :any,                 ventura:       "5f8fb4ff7acd92d7d61cf92cc5b04cc866f79e82c17b71ce7d66662ef32d4cd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d925ae42250f84375d204c3d625c1f58fb7802a7ea83c878a92b6b38b7c20d59"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
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