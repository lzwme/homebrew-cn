class Cekit < Formula
  include Language::Python::Virtualenv

  desc "Container Evolution Kit"
  homepage "https://cekit.io"
  url "https://files.pythonhosted.org/packages/19/bf/e6f731ca9eae441dbf08d4af91ed3fc76eb021f1e5870dff3692936bb50b/cekit-4.15.0.tar.gz"
  sha256 "3ced63835728e6fe43c63583ca0b1a45e65b573230ec9cb73dcd3aa9aa0a5aa9"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "d2f8831c610b2abfb398c173417afc377e77a70b94db09a123f23c052450c0f3"
    sha256 cellar: :any,                 arm64_sonoma:  "8139a72bc96db48f85d9d70ad38378a5556c947f02e5f6810b577962e7e181f5"
    sha256 cellar: :any,                 arm64_ventura: "e6158e2fc700c8f20fc57fc40541b5ad677bb260caf43b5fbcec7c8cb95ef206"
    sha256 cellar: :any,                 sonoma:        "8a029bcd505e6ea9e20b419b8e4f8172a759dc16ff2099e63d9408388e093744"
    sha256 cellar: :any,                 ventura:       "5f64f4d851ea7703fa7f204be8261607ee35219fc95bca447adbf94d3fb8f6b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6251e9a307320ecf348e1270a2ec03811427460d276fceebd57dd45d45fb92fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9aaa87b50f5774325dca9be632a0d79ae75c1dc07c7d65c57f99e99ee3134d4d"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/d3/7a/359f4d5df2353f26172b3cc39ea32daa39af8de522205f512f458923e677/colorlog-6.9.0.tar.gz"
    sha256 "bfba54a1b93b94f54e1f4fe48395725a3d92fd2a4af702f6bd70946bdc0c6ac2"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pykwalify" do
    url "https://files.pythonhosted.org/packages/d5/77/2d6849510dbfce5f74f1f69768763630ad0385ad7bb0a4f39b55de3920c7/pykwalify-1.8.0.tar.gz"
    sha256 "796b2ad3ed4cb99b88308b533fb2f559c30fa6efb4fa9fda11347f483d245884"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/ea/46/f44d8be06b85bc7c4d8c95d658be2b68f27711f279bf9dd0612a5e4794f5/ruamel.yaml-0.18.10.tar.gz"
    sha256 "20c86ab29ac2153f80a428e1254a8adf686d3383df04490514ca3b79a362db58"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"cekit", shells: [:bash, :fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cekit --version")
    (testpath/"test.yml").write <<~YAML
      schema_version: 1
      from: "scratch"
      name: &name "test"
      version: &version "0.0.1"
      description: "Test Description"
    YAML
    assert_match "INFO  Finished!",
shell_output("#{bin}/cekit --descriptor #{testpath}/test.yml build --dry-run docker 2>&1")
    system bin/"cekit", "--descriptor", "#{testpath}/test.yml", "build", "--dry-run", "docker"
    assert_path_exists testpath/"target/image/Dockerfile"
    assert_match "FROM scratch", File.read(testpath/"target/image/Dockerfile")
  end
end