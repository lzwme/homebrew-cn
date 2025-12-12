class Localstack < Formula
  include Language::Python::Virtualenv

  desc "Fully functional local AWS cloud stack"
  homepage "https://localstack.cloud/"
  url "https://files.pythonhosted.org/packages/80/89/871ca102d172d38a3b017e51fd1ad473381e537fb7099234aa1a58971f02/localstack-4.12.0.tar.gz"
  sha256 "87e0824d3115fc72fe78efa6d8bda942e68e69e38b74173c4bff3091efaea1ea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ca4ae41210325936f56f7446fcfc8b6b03d14c8f56f73392475ca85fa2c59dc3"
    sha256 cellar: :any,                 arm64_sequoia: "22aed4154cfa23744ecb4f7a80c532404f07d44b7e9b514de90b10c4d7e3fbe5"
    sha256 cellar: :any,                 arm64_sonoma:  "87174696707ccce616ab89e6f55b4903cba73b44f5e41a7b769cf92b6f807b52"
    sha256 cellar: :any,                 sonoma:        "b9379e2659f576b247d3176bab56004ce382a5f8e25a3b488d7e53d024097dc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6473d2015a98c7d0979d8e35c50921ea0a5ba1c8d9beea79e0b8f18151f49f1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "768a39d098eab3052a13f61fad35c7d1169cbaa773db9a2e210d27fcb0e14aff"
  end

  depends_on "rust" => :build # for orjson
  depends_on "docker" => :test
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[certifi cryptography]

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/de/cf/d547feed25b5244fcb9392e288ff9fdc3280b10260362fc45d37a798a6ee/asn1crypto-1.5.1.tar.gz"
    sha256 "13ae38502be632115abf8a24cbe5f4da52e3b5231990aff31123c805306ccb9c"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/fb/44/ca1675be2a83aeee1886ab745b28cda92093066590233cc501890eb8417a/cachetools-6.2.2.tar.gz"
    sha256 "8e6d266b25e539df852251cfd6f990b4bc3a141db73b939058d809ebd2590fc6"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/7c/e7/364a09134e1062d4d5ff69b853a56cf61c223e0afcc6906b6832bcd51ea8/dill-0.3.6.tar.gz"
    sha256 "e5db55f3687856d8fbdab002ed78544e1c4559a130302693d839dfe8f93f2373"
  end

  resource "dnslib" do
    url "https://files.pythonhosted.org/packages/a2/71/269f74ef9bc8ca453af2e1768d4f4c8e7ef5f894d058d27fd1b69c754d7f/dnslib-0.9.26.tar.gz"
    sha256 "be56857534390b2fbd02935270019bacc5e6b411d156cb3921ac55a7fb51f1a8"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/8c/8b/57666417c0f90f08bcafa776861060426765fdb422eb10212086fb811d26/dnspython-2.8.0.tar.gz"
    sha256 "181d3c6996452cb1189c4046c61599b84a5a86e099562ffde77d26984ff26d0f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "localstack-core" do
    url "https://files.pythonhosted.org/packages/ac/e1/9a3728824de648b35e22ebdfc40d2c5f0211c69a6bf1a604dc2c21ef8479/localstack_core-4.12.0.tar.gz"
    sha256 "893359fb2392b95a1587e109120904dd4001e640238a2d4a87f8b46c6cb67ba6"
  end

  resource "localstack-ext" do
    url "https://files.pythonhosted.org/packages/fe/43/d3f5b27f057a3cb273f7422715c46dbb9602577a93c1c575d86376c73a9a/localstack_ext-4.12.0.tar.gz"
    sha256 "010ac6ea245305aae29eb1a025e2ebe4e620bae37b296cb145460d307cf89a51"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "plux" do
    url "https://files.pythonhosted.org/packages/14/4b/bea3ff709d4d17b1e0351058c9dbe830dcbb33a75225836056f4591dfb1d/plux-1.13.0.tar.gz"
    sha256 "0358a618883be270cf8dd6b5ae48e633a7fecd386cff6347c8560116f4688a75"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/88/bdd0a41e5857d5d703287598cbf08dad90aed56774ea52ae071bae9071b6/psutil-7.1.3.tar.gz"
    sha256 "6c86281738d77335af7aec228328e944b30930899ea760ecf33a4dba66be5e74"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/e7/46/bd74733ff231675599650d3e47f361794b22ef3e3770998dda30d3b63726/pyjwt-2.10.1.tar.gz"
    sha256 "3cc5772eb20009233caf06e9d8a0577824723b44e6648ee0a2aedb6cf9381953"
  end

  resource "pyotp" do
    url "https://files.pythonhosted.org/packages/f3/b2/1d5994ba2acde054a443bd5e2d384175449c7d2b6d1a0614dbca3a63abfc/pyotp-2.9.0.tar.gz"
    sha256 "346b6642e0dbdde3b4ff5a930b664ca82abfa116356ed48cc42c7d6590d36f63"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/f0/26/19cadc79a718c5edbec86fd4919a6b6d3f681039a2f6d66d14be94e75fb9/python_dotenv-1.2.1.tar.gz"
    sha256 "42667e897e16ab0d66954af0e60a9caa94f0fd4ecf3aaf6d2d260eec1aa36ad6"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fb/d2/8920e102050a0de7bfabeb4c4614a49248cf8d5d7a8d01885fbb24dc767a/rich-14.2.0.tar.gz"
    sha256 "73ff50c7c0c1c77c8243079283f4edb376f0f6442433aecb8ce7e6d0b92d1fe4"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/72/d1/d3159231aec234a59dd7d601e9dd9fe96f3afff15efd33c1070019b26132/semver-3.0.4.tar.gz"
    sha256 "afc7d8c584a5ed0a11033af086e8af226a9c0b206f313e0301f8dd7b6b589602"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/5e/1d/0f3a93cca1ac5e8287842ed4eebbd0f7a991315089b1a0b01c7788aa7b63/urllib3-2.6.1.tar.gz"
    sha256 "5379eb6e1aba4088bae84f8242960017ec8d8e3decf30480b3a1abdaa9671a3f"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/localstack"

    generate_completions_from_executable(bin/"localstack", shell_parameter_format: :click)
  end

  test do
    ENV["DOCKER_HOST"] = "unix://" + (testpath/"invalid.sock")
    ENV["LOCALSTACK_API_KEY"] = "brewtest"

    assert_match version.to_s, shell_output("#{bin}/localstack --version")

    output = shell_output("#{bin}/localstack start --docker 2>&1", 1)

    assert_match "License activation failed!", output
  end
end