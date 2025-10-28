class CodecovCli < Formula
  include Language::Python::Virtualenv

  desc "Codecov's command-line interface"
  homepage "https://cli.codecov.io/"
  url "https://files.pythonhosted.org/packages/18/8a/7ffb9a25cef38d2313c5c407026f90e8f07f92f2b787a697b00a1058feb4/codecov_cli-11.2.4.tar.gz"
  sha256 "07a2f080f32be52dc7948b10a289279c8758e0e3f235d48b513562e0ba68c2c0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7c5642987e6af96a43db21f9f77f1f9e9884d99152850f2d4991be153db4053f"
    sha256 cellar: :any,                 arm64_sequoia: "e8ffd249a86f49a57366907819b41a72251caa8ea1d9e2aa9f923e2fa2453904"
    sha256 cellar: :any,                 arm64_sonoma:  "509090478deb7f4040d6869265702780a6c486c5c7bb9c8033c8fe18ef5f698d"
    sha256 cellar: :any,                 sonoma:        "f2f7c99521314e8a9e4893330cabdcb485ac20f88a5702793863ec951bd5a172"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a21ceac6c63bcf9971637549f9cb872ee79377073cc8759349ce957eb295eb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af223ada0d675032642f8e77c53566697f4dd810549d6a787c899eae02a3c7a0"
  end

  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "ijson" do
    url "https://files.pythonhosted.org/packages/2d/30/7ab4b9e88e7946f6beef419f74edcc541df3ea562c7882257b4eaa82417d/ijson-3.4.0.post0.tar.gz"
    sha256 "9aa02dc70bb245670a6ca7fba737b992aeeb4895360980622f7e568dbf23e41e"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "responses" do
    url "https://files.pythonhosted.org/packages/6d/db/b949a6bf2a75c64caea0a6b39d05e433aa2e51bea78ae9d5dda1110b31a5/responses-0.21.0.tar.gz"
    sha256 "b82502eb5f09a0289d8e209e7bad71ef3978334f56d09b444253d5ad67bf5253"
  end

  resource "sentry-sdk" do
    url "https://files.pythonhosted.org/packages/31/04/ec8c1dd9250847303d98516e917978cb1c7083024770d86d657d2ccb5a70/sentry_sdk-2.42.1.tar.gz"
    sha256 "8598cc6edcfe74cb8074ba6a7c15338cdee93d63d3eb9b9943b4b568354ad5b6"
  end

  resource "test-results-parser" do
    url "https://files.pythonhosted.org/packages/e9/25/c6459ae54e5b57944417a8f72662d186ab43b0eae956193d6de281619ce4/test_results_parser-0.5.4.tar.gz"
    sha256 "2fbfd809a2c1f746360146809b6df30690c992463d7d43e7b1fed31c1a7c15b4"

    # Bump `pyo3` to support Python 3.14
    # Upstream version 0.5.4 is actually same as 0.5.1 and the next of 0.5.3 is not developing,
    # so manually add the patch here.
    # Issue ref: https://github.com/codecov/test-results-parser/issues/86
    # Related PR ref: https://github.com/codecov/test-results-parser/pull/87
    patch do
      url "https://ghfast.top/https://raw.githubusercontent.com/Homebrew/Homebrew-core/0a81f140/Patches/codecov-cli/support-python3.14.patch"
      sha256 "e6401a73c44388aa4ee4330436d91693f1a8d1ab8430d1d47a1730ec229a872f"
    end
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
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
    assert_match "Process Upload complete", output
  end
end