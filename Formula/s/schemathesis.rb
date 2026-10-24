class Schemathesis < Formula
  include Language::Python::Virtualenv

  desc "Testing tool for web applications with specs"
  homepage "https://schemathesis.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/01/f9/cf39b47702bca657c37c76e502da6974a1088bbad295525353406e0d0d20/schemathesis-4.32.4.tar.gz"
  sha256 "13faf4cc8a0f39f7a5c4b498cc656fa756205f2c1bc5d21d892323a85c3a0165"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ca206ed344ca3d52aa9bb759c38e7ed39b53fd065f35102ef0ade1d552110bcd"
    sha256 cellar: :any, arm64_tahoe:       "460c328613dc5007ed37e42ad04c4cfcd67dd45401957dcbc83da2691d5e8d65"
    sha256 cellar: :any, arm64_sequoia:     "595809221415f2a2c506e667fd7d81fb417897925dc596fb416e5f65734410ae"
    sha256 cellar: :any, arm64_linux:       "f7764c5adcbf860bcd2f1448c398c81f77b565952dbc77c0a96c04bfe9d1aaaa"
    sha256 cellar: :any, x86_64_linux:      "8ea853c5bdfcc1ececf502f19643f44c95157e779a3678f0987216aa50ada8a0"
  end

  depends_on "rust" => :build # for jsonschema-rs
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.15"
  depends_on "rpds-py" => :no_linkage

  conflicts_with "st", because: "both install `st` binaries"

  pypi_packages exclude_packages: %w[certifi rpds-py]

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a9/d2/f4d173e22df740bc37b1db102b386ba719b66e95b0f0d751f556b387e6d2/anyio-4.15.1.tar.gz"
    sha256 "9f28306018cbd6d329e64a36d58256edff76dd996fe423bc957326e578b82a94"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "graphql-core" do
    url "https://files.pythonhosted.org/packages/fa/90/dfade6d16a55abb45e41b215fcdc940e4f119a6ac7d87430d45d020b659f/graphql_core-3.3.0.tar.gz"
    sha256 "fd3424e88af3f3211931c6ff96350f1cd9069cf0f1a31b9972899e35d39136b5"
  end

  resource "harfile" do
    url "https://files.pythonhosted.org/packages/42/03/d0c14a45c41820731e537ae92586d1aebe1a333a3347cef4f69a467c2d90/harfile-0.6.0.tar.gz"
    sha256 "3e5751d52c59bda35789748256cbac097b664e65315d15ded67b006c173e34b3"
  end

  resource "hypothesis" do
    url "https://files.pythonhosted.org/packages/05/a8/c290eb70e3d6d8e39d2d93556812bbcfc4269b839239505b246cf276e747/hypothesis-6.170.6.tar.gz"
    sha256 "fc6a32aff0e042dd2d844b9cbf18346761835668025e40a9cc01d5c706e73285"
  end

  resource "hypothesis-graphql" do
    url "https://files.pythonhosted.org/packages/cd/d4/0ff754287dff35bb675b13ab46f8fd179f4d0bddec63f1369f15388c41b2/hypothesis_graphql-0.13.5.tar.gz"
    sha256 "d136615c0e11a4d50fd7212cbe69e9a78e2411aedcc945dba20f05df92e662f0"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/01/e1/2069291243c926a2ff1cd706c7f3eeb9b62144bf60f77c9fb9ff2fb26bd3/iniconfig-2.3.1.tar.gz"
    sha256 "67f4b9c50da0dedf52af349e7749a80a9057a5031199791b906c3bb3ae878960"
  end

  resource "jsonschema-rs" do
    url "https://files.pythonhosted.org/packages/eb/49/c93fca9ad43188d90609f92d0c65b27f872b9b2d5fada8ef0202ab7a073c/jsonschema_rs-0.60.0.tar.gz"
    sha256 "e43f7354e616380e49a1469d534f08f60fc58c6cb47c69494e8fbb2f9e8e872e"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/bf/db/7fc19e6f2dc92a966727031389fc2e08b558f0f25eb7403c1119ad4713cd/pluggy-1.7.0.tar.gz"
    sha256 "d1eaa46ebb595891b860ab086b4d09c8588af65ebd4361b8e8f4bb8920b90ba8"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyrate-limiter" do
    url "https://files.pythonhosted.org/packages/2b/0b/f69f1614940f29d51e31d4fe8de69b2b4d411094ba3c77f50da34dfb63c6/pyrate_limiter-4.5.1.tar.gz"
    sha256 "7f03c6a9235b00a4ba3c7b1e8cb6b23fbacc9d40b09f326220917a12ef22cc09"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/e4/47/b9efed96c114afcfa3c9d3fe98a76a1d14c74a9e266d397cf6eb64be5e01/pytest-9.1.1.tar.gz"
    sha256 "1088fbde8f2b49d95a549a195707afa7a76a3ce9bcadc26b6d71f0ffda5fe313"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/a4/34/4dd12fc8bb7d61c91467ec3efe415ffa7d5456f799954b40c5bbaeae470e/werkzeug-3.1.9.tar.gz"
    sha256 "55ca7c70a75689be937aa27f8ff4b018f06ff4838fc73045560bf0f5a1291060"
  end

  def install
    venv = virtualenv_install_with_resources without: "jsonschema-rs"
    resource("jsonschema-rs").stage do
      # Use ring instead since building bundled aws-lc is tricky to do indirectly within superenv.
      # Can consider switching if system copy is supported https://github.com/aws/aws-lc-rs/issues/936
      inreplace "crates/jsonschema-py/Cargo.toml",
                /^(jsonschema = .*), features = \[/,
                '\1, default-features = false, features = ["resolve-http", "resolve-file", "tls-ring",'
      venv.pip_install Pathname.pwd
    end

    generate_completions_from_executable(bin/"st", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/st --version")
    openapi_url = "https://httpbin.dmuth.org/openapi.json"
    output = shell_output("#{bin}/st run #{openapi_url} --phases examples --include-path /ip", 2)
    assert_match "Specification:    Open API 3.1.0", output
    assert_match "No test cases were generated", output
  end
end