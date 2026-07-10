class CodecovCli < Formula
  include Language::Python::Virtualenv

  desc "Codecov's command-line interface"
  homepage "https://cli.codecov.io/"
  url "https://files.pythonhosted.org/packages/7f/1e/31cd40f3439abe64ce4451b25ac27dd94637b3541057a3d399ac6128bcfc/codecov_cli-11.3.0.tar.gz"
  sha256 "3ed02305200fe82fc424b276f1dfb384530d5b73a4cb165e0d554f5d965149c6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e52aae9a99c5ea5594d18eeea1e108f55799581a86b85c9b5effa23fbfc5dda4"
    sha256 cellar: :any, arm64_sequoia: "95e2c6f090e98db1990036a95580ccb135226ea9e2f0d99dfcc575ccd931d624"
    sha256 cellar: :any, arm64_sonoma:  "1f5e1de6a2f25954ab91601c8afe0e9769692dd06fb9d4149b90977a3cb146a9"
    sha256 cellar: :any, sonoma:        "7c5cad89ae1a84c2273103918e9bafb950901b53c44407ef1427e128b1910d57"
    sha256 cellar: :any, arm64_linux:   "5befb33831ad3d3c1e60981d012b52e4c34429fc8ab62e427e3f396219321bec"
    sha256 cellar: :any, x86_64_linux:  "6166e483b54d52521caad2b73bab1d2c1e43ef2873c57582665fe2ed16982b21"
  end

  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/bd/2a/23f34ec9d04624958e137efdc394888716353190e75f25dd22c7a2c7a8aa/charset_normalizer-3.4.9.tar.gz"
    sha256 "673611bbd43f0810bec0b0f028ddeaaa501190339cac411f347ac76917c3ae7b"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "ijson" do
    url "https://files.pythonhosted.org/packages/3a/06/b31f040a8764336a11152e474a7abcb3782fedb0d1cdf78f442b82878c56/ijson-3.5.1.tar.gz"
    sha256 "af40bd1a85f55db0b8b30715c858761306bd92d5590148636f75c3309e6e76bd"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "sentry-sdk" do
    url "https://files.pythonhosted.org/packages/60/31/b7341f156a5f6f36f0b4845d6f1c28a2ae4799171dba7007f3a1e9b234b4/sentry_sdk-2.64.0.tar.gz"
    sha256 "68be2c29e14ae310f8a39e1a79916b6d85c6cb41dcce789d14ff05fe293e4c55"
  end

  resource "test-results-parser" do
    url "https://files.pythonhosted.org/packages/e4/bd/ee2278f92c6fdee1490c9dacd3ab5d6cdf61a26de988465723f52c17fb03/test_results_parser-0.6.1.tar.gz"
    sha256 "5ea92dc7ae84bd89e9c3fc375317d85c981f9d139c3cca1b0afe16d96e34e7f6"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"codecovcli", shell_parameter_format: :click)
  end

  test do
    assert_equal "codecovcli, version #{version}\n", shell_output("#{bin}/codecovcli --version")

    (testpath/"coverage.json").write <<~JSON
      {
        "meta": { "format": 2 },
        "files": {},
        "totals": {
          "covered_lines": 0,
          "num_statements": 0,
          "percent_covered": 100,
        }
      }
    JSON

    output = shell_output("#{bin}/codecovcli do-upload --commit-sha=mocksha --dry-run 2>&1")
    assert_match "Found 1 coverage files to report", output
    assert_match "Upload queued for processing complete", output
  end
end