class Fred < Formula
  include Language::Python::Virtualenv

  desc "Fully featured FRED Command-line Interface & Python API wrapper"
  homepage "https://fred.stlouisfed.org/docs/api/fred/"
  url "https://files.pythonhosted.org/packages/ff/22/44051587a95461a3fb0cd57e5ba215f3c4d3086544294e5ac79ab0028c20/fred_py_api-1.2.0.tar.gz"
  sha256 "4e588b6f5349461436aad2fc20ff4ca97b3b69fb0daa24c0e12ab837dedad90f"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcb2199459dbbeae33578b27e4328ac2514c4aecd434e3b1c5c664137e5d9a18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fcb2199459dbbeae33578b27e4328ac2514c4aecd434e3b1c5c664137e5d9a18"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fcb2199459dbbeae33578b27e4328ac2514c4aecd434e3b1c5c664137e5d9a18"
    sha256 cellar: :any_skip_relocation, sonoma:        "12895b8db5c519c9ef051229b13b8bf10a2bb87650a1dcaec0cb87acfec73cbc"
    sha256 cellar: :any_skip_relocation, ventura:       "12895b8db5c519c9ef051229b13b8bf10a2bb87650a1dcaec0cb87acfec73cbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcb2199459dbbeae33578b27e4328ac2514c4aecd434e3b1c5c664137e5d9a18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcb2199459dbbeae33578b27e4328ac2514c4aecd434e3b1c5c664137e5d9a18"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/e8/9e/c05b3920a3b7d20d3d3310465f50348e5b3694f4f88c6daf736eef3024c4/certifi-2025.4.26.tar.gz"
    sha256 "0a816057ea3cdefcef70270d2c515e4506bbc954f417fa5ade2021213bb8f0c6"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8a/78/16493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0/urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"fred", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    # assert output & ensure exit code is 2
    # NOTE: this makes an API request to FRED with a purposely invalid API key
    invalid_api_key = "sqwer1234asdfasdfqwer1234asdfsdf"
    output = shell_output("#{bin}/fred --api-key #{invalid_api_key} categories get-category -i 15 2>&1", 2)
    assert_match "Bad Request.  The value for variable api_key is not registered.", output
  end
end