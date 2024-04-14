class Streamlink < Formula
  include Language::Python::Virtualenv

  desc "CLI for extracting streams from various websites to a video player"
  homepage "https:streamlink.github.io"
  url "https:files.pythonhosted.orgpackages6631326decb04078c7ba4fe917f4dbc7dcbd9ac0aa7be1a5e8cac69fa3d76adestreamlink-6.7.2.tar.gz"
  sha256 "7a74700129f5c29c006260df53976384300981c9aff9d3d5c2eb7e91d3dca359"
  license "BSD-2-Clause"
  revision 1
  head "https:github.comstreamlinkstreamlink.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c7f9ac98e57704fafad95e591b79eeed293105a12b91129d8be18f682fcac17f"
    sha256 cellar: :any,                 arm64_ventura:  "2b0ffb55a7aae6a4667714115fbe30b8d1b1d786cd8a7b9ccdec1b25495d276b"
    sha256 cellar: :any,                 arm64_monterey: "35c5a1d3fced5fc783f24ae4ef8e7864f721f8741e5f000974fa9b0fe55efa8d"
    sha256 cellar: :any,                 sonoma:         "2de65b19483e71c7f282c7687faef6930799f7906ba61be2a7fe3858b751c450"
    sha256 cellar: :any,                 ventura:        "6ff2865b5d384f79c8268357f864c12c87facd90f1ae110fda0885311d1b2346"
    sha256 cellar: :any,                 monterey:       "b8e3823a28e1a688154d6d24a9c1a27705dc86c3695ad66a00367e373600fe75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac839552b5342a96c564d7ff6a63e3d9ab9b301b99e219b1af82b6033ec5915e"
  end

  depends_on "certifi"
  depends_on "libxml2" # https:github.comHomebrewhomebrew-coreissues98468
  depends_on "python@3.12"

  uses_from_macos "libffi"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagese3fcf800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650dattrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "exceptiongroup" do
    url "https:files.pythonhosted.orgpackages8e1cbeef724eaf5b01bb44b6338c8c3494eff7cab376fab4904cfbbc3585dc79exceptiongroup-1.2.0.tar.gz"
    sha256 "91f5c769735f051a4290d52edd0858999b57e5876e9f85937691bd4c9fa3ed68"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackagesf5383af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "isodate" do
    url "https:files.pythonhosted.orgpackagesdb7ac0a56c7d56c7fa723988f122fa1f1ccf8c5c4ccc48efad0d214b49e5b1afisodate-0.6.1.tar.gz"
    sha256 "48c5881de7e8b0a0d648cb024c8062dc84e7b840ed81e864c7614fd3c127bde9"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackageseae23834472e7f18801e67a3cd6f3c203a5456d6f7f903cfb9a990e62098a2f3lxml-5.2.1.tar.gz"
    sha256 "3f7765e69bbce0906a7c74d5fe46d2c7a7596147318dbc08e4a2431f3060e306"
  end

  resource "outcome" do
    url "https:files.pythonhosted.orgpackages98df77698abfac98571e65ffeb0c1fba8ffd692ab8458d617a0eed7d9a8d38f2outcome-1.3.0.post0.tar.gz"
    sha256 "9dcf02e65f2971b80047b377468e72a268e15c0af3cf1238e6ff14f7f91143b8"
  end

  resource "pycountry" do
    url "https:files.pythonhosted.orgpackages084a137f422423b9c85148183691da65c5c843a209b7fc0c33a5144489366f53pycountry-23.12.11.tar.gz"
    sha256 "00569d82eaefbc6a490a311bfa84a9c571cff9ddbf8b0a4f4e7b4f868b4ad925"
  end

  resource "pycryptodome" do
    url "https:files.pythonhosted.orgpackagesb9ed19223a0a0186b8a91ebbdd2852865839237a21c74f1fbc4b8d5b62965239pycryptodome-3.20.0.tar.gz"
    sha256 "09609209ed7de61c2b560cc5c8c4fbf892f8b15b1faf7e4cbffac97db1fffda7"
  end

  resource "pysocks" do
    url "https:files.pythonhosted.orgpackagesbd11293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagesa287a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbdsniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "sortedcontainers" do
    url "https:files.pythonhosted.orgpackagese8c4ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "trio" do
    url "https:files.pythonhosted.orgpackagesb4514f5ae37ec58768b9c30e5bc5b89431a7baf3fa9d0dda98983af6ef55eb47trio-0.25.0.tar.gz"
    sha256 "9b41f5993ad2c0e5f62d0acca320ec657fdb6b2a2c22b8c7aed6caf154475c4e"
  end

  resource "trio-websocket" do
    url "https:files.pythonhosted.orgpackagesdd36abad2385853077424a11b818d9fd8350d249d9e31d583cb9c11cd4c85edatrio-websocket-0.11.1.tar.gz"
    sha256 "18c11793647703c158b1f6e62de638acada927344d534e3c7628eedcb746839f"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesf6f3b827b3ab53b4e3d8513914586dcca61c355fa2ce8252dea4da56e67bf8f2typing_extensions-4.11.0.tar.gz"
    sha256 "83f085bd5ca59c80295fc2a82ab5dac679cbe02b9f33f7d83af68e241bea51b0"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "websocket-client" do
    url "https:files.pythonhosted.orgpackages20072a94288afc0f6c9434d6709c5320ee21eaedb2f463ede25ed9cf6feff330websocket-client-1.7.0.tar.gz"
    sha256 "10e511ea3a8c744631d3bd77e61eb17ed09304c413ad42cf6ddfa4c7787e8fe6"
  end

  resource "wsproto" do
    url "https:files.pythonhosted.orgpackagesc94a44d3c295350d776427904d73c189e10aeae66d7f555bb2feee16d1e4ba5awsproto-1.2.0.tar.gz"
    sha256 "ad565f26ecb92588a3e43bc3d96164de84cd9902482b130d0ddbaa9664a85065"
  end

  def install
    virtualenv_install_with_resources(link_manpages: true)
  end

  test do
    system "#{bin}streamlink", "https:youtu.behe2a4xK8ctk", "audio_mp4a", "-o", "video.mp4"
    assert_match "video.mp4: ISO Media, MPEG v4 system", shell_output("file video.mp4")

    url = OS.mac? ? "https:ok.ruvideo3388934659879" : "https:www.youtube.comwatch?v=pOtd1cbOP7k"
    output = shell_output("#{bin}streamlink --ffmpeg-no-validation -l debug '#{url}'")
    assert_match "Available streams:", output
    refute_match "error", output
    refute_match "Could not find metadata", output
  end
end