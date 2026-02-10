class Plutoprint < Formula
  include Language::Python::Virtualenv

  desc "Generate PDFs and Images from HTML"
  homepage "https://github.com/plutoprint/plutoprint"
  url "https://files.pythonhosted.org/packages/9b/a3/78151c5bc81abe3586ee09ef5ddd6ed193220641bfed10f1b07e467f8852/plutoprint-0.17.0.tar.gz"
  sha256 "361bb13f152c31d03023f91a0bc81706cda0637f795c43f5859725c1d94c9bb5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "121ba3371477142ddf66b83b068b8d030706f615730d91fe4d05911cfce908f5"
    sha256 cellar: :any,                 arm64_sequoia: "943a81cda23c70017dcb8160b4fc38eb063b196d9f5ef1588d8d3899af6902db"
    sha256 cellar: :any,                 arm64_sonoma:  "11819443a60bbe4feb95925071b1bf1dcbe8d7353891d3780a4bdf3fd5671225"
    sha256 cellar: :any,                 sonoma:        "ad23477013577e911ee422fcfbaf6f9e733121510b6d9b2ec24deccb65d58357"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b94725446c89260f8c28cd3e8a51881a236c45850b63fe051999f5149f626011"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "353c0db4c726a927e157b438485c07601cb38b6e8296da54c60087f92e3bc6da"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "plutobook"
  depends_on "python@3.14"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1499
  end

  on_ventura do
    depends_on "llvm" => :build
  end

  on_linux do
    depends_on "patchelf" => :build
  end

  fails_with :clang do
    build 1499
    cause "Requires C++20 support"
  end

  fails_with :gcc do
    version "9"
    cause "requires GCC 10+"
  end

  def python3
    "python3.14"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plutoprint --version")

    (testpath/"test.html").write <<~HTML
      <h1>Hello World!</h1>
    HTML

    system bin/"plutoprint", "test.html", "test.pdf"
    assert_path_exists testpath/"test.pdf"
  end
end