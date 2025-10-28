class Backgroundremover < Formula
  include Language::Python::Virtualenv

  desc "Remove background from images and video using AI"
  homepage "https://github.com/nadermx/backgroundremover"
  url "https://files.pythonhosted.org/packages/81/c9/5c7d668bea7bb5ae6e069afe33c19e55ae95975a87a7e3a5bbd3d6199f74/backgroundremover-0.3.4.tar.gz"
  sha256 "c4ce35da0194138c115017dba9f5dae38b7e2bfcf15a413ef04d8ce01e66e214"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "d2b21276350dba7e2699108574cd3608c25c5e22d72c9434fe352c165d12ad98"
    sha256 cellar: :any,                 arm64_sequoia: "e083a60c6869c60574e1968a635b7d8f1654cfb0dfae5a0da4a29c58066667ed"
    sha256 cellar: :any,                 arm64_sonoma:  "a8718a44aa6a253f9b9af1fca66e406eb1cb96bb28f8f1ff4de50579e1173558"
    sha256 cellar: :any,                 sonoma:        "c2981ba9aa8107bcd22fa3f542b50ef164a0d967c5f2bf723b7d658e4eba2326"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0f7510adcb19eff67fef89eda903390de96d266747fc21b8757fa1cef652fd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21cb19aaaf5b99436075ad9d0d9eb7d3aef96eb4357d6b20c25b6ac2c3b04294"
  end

  depends_on "cmake" => :build
  depends_on "certifi"
  depends_on "ffmpeg"
  depends_on "llvm@20"
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.13"
  depends_on "scikit-image"
  depends_on "scipy"
  depends_on "torchvision"

  on_linux do
    depends_on "patchelf" => :build
  end

  pypi_packages exclude_packages: %w[certifi numpy torch torchvision pillow scipy scikit-image],
                extra_packages:   "imageio"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "commandlines" do
    url "https://files.pythonhosted.org/packages/b9/4c/d380f7f9aaa12175b189cfe087e823cd9aa2a99afc95a8d6e028142311c9/commandlines-0.4.1.tar.gz"
    sha256 "86b650b78470ac95966d7b1a9d215c16591bccb34b28ae2bb9026c3b4166fd64"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/43/fa/6d96a0978d19e17b68d634497769987b16c8f4cd0a7a05048bec693caa6b/decorator-5.2.1.tar.gz"
    sha256 "65f266143752f734b0a7cc83c46f4618af75b8c5911b00ccb61d0ac9b6da0360"
  end

  resource "ffmpeg-python" do
    url "https://files.pythonhosted.org/packages/dd/5e/d5f9105d59c1325759d838af4e973695081fbbc97182baf73afc78dec266/ffmpeg-python-0.2.0.tar.gz"
    sha256 "65225db34627c578ef0e11c8b1eb528bb35e024752f6f10b78c011f6f64c4127"
  end

  resource "filetype" do
    url "https://files.pythonhosted.org/packages/bb/29/745f7d30d47fe0f251d3ad3dc2978a23141917661998763bebb6da007eb1/filetype-1.2.0.tar.gz"
    sha256 "66b56cd6474bf41d8c54660347d37afcc3f7d1970648de365c102ef77548aadb"
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
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "imageio-ffmpeg" do
    url "https://files.pythonhosted.org/packages/44/bd/c3343c721f2a1b0c9fc71c1aebf1966a3b7f08c2eea8ed5437a2865611d6/imageio_ffmpeg-0.6.0.tar.gz"
    sha256 "e2556bed8e005564a9f925bb7afa4002d82770d6b08825078b7697ab88ba1755"
  end

  resource "llvmlite" do
    url "https://files.pythonhosted.org/packages/9d/73/4b29b502618766276816f2f2a7cf9017bd3889bc38a49319bee9ad492b75/llvmlite-0.45.0.tar.gz"
    sha256 "ceb0bcd20da949178bd7ab78af8de73e9f3c483ac46b5bef39f06a4862aa8336"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/ea/5d/38b681d3fce7a266dd9ab73c66959406d565b3e85f21d5e66e1181d93721/more_itertools-10.8.0.tar.gz"
    sha256 "f638ddf8a1a0d134181275fb5d58b086ead7c6a72429ad725c67503f13ba30bd"
  end

  resource "moviepy" do
    url "https://files.pythonhosted.org/packages/de/61/15f9476e270f64c78a834e7459ca045d669f869cec24eed26807b8cd479d/moviepy-2.2.1.tar.gz"
    sha256 "c80cb56815ece94e5e3e2d361aa40070eeb30a09d23a24c4e684d03e16deacb1"
  end

  resource "numba" do
    url "https://files.pythonhosted.org/packages/e5/96/66dae7911cb331e99bf9afe35703317d8da0fad81ff49fed77f4855e4b60/numba-0.62.0.tar.gz"
    sha256 "2afcc7899dc93fefecbb274a19c592170bc2dbfae02b00f83e305332a9857a5a"
  end

  resource "proglog" do
    url "https://files.pythonhosted.org/packages/c2/af/c108866c452eda1132f3d6b3cb6be2ae8430c97e9309f38ca9dbd430af37/proglog-0.1.12.tar.gz"
    sha256 "361ee074721c277b89b75c061336cb8c5f287c92b043efa562ccf7866cda931c"
  end

  resource "pymatting" do
    url "https://files.pythonhosted.org/packages/35/43/cd7a82913dfde95dfb653efd09c7b394a76b3865570050b674a36fc0078c/pymatting-1.1.14.tar.gz"
    sha256 "75e2ec1e346dbd564c9a2cc8229b134ec939f49008fa570025db30003d0c46fc"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/f6/b0/4bc07ccd3572a2f9df7e6782f52b0c6c90dcbb803ac4a167702d7d0dfe1e/python_dotenv-1.1.1.tar.gz"
    sha256 "a8a6399716257f45be6a007360200409fce5cda2661e3dec71d23dc15f6189ab"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "waitress" do
    url "https://files.pythonhosted.org/packages/bf/cb/04ddb054f45faa306a230769e868c28b8065ea196891f09004ebace5b184/waitress-3.0.2.tar.gz"
    sha256 "682aaaf2af0c44ada4abfb70ded36393f0e307f4ab9456a215ce0020baefc31f"
  end

  def install
    ENV["LLVMLITE_SHARED"] = "1"
    venv = virtualenv_install_with_resources

    # We depend on the formula below, but they are separate formula, so install a `.pth` file to link them.
    # NOTE: This is an exception to our usual policy as building them is complicated
    site_packages = Language::Python.site_packages(venv.root/"bin/python3")
    torchvision_pth_contents = "import site; site.addsitedir('#{Formula["torchvision"].opt_libexec/site_packages}')\n"
    (venv.site_packages/"homebrew-torchvision.pth").write torchvision_pth_contents

    skimage_pth_contents = "import site; site.addsitedir('#{Formula["scikit-image"].opt_libexec/site_packages}')\n"
    (venv.site_packages/"homebrew-scikit-image.pth").write skimage_pth_contents
  end

  test do
    system bin/"backgroundremover", "-i", test_fixtures("test.jpg"), "-o", testpath/"output.png"
    assert_path_exists testpath/"output.png"
  end
end