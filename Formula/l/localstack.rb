class Localstack < Formula
  include Language::Python::Virtualenv

  desc "Fully functional local AWS cloud stack"
  homepage "https://localstack.cloud/"
  url "https://files.pythonhosted.org/packages/71/22/4eeec394941d84b01f66757213996b38787815bf38268d62f7e7801dd2fd/localstack-4.9.2.tar.gz"
  sha256 "334a583023b4bc4257635ea4b5087e0b43a99fe6aaf68d8de3d8009de04cf0af"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ab683a5081361b54bb75d666bc0e12e4ac78d6c09fd708585aa19bd303150bd6"
    sha256 cellar: :any,                 arm64_sequoia: "d80ceec9858db5b39e94fc64b3e74b4e869aaf8319ec1b833fb12ed63567b283"
    sha256 cellar: :any,                 arm64_sonoma:  "029593edc62c993bfd3952612b589485b3ae658e87969c090bebe428a6530a75"
    sha256 cellar: :any,                 sonoma:        "d3f557ecee9ef5ac96e593a0bc98b5d2c7e692f4b0f1eb812173306c6fc2e908"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a488f804446e02d6f3885af50020892f7f368d8a2493b59a30664ca5e3e885b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dae4bae5aa776f95f3ffdbc755670be1c8eedb1ba3b61bb84188de593971ac0"
  end

  depends_on "rust" => :build # for orjson
  depends_on "docker" => :test
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "avro" do
    url "https://files.pythonhosted.org/packages/e6/73/48668732bbc8ae1e79b237f84e761204c8dd266c5e16e7601000aba471d3/avro-1.12.0.tar.gz"
    sha256 "cad9c53b23ceed699c7af6bddced42e2c572fd6b408c257a7d4fc4e8cf2e2d6b"
  end

  resource "build" do
    url "https://files.pythonhosted.org/packages/25/1c/23e33405a7c9eac261dff640926b8b5adaed6a6eb3e1767d441ed611d0c0/build-1.3.0.tar.gz"
    sha256 "698edd0ea270bde950f53aed21f3a0135672206f3911e0176261a31e0e07b397"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/9d/61/e4fad8155db4a04bfb4734c7c8ff0882f078f24294d42798b3568eb63bff/cachetools-6.2.0.tar.gz"
    sha256 "38b328c0889450f05f5e120f56ab68c8abaf424e1275522b138ffc93253f7e32"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
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

  resource "fastavro" do
    url "https://files.pythonhosted.org/packages/cc/ec/762dcf213e5b97ea1733b27d5a2798599a1fa51565b70a93690246029f84/fastavro-1.12.0.tar.gz"
    sha256 "a67a87be149825d74006b57e52be068dfa24f3bfc6382543ec92cd72327fe152"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "localstack-core" do
    url "https://files.pythonhosted.org/packages/b6/2a/a5771e0312e153d6308bece0668d2129d9ada9bac1355b6eacf6a0f59ff6/localstack_core-4.9.2.tar.gz"
    sha256 "7e0ceb25dd5d2c62add216f64badad1b13ae9144af5228361a39a256f3615240"
  end

  resource "localstack-ext" do
    url "https://files.pythonhosted.org/packages/6c/82/6ff87b1ba48c35703e64ffc45c5724e2ce4db5766971aaeb62c98d60c841/localstack_ext-4.9.2.tar.gz"
    sha256 "8e9671ca47e3338bc3bf1bf24fbe33815c61ab6489c88dc2c84805b189cd95d4"
  end

  resource "localstack-py-avro-schema" do
    url "https://files.pythonhosted.org/packages/f6/87/875c82590fc76605397a0c80c965c9567a01037a75e1552a71562d25b76e/localstack_py_avro_schema-3.9.2.tar.gz"
    sha256 "5800a14420ab2402c46c849c523c131cfdf08cd5a038e74d8b98b9af7e4d69a6"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "memoization" do
    url "https://files.pythonhosted.org/packages/af/53/e948a943e16423a87ced16e34ea7583c300e161a4c3e85d47d77d83830bf/memoization-0.4.0.tar.gz"
    sha256 "fde5e7cd060ef45b135e0310cfec17b2029dc472ccb5bbbbb42a503d4538a135"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/ea/5d/38b681d3fce7a266dd9ab73c66959406d565b3e85f21d5e66e1181d93721/more_itertools-10.8.0.tar.gz"
    sha256 "f638ddf8a1a0d134181275fb5d58b086ead7c6a72429ad725c67503f13ba30bd"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/be/4d/8df5f83256a809c22c4d6792ce8d43bb503be0fb7a8e4da9025754b09658/orjson-3.11.3.tar.gz"
    sha256 "1c0603b1d2ffcd43a411d64797a19556ef76958aef1c182f22dc30860152a98a"
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
    url "https://files.pythonhosted.org/packages/b3/31/4723d756b59344b643542936e37a31d1d3204bcdc42a7daa8ee9eb06fb50/psutil-7.1.0.tar.gz"
    sha256 "655708b3c069387c8b77b072fc429a57d0e214221d01c0a772df7dfedcb3bcd2"
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

  resource "pyproject-hooks" do
    url "https://files.pythonhosted.org/packages/e7/82/28175b2414effca1cdac8dc99f76d660e7a4fb0ceefa4b4ab8f5f6742925/pyproject_hooks-1.2.0.tar.gz"
    sha256 "1e859bd5c40fae9448642dd871adf459e5e2084186e8d2c2a79a824c970da1f8"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/f6/b0/4bc07ccd3572a2f9df7e6782f52b0c6c90dcbb803ac4a167702d7d0dfe1e/python_dotenv-1.1.1.tar.gz"
    sha256 "a8a6399716257f45be6a007360200409fce5cda2661e3dec71d23dc15f6189ab"
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
    url "https://files.pythonhosted.org/packages/fe/75/af448d8e52bf1d8fa6a9d089ca6c07ff4453d86c65c145d0a300bb073b9b/rich-14.1.0.tar.gz"
    sha256 "e497a48b844b0320d45007cdebfeaeed8db2a4f4bcf49f15e455cfc4af11eaa8"
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

  resource "tailer" do
    url "https://files.pythonhosted.org/packages/dd/05/01de24d6393d6da0c27857c76b0f9ae97b42cd6102bbdf76cce95e031295/tailer-0.4.1.tar.gz"
    sha256 "78d60f23a1b8a2d32f400b3c8c06b01142ac7841b75d8a1efcb33515877ba531"
  end

  resource "typeguard" do
    url "https://files.pythonhosted.org/packages/3a/38/c61bfcf62a7b572b5e9363a802ff92559cb427ee963048e1442e3aef7490/typeguard-2.13.3.tar.gz"
    sha256 "00edaa8da3a133674796cf5ea87d9f4b4c367d77476e185e80251cc13dfbb8c4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
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