class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://ghfast.top/https://github.com/PyO3/maturin/archive/refs/tags/v1.9.6.tar.gz"
  sha256 "c8aef8af6cd3d5b3331191b21191ec92d7b4ee0633e0799351a01af1c5ea2a6c"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bfad0a52d95ceaa44e11a68c7d91419d99c2b3134ae625ef5203df1c88baaead"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69292168f5341738f5053f7848dfd119bc1fd9584e59e5272a7f68610f7a7910"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2e8ed88a6fd3d052c70d655196e92caf6152e0a505e6df57f3c8a0b8fbad9a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa959075643bfe9543fc8b958df94ac91b10f45980e5d19e7b59bb9708df4b1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a806bfb45bdcfee73ce731737da4376aa46830fec143869c2b9275ad09a0ada"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7b59ae95664ffb80a761fd3f1c30235e71ab48890883b5cf13d4e9bc711dc42"
  end

  depends_on "python@3.14" => :test
  depends_on "rust"

  uses_from_macos "bzip2"
  uses_from_macos "xz"

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