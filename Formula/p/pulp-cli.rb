class PulpCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for Pulp 3"
  homepage "https://github.com/pulp/pulp-cli"
  url "https://files.pythonhosted.org/packages/53/3e/54362e5cd5c731759b2734cf0ced8956ebdc718dc5f8de261e0328f39986/pulp_cli-0.41.0.tar.gz"
  sha256 "7afca31354ac26d5ea8259f93ea286230765a7c9ce53170ed3d4e12aec9e520b"
  license "GPL-2.0-or-later"
  head "https://github.com/pulp/pulp-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1648e0bf7d414fe7dd308c53af5fb20fa86dfc2fc56e2553b6999f8b5fc0a16b"
    sha256 cellar: :any, arm64_tahoe:       "5e5142cf55c1200a733a3c4348194be34810309351338a7b242907b23a0632c9"
    sha256 cellar: :any, arm64_sequoia:     "6c600c81c3a1ae1b4f930c2407b050347210a37e022158ef674b4e3012bd8925"
    sha256 cellar: :any, arm64_linux:       "a74f69b2d0caaaaf098c0f07f9b4324a05bb3512a90674f30c7ad0a48ad26795"
    sha256 cellar: :any, x86_64_linux:      "68323ae857b2299a3ccd5aa71f66e354b2466296412a9e28935603c851b78c4a"
  end

  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[certifi pydantic]

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/c4/64/642465a4827331a98ba4ae29f97658be25d1bdcb868872a2f78f7482b507/multidict-7.0.0.tar.gz"
    sha256 "a7fcd089a0af2e0ef053c0d39c22c9ebf2434dddcb91034fd2f59ec99623788e"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pulp-glue" do
    url "https://files.pythonhosted.org/packages/77/70/074bcfdd3d5b97601ef2988e202e43c5c111128746c7695e64d5651f2b0c/pulp_glue-0.41.0.tar.gz"
    sha256 "f11a5d6bd056c29fc267899e085021d0904b4b77603fc79cb0a4888ba2e931e0"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "schema" do
    url "https://files.pythonhosted.org/packages/fb/2e/8da627b65577a8f130fe9dfa88ce94fcb24b1f8b59e0fc763ee61abef8b8/schema-0.7.8.tar.gz"
    sha256 "e86cc08edd6fe6e2522648f4e47e3a31920a76e82cce8937535422e310862ab5"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"pulp", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pulp --version")

    (testpath/"config.toml").write <<~TEXT
      [cli]
      base_url = "https://pulp.dev"
      verify_ssl = false
      format = "json"
    TEXT

    output = shell_output("#{bin}/pulp config validate --location #{testpath}/config.toml")
    assert_match "valid pulp-cli config", output
  end
end