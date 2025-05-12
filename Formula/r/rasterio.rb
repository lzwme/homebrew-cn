class Rasterio < Formula
  include Language::Python::Virtualenv

  desc "Reads and writes geospatial raster datasets"
  homepage "https:rasterio.readthedocs.ioenstable"
  url "https:files.pythonhosted.orgpackagesde19ab4326e419b543da623ce4191f68e3f36a4d9adc64f3df5c78f044d8d9carasterio-1.4.3.tar.gz"
  sha256 "201f05dbc7c4739dacb2c78a1cf4e09c0b7265b0a4d16ccbd1753ce4f2af350a"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4410576ace32e78400ed9d09167fdb8512765eec039229237a3db59dbdf3a673"
    sha256 cellar: :any,                 arm64_sonoma:  "f66b60551ec2f3d51a889d8738a4b0bec36b1212d05183fd0d0623dbcb9a6221"
    sha256 cellar: :any,                 arm64_ventura: "26af3700f3b615d9eac3d871eb2e9efbae7f402294966b12108414ec57296eab"
    sha256 cellar: :any,                 sonoma:        "50ad9d3ac08ab03e08678ca3d6551016421b7b186fe95c362b9dbd67a8304214"
    sha256 cellar: :any,                 ventura:       "868807093a9173ae0a22dcc9426e4e7a38fce818789bbc9e51192eea11695887"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3591bf74726a6e4663aad38970345a67c0bd75cd5eb553c8ca8b218cc6dacce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00de49b47c6a04925b1575417950a468713913e3a64279ca8e02b77fb86b9131"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "certifi"
  depends_on "gdal"
  depends_on "numpy"
  depends_on "python@3.13"

  on_linux do
    depends_on "patchelf" => :build
  end

  conflicts_with "rio", because: "both install `rio` binaries"
  conflicts_with cask: "rio", because: "both install `rio` binaries"

  resource "affine" do
    url "https:files.pythonhosted.orgpackages6998d2f0bb06385069e799fc7d2870d9e078cfa0fa396dc8a2b81227d0da08b9affine-2.4.0.tar.gz"
    sha256 "a24d818d6a836c131976d22f8c27b8d3ca32d0af64c1d8d29deb7bafa4da1eea"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages5ab01367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackagesb92e0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8bclick-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "click-plugins" do
    url "https:files.pythonhosted.orgpackages5f1d45434f64ed749540af821fd7e42b8e4d23ac04b1eda7c26613288d6cd8a8click-plugins-1.1.1.tar.gz"
    sha256 "46ab999744a9d831159c3411bb0c79346d94a444df9a3a3742e9ed63645f264b"
  end

  resource "cligj" do
    url "https:files.pythonhosted.orgpackagesea0d837dbd5d8430fd0f01ed72c4cfb2f548180f4c68c635df84ce87956cff32cligj-0.7.2.tar.gz"
    sha256 "a4bc13d623356b373c2c27c53dbd9c68cae5d526270bfa71f6c6fa69669c6b27"
  end

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackages8b1a3544f4f299a47911c2ab3710f534e52fea62a633c96806995da5d25be4b2pyparsing-3.2.1.tar.gz"
    sha256 "61980854fd66de3a90028d679a954d5f2623e83144b5afe5ee86f43d762e5f0a"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin"rio", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}rio --version")

    resource "test_file" do
      url "https:github.comrasteriorasteriorawrefsheadsmaintestsdatared.tif"
      sha256 "faff88a7935f2993ad2a24f572bb73c4d1fa4c5159377f4d9742583ae7c4c52b"
    end

    testpath.install resource("test_file")

    output = shell_output("#{bin}rio info red.tif")
    assert_equal 16, JSON.parse(output)["blockxsize"]
  end
end