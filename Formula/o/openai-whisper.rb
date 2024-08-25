class OpenaiWhisper < Formula
  include Language::Python::Virtualenv

  desc "General-purpose speech recognition model"
  homepage "https:github.comopenaiwhisper"
  url "https:files.pythonhosted.orgpackagesd26e50ace2bf704e5ffc786d20d96403ab0d57c5d6ab8729de7fed8c436687dfopenai-whisper-20231117.tar.gz"
  sha256 "7af424181436f1800cc0b7d75cf40ede34e9ddf1ba4983a910832fcf4aade4a4"
  license "MIT"
  revision 6
  head "https:github.comopenaiwhisper.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "66994757920b560b0ddba120aa779ca8b69676883716ff5ebac3ed6c72ecf112"
    sha256 cellar: :any,                 arm64_ventura:  "d127afd6258ab3b5e1734f1c47b0178b29a55e3ebd5c317c88fe46c721e940b7"
    sha256 cellar: :any,                 arm64_monterey: "b955e1d73e96d0f1c8ea3fd80ff4fe2edac30039cc9edbbf6bca1c6649f81fa8"
    sha256 cellar: :any,                 sonoma:         "3a3417495a3f08fad995dc16fc457245b8dd75cd8fc23a37cc8204b6eb677bdd"
    sha256 cellar: :any,                 ventura:        "1ad6a7853c20c84786421f592444b34cf7f0e71e8acd0b36fb324702a6f0a1a0"
    sha256 cellar: :any,                 monterey:       "3fe3d019c3094fb814976c1573a12867858f89912387a6d472dc5af925343450"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebe5c9ee278764c7abdeb454aafa3d3009c1ce961170b7562b9089dd0e261500"
  end

  depends_on "rust" => :build # for tiktoken
  depends_on "certifi"
  depends_on "ffmpeg"
  depends_on "llvm@15" # Issue for newer LLVM: https:github.comnumballvmliteissues1048
  depends_on "numpy"
  depends_on "python@3.12"
  depends_on "pytorch"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "llvmlite" do
    # Fetch from Git hash for compatibility with the new version of `numba` below.
    url "https:github.comnumballvmlitearchiveca123c3ae2a6f7db865661ae509862277ec5d692.tar.gz"
    sha256 "a778c3b02f96a57a8c4c2e22cb7b2b0712cf487ac5167d459150e1b1fc42b028"
  end

  resource "more-itertools" do
    url "https:files.pythonhosted.orgpackages920dad6a82320cb8eba710fd0dceb0f678d5a1b58d67d03ae5be14874baa39e0more-itertools-10.4.0.tar.gz"
    sha256 "fe0e63c4ab068eac62410ab05cccca2dc71ec44ba8ef29916a0090df061cf923"
  end

  resource "numba" do
    # Fetch from Git hash for numpy 2.1 compatibility
    url "https:github.comnumbanumbaarchivea344e8f55440c91d40c5221e93a38ce0c149b803.tar.gz"
    sha256 "6295d40e7f2f29dfe06a0403e6e7540f7d286df238085d61637740017acb11ee"
  end

  resource "regex" do
    url "https:files.pythonhosted.orgpackages3f5164256d0dc72816a4fe3779449627c69ec8fee5a5625fd60ba048f53b3478regex-2024.7.24.tar.gz"
    sha256 "9cfd009eed1a46b27c14039ad5bbc5e71b6367c5b2e6d5f5da0ea91600817506"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "tiktoken" do
    url "https:files.pythonhosted.orgpackagesc44aabaec53e93e3ef37224a4dd9e2fc6bb871e7a538c2b6b9d2a6397271daf4tiktoken-0.7.0.tar.gz"
    sha256 "1077266e949c24e0291f6c350433c6f0971365ece2b173a23bc3b9f9defef6b6"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackages58836ba9844a41128c62e810fddddd72473201f3eacde02046066142a2d96cc5tqdm-4.66.5.tar.gz"
    sha256 "e1020aef2e5096702d8a025ac7d16b1577279c9d63f8375b63083e9a5f0fcbad"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    python3 = "python3.12"
    venv = virtualenv_create(libexec, python3)

    # We depend on pytorch, but that's a separate formula, so install a `.pth` file to link them.
    # This needs to happen _before_ we try to install torchvision.
    site_packages = Language::Python.site_packages(python3)
    pytorch = Formula["pytorch"].opt_libexec
    (venv.site_packages"homebrew-pytorch.pth").write pytorchsite_packages

    ENV["LLVM_CONFIG"] = Formula["llvm@15"].opt_bin"llvm-config"
    venv.pip_install resources.reject { |r| r.name == "numba" }
    venv.pip_install(resource("numba"), build_isolation: false)
    venv.pip_install_and_link buildpath
  end

  test do
    resource "homebrew-test-audio" do
      url "https:raw.githubusercontent.comopenaiwhisper7858aa9c08d98f75575035ecd6481f462d66ca27testsjfk.flac"
      sha256 "63a4b1e4c1dc655ac70961ffbf518acd249df237e5a0152faae9a4a836949715"
    end

    resource "homebrew-test-model" do
      url "https:openaipublic.azureedge.netmainwhispermodelsd3dd57d32accea0b295c96e26691aa14d8822fac7d9d27d5dc00b4ca2826dd03tiny.en.pt"
      sha256 "d3dd57d32accea0b295c96e26691aa14d8822fac7d9d27d5dc00b4ca2826dd03"
    end

    testpath.install resource("homebrew-test-audio")
    (testpath"models").install resource("homebrew-test-model")
    # for some unknown reason, the file is installed as `tests` rather than `jfk.flac`
    system bin"whisper", "tests", "--model", "tiny.en", "--model_dir", "models", "--output_format", "txt"
    transcription = File.read("tests.txt")
    assert_equal transcription, <<~EOS
      And so, my fellow Americans ask not what your country can do for you
      ask what you can do for your country.
    EOS
  end
end