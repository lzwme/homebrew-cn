class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://ghfast.top/https://github.com/PyO3/maturin/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "ff8f7486f41e23afe305530e10a2c0804ea841151203340505e07d9ea5b74c7b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a717512dfd6c3961e657d8f1d8acdce272d2684d0a22f2c72b7764a4dbc6e22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "956f691e31c54b36969b9f442e915d2bc1c0414fd2d65160f03ee01705656fd3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae36f25142892e7815b6c291272e36675a5fb6ecc0f8029eb1543d67edef3e48"
    sha256 cellar: :any_skip_relocation, sonoma:        "975599172c0c2d5740bdf0451436a739bcbfca06bc2377cdc6541477b3e72047"
    sha256 cellar: :any_skip_relocation, ventura:       "5d69aae33d4dfc922f7d927c219a0077609a177533621b5a0aa8d282531a1b6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "383bbef03fec6a361efa09f7902ed81b4a7695c07462e276502321299391ca2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc55e929ab4f80fd3bfb2b2270ce1604b85a1bd485217e5eb4870c71a1c03b84"
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