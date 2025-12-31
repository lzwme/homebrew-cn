class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://ghfast.top/https://github.com/PyO3/maturin/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "0e25b8931fd4b4d894c739fd61500cc79289ed10be907440013a7ffb6492ef78"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "16f6d8c9d31772b0797c85f46ceaf39e7878df29d634f2eb21790a0872329c9f"
    sha256 cellar: :any,                 arm64_sequoia: "5e7a56d998b5dbb179dec3d0bffd8ff2d6333e451438e81e2ece2ad91392125d"
    sha256 cellar: :any,                 arm64_sonoma:  "69649c0f6c0c344ffe6d2c6f22d0f80f9d471c0938ddd50990bfc8e94bf24f26"
    sha256 cellar: :any,                 sonoma:        "acfe5e1a90439d45a916e3bf00e3afa30c450e8214cf29382a827df443d93713"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0de1daf44c61c2595bd5983b48ac3fc1269378290ce7982e8fcd3282cb4f020f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "232bc53f201f93384da082dda060afcf03e2791acf8128d51d153fdf3e68812c"
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