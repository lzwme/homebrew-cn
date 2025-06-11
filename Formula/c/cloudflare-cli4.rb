class CloudflareCli4 < Formula
  include Language::Python::Virtualenv

  desc "CLI for Cloudflare API v4"
  homepage "https:github.comcloudflarepython-cloudflare-cli4"
  url "https:github.comcloudflarepython-cloudflare-cli4archiverefstags2.19.4.tar.gz"
  sha256 "7a3e9b71cad0a995d59b0c3e285e1cf16bd08d9998509f44d7c321abe803d22b"
  license "MIT"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a5af04e49d3f9da5cb3777b40cf430cee2ee79c80f72c8db44897731abc124f7"
    sha256 cellar: :any,                 arm64_sonoma:  "20cfd36aa45bef723d27ca30e728b9876109e8a9ebdc580b999a343395fa259f"
    sha256 cellar: :any,                 arm64_ventura: "9d33a02ccf8e04b6f18b9868efa2f2958c1556ddb1f973edf05179dbaae961e8"
    sha256 cellar: :any,                 sonoma:        "e52ce4d74b12ffd1dc804d350bd65c65a2e4cd5ba9675cdcf3a608ae96965b17"
    sha256 cellar: :any,                 ventura:       "f72281daadc4b6298186e6bd4741c2496c39b5d844bf219e6ff07622117873d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0072275bd71000978f837e4455077dd120b622a30c2b3c4522d985c69d335eea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dde8e52d0ba02a7588abc5a38c548d2d090999b14c146ad037b3b69cbe00ed1e"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages5ab01367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "certifi" do
    url "https:files.pythonhosted.orgpackagese89ec05b3920a3b7d20d3d3310465f50348e5b3694f4f88c6daf736eef3024c4certifi-2025.4.26.tar.gz"
    sha256 "0a816057ea3cdefcef70270d2c515e4506bbc954f417fa5ade2021213bb8f0c6"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jsonlines" do
    url "https:files.pythonhosted.orgpackages3587bcda8e46c88d0e34cad2f09ee2d0c7f5957bccdb9791b0b934ec84d84be4jsonlines-4.0.0.tar.gz"
    sha256 "0c6d2c09117550c089995247f605ae4cf77dd1533041d366351f6f298822ea74"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath".cloudflarecloudflare.cfg").write <<~EOS
      [CloudFlare]
      email = BrewTestBot@example.com
      token = 00000000000000000000000000000000
      [Work]
      token = 00000000000000000000000000000000
    EOS

    output = shell_output("#{bin}cli4 --profile Work zones 2>&1", 1)
    assert_match "cli4: zones - 6111 Invalid format for Authorization header", output
    assert_match version.to_s, shell_output("#{bin}cli4 --version 2>&1", 1)
  end
end