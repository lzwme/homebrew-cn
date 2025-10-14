class Plutoprint < Formula
  include Language::Python::Virtualenv

  desc "Generate PDFs and Images from HTML"
  homepage "https://github.com/plutoprint/plutoprint"
  url "https://files.pythonhosted.org/packages/ef/d0/af1b23123d37d1f672dbf5d68cf33b1ad1e274936079d33118ae9e18ce47/plutoprint-0.12.0.tar.gz"
  sha256 "cbca7d1f2bc1c61c14c3feb9ab16b54583cfaa350ec8266de879940494e7dbe1"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "ee61df735c944b3a3175b2e334991facc2efb3e6a36004e03a3b6bfa9c55d2b3"
    sha256 cellar: :any,                 arm64_sequoia: "56b3831569d7b22d9194d4af5fcc3ad5f9d4eabd3751cacebead3ff45b6f3cee"
    sha256 cellar: :any,                 arm64_sonoma:  "83793fcf1f842cb335430289862178d0c151aa785089c8d663e7049529cbe073"
    sha256 cellar: :any,                 sonoma:        "58f05010899888e358c582e519f5588554e9a4abc6a4f1fd439b5c78da8a29fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb85b3c719aff6570f47fd4192951e50de21e73425d30734bd395a7297d2ee40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6867799febf98cf466f256adf3bc35c91fd51a59c68117ac9674ac09ac72c540"
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