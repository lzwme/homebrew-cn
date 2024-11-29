class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https:github.comPyO3maturin"
  url "https:github.comPyO3maturinarchiverefstagsv1.7.6.tar.gz"
  sha256 "97fbd90108886776441eccbc44b92d5804cc6e8261fd8c03758c210c7f759320"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comPyO3maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5784fbd684ee35fc8ae2641d2adee25bdb67d02df2aa39ed4f3bc801a8ceaf0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "772c217c599e6f41abf5956a4965ba7b43d9c5ed5c89ffcca80a0c24664794c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c2439388c570370f0390c5ba47ba35fe336f6e043c521d2d74d159fd81b87d50"
    sha256 cellar: :any_skip_relocation, sonoma:        "039cfbdfc091143106abb9a978c9fde1f7d01513ed175db694630f1872e2211f"
    sha256 cellar: :any_skip_relocation, ventura:       "9d30cfbd74f2199893e3a050c3d39bf3adfcce241b1ed00e676ec3cc6b026586"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c8e062d673a83a428da9fe2aec16441c3aa38b9ec9d9a9bf37fd577baa4124f"
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