class Cekit < Formula
  include Language::Python::Virtualenv

  desc "Container Evolution Kit"
  homepage "https://cekit.io"
  url "https://files.pythonhosted.org/packages/98/cf/091d054e0bee657f4ed0e26a2f3384007c66a9eb57b009375ed1c0848f06/cekit-4.12.0.tar.gz"
  sha256 "797d28ac17a991643d851774a2564d02c788ca9b304517c375142374be8e17f8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "142a2fade6ffe2936932afda28102953c94087060814f0cdb1c59fefd40f934c"
    sha256 cellar: :any,                 arm64_ventura:  "70c98ab2a06446d7d060ccd139c1f7cb76adbfee70cc87464448d0f8590b3af9"
    sha256 cellar: :any,                 arm64_monterey: "da1ea7dfb5ed6ef62bcde6e78d95d63285f0cfdcf3f4df285075de83240d0b11"
    sha256 cellar: :any,                 sonoma:         "84ab2e65708925d76f7a9728ce947fbb8e7fdcc5168e8dc5e63ade19931f256f"
    sha256 cellar: :any,                 ventura:        "94bad49481453179b1370bb3b6eace416eda2bc950dba5b63ff7d0a6ccc086db"
    sha256 cellar: :any,                 monterey:       "74721fe4d7f7cbbbcdeea2cac13cfd8e5af5ee7a0a90b1c1d13e75be3aed695f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2710a194fd415900ebb6c822caf100acdf3506fbdc35a115f7872abb25626fe"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/db/38/2992ff192eaa7dd5a793f8b6570d6bbe887c4fbbf7e72702eb0a693a01c8/colorlog-6.8.2.tar.gz"
    sha256 "3e3e079a41feb5a1b64f978b5ea4f46040a94f11f0e8bbb8261e3dbbeca64d44"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
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
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/29/81/4dfc17eb6ebb1aac314a3eb863c1325b907863a1b8b1382cdffcb6ac0ed9/ruamel.yaml-0.18.6.tar.gz"
    sha256 "8b27e6a217e786c6fbe5634d8f3f11bc63e0f80f6a5890f28863d9c45aac311b"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/46/ab/bab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295b/ruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    # Work around ruamel.yaml.clib not building on Xcode 15.3, remove after a new release
    # has resolved: https://sourceforge.net/p/ruamel-yaml-clib/tickets/32/
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"cekit", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cekit --version")
    (testpath/"test.yml").write <<~EOS
      schema_version: 1
      from: "scratch"
      name: &name "test"
      version: &version "0.0.1"
      description: "Test Description"
    EOS
    assert_match "INFO  Finished!",
shell_output("#{bin}/cekit --descriptor #{testpath}/test.yml build --dry-run docker 2>&1")
    system bin/"cekit", "--descriptor", "#{testpath}/test.yml", "build", "--dry-run", "docker"
    assert_predicate testpath/"target/image/Dockerfile", :exist?
    assert_match "FROM scratch", File.read(testpath/"target/image/Dockerfile")
  end
end