class Backgroundremover < Formula
  include Language::Python::Virtualenv

  desc "Remove background from images and video using AI"
  homepage "https://backgroundremoverai.com"
  url "https://files.pythonhosted.org/packages/01/23/b6db66a9a7ad24e34581bae7910e77e16fce103fd9658bd5b6aef4e5effd/backgroundremover-0.4.5.tar.gz"
  sha256 "b9fe5ebaa234d43bfae02a2f28734e589ee895a861e55c02f6f1a41518587852"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "762f9456f9dffacd10dc03e712ac8ce8f38433885b721c6248a91ee56d6605b8"
    sha256 cellar: :any, arm64_tahoe:       "e725846b654f35a5b22d26bb5c3f1554b21f3cd480f730e3564bb725bf963750"
    sha256 cellar: :any, arm64_sequoia:     "0a84335deec736bbb7cfd7c86b3ecd0174d2d639f24df4418246c9eb2de2bed9"
    sha256 cellar: :any, arm64_linux:       "f8a076ea1bc322cb9fbe7c1b75a361e4e942ea591684cee109e0df71f233aa7f"
    sha256 cellar: :any, x86_64_linux:      "e5d2e727dded6be23f2018c82647ec1427d16ec4762c5eb073c4928e9c925153"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "certifi" => :no_linkage
  depends_on "ffmpeg"
  depends_on "libheif"
  depends_on "llvm@22"
  depends_on "pillow" => :no_linkage
  depends_on "python@3.14"
  depends_on "scikit-image" => :no_linkage
  depends_on "scipy" => :no_linkage
  depends_on "torchvision" => :no_linkage

  on_linux do
    depends_on "patchelf" => :build
    depends_on "openblas"
  end

  pypi_packages exclude_packages: %w[certifi torch torchvision pillow scipy scikit-image],
                extra_packages:   %w[imageio numpy] # numba needs numpy < 2.5, so vendor it as a resource

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/21/28/9b3f50ce0e048515135495f198351908d99540d69bfdc8c1d15b73dc55ce/blinker-1.9.0.tar.gz"
    sha256 "b4ce2265a7abece45e7cc896e98dbebe6cead56bcf805a3d23136d145f5445bf"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "commandlines" do
    url "https://files.pythonhosted.org/packages/b9/4c/d380f7f9aaa12175b189cfe087e823cd9aa2a99afc95a8d6e028142311c9/commandlines-0.4.1.tar.gz"
    sha256 "86b650b78470ac95966d7b1a9d215c16591bccb34b28ae2bb9026c3b4166fd64"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/60/8b/32f9823da46cde7df2087faa08cd98d01b908f8dcab982cdba9c84e85355/decorator-5.3.1.tar.gz"
    sha256 "4cbcdd55a6efadb9dbea26b858f4fb3264567b52d69ca0d25b721b553f60ea82"
  end

  resource "ffmpeg-python" do
    url "https://files.pythonhosted.org/packages/dd/5e/d5f9105d59c1325759d838af4e973695081fbbc97182baf73afc78dec266/ffmpeg-python-0.2.0.tar.gz"
    sha256 "65225db34627c578ef0e11c8b1eb528bb35e024752f6f10b78c011f6f64c4127"
  end

  resource "filetype" do
    url "https://files.pythonhosted.org/packages/bb/29/745f7d30d47fe0f251d3ad3dc2978a23141917661998763bebb6da007eb1/filetype-1.2.0.tar.gz"
    sha256 "66b56cd6474bf41d8c54660347d37afcc3f7d1970648de365c102ef77548aadb"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/26/00/35d85dcce6c57fdc871f3867d465d780f302a175ea360f62533f12b27e2b/flask-3.1.3.tar.gz"
    sha256 "0ef0e52b8a9cd932855379197dd8f94047b359ca0a78695144304cb45f87c9eb"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/a7/b2/4140c69c6a66432916b26158687e821ba631a4c9273c474343badf84d3ba/future-1.0.0.tar.gz"
    sha256 "bd2968309307861edae1458a4f8a4f3598c03be43b97521076aebf5d94c07b05"
  end

  resource "hsh" do
    url "https://files.pythonhosted.org/packages/88/dd/c04f9a56e374e7fe5a0ac5032d0a059ef7338485bcd2ae1a05115081c4e1/hsh-1.1.0.tar.gz"
    sha256 "c04e43ac538feafb029dba3c4972207a704f5fcdf0ee271ebdddd03d96b5df85"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "imageio" do
    url "https://files.pythonhosted.org/packages/81/c8/2b56274457e4fadcfa86bf7c0fb93f19e124ab8f38f4bfa4372423052046/imageio-2.38.0.tar.gz"
    sha256 "fe1d406862f6bc2930e8ec662d7bc40d4370cb76e3390dcd33819560d2708531"
  end

  resource "imageio-ffmpeg" do
    url "https://files.pythonhosted.org/packages/44/bd/c3343c721f2a1b0c9fc71c1aebf1966a3b7f08c2eea8ed5437a2865611d6/imageio_ffmpeg-0.6.0.tar.gz"
    sha256 "e2556bed8e005564a9f925bb7afa4002d82770d6b08825078b7697ab88ba1755"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/9c/cb/8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31d/itsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "llvmlite" do
    url "https://files.pythonhosted.org/packages/43/27/72ae94ea5c8f7349ec1c229d4cd058feb799cbd0833ad6d1b47c919b37b7/llvmlite-0.49.0.tar.gz"
    sha256 "00f16db782f4a13c78c5804aedc434e46794a77e89999a168f9401106270e50a"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/de/1d/f4da6f02cdffe04d6362210b807146a26044c88d839208aec273bb0d9184/more_itertools-11.1.0.tar.gz"
    sha256 "48e8f4d9e7e5878571ecf6f2b4e57634f93cd474cc8cfbd2376f2d11b396e30d"
  end

  resource "moviepy" do
    url "https://files.pythonhosted.org/packages/de/61/15f9476e270f64c78a834e7459ca045d669f869cec24eed26807b8cd479d/moviepy-2.2.1.tar.gz"
    sha256 "c80cb56815ece94e5e3e2d361aa40070eeb30a09d23a24c4e684d03e16deacb1"
  end

  resource "numba" do
    url "https://files.pythonhosted.org/packages/7a/90/2544f4e3a61e501d6c9a5418fd4b905323222693d54a02cab0106a0af865/numba-0.67.0.tar.gz"
    sha256 "cd75aa535b33fa05d9d930b1ae8af9f97a2881e96d72dfb38ec9b78284d9f851"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/13/01/11703282db468b85f6f7b8c7f22d058de5970d5c7e60a3a8aaa313c3de36/numpy-2.5.3.tar.gz"
    sha256 "df2d5874ff183595a4ba404edd04f6bd9b5505c1d7708573f6a6c17489a67563"
  end

  resource "pillow-heif" do
    url "https://files.pythonhosted.org/packages/bb/4c/d5319a1f276c70528ff97893afc42a300ff28029e27ca8de89bb3b271680/pillow_heif-1.8.0.tar.gz"
    sha256 "e47c27432c6fd3d66c22f0de9f27fd379383b646c947520bc485854ce72060d0"
  end

  resource "proglog" do
    url "https://files.pythonhosted.org/packages/c2/af/c108866c452eda1132f3d6b3cb6be2ae8430c97e9309f38ca9dbd430af37/proglog-0.1.12.tar.gz"
    sha256 "361ee074721c277b89b75c061336cb8c5f287c92b043efa562ccf7866cda931c"
  end

  resource "pymatting" do
    url "https://files.pythonhosted.org/packages/75/4b/01a653f1ec2a69b1579d9ff47578b41bc432216f1a2b6e57cf37f725a95b/pymatting-1.1.16.tar.gz"
    sha256 "656e16f07c941b8792c8cd341b49791e74d1949ceae4d8c45fb4e10d3c6e7d77"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/6a/53/ed9d74092561d4b01a2ef1349d52cdbc135e526c245f366b089cfca6de49/python_dotenv-1.2.3.tar.gz"
    sha256 "a20a594dabeaa385725aa239d5244871c143ecb356add8a20fcf23773a6c3a35"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/0d/ea/b2a5bd54b28a324dae8211928b2d730b6547500342c7e6c6dea08bd0a485/tqdm-4.70.1.tar.gz"
    sha256 "cefd0eca11b2a37a3aee776544d4f4ae913f02688135b5556b8788dfa474afc4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "waitress" do
    url "https://files.pythonhosted.org/packages/bf/cb/04ddb054f45faa306a230769e868c28b8065ea196891f09004ebace5b184/waitress-3.0.2.tar.gz"
    sha256 "682aaaf2af0c44ada4abfb70ded36393f0e307f4ab9456a215ce0020baefc31f"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/a4/34/4dd12fc8bb7d61c91467ec3efe415ffa7d5456f799954b40c5bbaeae470e/werkzeug-3.1.9.tar.gz"
    sha256 "55ca7c70a75689be937aa27f8ff4b018f06ff4838fc73045560bf0f5a1291060"
  end

  def install
    ENV["LLVMLITE_SHARED"] = "1"
    venv = virtualenv_install_with_resources without: "numba"

    # We depend on the formula below, but they are separate formula, so install a `.pth` file to link them.
    # NOTE: This is an exception to our usual policy as building them is complicated
    site_packages = Language::Python.site_packages(venv.root/"bin/python3")
    torchvision_pth_contents = "import site; site.addsitedir('#{formula_opt_libexec("torchvision")/site_packages}')\n"
    (venv.site_packages/"homebrew-torchvision.pth").write torchvision_pth_contents

    skimage_pth_contents = "import site; site.addsitedir('#{formula_opt_libexec("scikit-image")/site_packages}')\n"
    (venv.site_packages/"homebrew-scikit-image.pth").write skimage_pth_contents

    # We install `numba` separately without build isolation to avoid building another `numpy`
    venv.pip_install(resource("numba"), build_isolation: false)
  end

  test do
    system bin/"backgroundremover", "-i", test_fixtures("test.jpg"), "-o", testpath/"output.png"
    assert_path_exists testpath/"output.png"
  end
end