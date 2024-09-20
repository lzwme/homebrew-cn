class Sigstore < Formula
  include Language::Python::Virtualenv

  desc "Codesigning tool for Python packages"
  homepage "https:github.comsigstoresigstore-python"
  url "https:files.pythonhosted.orgpackagesd9f4c4ae408a49250f47614f44584c73a7bbe3d1cebedf8a7c89aa5a7f7eb97bsigstore-3.3.0.tar.gz"
  sha256 "931e9913996ceace713d28e2431989414e711af30606f0b1e8bdc30fcbdd3fbe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cbbbcb1ef5f01446ffa6270f3f139c5c448fa5512728402e26cde6010b962fc4"
    sha256 cellar: :any,                 arm64_sonoma:  "5974d3fcaaa7492473663cdf81541dac981ce6d72ea60d9648489633b2917399"
    sha256 cellar: :any,                 arm64_ventura: "63c51fee0cc03668389a86e1ab764b16eeed192fae8edbbc6c8892aa3f63bde9"
    sha256 cellar: :any,                 sonoma:        "abc91178ac640e30db53387ed9495a36d45e7d75fd7d24587defa28655161be6"
    sha256 cellar: :any,                 ventura:       "34b7afb5d5f910479442cf9400b65d83c251678aadb4617e6e28d36d24f8d041"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdc6b05274b619e012d39cf4eec3bc2c0575ad968233d7aa3844543b942e37dc"
  end

  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.12"

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackagesee67531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "betterproto" do
    url "https:files.pythonhosted.orgpackages45434c44efd75f2ef48a16b458c2fe2cff7aa74bab8fcadf2653bb5110a87f97betterproto-2.0.0b6.tar.gz"
    sha256 "720ae92697000f6fcf049c69267d957f0871654c8b0d7458906607685daee784"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "dnspython" do
    url "https:files.pythonhosted.orgpackages377dc871f55054e403fdfd6b8f65fd6d1c4e147ed100d3e9f9ba1fe695403939dnspython-2.6.1.tar.gz"
    sha256 "e8f0f9c23a7b7cb99ded64e6c3a6f3e701d78f50c55e002b839dea7225cff7cc"
  end

  resource "email-validator" do
    url "https:files.pythonhosted.orgpackages48ce13508a1ec3f8bb981ae4ca79ea40384becc868bfae97fd1c942bb3a001b1email_validator-2.2.0.tar.gz"
    sha256 "cb690f344c617a714f22e66ae771445a1ceb46821152df8e165c5f9a364582b7"
  end

  resource "grpclib" do
    url "https:files.pythonhosted.orgpackages79b955936e462a5925190d7427e880b3033601d1effd13809b483d13a926061agrpclib-0.4.7.tar.gz"
    sha256 "2988ef57c02b22b7a2e8e961792c41ccf97efc2ace91ae7a5b0de03c363823c3"
  end

  resource "h2" do
    url "https:files.pythonhosted.orgpackages2a32fec683ddd10629ea4ea46d206752a95a2d8a48c22521edd70b142488efe1h2-4.1.0.tar.gz"
    sha256 "a83aca08fbe7aacb79fec788c9c0bac936343560ed9ec18b82a13a12c28d2abb"
  end

  resource "hpack" do
    url "https:files.pythonhosted.orgpackages3e9bfda93fb4d957db19b0f6b370e79d586b3e8528b20252c729c476a2c02954hpack-4.0.0.tar.gz"
    sha256 "fc41de0c63e687ebffde81187a948221294896f6bdc0ae2312708df339430095"
  end

  resource "hyperframe" do
    url "https:files.pythonhosted.orgpackages5a2a4747bff0a17f7281abe73e955d60d80aae537a5d203f417fa1c2e7578ebbhyperframe-6.0.1.tar.gz"
    sha256 "ae510046231dc8e9ecb1a6586f63d2347bf4c8905914aa84ba585ae85f28a914"
  end

  resource "id" do
    url "https:files.pythonhosted.orgpackages42cad8032376d0279916bb43ff709bba4c45c5f56c3f3f65c50bc8720f360701id-1.4.0.tar.gz"
    sha256 "23c06772e8bd3e3a44ee3f167868bf5a8e385b0c1e2cc707ad36eb7486b4765b"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackagesd6be504b89a5e9ca731cd47487e91c469064f8ae5af93b7259758dcfc2b9c848multidict-6.1.0.tar.gz"
    sha256 "22ae2ebf9b0c69d206c003e2f6a914ea33f0a932d4aa16f236afc049d9958f4a"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages13fc128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "pyasn1" do
    url "https:files.pythonhosted.orgpackagesbae901f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackagesa9b7d9e3f12af310e1120c21603644a1cd86f59060e040ec5c3a80b8f05fae30pydantic-2.9.2.tar.gz"
    sha256 "d155cef71265d1e9807ed1c32b4c8deec042a44a50a4188b25ac67ecd81a9c0f"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackagese2aa6b6a9b9f8537b872f552ddd46dd3da230367754b6f707b8e1e963f515ea3pydantic_core-2.23.4.tar.gz"
    sha256 "2584f7cf844ac4d970fba483a717dbe10c1c1c96a969bf65d61ffe94df1b2863"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pyjwt" do
    url "https:files.pythonhosted.orgpackagesfb68ce067f09fca4abeca8771fe667d89cc347d1e99da3e093112ac329c6020epyjwt-2.9.0.tar.gz"
    sha256 "7e1e5b56cc735432a7369cbfa0efe50fa113ebecdc04ae6922deba8b84582d0c"
  end

  resource "pyopenssl" do
    url "https:files.pythonhosted.orgpackages5d70ff56a63248562e77c0c8ee4aefc3224258f1856977e0c1472672b62dadb8pyopenssl-24.2.1.tar.gz"
    sha256 "4247f0dbe3748d560dcbb2ff3ea01af0f9a1a001ef5f7c4c647956ed8cbf0e95"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rfc8785" do
    url "https:files.pythonhosted.orgpackages7d8fdb412a9abee1d6f982371512db2078c0148776aa96964d62bf4c15a78713rfc8785-0.1.3.tar.gz"
    sha256 "167efe3b5cdd09dded9d0cfc8fec1f48f5cd9f8f13b580ada4efcac138925048"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackages927640f084cb7db51c9d1fa29a7120717892aeda9a7711f6225692c957a93535rich-13.8.1.tar.gz"
    sha256 "8260cda28e3db6bf04d2d1ef4dbc03ba80a824c88b0e7668a0f23126a424844a"
  end

  resource "securesystemslib" do
    url "https:files.pythonhosted.orgpackages81add01a19c754c512f35ed3b955db08bd3d077a322038bc8544e15c7b016b76securesystemslib-1.1.0.tar.gz"
    sha256 "27143a8e04b5573636f260f21d7e26b48bcedcf394e6f74ec31e9a5287e0c38b"
  end

  resource "sigstore-protobuf-specs" do
    url "https:files.pythonhosted.orgpackagesc031f73764f96787b53dd14641b2cc02dc7f4a0586de35c020ab1ff9bb12e833sigstore_protobuf_specs-0.3.2.tar.gz"
    sha256 "cae041b40502600b8a633f43c257695d0222a94efa1e5110a7ec7ada78c39d99"
  end

  resource "sigstore-rekor-types" do
    url "https:files.pythonhosted.orgpackagesf335342daa1dcfd101a6c084cc767b93d2e1095c9f3c9c0c57736ed9abc20a08sigstore_rekor_types-0.0.13.tar.gz"
    sha256 "63e9306a26931ed74411911948c250da7c5adc51c53507227738170424e6ae2d"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "tuf" do
    url "https:files.pythonhosted.orgpackagesdbea5a89820ae36f8717ca3f12bfe369e92b51a5bd43efb3f2afec6cdd8e15adtuf-5.0.0.tar.gz"
    sha256 "9c5d87d3822ae2f83c756d5a208c6942a2829ae1ea63c18c363124497d04da4f"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}sigstore -V")

    resource "homebrew-test-artifact" do
      url "https:github.comsigstoresigstore-pythonreleasesdownloadv3.3.0sigstore-3.3.0.tar.gz", using: :nounzip
      sha256 "931e9913996ceace713d28e2431989414e711af30606f0b1e8bdc30fcbdd3fbe"
    end

    resource "homebrew-test-artifact.sigstore" do
      url "https:github.comsigstoresigstore-pythonreleasesdownloadv3.3.0sigstore-3.3.0.tar.gz.sigstore"
      sha256 "1cb946269f563b669183307b603f85169c7b1399835c66b8b4d28d913d26d5f7"
    end

    resource("homebrew-test-artifact").stage testpath
    resource("homebrew-test-artifact.sigstore").stage testpath

    cert_identity = "https:github.comsigstoresigstore-python.githubworkflowsrelease.yml@refstagsv3.3.0"

    output = shell_output("#{bin}sigstore verify github sigstore-3.3.0.tar.gz --cert-identity #{cert_identity} 2>&1")
    assert_match "OK: sigstore-3.3.0.tar.gz", output
  end
end