class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/b8/08/1516006b7ea61906e70b1504c2702a22c97415ee91bf00bb9b1799692b8a/pipdeptree-4.2.6.tar.gz"
  sha256 "e6361a93fcc230669a6a47ce4a55ed812ad508ed4720aad90242b0f038643018"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ee562ea020e58e6646f5bbe41f091d7fd0adf7b0ef65ce932d9dbf6607f0cf1c"
    sha256 cellar: :any, arm64_tahoe:       "f41c23cc4af0a567ff25781285e68c20eb9fdb67f7e921a6f2ee94c171909eeb"
    sha256 cellar: :any, arm64_sequoia:     "f56fd7ef54749927d5248066f39781ad250e8eb9593b88b66c69375ae863e6ff"
    sha256 cellar: :any, arm64_linux:       "b42d43d914a2d5fcfb2e694288c89a4583304f7379b493a093d9b36da37401c8"
    sha256 cellar: :any, x86_64_linux:      "7b65a31a80c4d612bfea5f4831a8f40a36052c98ba11438e523eb996ffc96a52"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "rust" => :build
  depends_on "python@3.14"

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
    url "https://files.pythonhosted.org/packages/9f/21/e7199e089d7bfeabfd1cc5de49d99c8be930acea2eb98a5bac9df78b4320/nab-0.0.18.tar.gz"
    sha256 "f34b19146b2b1ac1d34108ff69525758202ad20f39a8ceb9a3649013c083e97c"
  end

  resource "nab-index" do
    url "https://files.pythonhosted.org/packages/5e/50/b4b7f99a5b001f47af263701990621358731dde8798cc3e60cbe49ef109b/nab_index-0.0.18.tar.gz"
    sha256 "e53803a771edd086859ac4be35f68204868b067e2d74061375d24e31036c27b3"
  end

  resource "nab-markersets" do
    url "https://files.pythonhosted.org/packages/06/6d/ba6a28e8eb04c2f7a548abfb5db2debf965ca4a5a94596531ce1e0060b3b/nab_markersets-0.0.18.tar.gz"
    sha256 "a8353c7a435d4b232eb0718a009309fe56b30af252d376a77b273f639fda2aa7"
  end

  resource "nab-project" do
    url "https://files.pythonhosted.org/packages/2a/dc/7ebc631b9ad6a9cad5bbe08b68c4366e2874744853d0ee9529ae51854d1f/nab_project-0.0.18.tar.gz"
    sha256 "e60bc27d893c3012b138f1f40a803cf45a9b7c24ebf88d52fcfe8b17c986a708"
  end

  resource "nab-provider" do
    url "https://files.pythonhosted.org/packages/b6/a5/8a36478f76942d3abb6deff396d2b8c50838bca52674f4a361ebf0550bfd/nab_provider-0.0.18.tar.gz"
    sha256 "9c6838f5f2be2c328c4b0af7cee38846d66e3a430505c4945e7ae7d3ff6fb810"
  end

  resource "nab-resolver" do
    url "https://files.pythonhosted.org/packages/6c/03/5ecf2c2bf0e93e44a2e4f0a396d79cd9b6e98d790ecf5c9d9c3bb34e5a79/nab_resolver-0.0.18.tar.gz"
    sha256 "161f4613aa5394827f939fee369d881340455811ff5fa105c4688b978955c3b4"
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