class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://ghfast.top/https://github.com/PyO3/maturin/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "1a4a87224a34a97a4322bd123487e9c6f2d2091bac4fe469618b92a06aad3492"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "167fc20fe026592a3bbf691368c8bdfa14b92b36e7a3a0c831d22d0a874b3617"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6848a0a557b81670966d540cf64633b86b7f105eff71421760d1e2ecad9c45d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "637cc95dfdf2e00bd137811329b7dbae22105dff161480c3c09a7e07bce09f18"
    sha256 cellar: :any_skip_relocation, sonoma:        "345a0efce57486cb052cf37cfbab8176f6e1e17fd42511fa0042807c5023657a"
    sha256 cellar: :any_skip_relocation, ventura:       "b2dcce819e3dccbafeb4a6d2d50c056ce5a2e7a77e727d9c843cd5b5eff22a27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "898214620bb2b6fc8f89b495713d502b1a55c838b4be2fa06f50274266a7569e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f4cff8233f2980f4e3e17a6bdfb13dd39b85fef9398ba8f29e3673143a5e4a7"
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