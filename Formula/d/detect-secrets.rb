class DetectSecrets < Formula
  include Language::Python::Virtualenv

  desc "Enterprise friendly way of detecting and preventing secrets in code"
  homepage "https:github.comYelpdetect-secrets"
  url "https:files.pythonhosted.orgpackages6967382a863fff94eae5a0cf05542179169a1c49a4c8784a9480621e2066ca7ddetect_secrets-1.5.0.tar.gz"
  sha256 "6bb46dcc553c10df51475641bb30fd69d25645cc12339e46c824c1e0c388898a"
  license "Apache-2.0"
  revision 3
  head "https:github.comYelpdetect-secrets.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dfe38094256d4eac4bbc51f4494e65dd444f8a0c7e271f233273754f6e3639a3"
    sha256 cellar: :any,                 arm64_sonoma:  "7c0722116900c5364c73515fca5f21999e7f7c4f18629f0695f347ffae3a272e"
    sha256 cellar: :any,                 arm64_ventura: "3d5bdf3ab33233207e596622876a0a134d83a58025c158a0c7a9dc4874ec3e21"
    sha256 cellar: :any,                 sonoma:        "192d4d619fa97ddec7e2d16f955962afb1814ca8b8e22d9baf487cd7deab41ab"
    sha256 cellar: :any,                 ventura:       "31bd87e1ee4becadebac76bd35a86d387fb0bb0705de7ec7e12ad304ec64da34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96218f5d2fe9aefbe544c3ccf9e9b8a02c472db32322e0e20c0475f93959a313"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b80272b4ad1bb120494729bc5dd3b5dff805ec8cf2fd8803664fb929da64b44"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
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
    assert_match "ArtifactoryDetector", shell_output("#{bin}detect-secrets scan --list-all-plugins 2>&1")
  end
end