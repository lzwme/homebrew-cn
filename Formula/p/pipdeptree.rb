class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/f0/ec/1a384c5f240c2a274001f3719595c87a80eb051e158efad5cf6a278579ad/pipdeptree-4.2.12.tar.gz"
  sha256 "1a441b1918dc70afb64cbb3f715f159459bb74395539ebbd0c0a2893c5cedeb7"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ce837919e948d01422b622514cd26fd0d076370ea11ead042bc95963fa284b49"
    sha256 cellar: :any, arm64_tahoe:       "21b0b5a51c51e119a2dbd99f6f25fa2d07e99b7ebe983a75736607b2e5c917b8"
    sha256 cellar: :any, arm64_sequoia:     "fee90b3597f9079468723ada1c7a398abf53574a33ce12c814544d07ebe50fcd"
    sha256 cellar: :any, arm64_linux:       "0a8eaf1e8310301f413d6d8df5842d4df2b3ff7c2b8bb769c15009c3eb1793ac"
    sha256 cellar: :any, x86_64_linux:      "1d6799eadf91c6f909addced7e7085b42fca495c60bfd3451affbb7565a1b3d8"
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
    url "https://files.pythonhosted.org/packages/3c/a9/e37ba832e0abdc50fdb24c467f19fa16a187dbc52902613d2664263a69ca/nab-0.0.23.tar.gz"
    sha256 "4754ba4f17faf09930a1b1093faafd641edab00e63fedb4c75e0cf856d13326e"
  end

  resource "nab-index" do
    url "https://files.pythonhosted.org/packages/ac/66/b0b6de69648644dbf01c030e56e52980851793b5556b0ba922d58fef6a3b/nab_index-0.0.23.tar.gz"
    sha256 "c75bbdc3a02ceaf4e7d81f00ef88023b5cc399c8e93e778ce146ea4dfa5ef662"
  end

  resource "nab-markersets" do
    url "https://files.pythonhosted.org/packages/c4/dd/d90ecc6152dca0ea1e6a77f82f135c3642147cc321becf6aea6e526e2781/nab_markersets-0.0.23.tar.gz"
    sha256 "9ca0b1b5c98b6cf82feecc07c06a558f9e915d17577a747ef05c001210194f60"
  end

  resource "nab-project" do
    url "https://files.pythonhosted.org/packages/aa/28/435a8d3ad9beb39d2367bcee81c61a97dd169bf00d09be58d508a25a0bf7/nab_project-0.0.23.tar.gz"
    sha256 "a2a3b842597a21e763dc1642b8adab6d2efd5e6d1307c3c2f6cac4bf7d86d29e"
  end

  resource "nab-provider" do
    url "https://files.pythonhosted.org/packages/fa/53/9e3078e0974694e00843ad0bc97dc377553b9a8da6243bf4fe485d04c3f0/nab_provider-0.0.23.tar.gz"
    sha256 "be51639dd663708893a73692382a8d71c9b77fc5544a7ecddc9415b28d39d814"
  end

  resource "nab-resolver" do
    url "https://files.pythonhosted.org/packages/9f/a5/442183a62cd2b7ca0aef64f774a0da7ae4334feafb234f2ced017f810361/nab_resolver-0.0.23.tar.gz"
    sha256 "63a36fd319d2de8a244cfca0261452d1d5017ac8ef17b3392fd8daaa3f7e994a"
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