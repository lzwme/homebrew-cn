class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://ghfast.top/https://github.com/PyO3/maturin/archive/refs/tags/v1.11.4.tar.gz"
  sha256 "50aff01e366b4938f6021add0ee5f5a0a4d43f0209bbf099f35bf5dac4f4dfe2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "67e959ed7da88afe4b1fe29c17c6f5d3869a09719a7d3c41955ed4ef450bebd8"
    sha256 cellar: :any,                 arm64_sequoia: "0c466ea79c9595e0d8903c05aca0b93f32cdb0aad8841a9de5988e81b08c6479"
    sha256 cellar: :any,                 arm64_sonoma:  "06a2f0c322123ec142c8005f9a888bdeb8dc5e3a99be49c572e6f1369918e7d1"
    sha256 cellar: :any,                 sonoma:        "9fce33f67e1b820f504da39008b0766dd05ceeefc277c29360f82616f91d8cb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "913413f9a1c20bc29905a3663544f736c51e786b940e5eb956e6c892fdcd8a15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "299b8517500a49c33a5afa8ac2bd0526d50d5f65c5dc1c76e2c588188c89be0d"
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