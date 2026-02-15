class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://ghfast.top/https://github.com/PyO3/maturin/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "ac941d96712ff95cb1b3b1aeb701359e5bdb16f24f1e9aa588e6e2d25d6bf927"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9f1c035194dd0169e060898bb44143d43d8ed8aa0942974fa3e116d5c090cd00"
    sha256 cellar: :any,                 arm64_sequoia: "05b660d54076a394c3a6956b3800a8a2a4abf4df5d741ba0e27249694e685987"
    sha256 cellar: :any,                 arm64_sonoma:  "4ba9b2b769ce89436a8fc21e80f447feef83bd3f3b976555a3e49d7d8ff35246"
    sha256 cellar: :any,                 sonoma:        "140878a027fab98975d4c981f474ddadce879c6fdc83b96e6df63ece3044d4e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6416f45082e8774b64bc673e49ad2941b0305a423531f03909360a8139990cc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c499fbff7403853dc00b6099b832ef38050a526b46864f5040a6a3cc594a351"
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