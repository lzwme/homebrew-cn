class Abi3audit < Formula
  include Language::Python::Virtualenv

  desc "Scans Python packages for abi3 violations and inconsistencies"
  homepage "https://github.com/trailofbits/abi3audit"
  url "https://files.pythonhosted.org/packages/a3/4d/1f08c6db0b6cf02ef0fe33be39144d4477030910c3f61bffa3b2a9b09e87/abi3audit-0.0.9.tar.gz"
  sha256 "4f469e146d911f238724d49fd280d8bb7f411ff5d224865b13e47d4132e776a6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32629132628155b7d6912a441572f154a3517d9b766a1715ef60caddc215a2fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b0f331a37688fdf2630bd80d740831b6241438efc8af95926452e0f30f91399"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73e1e88049fde36ac53ea374f296cf5a116e0172e667e24adb8f6ff52a53716a"
    sha256 cellar: :any_skip_relocation, sonoma:         "642f2bfacc6327af8113c09c928ace7aef127edfecc5214f84d2d401da532023"
    sha256 cellar: :any_skip_relocation, ventura:        "2b285f42a7ef2e38b420e896aa8b17669cb6c0cb115a59a1dfbe559962b26410"
    sha256 cellar: :any_skip_relocation, monterey:       "4056acb2d58d05903381a85328f6500f1972ed1da9de8b2633fc35fc8924d576"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bb8143edd8abcafd85e0fd1cb3683240809bb611d6d621ed26a7322cad30598"
  end

  depends_on "cmake" => :build
  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python-packaging"
  depends_on "python@3.12"
  depends_on "six"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "rust" => :build
  end

  resource "abi3info" do
    url "https://files.pythonhosted.org/packages/4f/d9/366f6670b677f68c96cb06a5ab58c410be888bcb19bd39743e7e177db9d0/abi3info-2023.10.22.tar.gz"
    sha256 "b02a11119d417e02e2e2ebb0adf247f6796fa19906d2c49926d207b22f19e3ef"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/68/d4/27f9fd840e74d51b6d6a024d39ff495b56ffde71d28eb82758b7b85d0617/cattrs-23.1.2.tar.gz"
    sha256 "db1c821b8c537382b2c7c66678c3790091ca0275ac486c76f3c8f3920e83c657"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/6d/b3/aa417b4e3ace24067f243e45cceaffc12dba6b8bd50c229b43b3b163768b/charset-normalizer-3.3.1.tar.gz"
    sha256 "d9137a876020661972ca6eec0766d81aef8a5627df628b664b234b73396e727e"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "kaitaistruct" do
    url "https://files.pythonhosted.org/packages/54/04/dd60b9cb65d580ef6cb6eaee975ad1bdd22d46a3f51b07a1e0606710ea88/kaitaistruct-0.10.tar.gz"
    sha256 "a044dee29173d6afbacf27bcac39daf89b654dd418cfa009ab82d9178a9ae52a"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pefile" do
    url "https://files.pythonhosted.org/packages/78/c5/3b3c62223f72e2360737fd2a57c30e5b2adecd85e70276879609a7403334/pefile-2023.2.7.tar.gz"
    sha256 "82e6114004b3d6911c77c3953e3838654b04511b8b66e8583db70c65998017dc"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d3/e3/aa14d6b2c379fbb005993514988d956f1b9fdccd9cbe78ec0dbe5fb79bf5/platformdirs-3.11.0.tar.gz"
    sha256 "cf8ee52a3afdb965072dcc652433e0c7e3e40cf5ea1477cd4b3b1d2eb75495b3"
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/84/05/fd41cd647de044d1ffec90ce5aaae935126ac217f8ecb302186655284fc8/pyelftools-0.30.tar.gz"
    sha256 "2fc92b0d534f8b081f58c7c370967379123d8e00984deb53c209364efd575b40"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-cache" do
    url "https://files.pythonhosted.org/packages/79/13/c37358338bbbe223caf2ec59580be675c1657f3f295598ac69e275590140/requests_cache-1.1.0.tar.gz"
    sha256 "41b79166aa8e300cc4de982f7ab7c52af914a785160be1eda25c6e9265969a67"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b1/0e/e5aa3ab6857a16dadac7a970b2e1af21ddf23f03c99248db2c01082090a3/rich-13.6.0.tar.gz"
    sha256 "5c14d22737e6d5084ef4771b62d5d4363165b403455a30a1c8ca39dc7b644bef"
  end

  resource "url-normalize" do
    url "https://files.pythonhosted.org/packages/ec/ea/780a38c99fef750897158c0afb83b979def3b379aaac28b31538d24c4e8f/url-normalize-1.4.3.tar.gz"
    sha256 "d23d3a070ac52a67b83a1c59a0e68f8608d1cd538783b401bc9de2c0fac999b2"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/abi3audit sip 2>&1", 1)
    assert_match(/sip: \d+ extensions scanned; \d+ ABI version mismatches and \d+ ABI\s+violations found/, output)
  end
end