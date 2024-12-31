class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https:github.comPyO3maturin"
  url "https:github.comPyO3maturinarchiverefstagsv1.8.1.tar.gz"
  sha256 "8ddaf1655509ae079406635654cbc0c73d622e7c2a537f2465a83e8021dd0cc4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comPyO3maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "801242f1efb4fbf7292fb8c6f85d231656aed389f714e980317af9bb43beb637"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b3c1d29c8e7faf4f0e37e5a5f3bc036667eefa055c85adc48de3727aac50537"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "559878ad61e991022d66beff777d1d797ba07a31700156f9be59e5d267fe9ab7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b87b83851d8fc3d68369212fd0e66a22e112c8ddd3d7f513112e555826792cea"
    sha256 cellar: :any_skip_relocation, ventura:       "1e64f075a7bc91c8c96e89d474e3793751ffc9d1a43564f79a28b12e3eadac08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb7f7e1fea18ba95a20433f193a4a5ca298146e60403152c0897954834131e1b"
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