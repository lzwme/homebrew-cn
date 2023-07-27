class Urlwatch < Formula
  include Language::Python::Virtualenv

  desc "Get notified when a webpage changes"
  homepage "https://thp.io/2008/urlwatch/"
  url "https://files.pythonhosted.org/packages/ef/6d/28df22a0912d40e294cfde709ead82e36441018ff9c0137c9e768ce9084e/urlwatch-2.28.tar.gz"
  sha256 "911df3abbd8923e46ec167a9657a812436caf93f7f9917cb7c95ebd73d28cce5"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f22a46e1a12c6370c959d70739a239fd8b972ee091e33a272f7d6dcbf8b2a7ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a9a7c71400f56b11656a73ed78a56b6f441a63e0ba329aee43e168cc91b7ea2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3923500844fd36b33be00b397110de34589ad411f9c7a4faa1157ec921aacd81"
    sha256 cellar: :any_skip_relocation, ventura:        "f474165a769dd6ab315a2a66e29259750b4927532d41d0f7e72713383638d66f"
    sha256 cellar: :any_skip_relocation, monterey:       "4f4f67868de5814fcdcfb0d05c36c4e60e169dfd761969b62e219c12fdc76af7"
    sha256 cellar: :any_skip_relocation, big_sur:        "a36a8dde4f2ab6f1b57497316de45e5e5223f42283b03b91503c2ab4d0635b8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c41c72f2719e90966f97ce677e5f71423951436f442323680a49fd8440114b7"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/98/98/c2ff18671db109c9f10ed27f5ef610ae05b73bd876664139cf95bd1429aa/certifi-2023.7.22.tar.gz"
    sha256 "539cc1d13202e33ca466e88b2807e29f4c13049d6d87031a3c110744495cb082"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/d1/91/d51202cc41fbfca7fa332f43a5adac4b253962588c7cc5a54824b019081c/cssselect-1.2.0.tar.gz"
    sha256 "666b19839cfaddb9ce9d36bfe4c969132c647b92fc9088c4e23f786b30f1b3dc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/33/44/ae06b446b8d8263d712a211e959212083a5eda2bf36d57ca7415e03f6f36/importlib_metadata-6.8.0.tar.gz"
    sha256 "dbace7892d8c0c4ac1ad096662232f831d4e64f4c4545bd53016a3e9d4654743"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/8b/de/d0a466824ce8b53c474bb29344e6d6113023eb2c3793d1c58c0908588bfa/jaraco.classes-3.3.0.tar.gz"
    sha256 "c063dd08e89217cee02c8d5e5ec560f2c8ce6cdc2fcdc2e68f7b2e5547ed3621"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/14/c5/7a2a66489c66ee29562300ddc5be63636f70b4025a74df71466e62d929b1/keyring-24.2.0.tar.gz"
    sha256 "ca0746a19ec421219f4d713f848fa297a661a8a8c1504867e55bfb5e09091509"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/30/39/7305428d1c4f28282a4f5bdbef24e0f905d351f34cf351ceb131f5cddf78/lxml-4.9.3.tar.gz"
    sha256 "48628bd53a426c9eb9bc066a923acaa0878d1e86129fd5359aee99285f4eed9c"
  end

  resource "minidb" do
    url "https://files.pythonhosted.org/packages/20/d4/915ac3b905cf33f3a0df5c92619fad66ae2e23cecd8f21dbfa76a9a27133/minidb-2.0.7.tar.gz"
    sha256 "339fd231e3b34daecd3160946e0141585666ac57583882a14c4c69e597accca1"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/b7/56/7daf104a9cb6af39c00127aee6904b01040dbb12cf1ceedd6a087c097055/more-itertools-10.0.0.tar.gz"
    sha256 "cd65437d7c4b615ab81c0640c0480bc29a550ea032891977681efd28344d51e1"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/e2/45/f3b987ad5bf9e08095c1ebe6352238be36f25dd106fde424a160061dce6d/zipp-3.16.2.tar.gz"
    sha256 "ebc15946aa78bd63458992fc81ec3b6f7b1e92d51c35e6de1c3804e73b799147"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"config.yaml").write("")
    (testpath/"urls.yaml").write("")
    output = shell_output("#{bin}/urlwatch --config #{testpath/"config.yaml"} " \
                          "--urls #{testpath/"urls.yaml"} --test-filter 1", 1)
    assert_match("Not found: '1'", output)
  end
end