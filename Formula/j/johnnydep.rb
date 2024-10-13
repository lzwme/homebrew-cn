class Johnnydep < Formula
  include Language::Python::Virtualenv

  desc "Display dependency tree of Python distribution"
  homepage "https:github.comwimglennjohnnydep"
  url "https:files.pythonhosted.orgpackagese557ccdd7ab46a4a06fae442555fe90a02d551009d765b79b99a942b2df330c5johnnydep-1.20.5.tar.gz"
  sha256 "eacee79094c7820b089619a6b8ac2a1b62692db2e518eaeb03f8efa549bfaf04"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "3a40d16cf3d1713bbf8f6887a87be7e452ba9ddc1d297a94264d3448f47e6087"
    sha256 cellar: :any,                 arm64_sonoma:  "0f0d84456e51f71a5a3750526b475e5bd123a5afde597b9a5d858ccb1000309c"
    sha256 cellar: :any,                 arm64_ventura: "7d4362418eb82758f72097c4a05a54982e4b28fd42a0c452170725a6637dd5cf"
    sha256 cellar: :any,                 sonoma:        "49e5ab4d6e4fc95c046b422f8085b53dd66dd7b064de11900ea03a012aa17969"
    sha256 cellar: :any,                 ventura:       "52f56c3a49c20540babf75f1999ca745f88ae1aca7e1ac2d54641b36e4eacff2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b6b46add6f5753af33ce77c79926ad6e9d18a6343359f1b84ecb96eb80f6c1b"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "anytree" do
    url "https:files.pythonhosted.orgpackagesf9442dd9c5d0c3befe899738b930aa056e003b1441bfbf34aab8fce90b2b7deaanytree-2.12.1.tar.gz"
    sha256 "244def434ccf31b668ed282954e5d315b4e066c4940b94aff4a7962d85947830"
  end

  resource "cachetools" do
    url "https:files.pythonhosted.orgpackagesc338a0f315319737ecf45b4319a8cd1f3a908e29d9277b46942263292115eee7cachetools-5.5.0.tar.gz"
    sha256 "2cc24fb4cbe39633fb7badd9db9ca6295d766d9c2995f245725a46715d050f2a"
  end

  resource "oyaml" do
    url "https:files.pythonhosted.orgpackages0071c721b9a524f6fe6f73469c90ec44784f0b2b1b23c438da7cc7daac1ede76oyaml-1.0.tar.gz"
    sha256 "ed8fc096811f4763e1907dce29c35895d6d5936c4d0400fe843a91133d4744ed"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackages516550db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "structlog" do
    url "https:files.pythonhosted.orgpackages78a3e811a94ac3853826805253c906faa99219b79951c7d58605e89c79e65768structlog-24.4.0.tar.gz"
    sha256 "b27bfecede327a6d2da5fbc96bd859f114ecc398a6389d664f62085ee7ae6fc4"
  end

  resource "tabulate" do
    url "https:files.pythonhosted.orgpackagesecfe802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "toml" do
    url "https:files.pythonhosted.orgpackagesbeba1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3ctoml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "wheel" do
    url "https:files.pythonhosted.orgpackagesb7a095e9e962c5fd9da11c1e28aa4c0d8210ab277b1ada951d2aee336b505813wheel-0.44.0.tar.gz"
    sha256 "a29c3f2817e95ab89aa4660681ad547c0e9547f20e75b0562fe7723c9a2a9d49"
  end

  resource "wimpy" do
    url "https:files.pythonhosted.orgpackages6ebc88b1b2abdd0086354a54fb0e9d2839dd1054b740a3381eb2517f1e0ace81wimpy-0.6.tar.gz"
    sha256 "5d82b60648861e81cab0a1868ae6396f678d7eeb077efbd7c91524de340844b3"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}johnnydep johnnydep")
    resources.each do |r|
      assert_match r.name, output
    end
  end
end