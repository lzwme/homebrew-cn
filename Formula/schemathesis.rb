class Schemathesis < Formula
  include Language::Python::Virtualenv

  desc "Testing tool for web applications with specs"
  homepage "https://schemathesis.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/3f/de/76fbef3c41c7700d42929e093e35829117c48c277cb09e2a849bfabc98ff/schemathesis-3.19.1.tar.gz"
  sha256 "be9b87bfd92a856cbff9518d5f6f0ef9172240c6571ca272bdd8045a405c60c0"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce743f609c6001e5001f5ae791a905522b5244bc97f0461924161a75d452c3cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8a5f7de091ad0f4135bffba1bcab3fd8127b0d36291f5c02761566d9d43bad5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d15688016ba9efd95d6aa33aba43158bf3f15d092620de2d02f3714ce8231f12"
    sha256 cellar: :any_skip_relocation, ventura:        "cfff2683ee7bb13fd7536339412a6e1f94eeec47bea27352e5f973c5800db411"
    sha256 cellar: :any_skip_relocation, monterey:       "4bb8e96e7a1eff6f584b44865843b1f6855d57d340d6912a92fade9df01c2a6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "20c7ff1a313627443e0fe241b7c146cb3a916716e51a55499d516820fd8316b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f6525972d9f0375c92b0abf36be5e75caf64da656c8508d079221de16398271"
  end

  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/8b/94/6928d4345f2bc1beecbff03325cad43d320717f51ab74ab5a571324f4f5a/anyio-3.6.2.tar.gz"
    sha256 "25ea0d673ae30af41a0c442f81cf3b38c7e79fdc7b60335a4c14e05eb0947421"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "backoff" do
    url "https://files.pythonhosted.org/packages/47/d7/5bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619/backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "curlify" do
    url "https://files.pythonhosted.org/packages/fa/2c/9254b2294d0250291560d78e16e5cd764b8e2caa75d4cad1e8ae9d73899d/curlify-2.2.1.tar.gz"
    sha256 "0d3f02e7235faf952de8ef45ef469845196d30632d5838bcd5aee217726ddd6d"
  end

  resource "graphql-core" do
    url "https://files.pythonhosted.org/packages/ee/a6/94df9045ca1bac404c7b394094cd06713f63f49c7a4d54d99b773ae81737/graphql-core-3.2.3.tar.gz"
    sha256 "06d2aad0ac723e35b1cb47885d3e5c45e956a53bc1b209a9fc5369007fe46676"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/41/16/c809655d32fd93e688b9e2a1aaba1008118369d1eda00818f6f65eb509f8/httpcore-0.17.0.tar.gz"
    sha256 "cc045a3241afbf60ce056202301b4d8b6af08845e3294055eb26b09913ef903c"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/ae/23/f7beaf11a8b95fc173b8979c4bfd23ea7711c5ebd458d657d24a59df7e9f/httpx-0.24.0.tar.gz"
    sha256 "507d676fc3e26110d41df7d35ebd8b3b8585052450f4097401c9be59d928c63e"
  end

  resource "hypothesis" do
    url "https://files.pythonhosted.org/packages/ca/bb/5e142069484aba2f1d34050b2b50518a19fb72fb25987da7bb4b8606084e/hypothesis-6.75.3.tar.gz"
    sha256 "15cdadb80a7ac59087581624d266a4fb585b5cce9b7f88f506c481a9f0e583f6"
  end

  resource "hypothesis-graphql" do
    url "https://files.pythonhosted.org/packages/50/18/e9c6375162bf2863feb6e073d649eff7e2f12eb9f6f028e05a72fbd69fee/hypothesis_graphql-0.10.0.tar.gz"
    sha256 "468d45f7ab32c2f4121799b2aa5892bd7cd9c8231ec2059dd6b34ed4b976698c"
  end

  resource "hypothesis-jsonschema" do
    url "https://files.pythonhosted.org/packages/8b/d7/47d7c208ca0f8a2ce6535d6cf0a167d9120ccfc00d6c5ff5fae7936a4654/hypothesis-jsonschema-0.22.1.tar.gz"
    sha256 "5dd7449009f323e408a9aa64afb4d18bd1f60ea2eabf5bf152a510da728b34f2"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/d7/4b/cbd8e699e64a6f16ca3a8220661b5f83792b3017d0f79807cb8708d33913/iniconfig-2.0.0.tar.gz"
    sha256 "2d91e135bf72d31a410b17c16da610a82cb55f6b0477d1a902134b24a455b8b3"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/36/3d/ca032d5ac064dff543aa13c984737795ac81abc9fb130cd2fcff17cfabc7/jsonschema-4.17.3.tar.gz"
    sha256 "0f864437ab8b6076ba6707453ef8f98a6a0d512a80e93f8abdb676f737ecb60d"
  end

  resource "junit-xml" do
    url "https://files.pythonhosted.org/packages/98/af/bc988c914dd1ea2bc7540ecc6a0265c2b6faccc6d9cdb82f20e2094a8229/junit-xml-1.9.tar.gz"
    sha256 "de16a051990d4e25a3982b2dd9e89d671067548718866416faec14d9de56db9f"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/95/7e/68018b70268fb4a2a605e2be44ab7b4dd7ce7808adae6c5ef32e34f4b55a/MarkupSafe-2.1.2.tar.gz"
    sha256 "abcabc8c2b26036d62d4c746381a6f7cf60aafcc653198ad678306986b09450d"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/4a/15/bd620f7a6eb9aa5112c4ef93e7031bcd071e0611763d8e17706ef8ba65e0/multidict-6.0.4.tar.gz"
    sha256 "3666906492efb76453c0e7b97f2cf459b0682e7402c0489a95484965dbc1da49"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/a1/16/db2d7de3474b6e37cbb9c008965ee63835bba517e22cdb8c35b5116b5ce1/pluggy-1.0.0.tar.gz"
    sha256 "4224373bacce55f955a878bf9cfa763c1e360858e330072059e10bad68531159"
  end

  resource "pyrate-limiter" do
    url "https://files.pythonhosted.org/packages/c0/a2/bb73c385e6d68cbe0ebe6ff16c22c96a79194c1298b2942005fcaf3eda9d/pyrate_limiter-2.10.0.tar.gz"
    sha256 "98cc52cdbe058458e945ae87d4fd5a73186497ffa545ee6e98372f8599a5bd34"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/bf/90/445a7dbd275c654c268f47fa9452152709134f61f09605cf776407055a89/pyrsistent-0.19.3.tar.gz"
    sha256 "1a2994773706bbb4995c31a97bc94f1418314923bd1048c6d964837040376440"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/ec/d9/36b65598f3d19d0a14d13dc87ad5fa42869ae53bb7471f619a30eaabc4bf/pytest-7.3.1.tar.gz"
    sha256 "434afafd78b1d78ed0addf160ad2b77a30d35d4bdf8af234fe621919d9ed15e3"
  end

  resource "pytest-subtests" do
    url "https://files.pythonhosted.org/packages/b9/ea/3971817de038f8a03e8a1d1833ce5708965c67bacf1455d140f836c6f7f4/pytest-subtests-0.7.0.tar.gz"
    sha256 "95c44c77e3fbede9848bb88ca90b384815fcba8090ef9a9f55659ab163b1681c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/cd/50/d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0ac/sniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/06/68/559bed5484e746f1ab2ebbe22312f2c25ec62e4b534916d41a8c21147bf8/starlette-0.27.0.tar.gz"
    sha256 "6a6b0d042acb8d469a01eba54e9cda6cbd24ac602c4cd016723117d6a7e73b75"
  end

  resource "starlette-testclient" do
    url "https://files.pythonhosted.org/packages/ab/2d/41c70f946ea97c20149c2ae65466ea10d15a23bc044f5c90ba0e2016a41f/starlette_testclient-0.2.0.tar.gz"
    sha256 "3fb6681d1dc7e9ab6dc05b5ab455b822a03f37e7371316a828e2d8380a198a4a"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/49/05/6bf21838623186b91aedbda06248ad18f03487dc56fbc20e4db384abde6c/tomli_w-1.0.0.tar.gz"
    sha256 "f463434305e0336248cac9c2dc8076b707d8a12d019dd349f5c1e382dd1ae1b9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/21/79/6372d8c0d0641b4072889f3ff84f279b738cd8595b64c8e0496d4e848122/urllib3-1.26.15.tar.gz"
    sha256 "8a388717b9476f934a21484e8c8e61875ab60644d29b9b39e11e4b9dc1c6b305"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/2d/bf/5a00bb4a70028f7c6000bc9394492154fa9ae3f5226187e3ddcd0aa5eca1/Werkzeug-2.3.4.tar.gz"
    sha256 "1d5a58e0377d1fe39d061a5de4469e414e78ccb1e1e59c0f5ad6fa1c36c52b76"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/5f/3f/04b3c5e57844fb9c034b09c5cb6d2b43de5d64a093c30529fd233e16cf09/yarl-1.9.2.tar.gz"
    sha256 "04ab9d4b9f587c06d801c2abfe9317b77cdf996c65a90d5e84ecc45010823571"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"example.json").write <<~EOS
      {
        "openapi": "3.0.3",
        "paths": {}
      }
    EOS
    output = shell_output("#{bin}/st run ./example.json --dry-run")
    assert_match "Schemathesis test session starts", output
    assert_match "Specification version: Open API 3.0.3", output
    assert_match "No checks were performed.", output
  end
end