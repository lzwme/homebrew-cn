class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https:github.comPyO3maturin"
  url "https:github.comPyO3maturinarchiverefstagsv1.7.5.tar.gz"
  sha256 "e0c82ba54e5b410c9641db653581b995f6ec9f7a44e10a2cc6a8f75ce3797c2a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comPyO3maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88a63869f72b1cbd552701d989c8cde7d51cd4503f955eb86797c11b0f3f8915"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f7413a1ce352bb4e4b81dfdf70487d6992a2de95f2ffffae8d7aa7c37c9cb0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "01e725dec32794803ac57634a124594c87ed17841442fd1018e1e2a64deec27f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4ff50c642e37e53281cf8ce3d28674d8c33e86a4d86208d16839be998aa8a6b"
    sha256 cellar: :any_skip_relocation, ventura:       "d34147513268f169d81367fbe81c66b7b297bb9385a2a1662b13b6459f103432"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe45f423c8110066bff523e78fe5898b43b7ad9fa6666a23dc447d22dab02095"
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