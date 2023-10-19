class Urlwatch < Formula
  include Language::Python::Virtualenv

  desc "Get notified when a webpage changes"
  homepage "https://thp.io/2008/urlwatch/"
  url "https://files.pythonhosted.org/packages/ef/6d/28df22a0912d40e294cfde709ead82e36441018ff9c0137c9e768ce9084e/urlwatch-2.28.tar.gz"
  sha256 "911df3abbd8923e46ec167a9657a812436caf93f7f9917cb7c95ebd73d28cce5"
  license "BSD-3-Clause"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0cc3d8772b8f74544707923eacf442f1dc834db27e655179289e8df360e8329f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6df6182c6a44af7156ca5f7a8ac770ae35f8b9526cab0460184b0a31f99c11b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a526d9114511b8cd1995bccf282a84a4952f02762055baf84899a36d89755460"
    sha256 cellar: :any_skip_relocation, sonoma:         "659a778c4a4ec92f2a8d7723ca84e6d587e1cecec1fc8a970a082bc257deff23"
    sha256 cellar: :any_skip_relocation, ventura:        "e857715c758bd9fa5601623415fcb90371062329670175198fc9beed2665fe8d"
    sha256 cellar: :any_skip_relocation, monterey:       "74132662605533c41b18702668cbb5c892928ede851d2f065406c54cd5cefc8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea35fec6d951fadeec69ec1332f5580fb32e2669a0dc03a828ce07bf6c1cfddf"
  end

  depends_on "keyring"
  depends_on "python-certifi"
  depends_on "python-lxml"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/d1/91/d51202cc41fbfca7fa332f43a5adac4b253962588c7cc5a54824b019081c/cssselect-1.2.0.tar.gz"
    sha256 "666b19839cfaddb9ce9d36bfe4c969132c647b92fc9088c4e23f786b30f1b3dc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/30/39/7305428d1c4f28282a4f5bdbef24e0f905d351f34cf351ceb131f5cddf78/lxml-4.9.3.tar.gz"
    sha256 "48628bd53a426c9eb9bc066a923acaa0878d1e86129fd5359aee99285f4eed9c"
  end

  resource "minidb" do
    url "https://files.pythonhosted.org/packages/20/d4/915ac3b905cf33f3a0df5c92619fad66ae2e23cecd8f21dbfa76a9a27133/minidb-2.0.7.tar.gz"
    sha256 "339fd231e3b34daecd3160946e0141585666ac57583882a14c4c69e597accca1"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    virtualenv_install_with_resources

    # we depend on keyring, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.11")
    paths = %w[keyring].map { |p| Formula[p].opt_libexec/site_packages }
    (libexec/site_packages/"homebrew-deps.pth").write paths.join("\n")
  end

  test do
    (testpath/"config.yaml").write("")
    (testpath/"urls.yaml").write("")
    output = shell_output("#{bin}/urlwatch --config #{testpath/"config.yaml"} " \
                          "--urls #{testpath/"urls.yaml"} --test-filter 1", 1)
    assert_match("Not found: '1'", output)
  end
end