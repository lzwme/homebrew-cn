class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https:github.comPyO3maturin"
  url "https:github.comPyO3maturinarchiverefstagsv1.7.8.tar.gz"
  sha256 "ba17ef703c501613cf561e889ce10aa09f8caa475a34155584fa15a5315b344c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comPyO3maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f95371d69fca9103c48459ef74723638519dbe94ef1078c4bedf13ab8c580ca1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8b1f972077f5dc1c0993da2798b43ad48e1e4cc50cf511d0c858f4bb3a8bebc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe837ef5a1d7963fec6f5966e7a6fa3eed577bd57826522d26f626e95fd95cbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "89db0cd205739216b7bc252f43f595d12bb3f1709d8447bda17a047f7fb074ce"
    sha256 cellar: :any_skip_relocation, ventura:       "674e9fef96d7520819a3576ac029bf970e814570875840c4635fc0d1f6537c9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ef28487cd888a49f24e98f3e4ccaec68ac79893fc9cdff6194cc13bba7b2aae"
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