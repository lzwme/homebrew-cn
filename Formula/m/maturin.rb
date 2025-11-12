class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://ghfast.top/https://github.com/PyO3/maturin/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "d7ed8faa68f2b20ecd18f82d2ba96b85ad7ad0b4d93bef3b84a87cc9be00ac64"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a2ec490ee65c80b50cf80991e377d145c525a1d88fc9637f3acfe346b1fee1b1"
    sha256 cellar: :any,                 arm64_sequoia: "dfabfe2870956b38f5c590a15524ec7d5d66dc6b006129704e7020301f1b0f56"
    sha256 cellar: :any,                 arm64_sonoma:  "faedd15c8e5a78d016b6dbea216987789b4c019d74198414e88eeb5e81f8a776"
    sha256 cellar: :any,                 sonoma:        "0e0110d8cdc5dbd2bdec6606bd84ee3932ee850bf654f266a4d8f6819adad814"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fabfa346a6772185658412cb9d7723902dd5f7ef56d2d4cceb6c6acc4af600ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "403e7125370909c268ccc8e17b6bb9c05046f4164336abc1af4fce070a74c6d0"
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