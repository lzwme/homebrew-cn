class Gcalcli < Formula
  include Language::Python::Virtualenv

  desc "Easily access your Google Calendar(s) from a command-line"
  homepage "https:github.cominsanumgcalcli"
  url "https:files.pythonhosted.orgpackagesb066db883aef2db06fe6795e510f520b845e6db2b5b99922910236b7d06ef942gcalcli-4.5.0.tar.gz"
  sha256 "fb3b7b2f4a086581ed5141b5a0f61822ef374ea782707e736b7711ecc35a0574"
  license "MIT"
  head "https:github.cominsanumgcalcli.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9b047282b4a42ff2ad8b832bb70e6a97674b5b99aa2b5eedde8093389f643dc9"
    sha256 cellar: :any,                 arm64_sonoma:  "0ce8d0415aa650e71511666c0b2df8cc15a405e8d03f4f24e8ee2c560f83cc9f"
    sha256 cellar: :any,                 arm64_ventura: "ac78b8831e00c0074069df0b5fba0a1a2033d5eac6255d6f873e6745b7215d56"
    sha256 cellar: :any,                 sonoma:        "fdf66e8fb83a79d24fb9b2a45c21649ef5a80af5e7288ed9df2403fd3f0f198d"
    sha256 cellar: :any,                 ventura:       "351389b7394df6993b4e91da2d779b16d79cd92e888a615be3fa821ce4bf16c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36e4febfddb191170a2b14a254c3bd916bf2738ee7cc76f88585978304a2f8cb"
  end

  depends_on "cmake" => :build # for google_api_python_client_stubs
  depends_on "pkg-config" => :build
  depends_on "rust" => :build # for google_api_python_client_stubs
  depends_on "certifi"
  depends_on "python@3.12"

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackagesee67531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackages7533a3d23a2e9ac78f9eaf1fce7490fee430d43ca7d42c65adabbb36a2b28ff6argcomplete-3.5.0.tar.gz"
    sha256 "4349400469dccfb7950bb60334a680c58d88699bff6159df61251878dc6bf74b"
  end

  resource "babel" do
    url "https:files.pythonhosted.orgpackages2a74f1bc80f23eeba13393b7222b11d95ca3af2c1e28edca18af487137eefed9babel-2.16.0.tar.gz"
    sha256 "d1f3554ca26605fe173f3de0c65f750f5a42f924499bf134de6423582298e316"
  end

  resource "cachetools" do
    url "https:files.pythonhosted.orgpackagesc338a0f315319737ecf45b4319a8cd1f3a908e29d9277b46942263292115eee7cachetools-5.5.0.tar.gz"
    sha256 "2cc24fb4cbe39633fb7badd9db9ca6295d766d9c2995f245725a46715d050f2a"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "google-api-core" do
    url "https:files.pythonhosted.orgpackagesc85c31c1742a53b79c8a0c4757b5fae2e8ab9c519cbd7b98c587d4294e1d2d16google_api_core-2.20.0.tar.gz"
    sha256 "f74dff1889ba291a4b76c5079df0711810e2d9da81abfdc99957bc961c1eb28f"
  end

  resource "google-api-python-client" do
    url "https:files.pythonhosted.orgpackages35a473b9d642fa82f6fad67b0449c109a06c8e19b5980204b24fa86b86e8da06google_api_python_client-2.147.0.tar.gz"
    sha256 "e864c2cf61d34c00f05278b8bdb72b93b6fa34f0de9ead51d20435f3b65f91be"
  end

  resource "google-auth" do
    url "https:files.pythonhosted.orgpackagesa137c854a8b1b1020cf042db3d67577c6f84cd1e8ff6515e4f5498ae9e444ea5google_auth-2.35.0.tar.gz"
    sha256 "f4c64ed4e01e8e8b646ef34c018f8bf3338df0c8e37d8b3bba40e7f574a3278a"
  end

  resource "google-auth-httplib2" do
    url "https:files.pythonhosted.orgpackages56be217a598a818567b28e859ff087f347475c807a5649296fb5a817c58dacefgoogle-auth-httplib2-0.2.0.tar.gz"
    sha256 "38aa7badf48f974f1eb9861794e9c0cb2a0511a4ec0679b1f886d108f5640e05"
  end

  resource "google-auth-oauthlib" do
    url "https:files.pythonhosted.orgpackagescc0f1772edb8d75ecf6280f1c7f51cbcebe274e8b17878b382f63738fd96cee5google_auth_oauthlib-1.2.1.tar.gz"
    sha256 "afd0cad092a2eaa53cd8e8298557d6de1034c6cb4a740500b5357b648af97263"
  end

  resource "googleapis-common-protos" do
    url "https:files.pythonhosted.orgpackages533b1599ceafa875ffb951480c8c74f4b77646a6b80e80970698f2aa93c216cegoogleapis_common_protos-1.65.0.tar.gz"
    sha256 "334a29d07cddc3aa01dee4988f9afd9b2916ee2ff49d6b757155dc0d197852c0"
  end

  resource "httplib2" do
    url "https:files.pythonhosted.orgpackages3dad2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "oauthlib" do
    url "https:files.pythonhosted.orgpackages6dfafbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "parsedatetime" do
    url "https:files.pythonhosted.orgpackagesa820cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312acparsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages13fc128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "proto-plus" do
    url "https:files.pythonhosted.orgpackages3efce9a65cd52c1330d8d23af6013651a0bc50b6d76bcbdf91fae7cd19c68f29proto-plus-1.24.0.tar.gz"
    sha256 "30b72a5ecafe4406b0d339db35b56c4059064e69227b8c3bda7462397f966445"
  end

  resource "protobuf" do
    url "https:files.pythonhosted.orgpackagesb1a44579a61de526e19005ceeb93e478b61d77aa38c8a85ad958ff16a9906549protobuf-5.28.2.tar.gz"
    sha256 "59379674ff119717404f7454647913787034f03fe7049cbef1d74a97bb4593f0"
  end

  resource "pyasn1" do
    url "https:files.pythonhosted.orgpackagesbae901f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "pyasn1-modules" do
    url "https:files.pythonhosted.orgpackages1d676afbf0d507f73c32d21084a79946bfcfca5fbc62a72057e9c23797a737c9pyasn1_modules-0.4.1.tar.gz"
    sha256 "c28e2dbf9c06ad61c71a075c7e0f9fd0f1b0bb2d2ad4377f240d33ac2ab60a7c"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackagesa9b7d9e3f12af310e1120c21603644a1cd86f59060e040ec5c3a80b8f05fae30pydantic-2.9.2.tar.gz"
    sha256 "d155cef71265d1e9807ed1c32b4c8deec042a44a50a4188b25ac67ecd81a9c0f"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackagese2aa6b6a9b9f8537b872f552ddd46dd3da230367754b6f707b8e1e963f515ea3pydantic_core-2.23.4.tar.gz"
    sha256 "2584f7cf844ac4d970fba483a717dbe10c1c1c96a969bf65d61ffe94df1b2863"
  end

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackages830813f3bce01b2061f2bbd582c9df82723de943784cf719a35ac886c652043apyparsing-3.1.4.tar.gz"
    sha256 "f86ec8d1a83f11977c9a6ea7598e8c27fc5cddfa5b07ea2241edbbde1d7bc032"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "requests-oauthlib" do
    url "https:files.pythonhosted.orgpackages42f205f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "rsa" do
    url "https:files.pythonhosted.orgpackagesaa657d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "truststore" do
    url "https:files.pythonhosted.orgpackagesdf2e0e21d4c77bc41c588d3d3c87b8f9b32b2338452718cb261d31cbe55eb4d5truststore-0.9.2.tar.gz"
    sha256 "a1dee0d0575ff22d2875476343783a5d64575419974e228f3248772613c3d993"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "uritemplate" do
    url "https:files.pythonhosted.orgpackagesd25a4742fdba39cd02a56226815abfa72fe0aa81c33bed16ed045647d6000ebauritemplate-4.1.1.tar.gz"
    sha256 "4346edfc5c3b79f694bccd6d6099a322bbeb628dbf2cd86eea55a456ce5124f0"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}gcalcli refresh 2>&1", 2)
    assert_match "invalid choice: 'refresh'", output

    output = shell_output("#{bin}gcalcli --version")
    assert_match version.to_s, output
  end
end