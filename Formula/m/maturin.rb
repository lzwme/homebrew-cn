class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://ghfast.top/https://github.com/PyO3/maturin/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "b6932b3a20ea7091191844dc342811202e4ce5040948e3eb668acd2ef73d1d5e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "23269293df348780f98818a403e742e4b88e9eada999743d074eeb99704e7c06"
    sha256 cellar: :any,                 arm64_sequoia: "76123957aff5b30fbce9659dc533661789cd8b9528f02e0037170467b1207808"
    sha256 cellar: :any,                 arm64_sonoma:  "9e86aea63c9b3a16b4781d217f06c31c8d174e056d0302f794581e49ed68a133"
    sha256 cellar: :any,                 sonoma:        "a92e06e056b61ce94dd6c6c61cab546e1ae39c58cde84c83df26f56422c22baf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56165992402bb49a1ef995d6c919f2012c086e6e8c9f34e2a30a6c0b044174fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c322ae10b58c62b32eb6ecb48969a9135dccb56ea47eb2fb4023a43f9da4d0f6"
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