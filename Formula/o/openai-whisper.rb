class OpenaiWhisper < Formula
  include Language::Python::Virtualenv

  desc "General-purpose speech recognition model"
  homepage "https:github.comopenaiwhisper"
  url "https:files.pythonhosted.orgpackagesd26e50ace2bf704e5ffc786d20d96403ab0d57c5d6ab8729de7fed8c436687dfopenai-whisper-20231117.tar.gz"
  sha256 "7af424181436f1800cc0b7d75cf40ede34e9ddf1ba4983a910832fcf4aade4a4"
  license "MIT"
  revision 1
  head "https:github.comopenaiwhisper.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4c7699f18e18799736ce28800d6040ec454cfca2f00cc09081e9c4a525178c90"
    sha256 cellar: :any,                 arm64_ventura:  "b369003e2be75695b8cab6be6edd1f4d89c50cea5efed2f00fd3cc9dacd80e8e"
    sha256 cellar: :any,                 arm64_monterey: "3e55312927c5e4b216cbbe73b6e8203c7bdcc1f7c76352cc0ac46f61fb26472c"
    sha256 cellar: :any,                 sonoma:         "c0f9e109855aef6f4251ffe1f62d8b4c6c5f1285e00076c61d36c511578521a6"
    sha256 cellar: :any,                 ventura:        "41096642700cef3b6a1b1b9739505f210ddec97147e46e355f49732611ca11e0"
    sha256 cellar: :any,                 monterey:       "184612f34ec3ba01510a411b845a2e2a3848c3ec4adc6959bc06be0836ed9fd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7999941923a991fa99274ce7f3ba1c4f346a3521d8c224393e009c769582eda"
  end

  depends_on "rust" => :build # for tiktoken
  depends_on "ffmpeg"
  depends_on "llvm@14" # Issue for newer LLVM: https:github.comnumballvmliteissues914
  depends_on "numpy"
  depends_on "python-certifi"
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
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "llvmlite" do
    url "https:files.pythonhosted.orgpackages3bffad02ffee7d519615726fc46c99a37e697f2b4b1fb7e5d3cd6fb465d4f49fllvmlite-0.42.0.tar.gz"
    sha256 "f92b09243c0cc3f457da8b983f67bd8e1295d0f5b3746c7a1861d7a99403854a"
  end

  resource "more-itertools" do
    url "https:files.pythonhosted.orgpackagesdfad7905a7fd46ffb61d976133a4f47799388209e73cbc8c1253593335da88b4more-itertools-10.2.0.tar.gz"
    sha256 "8fccb480c43d3e99a00087634c06dd02b0d50fbf088b380de5a41a015ec239e1"
  end

  resource "numba" do
    url "https:files.pythonhosted.orgpackagesa35ead8f7a2ca55b5903cea0aa6ec0bb0eee7faeec3ca1c4f871d99ff46aad36numba-0.59.0.tar.gz"
    sha256 "12b9b064a3e4ad00e2371fc5212ef0396c80f41caec9b5ec391c8b04b6eaf2a8"
  end

  resource "regex" do
    url "https:files.pythonhosted.orgpackagesb53931626e7e75b187fae7f121af3c538a991e725c744ac893cc2cfd70ce2853regex-2023.12.25.tar.gz"
    sha256 "29171aa128da69afdf4bde412d5bedc335f2ca8fcfe4489038577d05f16181e5"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "tiktoken" do
    url "https:files.pythonhosted.orgpackages3a7ba8f49a8fb3f7dd70c77ab1d90b0514ab534db43cbcf8ac0a7ece57c64d87tiktoken-0.6.0.tar.gz"
    sha256 "ace62a4ede83c75b0374a2ddfa4b76903cf483e9cb06247f566be3bf14e6beed"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackagesea853ce0f9f7d3f596e7ea57f4e5ce8c18cb44e4a9daa58ddb46ee0d13d6bff8tqdm-4.66.2.tar.gz"
    sha256 "6cd52cdf0fef0e0f543299cfc96fec90d7b8a7e88745f411ec33eb44d5ed3531"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    python3 = "python3.12"
    venv = virtualenv_create(libexec, python3)

    # We depend on pytorch, but that's a separate formula, so install a `.pth` file to link them.
    # This needs to happen _before_ we try to install torchvision.
    site_packages = Language::Python.site_packages(python3)
    pytorch = Formula["pytorch"].opt_libexec
    (libexecsite_packages"homebrew-pytorch.pth").write pytorchsite_packages

    ENV["LLVM_CONFIG"] = Formula["llvm@14"].opt_bin"llvm-config"
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
    system "#{bin}whisper", "tests", "--model", "tiny.en", "--model_dir", "models", "--output_format", "txt"
    transcription = File.read("tests.txt")
    assert_equal transcription, <<~EOS
      And so, my fellow Americans ask not what your country can do for you
      ask what you can do for your country.
    EOS
  end
end