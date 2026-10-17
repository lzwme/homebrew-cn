class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/c9/f4/776e26a631ac5e8af00a5ef7f0996777792d0609a076689168e7b2c327ca/pipdeptree-4.2.8.tar.gz"
  sha256 "b63e58d6f24f3a4326c1e07f5992789a7284ad3d84c0f36fe651f3f8c75393c8"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4e16035a53c1fa9f5c0bbb0c0737fdb3cd78d522f38be0f936bf2c54ea6cc8a2"
    sha256 cellar: :any, arm64_tahoe:       "4dddb6bf9b8bf0b8b547f718346e9cb95730764fc5f4914afea167ea19593210"
    sha256 cellar: :any, arm64_sequoia:     "38448e0f644f24c73ced4f851466a4393011779a762654f58bb3f86677c5b5db"
    sha256 cellar: :any, arm64_linux:       "2763abdf16d7292469ce3749e5ace4fd7f0cb2ee9d7cd9b24f9c8e3a524e8c9b"
    sha256 cellar: :any, x86_64_linux:      "754c6935145ea1272df51b94b3958f07c5d4ef5370a8f4a362c9f5dbc7bc0f4d"
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
    url "https://files.pythonhosted.org/packages/56/d3/2fab33d15004d41ae8e7b5d3e310510f7f34a7e1dd032a3e60d8b38d8fba/installer-1.1.0.tar.gz"
    sha256 "5adc0c01ce62d809989e246987cd68944fe5df8af562d0358f65b2ab15cb5de7"
  end

  resource "meson-python" do
    url "https://files.pythonhosted.org/packages/b4/40/343ae23722d5d66a7b94b752d1b194202640995296379333b274b1860871/meson_python-0.22.1.tar.gz"
    sha256 "52c88628b0e5671592dc2306613fb5f6f3615fd24def059b9894f143b7f9a139"
  end

  resource "nab" do
    url "https://files.pythonhosted.org/packages/b6/15/fd49f67bf3e9b559c78dbd79c393214377ea78b858541ef47e9cfd1fcb4d/nab-0.0.21.tar.gz"
    sha256 "1cef7f26a758b1cdde7227d2e558a0f6e35d0858f6b918f65cb2e8ac45eb3fba"
  end

  resource "nab-index" do
    url "https://files.pythonhosted.org/packages/35/1d/cd81258161ebe3f7562614eb05a30370168d57c19d0e4b76f42d83c38b4c/nab_index-0.0.21.tar.gz"
    sha256 "51c8e37936fe5af85791791bf8eb46a881b5378edcb4d363b6610646f17489a6"
  end

  resource "nab-markersets" do
    url "https://files.pythonhosted.org/packages/a9/0f/2d6ea329bd7132ca9098b93dfb15555d89361c2219dc917040ffece7986c/nab_markersets-0.0.21.tar.gz"
    sha256 "0fa9f90c4fe9aa92700e8be97b738353afe751ba6e6b4c80f62806c2b22e9f08"
  end

  resource "nab-project" do
    url "https://files.pythonhosted.org/packages/cc/f3/649a8080e4ba15aea3b4100727f50e45168c178c71f2ed9c871a3aeda9e3/nab_project-0.0.21.tar.gz"
    sha256 "d746a4c831527d3ba48113ccbd9d5cdb8ba165150eb2aa3291756b0488f22761"
  end

  resource "nab-provider" do
    url "https://files.pythonhosted.org/packages/34/97/e187dc33611dcb0acc4eaec8980436e1b0cf70dc4270108bbda67e5c50a5/nab_provider-0.0.21.tar.gz"
    sha256 "b3b9dd6c629df89ecd0b4d7a13287853ac8ef7bfd75675a22f94f54163795a90"
  end

  resource "nab-resolver" do
    url "https://files.pythonhosted.org/packages/e1/a4/b2bf789fd6d6b33cdf7200cd373f27e4a2b7457bfb787a1d37009e2de372/nab_resolver-0.0.21.tar.gz"
    sha256 "f44391325dbde953ca7309572659e9d0f4afd9a1dafdf55cfa6e79b77c852897"
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
    url "https://files.pythonhosted.org/packages/ee/9f/c5201d42a484c061e528825fc8e2d565f5abd50a4ced6fb7d29c4ec99b2b/truststore-0.10.5.tar.gz"
    sha256 "30d36967ccaded5cbb38d602c433f53600036c79d502f4533a49b60a03bbefcd"
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