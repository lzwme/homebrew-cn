class Streamlink < Formula
  include Language::Python::Virtualenv

  desc "CLI for extracting streams from various websites to a video player"
  homepage "https:streamlink.github.io"
  url "https:files.pythonhosted.orgpackages52fada935fdba0883f8d3bfaf1e19825979e088d626584a1d1f6a986ed1c4eb5streamlink-7.1.1.tar.gz"
  sha256 "c1881ed0bba53612d979d9a918b7dec056fc93cd202a5b07a080e5568dbdab4c"
  license "BSD-2-Clause"
  head "https:github.comstreamlinkstreamlink.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f53f3339f13a3b3e4a9b43dec599037d9a68c812ed3b0a472d6ce39abaf6ad00"
    sha256 cellar: :any,                 arm64_sonoma:  "172b839b2eccba0187c2fddd3bdef71dde231520eb56c08583469307ab2ea108"
    sha256 cellar: :any,                 arm64_ventura: "c97d03a4cf7c41c27766739885cd1ea6412643bd0a000b0099a4a3090082ba4e"
    sha256 cellar: :any,                 sonoma:        "7ee9e09a7458f23d081bef9fcea1f7dfbb9d6d1b0ac058b7f464623306d71572"
    sha256 cellar: :any,                 ventura:       "52ee6a7008b14f3014801581921584c9360ee0aa2a3fc36ce9a9cdff299c2802"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f03954a5715914eb4c4023a6788500e1fb13f12ba46f58a521a014667ccee17"
  end

  depends_on "certifi"
  depends_on "libxml2" # https:github.comHomebrewhomebrew-coreissues98468
  depends_on "python@3.13"

  uses_from_macos "libffi"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "pkgconf" => :build
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages48c86260f8ccc11f0917360fc0da435c5c9c7504e3db174d5a12a1494887b045attrs-24.3.0.tar.gz"
    sha256 "8f5c07333d543103541ba7be0e2ce16eeee8130cb0b3f9238ab904ce1e85baff"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages16b0572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackagesf5383af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "isodate" do
    url "https:files.pythonhosted.orgpackages544de940025e2ce31a8ce1202635910747e5a87cc3a6a6bb2d00973375014749isodate-0.7.2.tar.gz"
    sha256 "4cd1aa0f43ca76f4a6c6c0292a85f40b35ec2e43e315b59f06e6d32171a953e6"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackagese76b20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
  end

  resource "outcome" do
    url "https:files.pythonhosted.orgpackages98df77698abfac98571e65ffeb0c1fba8ffd692ab8458d617a0eed7d9a8d38f2outcome-1.3.0.post0.tar.gz"
    sha256 "9dcf02e65f2971b80047b377468e72a268e15c0af3cf1238e6ff14f7f91143b8"
  end

  resource "pycountry" do
    url "https:files.pythonhosted.orgpackages7657c389fa68c50590881a75b7883eeb3dc15e9e73a0fdc001cdd45c13290c92pycountry-24.6.1.tar.gz"
    sha256 "b61b3faccea67f87d10c1f2b0fc0be714409e8fcdcc1315613174f6466c10221"
  end

  resource "pycryptodome" do
    url "https:files.pythonhosted.orgpackages135213b9db4a913eee948152a079fe58d035bd3d1a519584155da8e786f767e6pycryptodome-3.21.0.tar.gz"
    sha256 "f7787e0d469bdae763b876174cf2e6c0f7be79808af26b1da96f1a64bcf47297"
  end

  resource "pysocks" do
    url "https:files.pythonhosted.orgpackagesbd11293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
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
    url "https:files.pythonhosted.orgpackagesb37357efab729506a8d4b89814f1e356ec8f3369de0ed4fd7e7616974d09646dtrio-0.28.0.tar.gz"
    sha256 "4e547896fe9e8a5658e54e4c7c5fa1db748cbbbaa7c965e7d40505b928c73c05"
  end

  resource "trio-websocket" do
    url "https:files.pythonhosted.orgpackagesdd36abad2385853077424a11b818d9fd8350d249d9e31d583cb9c11cd4c85edatrio-websocket-0.11.1.tar.gz"
    sha256 "18c11793647703c158b1f6e62de638acada927344d534e3c7628eedcb746839f"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaa63e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  resource "websocket-client" do
    url "https:files.pythonhosted.orgpackagese630fba0d96b4b5fbf5948ed3f4681f7da2f9f64512e1d303f94b4cc174c24a5websocket_client-1.8.0.tar.gz"
    sha256 "3239df9f44da632f96012472805d40a23281a991027ce11d2f45a6f24ac4c3da"
  end

  resource "wsproto" do
    url "https:files.pythonhosted.orgpackagesc94a44d3c295350d776427904d73c189e10aeae66d7f555bb2feee16d1e4ba5awsproto-1.2.0.tar.gz"
    sha256 "ad565f26ecb92588a3e43bc3d96164de84cd9902482b130d0ddbaa9664a85065"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin"streamlink", "https:vimeo.com144358359", "360p", "-o", "video.mp4"
    assert_match "video.mp4: ISO Media, MP4 v2", shell_output("file video.mp4")

    url = OS.mac? ? "https:ok.ruvideo1643385658936" : "https:www.youtube.comwatch?v=pOtd1cbOP7k"
    if OS.mac?
      output = shell_output("#{bin}streamlink --ffmpeg-no-validation -l debug '#{url}'")
      assert_match "Available streams:", output
      refute_match "error", output
      refute_match "Could not find metadata", output
    else
      output = shell_output("#{bin}streamlink --ffmpeg-no-validation -l debug '#{url}'", 1)
      assert_match(Could not get video info - LOGIN_REQUIRED|plugin does not support VOD content, output)
    end
  end
end