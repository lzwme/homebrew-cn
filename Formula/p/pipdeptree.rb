class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/33/d4/ebf30a47d97e1edcb2d6ab1781f62eef341675ed350f24456d2a58ad4354/pipdeptree-4.2.7.tar.gz"
  sha256 "902e63188477951acca885e59a25cffc91fed7e2d372e205d96324e5f87d1736"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "a303c9b5d597b6f54f7095e8574d3c9ce7158f2b0acf2bebeb0b90095148ccf6"
    sha256 cellar: :any, arm64_tahoe:       "b0d738e45474ccef18c1ad7736b3cd29a2a2c40b1cdee48e2a4b94879ed4fb05"
    sha256 cellar: :any, arm64_sequoia:     "bdf8a94f6211ddc96f75ce21a4ae6a6b5f47edbfeb29ff4403c3570a23dc3ecd"
    sha256 cellar: :any, arm64_linux:       "4dee9cd4a19e9041b3eaaf5b8231ca9962979324e07664ee1641c54b2a20e509"
    sha256 cellar: :any, x86_64_linux:      "5484feb37ef4bfd643ca78773a1210643aff103a86330666ef126be71e2afb51"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "rust" => :build
  depends_on "python@3.15"

  pypi_packages exclude_packages: "meson",
                extra_packages:   "meson-python"

  resource "build" do
    url "https://files.pythonhosted.org/packages/bd/67/4898a44ea4f3f8e213b0954ec0aa0a16971d62a6212d6ea3931e97115b99/build-1.6.1.tar.gz"
    sha256 "51cc11666391ab6f092070437ac747002ff46f3e4113a3622177ee6b488bfc53"
  end

  resource "installer" do
    url "https://files.pythonhosted.org/packages/06/fe/b9f481cf0cc867958a21338baa900357b7b7d86cac9b025948049d77923c/installer-1.0.1.tar.gz"
    sha256 "052c7fc3721d54c696e2dea019be67539d7b144e924f559f54beb3121831c364"
  end

  resource "meson-python" do
    url "https://files.pythonhosted.org/packages/b4/40/343ae23722d5d66a7b94b752d1b194202640995296379333b274b1860871/meson_python-0.22.1.tar.gz"
    sha256 "52c88628b0e5671592dc2306613fb5f6f3615fd24def059b9894f143b7f9a139"
  end

  resource "nab" do
    url "https://files.pythonhosted.org/packages/47/17/de0ca73740d27f415480576269402288cb991b86c2a45ea5deadfb82c834/nab-0.0.19.tar.gz"
    sha256 "d6ab94d37d1a2f8438a775eee3d9e21ed4b0f27b39d0eab7eafe5d3cc6ceaf0f"
  end

  resource "nab-index" do
    url "https://files.pythonhosted.org/packages/dc/61/d7319fc9634fde5fbd6f7b5d247c94fda65dad8e8c8d38ac1407b0b4b034/nab_index-0.0.19.tar.gz"
    sha256 "c53b929812cde53fbff85dc499bad8fce6568db585b50ece4aac5047b8292236"
  end

  resource "nab-markersets" do
    url "https://files.pythonhosted.org/packages/1d/de/03b35011370e2c27d9ee32142fcb55c793636ab4bb29a35c9e7f2ff52c34/nab_markersets-0.0.19.tar.gz"
    sha256 "7e7314ac8cbdfb0d025a0a5ca53eaac7a6b66059c033386832ff8d1bd0f1ba2f"
  end

  resource "nab-project" do
    url "https://files.pythonhosted.org/packages/ce/c4/df2fa66071ed7a92088f389bbcbbeef7fe2e473c936a15233fb979ac1312/nab_project-0.0.19.tar.gz"
    sha256 "a9788f5e3e75a30881208de28d0fd88577dcaae61bc889158faad958241d5d00"
  end

  resource "nab-provider" do
    url "https://files.pythonhosted.org/packages/1b/69/6ca9f24f44d8762875afab92c73088472f5ca433707f6eee11e9a224e65a/nab_provider-0.0.19.tar.gz"
    sha256 "2962dcf9711dd2d24e865c66e6eab283667561645ebb8e911e6f8c02f260629a"
  end

  resource "nab-resolver" do
    url "https://files.pythonhosted.org/packages/18/a1/b5b5c11a5729184b332360d37fcf68ede46f087aa56ea959b2417321cc65/nab_resolver-0.0.19.tar.gz"
    sha256 "1d3e00fe8a6d920721318b68bd0fa6fc06a89cffd3020f1465d5cf726fe1f49c"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pyproject-hooks" do
    url "https://files.pythonhosted.org/packages/6d/5d/f2ddeef4a855a102aaae5e97826a0260007522ab504421b75addfdb1517c/pyproject_hooks-1.3.3.tar.gz"
    sha256 "defda19b854fa0d3bd4f76ea4ddcba8abd7dcfcdd585a6690ade050744fc5f43"
  end

  resource "pyproject-metadata" do
    url "https://files.pythonhosted.org/packages/4f/76/1cae539918a7b1746d624c2f01560b793c22cd8c081157505bb9bbf0e34d/pyproject_metadata-0.12.1.tar.gz"
    sha256 "8809a4df6fe08279b39a8890669506ed3158e0617855ac9aff098fcbe772ae4c"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/b0/78/9ad63712633ed3ab5cc1a648d863d7e7da371e9425e209555a0fe711b695/tomli-2.5.0.tar.gz"
    sha256 "264507556cd8b8c8e7c6ee037cdf443a463f03f4c958e57195e3d369711b8ff6"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "truststore" do
    url "https://files.pythonhosted.org/packages/53/a3/1585216310e344e8102c22482f6060c7a6ea0322b63e026372e6dcefcfd6/truststore-0.10.4.tar.gz"
    sha256 "9d91bd436463ad5e4ee4aba766628dd6cd7010cf3e2461756b3303710eebc301"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  def install
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources.reject { |r| r.name == "meson-python" }
    # meson-python self-hosts via backend-path; without isolation it uses brew meson and ninja
    venv.pip_install resource("meson-python"), build_isolation: false
    venv.pip_install_and_link buildpath, build_isolation: false
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end