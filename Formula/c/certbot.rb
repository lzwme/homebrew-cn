class Certbot < Formula
  include Language::Python::Virtualenv

  desc "Tool to obtain certs from Let's Encrypt and autoenable HTTPS"
  homepage "https:certbot.eff.org"
  url "https:files.pythonhosted.orgpackagesded76dbaabb3dd61a3a86cad455c65befa7512f1f8c60231f99ed1f2b576770fcertbot-4.1.1.tar.gz"
  sha256 "d1fdde3174bcf1d68f7a8dca070341acec28b78ef92ad2dd18b8d49959e96779"
  license "Apache-2.0"
  head "https:github.comcertbotcertbot.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a914663de082659e6764f7707c2af755b2ce20a6033e84c97da5a3d08d7d3019"
    sha256 cellar: :any,                 arm64_sonoma:  "522336962cd2c7bdf94aa437e27c9773abbbecf4e5210a28b2f4a9d63e00e984"
    sha256 cellar: :any,                 arm64_ventura: "b33ea2ea30e15d573bbad7068ceb52acb958e552ba7a5dd35e98db7f788ccc21"
    sha256 cellar: :any,                 sonoma:        "1e3d5da5645d6d2001a84a728664d6a994c35df85433d134fa0974023c069547"
    sha256 cellar: :any,                 ventura:       "5de71287f5d5c1e014530635be508307f7cc1f78a75351670dbca863c2871734"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "606746bb1e92f3fb80d077f4976d2b85742f9c06747b21ede8bcd055d3b8bb2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c64175305a4ce5d4088db61d232929b9c22d72ac63e814a864ccd930084b42c5"
  end

  depends_on "augeas"
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "dialog"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  resource "acme" do
    url "https:files.pythonhosted.orgpackages30caac80099cdcce9486f5c74220dac53e8b35c46afc27288881f4700adfe7f1acme-4.1.1.tar.gz"
    sha256 "0ffaaf6d3f41ff05772fd2b6170cf0b2b139f5134d7a70ee49f6e63ca20e8f9a"
  end

  resource "certbot-apache" do
    url "https:files.pythonhosted.orgpackages2232890b80ee38496583b72cf507ee197af930d8806c27692b08d554a2ff7524certbot_apache-4.1.1.tar.gz"
    sha256 "8b43f9f4b3cb504109cae58b7b8edbadb62bd3fbb1e796fe17ea426a7195b41f"
  end

  resource "certbot-nginx" do
    url "https:files.pythonhosted.orgpackages24473cd74f17c57377b89acedb7babecb9eb23da234c56f50aadf4892105921ecertbot_nginx-4.1.1.tar.gz"
    sha256 "9b03a0c877d8004bc8b077d6aa8419257300a23c7d72f9d8fe268a0a3bb859f2"
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