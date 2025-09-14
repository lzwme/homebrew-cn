class Certbot < Formula
  include Language::Python::Virtualenv

  desc "Tool to obtain certs from Let's Encrypt and autoenable HTTPS"
  homepage "https://certbot.eff.org/"
  url "https://files.pythonhosted.org/packages/42/7f/fd22e1bda654356e572e524762d4ee473d32a2c506960201d413073e5579/certbot-5.0.0.tar.gz"
  sha256 "4e9e4680e812037b582cef7335570074390b455d24a3e09bcaa2fdc473dbcc0a"
  license "Apache-2.0"
  head "https://github.com/certbot/certbot.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "51c7be44a2beaa19a7e908ef9e009b837f4ca6c026dfeb7ff0c88a593f83fe3d"
    sha256 cellar: :any,                 arm64_sequoia: "5cae36553051941d1e6a7a764887ef88da69c4531b0b837b8b9d75aa4569a565"
    sha256 cellar: :any,                 arm64_sonoma:  "2e5c66da81c267db5fc100845162b57550d5bf0e6fa1ea64b7e700d65ea96516"
    sha256 cellar: :any,                 arm64_ventura: "6ac369299a583e5ca8239dd386f1fc3bfe406e2b4a8408ae26e6c7763be5cb3e"
    sha256 cellar: :any,                 sonoma:        "7fadd1eff7a3e1d8aaf7d28f4c3833f620e8ddcfff8431514340042163b37695"
    sha256 cellar: :any,                 ventura:       "f51a28c967dc129d81dedd0994c4b26aea6fcdde84560694efad4a39a221bfa0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42e99e475ac3b7fed01a47a2d65214ee3ec854bf8f76fed322ce84eb1edfd873"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2033c4e6daea9e6441f6f82541047d8b5b45c53ff8e82efa0574ce09a83ad1d0"
  end

  depends_on "augeas"
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  resource "acme" do
    url "https://files.pythonhosted.org/packages/9f/11/2a8767ea1bac25ca73d952ca1d8bd701a65c84057e4ead8bda82fb086d9c/acme-5.0.0.tar.gz"
    sha256 "b701b23e66d3c58352896a72caa13523d9f72b183a0ba1cde93e6713a450a391"
  end

  resource "certbot-apache" do
    url "https://files.pythonhosted.org/packages/25/b0/6b9b6cc1e94d802ca361e7f0d64966dee85b4885ca344a14c407b201e62f/certbot_apache-5.0.0.tar.gz"
    sha256 "c438b6cb4fda2fef5868b7111d130a96233ccccf5538c292e642a04a47c9dbb6"
  end

  resource "certbot-nginx" do
    url "https://files.pythonhosted.org/packages/50/0f/b4e296e2b38a227f57347b3ebe6742271aec72e0e4728ce1b8266b6302c1/certbot_nginx-5.0.0.tar.gz"
    sha256 "c8e4b86d2537a5d9de5801a6e3a8cf17fa4f12777479192d0e2978cbc6b18305"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
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
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "josepy" do
    url "https://files.pythonhosted.org/packages/9d/19/4ebe24c42c341c5868dff072b78d503fc1b0725d88ea619d2db68f5624a9/josepy-2.1.0.tar.gz"
    sha256 "9beafbaa107ec7128e6c21d86b2bc2aea2f590158e50aca972dca3753046091f"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/04/8c/cd89ad05804f8e3c17dea8f178c3f40eeab5694c30e0c9f5bcd49f576fc3/pyopenssl-25.1.0.tar.gz"
    sha256 "8d031884482e0c67ee92bf9a4d8cceb08d92aba7136432ffb0703c5280fc205b"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/bb/22/f1129e69d94ffff626bdb5c835506b3a5b4f3d070f17ea295e12c2c6f60f/pyparsing-3.2.3.tar.gz"
    sha256 "b9c13f1ab8b3b542f72e28f634bad4de758ab3ce4546e4301970ad6fa77c38be"
  end

  resource "pyrfc3339" do
    url "https://files.pythonhosted.org/packages/b4/7f/3c194647ecb80ada6937c38a162ab3edba85a8b6a58fa2919405f4de2509/pyrfc3339-2.1.0.tar.gz"
    sha256 "c569a9714faf115cdb20b51e830e798c1f4de8dabb07f6ff25d221b5d09d8d7f"
  end

  resource "python-augeas" do
    url "https://files.pythonhosted.org/packages/44/f6/e09619a5a4393fe061e24a6f129c3e1fbb9f25f774bfc2f5ae82ba5e24d3/python-augeas-1.2.0.tar.gz"
    sha256 "d2334710e12bdec8b6633a7c2b72df4ca24ab79094a3c9e699494fdb62054a10"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    if build.head?
      head_packages = %w[acme certbot certbot-apache certbot-nginx]
      venv = virtualenv_create(libexec, "python3.13")
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