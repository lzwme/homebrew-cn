class CodecovCli < Formula
  include Language::Python::Virtualenv

  desc "Codecov's command-line interface"
  homepage "https:cli.codecov.io"
  url "https:files.pythonhosted.orgpackages3a7e7d916fa02a49d1f16fbb74498bdb95d005d008eb9792626b2468336297cbcodecov_cli-11.0.3.tar.gz"
  sha256 "0a6d92f51bc6bfb3c5bb6b59722ba3c32e1325f2d23562b4596e2c93782cadad"
  license "Apache-2.0"
  revision 1
  head "https:github.comcodecovcodecov-cli.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5b5bd1526ecfb25b6d23954b95b21a56e15a8a9b972b731c3ea5aa051e2295c3"
    sha256 cellar: :any,                 arm64_sonoma:  "fec967ee3ef0c8462db33a408060fe24fe2312348983bfd3b3974e092dce7453"
    sha256 cellar: :any,                 arm64_ventura: "daeb99e7b149654e093c60e84ef205918d968376b620aba659f3e442818d3a84"
    sha256 cellar: :any,                 sonoma:        "6c1e4bac47549d7d297ae3a34a5368604c25d987be28300239e4c9c2b5df5b83"
    sha256 cellar: :any,                 ventura:       "bed3efb52068ac475f9f089a1edded15ad185d3dc64fbc169f5b2552e6b61828"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6b2732d5753b0ea53e465fce020c1f38517cd127cf657650e8802fa00ffa0f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5266e46169fa78c2190466589d7d455d69824320153d9f7e29672409e459373"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "certifi" do
    url "https:files.pythonhosted.orgpackagese89ec05b3920a3b7d20d3d3310465f50348e5b3694f4f88c6daf736eef3024c4certifi-2025.4.26.tar.gz"
    sha256 "0a816057ea3cdefcef70270d2c515e4506bbc954f417fa5ade2021213bb8f0c6"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages606c8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbcclick-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "ijson" do
    url "https:files.pythonhosted.orgpackagesa34f1cfeada63f5fce87536651268ddf5cca79b8b4bbb457aee4e45777964a0aijson-3.4.0.tar.gz"
    sha256 "5f74dcbad9d592c428d3ca3957f7115a42689ee7ee941458860900236ae9bb13"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "responses" do
    url "https:files.pythonhosted.orgpackages6ddbb949a6bf2a75c64caea0a6b39d05e433aa2e51bea78ae9d5dda1110b31a5responses-0.21.0.tar.gz"
    sha256 "b82502eb5f09a0289d8e209e7bad71ef3978334f56d09b444253d5ad67bf5253"
  end

  resource "sentry-sdk" do
    url "https:files.pythonhosted.orgpackages2267d552a5f8e5a6a56b2feea6529e2d8ccd54349084c84176d5a1f7295044bcsentry_sdk-2.29.1.tar.gz"
    sha256 "8d4a0206b95fa5fe85e5e7517ed662e3888374bdc342c00e435e10e6d831aa6d"
  end

  resource "test-results-parser" do
    url "https:files.pythonhosted.orgpackagese925c6459ae54e5b57944417a8f72662d186ab43b0eae956193d6de281619ce4test_results_parser-0.5.4.tar.gz"
    sha256 "2fbfd809a2c1f746360146809b6df30690c992463d7d43e7b1fed31c1a7c15b4"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin"codecovcli", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_equal "codecovcli, version #{version}\n", shell_output("#{bin}codecovcli --version")

    (testpath"coverage.json").write <<~JSON
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

    output = shell_output("#{bin}codecovcli do-upload --commit-sha=mocksha --dry-run 2>&1")
    assert_match "Found 1 coverage files to report", output
    assert_match "Process Upload complete", output
  end
end