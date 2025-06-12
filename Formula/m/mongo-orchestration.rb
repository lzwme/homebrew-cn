class MongoOrchestration < Formula
  include Language::Python::Virtualenv

  desc "REST API to manage MongoDB configurations on a single host"
  homepage "https:github.com10genmongo-orchestration"
  url "https:files.pythonhosted.orgpackages738ff087958ff2ce6b0f06d5be16717e48d2009d598e4ae26270437b473a211amongo_orchestration-0.11.0.tar.gz"
  sha256 "6f53db5cb6bc1ab4a8f282f2638e1c2d35b7fdcb15f6c8e034acf5d0676e3df5"
  license "Apache-2.0"
  revision 1
  head "https:github.com10genmongo-orchestration.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfd1a392fdd07a640132664c00d5fb4a4713123b6893ebd6cdd3bb71107084d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be90eb1da97fbd735c843f2eb3dfa47bad2c50751f2ec7997318ef529eb6dc4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a8391a450907ccef446f1c816184a8413411f54e04f2c57909e95ea391d194b"
    sha256 cellar: :any_skip_relocation, sonoma:        "362e3b77ac394d9d3bf00840b3eafb668e9cc736772ddf4237a806e309303360"
    sha256 cellar: :any_skip_relocation, ventura:       "7631b1af15e3c3e7488a3b8ac817d568171ab7582be5a98fc68eeaf259ce00a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b3821a6c27dbd03bdb52ab7454e82f8642eda3afeaf7c8008c0391e9397e474"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1a98cb7e9f11d69ad9bf23f28ee2f0cd83ad3f6e1e41f78e8ccafc539479bc8"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  resource "bottle" do
    url "https:files.pythonhosted.orgpackagesf53befa9540213c71be3500e14592c5823bd3f9ddd881d306e01b5dd490ddab5bottle-0.13.3.tar.gz"
    sha256 "1c23aeb30aa8a13f39c60c0da494530ddd5de3da235bc431b818a50d999de49f"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "cheroot" do
    url "https:files.pythonhosted.orgpackages63e2f85981a51281bd30525bf664309332faa7c81782bb49e331af603421dbd1cheroot-10.0.1.tar.gz"
    sha256 "e0b82f797658d26b8613ec8eb563c3b08e6bd6a7921e9d5089bd1175ad1b1740"
  end

  resource "dnspython" do
    url "https:files.pythonhosted.orgpackagesb54a263763cb2ba3816dd94b08ad3a33d5fdae34ecb856678773cc40a3605829dnspython-2.7.0.tar.gz"
    sha256 "ce9c432eda0dc91cf618a5cedf1a4e142651196bbcd2c80e89ed5a907e5cfaf1"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jaraco-functools" do
    url "https:files.pythonhosted.orgpackagesab239894b3df5d0a6eb44611c36aec777823fc2e07740dabbd0b810e19594013jaraco_functools-4.1.0.tar.gz"
    sha256 "70f7e0e2ae076498e212562325e805204fc092d7b4c17e0e86c959e249701a9d"
  end

  resource "more-itertools" do
    url "https:files.pythonhosted.orgpackagescea0834b0cebabbfc7e311f30b46c8188790a37f89fc8d756660346fe5abfd09more_itertools-10.7.0.tar.gz"
    sha256 "9fddd5403be01a94b204faadcff459ec3568cf110265d3c54323e1e866ad29d3"
  end

  resource "pymongo" do
    url "https:files.pythonhosted.orgpackages740c1fb60383ab4b20566407b87f1a95b7f5cda83e8d5594da6fc84e2a543405pymongo-4.13.0.tar.gz"
    sha256 "92a06e3709e3c7e50820d352d3d4e60015406bcba69808937dac2a6d22226fde"
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

  service do
    run [opt_bin"mongo-orchestration", "-b", "127.0.0.1", "-p", "8889", "--no-fork", "start"]
    require_root true
  end

  test do
    system bin"mongo-orchestration", "-h"
  end
end