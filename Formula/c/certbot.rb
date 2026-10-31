class Certbot < Formula
  include Language::Python::Virtualenv

  desc "Tool to obtain certs from Let's Encrypt and autoenable HTTPS"
  homepage "https://certbot.eff.org/"
  url "https://files.pythonhosted.org/packages/f1/4c/c7ba4e990f6bded907aaefbb079e8adf8181bd92051e24ba70051d73f2b9/certbot-5.9.0.tar.gz"
  sha256 "bf7d096c8b7e595d8c8dd2c1374db2bd11f53ea33d1748aaea805e81007710d8"
  license "Apache-2.0"
  head "https://github.com/certbot/certbot.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "60137ffbd1c1a9971fd93ad725679fde6d869978bda2dfd62b4fe9ebf541fb03"
    sha256 cellar: :any, arm64_tahoe:       "8b4c594eb45fd244b1f30ec56b973241c98be3308a2fb71f3003666f67b8492e"
    sha256 cellar: :any, arm64_sequoia:     "bea972534e9f730f5c63e47503a8e0230719133b4b6d714b03254cba42ad591d"
    sha256 cellar: :any, arm64_linux:       "0b7993e8b1c6493e51dd2988d7c82c572291cb93dd73286151ee4d1978f49c01"
    sha256 cellar: :any, x86_64_linux:      "32c01b0a34fb8676369cb32710642a2aff0b25f09c36a64a60715ad4dea39e66"
  end

  depends_on "augeas"
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.15"

  uses_from_macos "libffi"

  pypi_packages exclude_packages: ["certifi", "cryptography", "pydantic"],
                extra_packages:   ["certbot-apache", "certbot-nginx", "certbot-dns-cloudflare"]

  resource "acme" do
    url "https://files.pythonhosted.org/packages/dd/ad/da805f98b7b7fc0e9f9ec490ad743b2c8b5fca3fb8fcf3bf4a3012bc53f2/acme-5.9.0.tar.gz"
    sha256 "bbfd9cf42797b5378a05833c0fd917de9418b69e03cbdb39abb7e85e5532fe75"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a9/d2/f4d173e22df740bc37b1db102b386ba719b66e95b0f0d751f556b387e6d2/anyio-4.15.1.tar.gz"
    sha256 "9f28306018cbd6d329e64a36d58256edff76dd996fe423bc957326e578b82a94"
  end

  resource "certbot-apache" do
    url "https://files.pythonhosted.org/packages/93/9d/3437dc70d07b8c2272da529606c8abee1a81b6b977e807079950576f68f8/certbot_apache-5.9.0.tar.gz"
    sha256 "d3fa2a89c9f9ad1a6781958b913893e43e4edc8af2c9ca1dcdb85a8689a82fff"
  end

  resource "certbot-dns-cloudflare" do
    url "https://files.pythonhosted.org/packages/4a/5a/0a26b34ac4139f475a238ad2e2a096edcb077c165e6380428a2643d0252e/certbot_dns_cloudflare-5.9.0.tar.gz"
    sha256 "86f5e579496cadbf46e4c02db811e89a20268bb008a67ef3a7133ca4c104488e"
  end

  resource "certbot-nginx" do
    url "https://files.pythonhosted.org/packages/06/dc/066334019dce8a88f452462e592381f80113e4f3ce7f3445d867f01cd0e1/certbot_nginx-5.9.0.tar.gz"
    sha256 "003d7576c94d311013f3ed13353c7131c56decfb48ad5e1cacd89b59e89bbf9f"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "cloudflare" do
    url "https://files.pythonhosted.org/packages/4b/52/5e736d63637e79c2381045250dbb6154a1fb4da8f3fd47518bff406c24d2/cloudflare-5.9.0.tar.gz"
    sha256 "1c9b9e243602c754e03636204272422dc45776f3babdc67f8341ca4d559d49e8"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/bc/d9/c591a80cf3335de7820c6762f8ee9298a43da5319803d319e16657b6fdf2/configargparse-1.9.0.tar.gz"
    sha256 "48d9c22affe4ac419b4dd0691fa929d759e1f99574be41826785f2dbf3da63a5"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "josepy" do
    url "https://files.pythonhosted.org/packages/7f/ad/6f520aee9cc9618d33430380741e9ef859b2c560b1e7915e755c084f6bc0/josepy-2.2.0.tar.gz"
    sha256 "74c033151337c854f83efe5305a291686cef723b4b970c43cfe7270cf4a677a9"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/3f/e8/7325d258199b159eb2c03fe32107533e2832e70e63f4fb88a6aa00023201/pyopenssl-26.4.0.tar.gz"
    sha256 "28dfcce0162b9211413e26dfbfdf1d24317fbeba18fc93c12400a1856b2a0bc7"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/e4/11/b213bebff182584360cb8d17c72c1677fec5c5c228de439e63bcf8ab1c8f/pyparsing-3.3.3.tar.gz"
    sha256 "928ae7e20211f3b6f3915a72f06a0cfd29ab9d24279dd6346b6b1a7146397d36"
  end

  resource "pyrfc3339" do
    url "https://files.pythonhosted.org/packages/80/7a/0e5227aa1c831fdaf579073a0ebb5ca11fc352a43fce8d2639e3ff87ff74/pyrfc3339-2.1.1.tar.gz"
    sha256 "b144d63819bd4c1ebf9cb57e12f4cba567fcf23d6e8f2f829ba9c7810ea4b951"
  end

  resource "python-augeas" do
    url "https://files.pythonhosted.org/packages/44/f6/e09619a5a4393fe061e24a6f129c3e1fbb9f25f774bfc2f5ae82ba5e24d3/python-augeas-1.2.0.tar.gz"
    sha256 "d2334710e12bdec8b6633a7c2b72df4ca24ab79094a3c9e699494fdb62054a10"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  def install
    if build.head?
      head_packages = %w[acme certbot certbot-apache certbot-nginx certbot-dns-cloudflare]
      venv = virtualenv_create(libexec, python3)
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