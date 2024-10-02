class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https:github.comPyO3maturin"
  url "https:github.comPyO3maturinarchiverefstagsv1.7.4.tar.gz"
  sha256 "19edb033a7d744dd2b4722218d9db47dadb633948577f957b44d8c9b8eececc8"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comPyO3maturin.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f049e9fb29588a84e7761c331c7c813845edae20bf70b189b4df3afa53804faf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60ad8a6c1eca60a3597a5afea87360a693a6edd346f66fd95e9bb592535303a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3eef48e3fe888774037cb2323c3a6d2ad903ba1e4818f80cb8526721f5ad4a50"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d24b16a836420944fadb3ce1846b69729a29a0840789339feb8e96bf4ff5ad8"
    sha256 cellar: :any_skip_relocation, ventura:       "4cbc3d48dfc37eacfdba5f4a18adc22348e26d18531eb31944e581e46b5a8327"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08049dfec24d8b8c8bccae9589a64c452817a902fea21255feaa202477146cea"
  end

  depends_on "python@3.12" => :test
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
    python = "python3.12"
    system "cargo", "init", "--name=brew", "--bin"
    system bin"maturin", "build", "-o", "dist", "--compatibility", "off"
    system python, "-m", "pip", "install", "brew", "--prefix=.dist", "--no-index", "--find-links=.dist"
    system python, "-c", "import maturin"
  end
end