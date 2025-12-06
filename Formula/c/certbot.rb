class Certbot < Formula
  include Language::Python::Virtualenv

  desc "Tool to obtain certs from Let's Encrypt and autoenable HTTPS"
  homepage "https://certbot.eff.org/"
  url "https://files.pythonhosted.org/packages/ab/3b/58c18b4820a2135921a24f188b05ef9fa3fe3e64fa77f8be68230ccddc43/certbot-5.2.1.tar.gz"
  sha256 "5faed67634a3f8a62782655b5f739161804fc9999577b263ea7dd76eba62f406"
  license "Apache-2.0"
  revision 1
  head "https://github.com/certbot/certbot.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f36cfa79fd51d883ea46824685a99e53b9abaf28a3b1c464a4f279c2e7ff9025"
    sha256 cellar: :any,                 arm64_sequoia: "232d7c018064b05119e27b57886cf7001b37dc3aa76bb7e283d2e86fb5b0e06a"
    sha256 cellar: :any,                 arm64_sonoma:  "53d264b15db42469a6ff6ca3fa43cf79bdb8c6c82ca52213a253328e5fad8a4d"
    sha256 cellar: :any,                 sonoma:        "7dfe521727fe78af844034bc734fb69e1a9ad551bb5d494d9b2cd8377ac8a1a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0386b57d09ed6c512b52ee574daec82b74ddd85f3de0cd93210bb947d5b1bd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6fee4535adebe2cff33870d692a8c7e9f4f2339f7d717a1b41707241aafae22"
  end

  depends_on "augeas"
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  uses_from_macos "libffi"

  pypi_packages exclude_packages: ["certifi", "cryptography"],
                extra_packages:   ["certbot-apache", "certbot-nginx", "certbot-dns-cloudflare"]

  resource "acme" do
    url "https://files.pythonhosted.org/packages/82/28/5e2c12a70afd822750e7ba7db4879e7310182093fdcbff7db1436c480be2/acme-5.2.1.tar.gz"
    sha256 "5f905542b85a75a767dfb540ccfa78b9c758c6619338651755347ca7dd22a1fd"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "certbot-apache" do
    url "https://files.pythonhosted.org/packages/5d/d9/0a2cf2b841034d958fb841f597db0acad2434d3e17bf5bccff3918ce81ca/certbot_apache-5.2.1.tar.gz"
    sha256 "c6e8f78953430aec2ffaedd5ba55184c4092b6865d157d03a573264e2499e62d"
  end

  resource "certbot-dns-cloudflare" do
    url "https://files.pythonhosted.org/packages/c0/c0/a45b956f203c8e0fe8a41abc424109033d5ee18c19f2bd0ebf5f95455256/certbot_dns_cloudflare-5.2.1.tar.gz"
    sha256 "914994cd4098cc4798589c946f9e96c472d4ab3810d9d52c5e15fb980d825bb2"
  end

  resource "certbot-nginx" do
    url "https://files.pythonhosted.org/packages/97/c8/74f4d00d0378d7d295c3646a8c3a9f4d7d8ef6806965d644131c53c4cf20/certbot_nginx-5.2.1.tar.gz"
    sha256 "214fa65dac5e0ae22604d849166849fb527feabf82cccf4b6f999e8e3783e567"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "cloudflare" do
    url "https://files.pythonhosted.org/packages/9b/8f/d3a435435c42d4b05ce2274432265c5890f91f6047e6dab52e50c811a4ea/cloudflare-2.19.4.tar.gz"
    sha256 "3b6000a01a237c23bccfdf6d20256ea5111ec74a826ae9e74f9f0e5bb5b2383f"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/85/4d/6c9ef746dfcc2a32e26f3860bb4a011c008c392b83eabdfb598d1a8bbe5d/configargparse-1.7.1.tar.gz"
    sha256 "79c2ddae836a1e5914b71d58e4b9adbd9f7779d4e6351a637b7d2d9b6c46d3d9"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "josepy" do
    url "https://files.pythonhosted.org/packages/7f/ad/6f520aee9cc9618d33430380741e9ef859b2c560b1e7915e755c084f6bc0/josepy-2.2.0.tar.gz"
    sha256 "74c033151337c854f83efe5305a291686cef723b4b970c43cfe7270cf4a677a9"
  end

  resource "jsonlines" do
    url "https://files.pythonhosted.org/packages/35/87/bcda8e46c88d0e34cad2f09ee2d0c7f5957bccdb9791b0b934ec84d84be4/jsonlines-4.0.0.tar.gz"
    sha256 "0c6d2c09117550c089995247f605ae4cf77dd1533041d366351f6f298822ea74"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/80/be/97b83a464498a79103036bc74d1038df4a7ef0e402cfaf4d5e113fb14759/pyopenssl-25.3.0.tar.gz"
    sha256 "c981cb0a3fd84e8602d7afc209522773b94c1c2446a3c710a75b06fe1beae329"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/f2/a5/181488fc2b9d093e3972d2a472855aae8a03f000592dbfce716a512b3359/pyparsing-3.2.5.tar.gz"
    sha256 "2df8d5b7b2802ef88e8d016a2eb9c7aeaa923529cd251ed0fe4608275d4105b6"
  end

  resource "pyrfc3339" do
    url "https://files.pythonhosted.org/packages/b4/7f/3c194647ecb80ada6937c38a162ab3edba85a8b6a58fa2919405f4de2509/pyrfc3339-2.1.0.tar.gz"
    sha256 "c569a9714faf115cdb20b51e830e798c1f4de8dabb07f6ff25d221b5d09d8d7f"
  end

  resource "python-augeas" do
    url "https://files.pythonhosted.org/packages/44/f6/e09619a5a4393fe061e24a6f129c3e1fbb9f25f774bfc2f5ae82ba5e24d3/python-augeas-1.2.0.tar.gz"
    sha256 "d2334710e12bdec8b6633a7c2b72df4ca24ab79094a3c9e699494fdb62054a10"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1c/43/554c2569b62f49350597348fc3ac70f786e3c32e7f19d266e19817812dd3/urllib3-2.6.0.tar.gz"
    sha256 "cb9bcef5a4b345d5da5d145dc3e30834f58e8018828cbc724d30b4cb7d4d49f1"
  end

  def install
    if build.head?
      head_packages = %w[acme certbot certbot-apache certbot-nginx certbot-dns-cloudflare]
      venv = virtualenv_create(libexec, "python3.14")
      venv.pip_install resources.reject { |r| head_packages.include? r.name }
      venv.pip_install_and_link head_packages.map { |pkg| buildpath/pkg }
      pkgshare.install buildpath/"certbot/examples"
    else
      virtualenv_install_with_resources
      pkgshare.install buildpath/"examples"
    end
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/certbot --version 2>&1")
    # This throws a bad exit code but we can check it actually is failing
    # for the right reasons by asserting. --version never fails even if
    # resources are missing or outdated/too new/etc.
    assert_match "Either run as root", shell_output("#{bin}/certbot 2>&1", 1)
  end
end