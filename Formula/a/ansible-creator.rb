class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/a3/a8/cd7bc4d8261f412fad81c0c50cd5a3a881aab619d4ec2a20f42497105c90/ansible_creator-24.12.0.tar.gz"
  sha256 "f7b6124f48e79ce63f9f62a9744d2dac0ce95756f8dfc0eec5e01a86f581ea6a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "19d5d5b17c186bdb97638a3139b79232e331984b8a80b2e68abcc745030d32fe"
    sha256 cellar: :any,                 arm64_sonoma:  "8dc344d80d4ab8a783f2f9dafd5e2150d357b8e982873f9292dae28cb7a10794"
    sha256 cellar: :any,                 arm64_ventura: "0ba331d8a55ac519fe4d4f9e5b036c80e1c6ddf4552eef936d8ec4cd0bb04441"
    sha256 cellar: :any,                 sonoma:        "c62c75114c22d09777f273b6e0f303eeadcaca97b762a276efc447d4029afd09"
    sha256 cellar: :any,                 ventura:       "e732a0dc4a3900bdc42604340074c29578e2adfdea7bb77ebd4bbb5b627121b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "771ac014c3f7ecfe0c9c85cee319dc64e03b9b076ec1746d8defe5e0f4f8ba67"
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