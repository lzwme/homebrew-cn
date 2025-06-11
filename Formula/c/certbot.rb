class Certbot < Formula
  include Language::Python::Virtualenv

  desc "Tool to obtain certs from Let's Encrypt and autoenable HTTPS"
  homepage "https:certbot.eff.org"
  url "https:files.pythonhosted.orgpackages0091a7acb7a9f7f065bf7f4aa356ecae039f229798eeceed205f397f329cd666certbot-4.0.0.tar.gz"
  sha256 "a867bfbb5126516c12d4c8a93909ef1e4d5309fc4e9f5b97b2d987b0ffd4bbe3"
  license "Apache-2.0"
  revision 1
  head "https:github.comcertbotcertbot.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9a5bee505f0ec3ce36398fdd3a1d151089d3df415e6fa63edf1402eb9a0bc2bb"
    sha256 cellar: :any,                 arm64_sonoma:  "a84be3256c9e6b28acb1ba451e279185d01a7f4a6ce1fb4c5a6584681907cd11"
    sha256 cellar: :any,                 arm64_ventura: "e3b868dd1e5aa9975cce33c88a235668114b1e5cae070eefc4baaf84c373dbf1"
    sha256 cellar: :any,                 sonoma:        "ac17b5eabeaf245ff7e00185233dec5aa9cc50f421a92a673c6f2540c7018a30"
    sha256 cellar: :any,                 ventura:       "e10c0adb851a2c02483d7ff7fc93235ab25d6113023f04adfa4356506c0c847f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51821681784f58d59594a15f24b46b47c0e4a9716943f8257e7118bb29c2a460"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2123a85ea6041c24be1382f33a2f1a18f6b77f98b04a0740d0c2a99b00596804"
  end

  depends_on "augeas"
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "dialog"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  resource "acme" do
    url "https:files.pythonhosted.orgpackagesc6aa8d598e7338fb9677a9084c27d86e51f3732c541be161d77a24e28f23b6f2acme-4.0.0.tar.gz"
    sha256 "972d6e0b160000ae833aaa9619901896336e5dc7ca82003fa6ff465bafcbdf52"
  end

  resource "certbot-apache" do
    url "https:files.pythonhosted.orgpackages0a936136841f9550fcfa7d7fee47854e359fc906e12446617b31c277c3e02dfccertbot_apache-4.0.0.tar.gz"
    sha256 "507f9a336bd95c25548f449d8307eead6f875186a13049de173d6833371910a2"
  end

  resource "certbot-nginx" do
    url "https:files.pythonhosted.orgpackages06a84ab3316ded812c91521c926ea3887ee6698cb656febd4e0f3ccc18dea64fcertbot_nginx-4.0.0.tar.gz"
    sha256 "4478c3e13e04b49f95675d83adaacdcf1356f8fac0824e236f893f2f5a1d991c"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "configargparse" do
    url "https:files.pythonhosted.orgpackages854d6c9ef746dfcc2a32e26f3860bb4a011c008c392b83eabdfb598d1a8bbe5dconfigargparse-1.7.1.tar.gz"
    sha256 "79c2ddae836a1e5914b71d58e4b9adbd9f7779d4e6351a637b7d2d9b6c46d3d9"
  end

  resource "configobj" do
    url "https:files.pythonhosted.orgpackagesf5c4c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "distro" do
    url "https:files.pythonhosted.orgpackagesfcf898eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "josepy" do
    url "https:files.pythonhosted.orgpackagesa929e7c14150f200c5cd49d1a71b413f61b97406f57872ad693857982c0869c9josepy-2.0.0.tar.gz"
    sha256 "e7d7acd2fe77435cda76092abe4950bb47b597243a8fb733088615fa6de9ec40"
  end

  resource "parsedatetime" do
    url "https:files.pythonhosted.orgpackagesa820cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312acparsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "pyopenssl" do
    url "https:files.pythonhosted.orgpackages048ccd89ad05804f8e3c17dea8f178c3f40eeab5694c30e0c9f5bcd49f576fc3pyopenssl-25.1.0.tar.gz"
    sha256 "8d031884482e0c67ee92bf9a4d8cceb08d92aba7136432ffb0703c5280fc205b"
  end

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackagesbb22f1129e69d94ffff626bdb5c835506b3a5b4f3d070f17ea295e12c2c6f60fpyparsing-3.2.3.tar.gz"
    sha256 "b9c13f1ab8b3b542f72e28f634bad4de758ab3ce4546e4301970ad6fa77c38be"
  end

  resource "pyrfc3339" do
    url "https:files.pythonhosted.orgpackagesf0d26587e8ec3951cbd97c56333d11e0f8a3a4cb64c0d6ed101882b7b31c431fpyrfc3339-2.0.1.tar.gz"
    sha256 "e47843379ea35c1296c3b6c67a948a1a490ae0584edfcbdea0eaffb5dd29960b"
  end

  resource "python-augeas" do
    url "https:files.pythonhosted.orgpackages44f6e09619a5a4393fe061e24a6f129c3e1fbb9f25f774bfc2f5ae82ba5e24d3python-augeas-1.2.0.tar.gz"
    sha256 "d2334710e12bdec8b6633a7c2b72df4ca24ab79094a3c9e699494fdb62054a10"
  end

  resource "pytz" do
    url "https:files.pythonhosted.orgpackagesf8bfabbd3cdfb8fbc7fb3d4d38d320f2441b1e7cbe29be4f23797b4a2b5d8aacpytz-2025.2.tar.gz"
    sha256 "360b9e3dbb49a209c21ad61809c7fb453643e048b38924c765813546746e81c3"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  def install
    if build.head?
      head_packages = %w[acme certbot certbot-apache certbot-nginx]
      venv = virtualenv_create(libexec, "python3.13")
      venv.pip_install resources.reject { |r| head_packages.include? r.name }
      venv.pip_install_and_link head_packages.map { |pkg| buildpathpkg }
      pkgshare.install buildpath"certbotexamples"
    else
      virtualenv_install_with_resources
      pkgshare.install buildpath"examples"
    end
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}certbot --version 2>&1")
    # This throws a bad exit code but we can check it actually is failing
    # for the right reasons by asserting. --version never fails even if
    # resources are missing or outdatedtoo newetc.
    assert_match "Either run as root", shell_output("#{bin}certbot 2>&1", 1)
  end
end