class Sigstore < Formula
  include Language::Python::Virtualenv

  desc "Codesigning tool for Python packages"
  homepage "https://github.com/sigstore/sigstore-python"
  url "https://files.pythonhosted.org/packages/9d/05/2908396b8c236c2e97bb3a37f13d4d0fa8bdd0d319a3b914cb2aa079d360/sigstore-2.0.1.tar.gz"
  sha256 "78013eaa2207c054ac803b361f8722011766d243bcbfa50c6e48003df2e3ca2f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3af9f25d562847c2abcfd047792e502f8ff8a3bd6f88a26381f70f74a654c388"
    sha256 cellar: :any,                 arm64_ventura:  "99378e87ea2ee93cc47b2aed7d61c092661cec7930f81ed1fa8810fa2c7494bd"
    sha256 cellar: :any,                 arm64_monterey: "aa4e2904d937d55f8c665e9a15d1020b767c094930da7e8f1f6d428950ecdd45"
    sha256 cellar: :any,                 sonoma:         "48e8bbbd2e34e645c50d71ea6bbfaaf80c0cd3c3fb00413b13551000bbdb5ebb"
    sha256 cellar: :any,                 ventura:        "ea5024808a66e6fbbdaf539c68e35bcb539105cc6519f61e9847c8f28caa4cd9"
    sha256 cellar: :any,                 monterey:       "ee0c5d7a21e9cd81e6de583b94ced51a832320a1491d42dc72adab8b99ac0e0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "674a306fb6133c743609cb27732ffd64060e5b2b4b6d16b1fb9bb60e1517281f"
  end

  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "six"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/67/fe/8c7b275824c6d2cd17c93ee85d0ee81c090285b6d52f4876ccc47cf9c3c4/annotated_types-0.6.0.tar.gz"
    sha256 "563339e807e53ffd9c267e99fc6d9ea23eb8443c08f112651963e24e22f84a5d"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "betterproto" do
    url "https://files.pythonhosted.org/packages/45/43/4c44efd75f2ef48a16b458c2fe2cff7aa74bab8fcadf2653bb5110a87f97/betterproto-2.0.0b6.tar.gz"
    sha256 "720ae92697000f6fcf049c69267d957f0871654c8b0d7458906607685daee784"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/6d/b3/aa417b4e3ace24067f243e45cceaffc12dba6b8bd50c229b43b3b163768b/charset-normalizer-3.3.1.tar.gz"
    sha256 "d9137a876020661972ca6eec0766d81aef8a5627df628b664b234b73396e727e"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/65/2d/372a20e52a87b2ba0160997575809806111a72e18aa92738daccceb8d2b9/dnspython-2.4.2.tar.gz"
    sha256 "8dcfae8c7460a2f84b4072e26f1c9f4101ca20c071649cb7c34e8b6a93d58984"
  end

  resource "email-validator" do
    url "https://files.pythonhosted.org/packages/69/36/70c8b90a303244b4b1bcb82c718797d91171c8f8b073fa9165c6f24df4fe/email_validator-2.1.0.post1.tar.gz"
    sha256 "a4b0bd1cf55f073b924258d19321b1f3aa74b4b5a71a42c305575dba920e1a44"
  end

  resource "grpclib" do
    url "https://files.pythonhosted.org/packages/55/80/66d4b36161996e75166f752408bb82eb04aeabcfdb487c5fd8dace72491a/grpclib-0.4.6.tar.gz"
    sha256 "595d05236ca8b8f8e433f5bf6095e6354c1d8777d003ddaf5288efa9611e3fd6"
  end

  resource "h2" do
    url "https://files.pythonhosted.org/packages/2a/32/fec683ddd10629ea4ea46d206752a95a2d8a48c22521edd70b142488efe1/h2-4.1.0.tar.gz"
    sha256 "a83aca08fbe7aacb79fec788c9c0bac936343560ed9ec18b82a13a12c28d2abb"
  end

  resource "hpack" do
    url "https://files.pythonhosted.org/packages/3e/9b/fda93fb4d957db19b0f6b370e79d586b3e8528b20252c729c476a2c02954/hpack-4.0.0.tar.gz"
    sha256 "fc41de0c63e687ebffde81187a948221294896f6bdc0ae2312708df339430095"
  end

  resource "hyperframe" do
    url "https://files.pythonhosted.org/packages/5a/2a/4747bff0a17f7281abe73e955d60d80aae537a5d203f417fa1c2e7578ebb/hyperframe-6.0.1.tar.gz"
    sha256 "ae510046231dc8e9ecb1a6586f63d2347bf4c8905914aa84ba585ae85f28a914"
  end

  resource "id" do
    url "https://files.pythonhosted.org/packages/a7/c6/2e83b0d17da616a21ff773873e6f64361ccf4bf11923e1fd852339a9c2e0/id-1.1.0.tar.gz"
    sha256 "726b995ffea6954ecbe3f2bb9e9d52b8502b2683b8470b13c58a429cd8e701e8"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/4a/15/bd620f7a6eb9aa5112c4ef93e7031bcd071e0611763d8e17706ef8ba65e0/multidict-6.0.4.tar.gz"
    sha256 "3666906492efb76453c0e7b97f2cf459b0682e7402c0489a95484965dbc1da49"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/df/e8/4f94ebd6972eff3babcea695d9634a4d60bea63955b9a4a413ec2fd3dd41/pydantic-2.4.2.tar.gz"
    sha256 "94f336138093a5d7f426aac732dcfe7ab4eb4da243c88f891d65deb4a2556ee7"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/af/31/8e466c6ed47cddf23013d2f2ccf3fdb5b908ffa1d5c444150c41690d6eca/pydantic_core-2.10.1.tar.gz"
    sha256 "0f8682dbdd2f67f8e1edddcbffcc29f60a6182b4901c367fc8c1c40d30bb0a82"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/30/72/8259b2bccfe4673330cea843ab23f86858a419d8f1493f66d413a76c7e3b/PyJWT-2.8.0.tar.gz"
    sha256 "57e28d156e3d5c10088e0c68abb90bfac3df82b40a71bd0daa20c65ccd5c23de"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/be/df/75a6525d8988a89aed2393347e9db27a56cb38a3e864314fac223e905aef/pyOpenSSL-23.2.0.tar.gz"
    sha256 "276f931f55a452e7dea69c7173e984eb2a4407ce413c918aa34b55f82f9b8bac"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "securesystemslib" do
    url "https://files.pythonhosted.org/packages/0b/65/7b11f438ab1fe724c9eae8d2aa0165b6127d648ad154b38d7b1c36bb5894/securesystemslib-0.30.0.tar.gz"
    sha256 "6a769e4816921ac4059c8c149ab5f69ed7cd92859857f0e17b67a3dd7bbee866"
  end

  resource "sigstore-protobuf-specs" do
    url "https://files.pythonhosted.org/packages/89/b6/5aa2f04b16cc089487fa5d40c0d032c989b2ba6d6e4f417d559ad9f8b85f/sigstore_protobuf_specs-0.2.2.tar.gz"
    sha256 "c05c1e7478a80af0c7dea9cc2d11f047826e4c029573d564137f788e11377391"
  end

  resource "sigstore-rekor-types" do
    url "https://files.pythonhosted.org/packages/32/cd/42f7a67aa471e783c26a44079bd9265f5a95a7c77cf2ef4efcebc180ec6a/sigstore_rekor_types-0.0.11.tar.gz"
    sha256 "791a696eccd5d07c933cc11d46dea22983efedaf5f1068734263ce0f25695bba"
  end

  resource "tuf" do
    url "https://files.pythonhosted.org/packages/de/38/952484915f31eb9cfcf0cf6e0e513c1319a9079075e4722f4f92bece65d6/tuf-3.1.0.tar.gz"
    sha256 "3a4e9abba9d03c221842f62a9a687d51cc2b4a26c43ee7deb1ffb5fa2fb49374"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sigstore -V")

    resource "homebrew-test-artifact" do
      url "https://ghproxy.com/https://github.com/sigstore/sigstore-python/releases/download/v2.0.1/sigstore-2.0.1.tar.gz", using: :nounzip
      sha256 "78013eaa2207c054ac803b361f8722011766d243bcbfa50c6e48003df2e3ca2f"
    end

    resource "homebrew-test-artifact.sigstore" do
      url "https://ghproxy.com/https://github.com/sigstore/sigstore-python/releases/download/v2.0.1/sigstore-2.0.1.tar.gz.sigstore"
      sha256 "0d19d7b7c30423f00b0f4a73ae4964e9c234d71d9b307192e612175444691b03"
    end

    resource("homebrew-test-artifact").stage testpath
    resource("homebrew-test-artifact.sigstore").stage testpath

    cert_identity = "https://github.com/sigstore/sigstore-python/.github/workflows/release.yml@refs/tags/v2.0.1"

    output = shell_output("#{bin}/sigstore verify github sigstore-2.0.1.tar.gz --cert-identity #{cert_identity}")
    assert_match "OK: sigstore-2.0.1.tar.gz", output
  end
end