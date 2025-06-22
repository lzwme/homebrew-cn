class Cloudiscovery < Formula
  include Language::Python::Virtualenv

  desc "Help you discover resources in the cloud environment"
  homepage "https:github.comCloud-Architectscloudiscovery"
  url "https:files.pythonhosted.orgpackagesd3c29a5f93ac5376f83903c8550bde45e2888da3fb092b63e02e19d6c852134ccloudiscovery-2.4.4.tar.gz"
  sha256 "1170ea352a3c7d5643652ebe96b068482734cd995b9c92dc820206f1b87407e5"
  license "Apache-2.0"
  revision 4

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "256b308ecc554b73243bb67c3c915c41803a6412945ee1673e8cfbb0458341ba"
    sha256 cellar: :any,                 arm64_sonoma:  "ce19aa2a03d018c44b919ecc49c54b3d315a768fb316b28fd8184e3f3af79df4"
    sha256 cellar: :any,                 arm64_ventura: "d59e08945ea884a6d7afbb865d2dfa337d418d067650992dbd4baacbe580c09e"
    sha256 cellar: :any,                 sonoma:        "92c2c35b1e56b7ff6155b90ba40ba5c532fb1fbe5c93626864b2c9fc48761dd3"
    sha256 cellar: :any,                 ventura:       "c052b8e19b166db9e82edb7639de2172aa0957104ecac1f3ecc719ffa6a563e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8593099c3de3b948acb078b4081af7be5fcba58c5cbb2f0ea8b808adf26972f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f6eb22585831e39b87ea1cf6370d5846ba9aa987633425c803ee14d12ec0349"
  end

  deprecate! date: "2024-10-11", because: :unmaintained

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages2f3bf421b30e32c33ce63f0de3b32ea12954039a4595c693db4ea4900babe742boto3-1.38.41.tar.gz"
    sha256 "c6710fc533c8e1f5d1f025c74ffe1222c3659094cd51c076ec50c201a54c8f22"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages9846cb33f5a0b00086a97c4eebbc4e0211fe85d66d45e53a9545b33805f25b31botocore-1.38.41.tar.gz"
    sha256 "98e3fed636ebb519320c4b2d078db6fa6099b052b4bb9b5c66632a5a7fe72507"
  end

  resource "cachetools" do
    url "https:files.pythonhosted.orgpackages8a89817ad5d0411f136c484d535952aef74af9b25e0d99e90cdffbe121e6d628cachetools-6.1.0.tar.gz"
    sha256 "b4c4f404392848db3ce7aac34950d17be4d864da4b8b66911008e430bc544587"
  end

  resource "cfgv" do
    url "https:files.pythonhosted.orgpackages1174539e56497d9bd1d484fd863dd69cbbfa653cd2aa27abfe35653494d85e94cfgv-3.4.0.tar.gz"
    sha256 "e52591d4c5f5dead8e0f673fb16db7949d2cfb3f7da4582893288f0ded8fe560"
  end

  resource "diagrams" do
    url "https:files.pythonhosted.orgpackages426144cc86725be481d87c7f35de39cdc21e57ad38dca90d81a2dd14a166ecd2diagrams-0.23.4.tar.gz"
    sha256 "b7ada0b119b5189dd021b1dc1467fad3704737452bb18b1e06d05e4d1fa48ed7"
  end

  resource "diskcache" do
    url "https:files.pythonhosted.orgpackages3f211c1ffc1a039ddcc459db43cc108658f32c57d271d7289a2794e401d0fdb6diskcache-5.6.3.tar.gz"
    sha256 "2c3a3fa2743d8535d832ec61c2054a1641f41775aa7c556758a109941e33e4fc"
  end

  resource "distlib" do
    url "https:files.pythonhosted.orgpackages0ddd1bec4c5ddb504ca60fc29472f3d27e8d4da1257a854e1d96742f15c1d02ddistlib-0.3.9.tar.gz"
    sha256 "a60f20dea646b8a33f3e7772f74dc0b2d0772d2837ee1342a00645c81edf9403"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackages0a10c23352565a6544bdc5353e0b15fc1c563352101f30e24bf500207a54df9afilelock-3.18.0.tar.gz"
    sha256 "adbc88eabb99d2fec8c9c1b229b171f18afa655400173ddc653d5d01501fb9f2"
  end

  resource "graphviz" do
    url "https:files.pythonhosted.orgpackagesfa835a40d19b8347f017e417710907f824915fba411a9befd092e52746b63e9fgraphviz-0.20.3.zip"
    sha256 "09d6bc81e6a9fa392e7ba52135a9d49f1ed62526f96499325930e87ca1b5925d"
  end

  resource "identify" do
    url "https:files.pythonhosted.orgpackagesa288d193a27416618628a5eea64e3223acd800b40749a96ffb322a9b55a49ed1identify-2.6.12.tar.gz"
    sha256 "d8de45749f1efb108badef65ee8386f0f7bb19a7f26185f74de6367bffbaf0e6"
  end

  resource "ipaddress" do
    url "https:files.pythonhosted.orgpackagesb99a3e9da40ea28b8210dd6504d3fe9fe7e013b62bf45902b458d1cdc3c34ed9ipaddress-1.0.23.tar.gz"
    sha256 "b7f8e0369580bb4a24d5ba1d7cc29660a4a6987763faf1d8a8046830e020e7e2"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackages4fe765300e6b32e69768ded990494809106f87da1d436418d5f1367ed3966fd7Jinja2-2.11.3.tar.gz"
    sha256 "a6d58433de0ae800347cab1fa3043cebbabe8baa9d29e668f1c768cb87a333c6"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesbf10ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7eMarkupSafe-2.0.1.tar.gz"
    sha256 "594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a"
  end

  resource "nodeenv" do
    url "https:files.pythonhosted.orgpackages4316fc88b08840de0e0a72a2f9d8c6bae36be573e475a6326ae854bcc549fc45nodeenv-1.9.1.tar.gz"
    sha256 "6ec12890a2dab7946721edbfbcd91f3319c6ccc9aec47be7c7e6b7011ee6645f"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackagesfe8b3c73abc9c759ecd3f1f7ceff6685840859e8070c4d947c93fae71f6a0bf2platformdirs-4.3.8.tar.gz"
    sha256 "3d512d96e16bcb959a814c9f348431070822a6496326a4be0911c40b5a74c2bc"
  end

  resource "pre-commit" do
    url "https:files.pythonhosted.orgpackages0839679ca9b26c7bb2999ff122d50faa301e49af82ca9c066ec061cfbc0c6784pre_commit-4.2.0.tar.gz"
    sha256 "601283b9757afd87d40c4c4a9b2b5de9637a8ea02eaff7adc2d0fb4e04841146"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https:files.pythonhosted.orgpackagesf8bfabbd3cdfb8fbc7fb3d4d38d320f2441b1e7cbe29be4f23797b4a2b5d8aacpytz-2025.2.tar.gz"
    sha256 "360b9e3dbb49a209c21ad61809c7fb453643e048b38924c765813546746e81c3"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackagesed5d9dcc100abc6711e8247af5aa561fc07c4a046f72f659c3adea9a449e191as3transfer-0.13.0.tar.gz"
    sha256 "f5e6db74eb7776a37208001113ea7aa97695368242b364d73e91c981ac522177"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages15229ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bcurllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "virtualenv" do
    url "https:files.pythonhosted.orgpackages562c444f465fb2c65f40c3a104fd0c495184c4f2336d65baf398e3c75d72ea94virtualenv-20.31.2.tar.gz"
    sha256 "e10c0a9d02835e592521be48b332b6caee6887f332c111aa79a09b9e79efc2af"
  end

  # drop setuptools dep, upstream pr ref, https:github.comCloud-Architectscloudiscoverypull192
  patch do
    url "https:github.comCloud-Architectscloudiscoverycommit905c1dc15812000dc7ed2beb9d5193bd6bbe6131.patch?full_index=1"
    sha256 "7a75658504faa46ad9c5424a836d7a1df25e56b64bec88d57ccddf7c06025d5d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "{aws-vpc,aws-iot,aws-policy,aws-all,aws-limit,aws-security}",
      shell_output(bin"cloudiscovery --help 2>&1")

    assert_match "Neither region parameter nor region config were passed",
      shell_output(bin"cloudiscovery aws-vpc --vpc-id vpc-123 2>&1")
  end
end