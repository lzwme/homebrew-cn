class HuggingfaceCli < Formula
  include Language::Python::Virtualenv

  desc "Client library for huggingface.co hub"
  homepage "https:huggingface.codocshuggingface_hubindex"
  url "https:files.pythonhosted.orgpackages918a1362d565fefabaa4185cf3ae842a98dbc5b35146f5694f7080f043a6952fhuggingface_hub-0.33.0.tar.gz"
  sha256 "aa31f70d29439d00ff7a33837c03f1f9dd83971ce4e29ad664d63ffb17d3bb97"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9ea6f6c0c5c87685e4f0ab323a39ab5aae4638695b8e64459a2494a96d679b8f"
    sha256 cellar: :any,                 arm64_sonoma:  "41d7cf51120054e731bd50956233710414dc0aa704498f6620e40239e96acba8"
    sha256 cellar: :any,                 arm64_ventura: "2a1cc83ee28f3a5be8b10a4e48ce869458cbc40baa76ddcf298875e18cd767e1"
    sha256 cellar: :any,                 sonoma:        "f720281a9670b9a9a4608813d485a53879e08c9a298cdc7122e16a89e72ccc07"
    sha256 cellar: :any,                 ventura:       "6d78a8eff0bde13dc4b9d612b90413b4fb122ba4781a870fb656955cd17505fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2c5ca916403694b0c434bc29313936e5442c5063d4de983cb2dd70f1fd4c86e"
  end

  depends_on "maturin" => :build # for `hf-xet`
  depends_on "pkgconf" => :build
  depends_on "rust" => :build # upstream bug report, https:github.comPyO3maturinissues2642

  depends_on "certifi"
  depends_on "git-lfs"
  depends_on "libyaml"
  depends_on "python@3.13"

  on_linux do
    depends_on "openssl@3"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackages0a10c23352565a6544bdc5353e0b15fc1c563352101f30e24bf500207a54df9afilelock-3.18.0.tar.gz"
    sha256 "adbc88eabb99d2fec8c9c1b229b171f18afa655400173ddc653d5d01501fb9f2"
  end

  resource "fsspec" do
    url "https:files.pythonhosted.orgpackages00f727f15d41f0ed38e8fcc488584b57e902b331da7f7c6dcda53721b15838fcfsspec-2025.5.1.tar.gz"
    sha256 "2e55e47a540b91843b755e83ded97c6e897fa0942b11490113f09e9c443c2475"
  end

  resource "hf-xet" do
    url "https:files.pythonhosted.orgpackages8d11b480bb7515db97d5b2b703927a59bbdd3f87e68d47dff5591aada467b4a9hf_xet-1.1.4.tar.gz"
    sha256 "875158df90cb13547752532ed73cad9dfaad3b29e203143838f67178418d08a4"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "inquirerpy" do
    url "https:files.pythonhosted.orgpackages64737570847b9da026e07053da3bbe2ac7ea6cde6bb2cbd3c7a5a950fa0ae40bInquirerPy-0.3.4.tar.gz"
    sha256 "89d2ada0111f337483cb41ae31073108b2ec1e618a49d7110b0d7ade89fc197e"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesa1d41fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24dpackaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pfzy" do
    url "https:files.pythonhosted.orgpackagesd95a32b50c077c86bfccc7bed4881c5a2b823518f5450a30e639db5d3711952epfzy-0.3.4.tar.gz"
    sha256 "717ea765dd10b63618e7298b2d98efd819e0b30cd5905c9707223dceeb94b3f1"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackagesbb6e9d084c929dfe9e3bfe0c6a47e31f78a25c54627d64a66e884a8bf5474f1cprompt_toolkit-3.0.51.tar.gz"
    sha256 "931a162e3b27fc90c86f1b48bb1fb2c528c2761475e57c9c06de13311c7b54ed"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackagesa84b29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744dtqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesd1bc51647cd02527e87d05cb083ccc402f93e441606ff1f01739a62c8ad09ba5typing_extensions-4.14.0.tar.gz"
    sha256 "8676b788e32f02ab42d9e7c61324048ae4c6d844a399eebace3d4979d75ceef4"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages15229ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bcurllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    whoami_output = shell_output("#{bin}huggingface-cli whoami")
    assert_match "Not logged in", whoami_output
    test_cache = testpath"cache"
    test_cache.mkdir
    ENV["HUGGINGFACE_HUB_CACHE"] = test_cache.to_s
    ENV["NO_COLOR"] = "1"
    scan_output = shell_output("#{bin}huggingface-cli scan-cache")
    assert_match "Done in 0.0s. Scanned 0 repo(s) for a total of 0.0.", scan_output
  end
end