class Howdoi < Formula
  include Language::Python::Virtualenv

  desc "Instant coding answers via the command-line"
  homepage "https:github.comgleitzhowdoi"
  url "https:files.pythonhosted.orgpackages6d430e8166583575bd500c0f8f1a4ab9429af9466feb6fcdc006e88de8fd23e9howdoi-2.0.20.tar.gz"
  sha256 "51cd40c53e0c0f8f8da88f480eb7423183be2350ab4f0a4d9d4763ca6ac3e2a9"
  license "MIT"
  revision 9

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5c28f21d2e7357942b10e5cfc93007617fb0ab1b84f197bfc41c571b130d835"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ded6aa318d6531f2165093355f7c3d6ed86870c80e18a8e4fb443ccba7ffdc1"
    sha256 cellar: :any,                 arm64_monterey: "2f4cd16d1af84a88a78c32577898999cbff813026332a9a36f9a85c4dd3e8e87"
    sha256 cellar: :any_skip_relocation, sonoma:         "60c48f986dfcbd633cb18de6979842ea7a0ea0699c03dc83e6a32ff576d73897"
    sha256 cellar: :any_skip_relocation, ventura:        "b4d70115086bd5b8b16af11a9c869635cae5a5490bd07b1a4ad4d8ea642b71b2"
    sha256 cellar: :any,                 monterey:       "3189a45e051a6a5616c9b312bc0032abc64fe18abdbd1b1852ef43c92b89c0d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83bf82d3a00ca204892e2248b633320006ba6c61f90daeffcabc54eca5f659de"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "appdirs" do
    url "https:files.pythonhosted.orgpackagesd7d805696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "cachelib" do
    url "https:files.pythonhosted.orgpackages1d690b5c1259e12fbcf5c2abe5934b5c0c1294ec0f845e2b4b2a51a91d79a4fbcachelib-0.13.0.tar.gz"
    sha256 "209d8996e3c57595bee274ff97116d1d73c4980b2fd9a34c7846cd07fd2e1a48"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "cssselect" do
    url "https:files.pythonhosted.orgpackagesd191d51202cc41fbfca7fa332f43a5adac4b253962588c7cc5a54824b019081ccssselect-1.2.0.tar.gz"
    sha256 "666b19839cfaddb9ce9d36bfe4c969132c647b92fc9088c4e23f786b30f1b3dc"
  end

  resource "deprecated" do
    url "https:files.pythonhosted.orgpackages92141e41f504a246fc224d2ac264c227975427a85caf37c3979979edb9b1b232Deprecated-1.2.14.tar.gz"
    sha256 "e5323eb936458dccc2582dc6f9c322c852a775a27065ff2b0c4970b9d53d01b3"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "keep" do
    url "https:files.pythonhosted.orgpackages6df22c35a4bb1332d81f2b1d94725a9ede4d44902fa8ec11b25dedd210394c2fkeep-2.10.1.tar.gz"
    sha256 "3abbe445347711cecd9cbb80dab4a0777418972fc14a14e9387d0d2ae4b6adb7"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackages63f7ffbb6d2eb67b80a45b8a0834baa5557a14a5ffce0979439e7cd7f0c4055blxml-5.2.2.tar.gz"
    sha256 "bb2dc4898180bea79863d5487e5f9c7c34297414bad54bcd0f0852aee9cfdb87"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygithub" do
    url "https:files.pythonhosted.orgpackages5cfb3af782cd3c0f2c19bc54c640af33513369d240ca748f39c0b38b371e5d1dPyGithub-2.3.0.tar.gz"
    sha256 "0148d7347a1cdeed99af905077010aef81a4dad988b0ba51d4108bf66b443f7e"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pyjwt" do
    url "https:files.pythonhosted.orgpackages30728259b2bccfe4673330cea843ab23f86858a419d8f1493f66d413a76c7e3bPyJWT-2.8.0.tar.gz"
    sha256 "57e28d156e3d5c10088e0c68abb90bfac3df82b40a71bd0daa20c65ccd5c23de"
  end

  resource "pynacl" do
    url "https:files.pythonhosted.orgpackagesa72227582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986daPyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyquery" do
    url "https:files.pythonhosted.orgpackages6cf25dfdea62dcffa3d224d6b25d050f27edfe3c143fff3505078b0903b18d7fpyquery-2.0.0.tar.gz"
    sha256 "963e8d4e90262ff6d8dec072ea97285dc374a2f69cad7776f4082abcf6a1d8ae"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesb301c954e134dc440ab5f96952fe52b4fdc64225530320a910473c1fe270d9aarich-13.7.1.tar.gz"
    sha256 "9be308cb1fe2f1f57d67ce99e95af38a1e2bc71ad9813b0e247cf7ffbcc3a432"
  end

  resource "terminaltables" do
    url "https:files.pythonhosted.orgpackagesf5fc0b73d782f5ab7feba8d007573a3773c58255f223c5940a7b7085f02153c3terminaltables-3.1.10.tar.gz"
    sha256 "ba6eca5cb5ba02bba4c9f4f985af80c54ec3dccf94cfcd190154386255e47543"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  resource "wrapt" do
    url "https:files.pythonhosted.orgpackages954c063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0awrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12")

    # Switch build-system to poetry-core to avoid rust dependency on Linux.
    # Remove when released: https:github.commatthewdeanmartinterminaltablespull1
    resource("terminaltables").stage do
      inreplace "pyproject.toml", 'requires = ["poetry>=0.12"]', 'requires = ["poetry-core>=1.0"]'
      inreplace "pyproject.toml", 'build-backend = "poetry.masonry.api"', 'build-backend = "poetry.core.masonry.api"'
      venv.pip_install_and_link Pathname.pwd
    end

    venv.pip_install resources.reject { |r| r.name == "terminaltables" }
    venv.pip_install_and_link buildpath
  end

  test do
    assert_equal "Here are a few popular howdoi commands ", shell_output("#{bin}howdoi howdoi").split("\n").first
  end
end