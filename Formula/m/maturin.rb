class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://ghfast.top/https://github.com/PyO3/maturin/archive/refs/tags/v1.12.5.tar.gz"
  sha256 "b7f5fa2e24cc31d0da07a9b9a666f76374175a05fe7d80b99c48652fdb218b5b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "695631fd55b2fd0391498aa2996c2ed17e4d88e86ebc19c3f740474855678d4a"
    sha256 cellar: :any,                 arm64_sequoia: "8c2ea0a72b766bb53e78875987c2716aa63fa737f58596bde2f01687d8836760"
    sha256 cellar: :any,                 arm64_sonoma:  "4312ef4c233b1e8d2588adfd4658147688e6ecf5b981053ed14ab10f6d3f0b5a"
    sha256 cellar: :any,                 sonoma:        "e666a5bfa4675608265a3230bf1b69054536a5dd8f507b601d7e5bff666944fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12ab6bb1f6f8c9315efcd124c6a465d48f2b24780297ca8ad8567670bb51bb87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "955cd287a56a71d78d087a0526ef765e91a645e669035958e0b34d4e65914b70"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => [:build, :test]
  depends_on "python@3.14" => :test
  depends_on "xz"

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    if DevelopmentTools.clang_build_version >= 1500
      ENV.remove "HOMEBREW_LIBRARY_PATHS",
                 recursive_dependencies.find { |d| d.name.match?(/^llvm(@\d+)?$/) }
                                       .to_formula
                                       .opt_lib
    end

    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"maturin", "completions")

    python_versions = Formula.names.filter_map do |name|
      Version.new(name.delete_prefix("python@")) if name.start_with?("python@")
    end.sort

    newest_python = python_versions.pop
    newest_python_site_packages = lib/"python#{newest_python}/site-packages"
    newest_python_site_packages.install "maturin"

    python_versions.each do |pyver|
      (lib/"python#{pyver}/site-packages/maturin").install_symlink (newest_python_site_packages/"maturin").children
    end
  end

  test do
    python3 = "python3.14"
    system "cargo", "init", "--name=brew", "--bin"
    system bin/"maturin", "build", "-o", "dist", "--compatibility", "off"
    system python3, "-m", "pip", "install", "brew", "--prefix=./dist", "--no-index", "--find-links=./dist"
    system python3, "-c", "import maturin"
  end
end