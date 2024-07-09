class MetaPackageManager < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang

  desc "Wrapper around all package managers with a unifying CLI"
  homepage "https://kdeldycke.github.io/meta-package-manager/"
  url "https://files.pythonhosted.org/packages/c5/c0/35fc343df6f7fb9ca58d36f224132447ed613124c88e7e5f5604de5e05f1/meta_package_manager-5.17.0.tar.gz"
  sha256 "96ba190a8e9bb67d6b230865ff06ff9c9bcc447377a0b219c0a8765f7e6f326d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3682e20f10fa44be8d0cd5319064c6b8506691cf98b876b31c99924f0b0aed86"
    sha256 cellar: :any,                 arm64_ventura:  "83d2a054eeb49110bd73a50699d3691f34d9b65517599c3e17af34f4e3c5082e"
    sha256 cellar: :any,                 arm64_monterey: "73b881e5ace1e5552ae36244d6a26368644af9f800a428ca4861b2d60f7b355e"
    sha256 cellar: :any,                 sonoma:         "de1b6d98810c9eb74fcb362a14ac8e1dce66b9646411d35eb31fde57c1a9fd45"
    sha256 cellar: :any,                 ventura:        "6208c647c05f2ffdd863d807c635df2bc2b8c2b30ed63aa41a7413ee5b9f2420"
    sha256 cellar: :any,                 monterey:       "c0185bbae9b8931c3a4bb85002152a942494f65c757c66bedeefbf10db381119"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7b0e5b79810c03a0380d5620687bf91396167bbc6b74237cd3aecdf23c3e172"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "boltons" do
    url "https://files.pythonhosted.org/packages/7a/fb/214de4d813f566849956915ff07ee60f2b86424f294525e60e01c460d4d2/boltons-24.0.0.tar.gz"
    sha256 "7153feccaea1ff2e1472f68d4b57fadb796a2ee49d29f638f1c9cd8fb5ebd916"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/90/8b/34d174ce519f859af104c722fa30213103d34896a07a4f27bde6ac780633/bracex-2.4.tar.gz"
    sha256 "a27eaf1df42cf561fed58b7a8f3fdf129d1ea16a81e1fadd1d17989bc6384beb"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-extra" do
    url "https://files.pythonhosted.org/packages/f4/30/f411e19756fb2f512ea118e55207dff0558234f5bf504929c951a153b39c/click_extra-4.8.3.tar.gz"
    sha256 "d0a2409d1c65ba40de73193bf5a589d4aa6ea913cd85bbcce72689a8844b0601"
  end

  resource "cloup" do
    url "https://files.pythonhosted.org/packages/cf/71/608e4546208e5a421ef00b484f582e58ce0f17da05459b915c8ba22dfb78/cloup-3.0.5.tar.gz"
    sha256 "c92b261c7bb7e13004930f3fb4b3edad8de2d1f12994dcddbe05bc21990443c5"
  end

  resource "commentjson" do
    url "https://files.pythonhosted.org/packages/c0/76/c4aa9e408dbacee3f4de8e6c5417e5f55de7e62fb5a50300e1233a2c9cb5/commentjson-0.9.0.tar.gz"
    sha256 "42f9f231d97d93aff3286a4dc0de39bfd91ae823d1d9eba9fa901fe0c7113dd4"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "lark-parser" do
    url "https://files.pythonhosted.org/packages/34/b8/aa7d6cf2d5efdd2fcd85cf39b33584fe12a0f7086ed451176ceb7fb510eb/lark-parser-0.7.8.tar.gz"
    sha256 "26215ebb157e6fb2ee74319aa4445b9f3b7e456e26be215ce19fdaaa901c20a4"
  end

  resource "mergedeep" do
    url "https://files.pythonhosted.org/packages/3a/41/580bb4006e3ed0361b8151a01d324fb03f420815446c7def45d02f74c270/mergedeep-1.3.4.tar.gz"
    sha256 "0096d52e9dad9939c3d975a774666af186eda617e6ca84df4c94dec30004f2a8"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/01/33/77f586de725fc990d12dda3d4efca4a41635be0f99a987b9cc3a78364c13/more-itertools-10.3.0.tar.gz"
    sha256 "e5d93ef411224fbcef366a6e8ddc4c5781bc6359d43412a65dd5964e46111463"
  end

  resource "packageurl-python" do
    url "https://files.pythonhosted.org/packages/b5/0c/08dfe9c4bf1dbb4aa06e1095bdbe636095e3b02e8212d3def3ea77c94c44/packageurl_python-0.15.2.tar.gz"
    sha256 "9cd10eeedbc6680728c10a1585c6dd7bbad4ef4b389d80cd0ac223205e9c87df"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/7a/db/5ddc89851e9cc003929c3b08b9b88b429459bf9acbf307b4556d51d9e49b/regex-2024.5.15.tar.gz"
    sha256 "d3ee02d9e5f482cc8309134a91eeaacbdd2261ba111b0fef3748eeb4913e6a2c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/49/05/6bf21838623186b91aedbda06248ad18f03487dc56fbc20e4db384abde6c/tomli_w-1.0.0.tar.gz"
    sha256 "f463434305e0336248cac9c2dc8076b707d8a12d019dd349f5c1e382dd1ae1b9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/ea/c4/55e0d36da61d7b8b2a49fd273e6b296fd5e8471c72ebbe438635d1af3968/wcmatch-8.5.2.tar.gz"
    sha256 "a70222b86dea82fb382dd87b73278c10756c138bd6f8f714e2183128887b9eb2"
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