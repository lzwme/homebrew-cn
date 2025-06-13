class PolicySentry < Formula
  include Language::Python::Virtualenv

  desc "Generate locked-down AWS IAM Policies"
  homepage "https:policy-sentry.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackagesbc4be03bbe626379bfee06c944a01ef25ad14ce30bc9dd86988dfda1cf343347policy_sentry-0.14.0.tar.gz"
  sha256 "5c52cebebad26e2360393f34af523c1685541d67b0dfd721b0779dbe9e327f1a"
  license "MIT"
  revision 1
  head "https:github.comsalesforcepolicy_sentry.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "46b843bf087131b63755a97e8c63205c4cd5e7beb16715b5c21a878b4c0c23d2"
    sha256 cellar: :any,                 arm64_sonoma:  "d875fc4b379c60174e3f4ed246d9bc67bc1057ea1a2f9dc0c0cd81fc5f90eb12"
    sha256 cellar: :any,                 arm64_ventura: "81bcf9bc3681e0dd59addfccfd5a6574e0b75d061e9fa59dfeb8fb180fc91d58"
    sha256 cellar: :any,                 sonoma:        "c0e378611ba7ec8dc6bd38f849989f6ea05fa74bc481738e30af78f9f469ca50"
    sha256 cellar: :any,                 ventura:       "b011280dfa732d387a00809aacd2056767c782f6657bf6eede023d3b2814a946"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6d0a280944eaeef9e022ca9c285848f3ee805b323a0979f665f760075fe5b1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d57d65a28701c75b73bc65d8e8f02ca9cf311ddef4f88576c22216140697df5b"
  end

  depends_on "rust" => :build # for orjson
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesd8e40c4c39e18fd76d6a628d4dd8da40543d136ce2d1752bd6eeeab0791f4d6bbeautifulsoup4-4.13.4.tar.gz"
    sha256 "dbb3c4e1ceae6aefebdaf2423247260cd062430a410e38c66f2baa50a8437195"
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

  resource "orjson" do
    url "https:files.pythonhosted.orgpackages810bfea456a3ffe74e70ba30e01ec183a9b26bec4d497f61dcfce1b601059c60orjson-3.10.18.tar.gz"
    sha256 "e8da3947d92123eda795b68228cafe2724815621fe35e8e320a9e9593a4bcd53"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "schema" do
    url "https:files.pythonhosted.orgpackagesd4010ea2e66bad2f13271e93b729c653747614784d3ebde219679e41ccdceecdschema-0.7.7.tar.gz"
    sha256 "7da553abd2958a19dc2547c388cde53398b39196175a9be59ea1caf5ab0a1807"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackages3ff44a80cd6ef364b2e8b65b15816a843c0980f7a5a2b4dc701fc574952aa19fsoupsieve-2.7.tar.gz"
    sha256 "ad282f9b6926286d2ead4750552c8a6142bc4c783fd66b0293547c8fe6ae126a"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesd1bc51647cd02527e87d05cb083ccc402f93e441606ff1f01739a62c8ad09ba5typing_extensions-4.14.0.tar.gz"
    sha256 "8676b788e32f02ab42d9e7c61324048ae4c6d844a399eebace3d4979d75ceef4"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin"policy_sentry", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}policy_sentry --version")

    test_file = testpath"policy_sentry.yml"
    output = shell_output("#{bin}policy_sentry create-template -o #{test_file} -t actions")
    assert_match "write-policy template file written to: #{test_file}", output
    assert_match "mode: actions", test_file.read
  end
end