class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https:github.comPyO3maturin"
  url "https:github.comPyO3maturinarchiverefstagsv1.9.0.tar.gz"
  sha256 "84a74988960a19f4e6ffa6f3a349803403496ced10dd3ff83baf4feed88c3fd8"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comPyO3maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "762d234ff9e69a35cd8c66531e1e43d556f5b373ff31964e6140ac4642b776e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2b3b03e06267c82096fe863345ec6e769bba61b2238de037c10c1c7b43440c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da19a2082cf98ec7f3865b77feb0ec84df8c5643e8e2d808cbdb09e676ef7c5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e8e5aa807eed77ce9a82debff5449dd1aedd5c24659bed238e47d1bd8a26b40"
    sha256 cellar: :any_skip_relocation, ventura:       "63a08bc68cca44182bf96659e5b8b1f6af72d467f076baf1d4c0a67727d7db60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6127227899ac597e337d1b353ce9cbce8f0d4f6ad3f86db8d9fc337dd429d1ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d824ad4f36121c93ccf6ddd849dca6fdad145ec7e9449b52136c148178c920d6"
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
      (lib"python#{pyver}site-packagesmaturin").install_symlink (newest_python_site_packages"maturin").children
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