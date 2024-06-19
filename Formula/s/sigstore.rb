class Sigstore < Formula
  include Language::Python::Virtualenv

  desc "Codesigning tool for Python packages"
  homepage "https:github.comsigstoresigstore-python"
  url "https:files.pythonhosted.orgpackages080249fb5e4f9c1e3dec6ab9b94b4d2b9778ad90a2bf6034e7bc7ccf6936d009sigstore-3.0.0.tar.gz"
  sha256 "a6a9538a648e112a0c3d8092d3f73a351c7598164764f1e73a6b5ba406a3a0bd"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4fd6b887ff74cea75f60336c9b898df88a5ffbc22bbe4a6f6ed5f592349b4953"
    sha256 cellar: :any,                 arm64_ventura:  "820605e69308ea69082f79c58e08bf470e281b9882f0dc512d73872d861be156"
    sha256 cellar: :any,                 arm64_monterey: "ae30f3132cef99363e694b315a3702922b02094297df3f044c66fb2bb9d1e62d"
    sha256 cellar: :any,                 sonoma:         "9e5761edfefc218550e476c8ba49054053bc8c8cb3d299c58149a961c2c69624"
    sha256 cellar: :any,                 ventura:        "2e6d499512b6f8bfca9c0ff46ee63ae0792b7bbfe088b6a8c9b372d871755eb2"
    sha256 cellar: :any,                 monterey:       "2b069d03600ba8dc7ae034c2c0cb7a647129792fba3623afbc79794397f5204d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5681fc8a5e4ff80a969a716b3b7ed6635eed6f5af6ca6cb361ca4e8d61cbcfdc"
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
    url "https:files.pythonhosted.orgpackages8523faab91ba691ddcff25db67c2835cbe65b0fbb0177cbbc532c6230b826d12email_validator-2.1.2.tar.gz"
    sha256 "14c0f3d343c4beda37400421b39fa411bbe33a75df20825df73ad53e06a9f04c"
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
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
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
    url "https:files.pythonhosted.orgpackagesf979722ca999a3a09a63b35aac12ec27dfa8e5bb3a38b0f857f7a1a209a88836multidict-6.0.5.tar.gz"
    sha256 "f7e301075edaf50500f0b341543c41194d8df3ae5caf4702f2095f3ca73dd8da"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackagesf5520763d1d976d5c262df53ddda8d8d4719eedf9594d046f117c25a27261a19platformdirs-4.2.2.tar.gz"
    sha256 "38b7b51f512eed9e84a22788b4bce1de17c0adb134d6becb09836e37d8654cd3"
  end

  resource "pyasn1" do
    url "https:files.pythonhosted.orgpackages4aa3d2157f333900747f20984553aca98008b6dc843eb62f3a36030140ccec0dpyasn1-0.6.0.tar.gz"
    sha256 "3a35ab2c4b5ef98e17dfdec8ab074046fbda76e281c5a706ccd82328cfc8f64c"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackages0dfcccd0e8910bc780f1a4e1ab15e97accbb1f214932e796cff3131f9a943967pydantic-2.7.4.tar.gz"
    sha256 "0c84efd9548d545f63ac0060c1e4d39bb9b14db8b3c0652338aecc07b5adec52"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackages02d0622cdfe12fb138d035636f854eb9dc414f7e19340be395799de87c1de6f6pydantic_core-2.18.4.tar.gz"
    sha256 "ec3beeada09ff865c344ff3bc2f427f5e6c26401cc6113d77e372c3fdac73864"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pyjwt" do
    url "https:files.pythonhosted.orgpackages30728259b2bccfe4673330cea843ab23f86858a419d8f1493f66d413a76c7e3bPyJWT-2.8.0.tar.gz"
    sha256 "57e28d156e3d5c10088e0c68abb90bfac3df82b40a71bd0daa20c65ccd5c23de"
  end

  resource "pyopenssl" do
    url "https:files.pythonhosted.orgpackages91a8cbeec652549e30103b9e6147ad433405fdd18807ac2d54e6dbb73184d8a1pyOpenSSL-24.1.0.tar.gz"
    sha256 "cabed4bfaa5df9f1a16c0ef64a0cb65318b5cd077a7eda7d6970131ca2f41a6f"
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
    url "https:files.pythonhosted.orgpackagesb301c954e134dc440ab5f96952fe52b4fdc64225530320a910473c1fe270d9aarich-13.7.1.tar.gz"
    sha256 "9be308cb1fe2f1f57d67ce99e95af38a1e2bc71ad9813b0e247cf7ffbcc3a432"
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
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}sigstore -V")

    resource "homebrew-test-artifact" do
      url "https:github.comsigstoresigstore-pythonreleasesdownloadv3.0.0sigstore-3.0.0.tar.gz", using: :nounzip
      sha256 "a6a9538a648e112a0c3d8092d3f73a351c7598164764f1e73a6b5ba406a3a0bd"
    end

    resource "homebrew-test-artifact.sigstore" do
      url "https:github.comsigstoresigstore-pythonreleasesdownloadv3.0.0sigstore-3.0.0.tar.gz.sigstore"
      sha256 "4985b593853a065b8fc3a0ffa437478b6ebd4925ef58855cbb034082746c2e02"
    end

    resource("homebrew-test-artifact").stage testpath
    resource("homebrew-test-artifact.sigstore").stage testpath

    cert_identity = "https:github.comsigstoresigstore-python.githubworkflowsrelease.yml@refstagsv3.0.0"

    output = shell_output("#{bin}sigstore verify github sigstore-3.0.0.tar.gz --cert-identity #{cert_identity}")
    assert_match "OK: sigstore-3.0.0.tar.gz", output
  end
end