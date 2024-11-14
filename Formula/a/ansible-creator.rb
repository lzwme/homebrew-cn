class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/6c/4e/0e9075f3a4eedcc2a8e87fc126da033a9ddb797279d93ee7132fd87fba6b/ansible_creator-24.11.0.tar.gz"
  sha256 "21f0baa7a37798f2b3c34a17e1c51873f95a33e8e4d2a68c66e39fd8bd33399f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "14da9244629ff431f2a464a9932386ca36af77af49b028d1deaad6d9e1ad805c"
    sha256 cellar: :any,                 arm64_sonoma:  "4b113069073e833c15b33a2bd483814c0b188e18c9f5c4c4c25c37fb326d386e"
    sha256 cellar: :any,                 arm64_ventura: "1bb7b328d01cb970118e611f4786bd01a30082c7f4861dd004ba0d382ae21cec"
    sha256 cellar: :any,                 sonoma:        "1990c714f1efe8301ed669281dd6e03d40111dfe473c4665db2db705ee1f0a0f"
    sha256 cellar: :any,                 ventura:       "b23e57d04fd3ae58a8a5380f011bb91685bc5dbc9db51281f5a66b3b386ebf0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c4d0c5d5cec0a3bf184fede354dbbfb6069a65719384b60ea75a94e87e36da6"
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