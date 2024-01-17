class MetaPackageManager < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang

  desc "Wrapper around all package managers with a unifying CLI"
  homepage "https://kdeldycke.github.io/meta-package-manager/"
  url "https://files.pythonhosted.org/packages/eb/50/ce722b0bd646702b54e855bea3d33ed17a3b212d890cde29fdf9ab1beceb/meta_package_manager-5.14.1.tar.gz"
  sha256 "77128a3911acc3a290b11bc310a858c0ec1630a77a5e2f716f53bf63796e5b10"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "09e3a5023f2740be5cc3dbcfdd9bdd38010b63c9d6b06aeb82ae39fb07b6ff0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8aebc3fc308e3eaa99dda605bd18f8894a6628abd9e834415e8715ad09d98cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cdec3be97572be7ec11c85d8b8a048872e52c25edd7652d073b6aefbf1a470d"
    sha256 cellar: :any_skip_relocation, sonoma:         "800dcfe7c7280c4a800857b08a9ef6e8c388eb28ea4e0b8ac44a5f2f48a82c37"
    sha256 cellar: :any_skip_relocation, ventura:        "3cac71a0f927f7b60ca10fb12eb4c5839911f3a74f57c0c86c5e276d6ca68dd7"
    sha256 cellar: :any_skip_relocation, monterey:       "ec6cae104a34b2e8f8179c3cfdc4845704f855903863e229280ba80eb26fed69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b693fccbbbd739e1593ef5af900081c47f731cccac88d268dbcdb85a3c835c9"
  end

  depends_on "docutils"
  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-markupsafe"
  depends_on "python-packaging"
  depends_on "python-tabulate"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "pyyaml"

  resource "alabaster" do
    url "https://files.pythonhosted.org/packages/c9/3e/13dd8e5ed9094e734ac430b5d0eb4f2bb001708a8b7856cbf8e084e001ba/alabaster-0.7.16.tar.gz"
    sha256 "75a8b99c28a5dad50dd7f8ccdd447a121ddb3892da9e53d1ca5cca3106d58d65"
  end

  resource "babel" do
    url "https://files.pythonhosted.org/packages/e2/80/cfbe44a9085d112e983282ee7ca4c00429bc4d1ce86ee5f4e60259ddff7f/Babel-2.14.0.tar.gz"
    sha256 "6919867db036398ba21eb5c7a0f6b28ab8cbc3ae7a73a44ebe34ae74a4e7d363"
  end

  resource "boltons" do
    url "https://files.pythonhosted.org/packages/55/5a/e8e581df428786bb9956a1faa61062cb4f2f726dbaedf8bd9165583d216d/boltons-23.1.1.tar.gz"
    sha256 "d2cb2fa83cf2ebe791be1e284183e8a43a1031355156a968f8e0a333ad2448fc"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/90/8b/34d174ce519f859af104c722fa30213103d34896a07a4f27bde6ac780633/bracex-2.4.tar.gz"
    sha256 "a27eaf1df42cf561fed58b7a8f3fdf129d1ea16a81e1fadd1d17989bc6384beb"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click-extra" do
    url "https://files.pythonhosted.org/packages/29/02/dd79eefde09f55b68a943f65ee33522bbc1906a6e2ec83e4369b2b40eed2/click_extra-4.7.3.tar.gz"
    sha256 "ce4bff859283fb7dc5c8da023bf286e3171ece3555dcb94809843f870d50085c"
  end

  resource "cloup" do
    url "https://files.pythonhosted.org/packages/e4/95/1cdc36a95ffb2a48542b7439d5a7ba6cba0fa90208be913c01edcf267ca5/cloup-3.0.4.tar.gz"
    sha256 "658111e2f49b8256a822dac5fa0205bf64109fdefc435f39923490a32b13ec09"
  end

  resource "commentjson" do
    url "https://files.pythonhosted.org/packages/c0/76/c4aa9e408dbacee3f4de8e6c5417e5f55de7e62fb5a50300e1233a2c9cb5/commentjson-0.9.0.tar.gz"
    sha256 "42f9f231d97d93aff3286a4dc0de39bfd91ae823d1d9eba9fa901fe0c7113dd4"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "imagesize" do
    url "https://files.pythonhosted.org/packages/a7/84/62473fb57d61e31fef6e36d64a179c8781605429fd927b5dd608c997be31/imagesize-1.4.1.tar.gz"
    sha256 "69150444affb9cb0d5cc5a92b3676f0b2fb7cd9ae39e947a5e11a36b4497cd4a"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/b2/5e/3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1/Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
  end

  resource "lark-parser" do
    url "https://files.pythonhosted.org/packages/34/b8/aa7d6cf2d5efdd2fcd85cf39b33584fe12a0f7086ed451176ceb7fb510eb/lark-parser-0.7.8.tar.gz"
    sha256 "26215ebb157e6fb2ee74319aa4445b9f3b7e456e26be215ce19fdaaa901c20a4"
  end

  resource "mergedeep" do
    url "https://files.pythonhosted.org/packages/3a/41/580bb4006e3ed0361b8151a01d324fb03f420815446c7def45d02f74c270/mergedeep-1.3.4.tar.gz"
    sha256 "0096d52e9dad9939c3d975a774666af186eda617e6ca84df4c94dec30004f2a8"
  end

  resource "packageurl-python" do
    url "https://files.pythonhosted.org/packages/8c/33/e50adf6a6cd4cde7ccd140e4538d898cea7a609f7aee5d6365e5cd44b6c8/packageurl-python-0.13.4.tar.gz"
    sha256 "6eb5e995009cc73387095e0b507ab65df51357d25ddc5fce3d3545ad6dcbbee8"
  end

  resource "pallets-sphinx-themes" do
    url "https://files.pythonhosted.org/packages/d2/33/95be76c25ed7b853f61cd7afbb5a2c1e17cca5fb39ca3f0f485a6d206358/Pallets-Sphinx-Themes-2.1.1.tar.gz"
    sha256 "e5da65967bb6fae3055682a97d37c3311fe38e132c0761052c16aaacafc8d47f"
  end

  resource "pygments-ansi-color" do
    url "https://files.pythonhosted.org/packages/50/f9/7f417aaee98a74b4f757f2b72971245181fcf25d824d2e7a190345669eaf/pygments-ansi-color-0.3.0.tar.gz"
    sha256 "7018954cf5b11d1e734383a1bafab5af613213f246109417fee3f76da26d5431"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/b5/39/31626e7e75b187fae7f121af3c538a991e725c744ac893cc2cfd70ce2853/regex-2023.12.25.tar.gz"
    sha256 "29171aa128da69afdf4bde412d5bedc335f2ca8fcfe4489038577d05f16181e5"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "snowballstemmer" do
    url "https://files.pythonhosted.org/packages/44/7b/af302bebf22c749c56c9c3e8ae13190b5b5db37a33d9068652e8f73b7089/snowballstemmer-2.2.0.tar.gz"
    sha256 "09b16deb8547d3412ad7b590689584cd0fe25ec8db3be37788be3810cbf19cb1"
  end

  resource "sphinx" do
    url "https://files.pythonhosted.org/packages/73/8e/6e51da4b26665b4b92b1944ea18b2d9c825e753e19180cc5bdc818d0ed3b/sphinx-7.2.6.tar.gz"
    sha256 "9a5160e1ea90688d5963ba09a2dcd8bdd526620edbb65c328728f1b2228d5ab5"
  end

  resource "sphinxcontrib-applehelp" do
    url "https://files.pythonhosted.org/packages/26/6b/68f470fc337ed24043fec987b101f25b35010970bd958970c2ae5990859f/sphinxcontrib_applehelp-1.0.8.tar.gz"
    sha256 "c40a4f96f3776c4393d933412053962fac2b84f4c99a7982ba42e09576a70619"
  end

  resource "sphinxcontrib-devhelp" do
    url "https://files.pythonhosted.org/packages/c7/a1/80b7e9f677abc673cb9320bf255ad4e08931ccbc2e66bde4b59bad3809ad/sphinxcontrib_devhelp-1.0.6.tar.gz"
    sha256 "9893fd3f90506bc4b97bdb977ceb8fbd823989f4316b28c3841ec128544372d3"
  end

  resource "sphinxcontrib-htmlhelp" do
    url "https://files.pythonhosted.org/packages/8a/03/2f9d699fbfdf03ecb3b6d0e2a268a8998d009f2a9f699c2dcc936899257d/sphinxcontrib_htmlhelp-2.0.5.tar.gz"
    sha256 "0dc87637d5de53dd5eec3a6a01753b1ccf99494bd756aafecd74b4fa9e729015"
  end

  resource "sphinxcontrib-jsmath" do
    url "https://files.pythonhosted.org/packages/b2/e8/9ed3830aeed71f17c026a07a5097edcf44b692850ef215b161b8ad875729/sphinxcontrib-jsmath-1.0.1.tar.gz"
    sha256 "a9925e4a4587247ed2191a22df5f6970656cb8ca2bd6284309578f2153e0c4b8"
  end

  resource "sphinxcontrib-qthelp" do
    url "https://files.pythonhosted.org/packages/ac/29/705cd4e93e98a8473d62b5c32288e6de3f0c9660d3c97d4e80d3dbbad82b/sphinxcontrib_qthelp-1.0.7.tar.gz"
    sha256 "053dedc38823a80a7209a80860b16b722e9e0209e32fea98c90e4e6624588ed6"
  end

  resource "sphinxcontrib-serializinghtml" do
    url "https://files.pythonhosted.org/packages/54/13/8dd7a7ed9c58e16e20c7f4ce8e4cb6943eb580955236d0c0d00079a73c49/sphinxcontrib_serializinghtml-1.1.10.tar.gz"
    sha256 "93f3f5dc458b91b192fe10c397e324f262cf163d79f3282c158e8436a2c4511f"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/49/05/6bf21838623186b91aedbda06248ad18f03487dc56fbc20e4db384abde6c/tomli_w-1.0.0.tar.gz"
    sha256 "f463434305e0336248cac9c2dc8076b707d8a12d019dd349f5c1e382dd1ae1b9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/92/51/72ce10501dbfe508808fd6a637d0a35d1b723a5e8c470f3d6e9458a4f415/wcmatch-8.5.tar.gz"
    sha256 "86c17572d0f75cbf3bcb1a18f3bf2f9e72b39a9c08c9b4a74e991e1882a8efb3"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/39/0d/40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7f/xmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  def install
    rewrite_shebang detected_python_shebang, "meta_package_manager/bar_plugin.py"
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mpm --version")

    # Check mpm is detecting brew and report it as a manager in a table row.
    assert_match(
      /\e\[32mbrew\e\[0m,Homebrew Formulae,\e\[32m✓\e\[0m,\e\[32m✓\e\[0m \S+,\e\[32m✓\e\[0m,\e\[32m✓\e\[0m \S+/,
      shell_output("#{bin}/mpm --output-format csv --all-managers managers"),
    )
    # Check mpm is reporting itself as installed via brew in a table row.
    assert_match "meta-package-manager,,brew,#{version}", shell_output("#{bin}/mpm --output-format csv installed")
  end
end