class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://ghfast.top/https://github.com/PyO3/maturin/archive/refs/tags/v1.9.6.tar.gz"
  sha256 "c8aef8af6cd3d5b3331191b21191ec92d7b4ee0633e0799351a01af1c5ea2a6c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2c9b828a4167fc766732f43dad062accd023f2996894de7499be4f39ee5cd47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e69b5f8ad86b655ef94449b9b55aa4835993d7382db7f6e68c4a91bb0a94138"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c63ce9e0b75363ded7f7340ba85ac9e30a15d895dd992ddf6aa93c1dd0e4b66e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8901c0238b3cf32c588e2dab70f7c719f6743ad0ce4d4a40a2623d0c5e018a33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58d77e99998d4fa0b03ccd2852415f58486cbc3c103a44359e2616178f8d5df9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "709f2ff8786982d0fddfbe2558d3b218a1a9838022869f9b981679078f47e57b"
  end

  depends_on "python@3.13" => :test
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
    python = "python3.13"
    system "cargo", "init", "--name=brew", "--bin"
    system bin/"maturin", "build", "-o", "dist", "--compatibility", "off"
    system python, "-m", "pip", "install", "brew", "--prefix=./dist", "--no-index", "--find-links=./dist"
    system python, "-c", "import maturin"
  end
end