class OpenaiWhisper < Formula
  include Language::Python::Virtualenv

  desc "General-purpose speech recognition model"
  homepage "https://github.com/openai/whisper"
  url "https://files.pythonhosted.org/packages/63/46/b5f9d697b138ef9885dd3e8a08c6475c1cbd747f2dfc14a437fe3b02b58e/openai-whisper-20231106.tar.gz"
  sha256 "9d1de7fa1e766b9adf8be4bfa7fb11e2bdf8d2b0bf77b90478cf4d75e0e58d19"
  license "MIT"
  head "https://github.com/openai/whisper.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7617d0217fbe550786fb84917b2d7aa2d728f2d749d830ba5072ffe19ed577b9"
    sha256 cellar: :any,                 arm64_ventura:  "a10c1c0ae356f0a593a20b9e4e060a25b0f862f43d6ae97371ecfd1fcd361169"
    sha256 cellar: :any,                 arm64_monterey: "412d130a5b2c883af7014afaa9aab44f8d38d4b631d523ffdc153152e0d19b61"
    sha256 cellar: :any,                 sonoma:         "8a163a1403a701cb9dc8f0c4f7126672422ba0b06183dcfee51f96095d1ca6a5"
    sha256 cellar: :any,                 ventura:        "7307422ace6150df05b8011e9c809780b730635405220997b19fe7d181961d55"
    sha256 cellar: :any,                 monterey:       "7e7900bf190f9da6904867d80531ddd2aca70423b95c58e2fed7d78eeab2e529"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9aac4e852f7bc09ca215fc636bbd22601ae2459b644e5eb155978a2a23e2fa24"
  end

  depends_on "rust" => :build # for tiktoken
  depends_on "ffmpeg"
  depends_on "huggingface-cli"
  depends_on "llvm@14"
  depends_on "numpy"
  depends_on "python-certifi"
  depends_on "python-markupsafe"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pytorch"
  depends_on "pyyaml"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/70/70/41905c80dcfe71b22fb06827b8eae65781783d4a14194bce79d16a013263/filelock-3.13.1.tar.gz"
    sha256 "521f5f56c50f8426f5e03ad3b281b490a87ef15bc6c526f168290f0c7148d44e"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/a4/f7/16ec1f92523165d10301cfa8cb83df0356dbe615d4ca5ed611a16f53e09a/fsspec-2023.10.0.tar.gz"
    sha256 "330c66757591df346ad3091a53bd907e15348c2ba17d63fd54f5c39c4457d2a5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "llvmlite" do
    url "https://files.pythonhosted.org/packages/01/c6/bc6634da9f58edf91a1a002280c6380f404715245a49a46234b1d9d9585a/llvmlite-0.41.1.tar.gz"
    sha256 "f19f767a018e6ec89608e1f6b13348fa2fcde657151137cb64e56d48598a92db"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/2d/73/3557e45746fcaded71125c0a1c0f87616e8258c78391f0c365bf97bbfc99/more-itertools-10.1.0.tar.gz"
    sha256 "626c369fa0eb37bac0291bce8259b332fd59ac792fa5497b59837309cd5b114a"
  end

  resource "mpmath" do
    url "https://files.pythonhosted.org/packages/e0/47/dd32fa426cc72114383ac549964eecb20ecfd886d1e5ccf5340b55b02f57/mpmath-1.3.0.tar.gz"
    sha256 "7a28eb2a9774d00c7bc92411c19a89209d5da7c4c9a9e227be8330a23a25b91f"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/c4/80/a84676339aaae2f1cfdf9f418701dd634aef9cc76f708ef55c36ff39c3ca/networkx-3.2.1.tar.gz"
    sha256 "9f1bb5cf3409bf324e0a722c20bdb4c20ee39bf1c30ce8ae499c8502b0b5e0c6"
  end

  resource "numba" do
    url "https://files.pythonhosted.org/packages/13/2b/0f750d451fd961fd91d6bc86c512781fa46f9ef64813007e501482522ff9/numba-0.58.1.tar.gz"
    sha256 "487ded0633efccd9ca3a46364b40006dbdaca0f95e99b8b83e778d1195ebcbaa"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/6b/38/49d968981b5ec35dbc0f742f8219acab179fc1567d9c22444152f950cf0d/regex-2023.10.3.tar.gz"
    sha256 "3fef4f844d2290ee0ba57addcec17eec9e3df73f10a2748485dfd6a3a188cc0f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "sympy" do
    url "https://files.pythonhosted.org/packages/e5/57/3485a1a3dff51bfd691962768b14310dae452431754bfc091250be50dd29/sympy-1.12.tar.gz"
    sha256 "ebf595c8dac3e0fdc4152c51878b498396ec7f30e7a914d6071e674d49420fb8"
  end

  resource "tiktoken" do
    url "https://files.pythonhosted.org/packages/bd/ef/91777d3310589c55da4bf0fafa10fdc8ddefa30aa7dfa67b2fc8825bc1f1/tiktoken-0.5.1.tar.gz"
    sha256 "27e773564232004f4f810fd1f85236673ec3a56ed7f1206fc9ed8670ebedb97a"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/62/06/d5604a70d160f6a6ca5fd2ba25597c24abd5c5ca5f437263d177ac242308/tqdm-4.66.1.tar.gz"
    sha256 "d88e651f9db8d8551a62556d3cff9e3034274ca5d66e93197cf2490e2dcb69c7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    python3 = "python3.11"
    venv = virtualenv_create(libexec, python3)
    ENV["LLVM_CONFIG"] = Formula["llvm@14"].opt_bin/"llvm-config"
    venv.pip_install resources.reject { |r| r.name.start_with? "test-" }
    venv.pip_install_and_link buildpath

    # link dependent virtualenvs to this one
    site_packages = Language::Python.site_packages(python3)
    paths = %w[pytorch huggingface-cli].map do |package_name|
      package = Formula[package_name].opt_libexec
      package/site_packages
    end
    (libexec/site_packages/"homebrew-deps.pth").write paths.join("\n")
  end

  test do
    resource "homebrew-test-audio" do
      url "https://ghproxy.com/https://raw.githubusercontent.com/openai/whisper/7858aa9c08d98f75575035ecd6481f462d66ca27/tests/jfk.flac"
      sha256 "63a4b1e4c1dc655ac70961ffbf518acd249df237e5a0152faae9a4a836949715"
    end

    resource "homebrew-test-model" do
      url "https://openaipublic.azureedge.net/main/whisper/models/d3dd57d32accea0b295c96e26691aa14d8822fac7d9d27d5dc00b4ca2826dd03/tiny.en.pt"
      sha256 "d3dd57d32accea0b295c96e26691aa14d8822fac7d9d27d5dc00b4ca2826dd03"
    end

    testpath.install resource("homebrew-test-audio")
    (testpath/"models").install resource("homebrew-test-model")
    # for some unknown reason, the file is installed as `tests` rather than `jfk.flac`
    system "#{bin}/whisper", "tests", "--model", "tiny.en", "--model_dir", "models", "--output_format", "txt"
    transcription = File.read("tests.txt")
    assert_equal transcription, <<~EOS
      And so, my fellow Americans ask not what your country can do for you
      ask what you can do for your country.
    EOS
  end
end