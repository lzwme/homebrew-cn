class Plutoprint < Formula
  include Language::Python::Virtualenv

  desc "Generate PDFs and Images from HTML"
  homepage "https://github.com/plutoprint/plutoprint"
  url "https://files.pythonhosted.org/packages/d9/67/8adc356edbeb6efac8cf16f90121fefd9eb65ec3478c5268be284438b94e/plutoprint-0.14.0.tar.gz"
  sha256 "8116c2fc739329ece9aea1eb8e835c77792e3a7f410361838dbb7252491cdd29"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4d796d157da7e8a6e7770ba57d2908dd1fbfc5b0cae6bd36965a74314e0abd24"
    sha256 cellar: :any,                 arm64_sequoia: "ed864b2d9353c07f0c09fe6ab68f1be07d48faa809c2a828e94fb939c33105e8"
    sha256 cellar: :any,                 arm64_sonoma:  "2ac7498c759e683508b6c86c60e3c40bd55ac2e5224699fe5bedc36260c54fd4"
    sha256 cellar: :any,                 sonoma:        "356eec52b9efe2436687c05cdc6d2b9a8eef46a1172efe818807ee21ce438a49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76e3f079d966298018118185bed9d26f913c53261236c5ba427ace888203e5f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39cb105f5817aff9001e05f07b920337e4f70687e1cc3c2aaae6b6876a71fd66"
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