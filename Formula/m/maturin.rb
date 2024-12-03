class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https:github.comPyO3maturin"
  url "https:github.comPyO3maturinarchiverefstagsv1.7.7.tar.gz"
  sha256 "791e471100076a555a53a1a76642b6cf1a7774f07cadefadd524d31cb8ae499d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comPyO3maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0eb24d2faba6bb78847d5414ba5670ee34f1334ce62dac0bc364217a21f30f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "983537f21f351fe5c12ecdb6099ffa4275501b565dd16df359bef899ea07234b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f2bc0fb26774ab63a4f63213da4d53bef3d550f9ec92a6825bd9ae3e3483326"
    sha256 cellar: :any_skip_relocation, sonoma:        "05ec20a6a9c1f6a4e32b6e1960f971214be9f43096f431326428c034283ad16b"
    sha256 cellar: :any_skip_relocation, ventura:       "90f1f0212aa82aa71838976db3e04b30bd877b0d95ef61f7001342cf77426c8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d1707d03de31b959e760196cc409e4d68241e18e4339480d966533d1a8a3ea1"
  end

  depends_on "python@3.13" => :test
  depends_on "rust"

  uses_from_macos "bzip2"

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    if DevelopmentTools.clang_build_version >= 1500
      ENV.remove "HOMEBREW_LIBRARY_PATHS",
                 recursive_dependencies.find { |d| d.name.match?(^llvm(@\d+)?$) }
                                       .to_formula
                                       .opt_lib
    end

    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin"maturin", "completions")

    python_versions = Formula.names.filter_map do |name|
      Version.new(name.delete_prefix("python@")) if name.start_with?("python@")
    end.sort

    newest_python = python_versions.pop
    newest_python_site_packages = lib"python#{newest_python}site-packages"
    newest_python_site_packages.install "maturin"

    python_versions.each do |pyver|
      (lib"python#{pyver}site-packages").install_symlink newest_python_site_packages"maturin"
    end
  end

  test do
    python = "python3.13"
    system "cargo", "init", "--name=brew", "--bin"
    system bin"maturin", "build", "-o", "dist", "--compatibility", "off"
    system python, "-m", "pip", "install", "brew", "--prefix=.dist", "--no-index", "--find-links=.dist"
    system python, "-c", "import maturin"
  end
end