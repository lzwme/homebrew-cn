class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://ghfast.top/https://github.com/PyO3/maturin/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "057c77b31a1d3058cfc5a8e2203d802c5727d7ffcdf806df37cb2bf6240fd908"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f693ee2ac677faf8368c7cc23ebc32c2205f81e3b16bd67a7fbfb9edb5ffe3a5"
    sha256 cellar: :any,                 arm64_sequoia: "43891f013f6781ec40a46457b4e1f9d3daff32d67296c3189d55cfd49bfcd527"
    sha256 cellar: :any,                 arm64_sonoma:  "0c00489fd8abbc36a089dae6d5a9bbcee5232f335a19c5641015a372675ac9f2"
    sha256 cellar: :any,                 sonoma:        "f5c5156b12bc7f38383304638d9ffe5e9960d2cac1f47b73d3cb5aee55667685"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e7b11721be6853d6fd6186046cbf3b78264a182771c6e242287752e50c4b035"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6328c58f098644b28d76adf4a8e7cfe8250003e6d3def28a33df85dc6b1bbaa7"
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
    system "cargo", "init", "homebrew", "--name=brew", "--bin"
    cd "homebrew" do
      system bin/"maturin", "build", "-o", "dist", "--compatibility", "off"
      system python3, "-m", "pip", "install", "brew", "--prefix=./dist", "--no-index", "--find-links=./dist"
      system python3, "-c", "import maturin"
    end
  end
end