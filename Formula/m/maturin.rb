class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https:github.comPyO3maturin"
  url "https:github.comPyO3maturinarchiverefstagsv1.8.5.tar.gz"
  sha256 "4511c34d4a362ba27aaf95b711f371e06e742b4a0d4e31f6e0c0243af636b07a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comPyO3maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45023642be0bdbeebd2ccb366854671a22f4c48f062e761819db133c0f484a58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a3163f46427caf116fea34298c29a01826a8a128f85e87db16a96b625c819d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4468f591de327b6a1d2cd9b85066cb9bb018510c32dcf894b2bbf3bbfc202917"
    sha256 cellar: :any_skip_relocation, sonoma:        "96e60903db8132db5caea8c8d23e71cee848561a9b4afe3dfc912b58f223c30f"
    sha256 cellar: :any_skip_relocation, ventura:       "e12da1af1f31873a5412d56a437bc57cc9205cb2285ae510b76d99b085523946"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4bcce8890749e3f37bf3658b14ff428e6d1c7700b8f49da87f171208656e5a41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18e142ff49fe39aa3a7cf5cbdf44b146c650f1954724421e298e9c12a8f5dad7"
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