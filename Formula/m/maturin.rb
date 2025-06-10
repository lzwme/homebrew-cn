class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https:github.comPyO3maturin"
  url "https:github.comPyO3maturinarchiverefstagsv1.8.7.tar.gz"
  sha256 "7fae57e8f14ea469c904f190774dd3c68a70fbc4c87b6a778b3e950e44cb8c24"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comPyO3maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e8bed0d4652c1aeafbfbfa8cb5e3201014a91c94ae01539d8c16e9dab7270e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19fd7ee33f51beaec3dd69e881eade9b9390f8bb445e179a1bb85612ca5ee675"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "43b1172b6379ebc165608d4c984ed8ab0ae2b08202e373219f120168175d4ebf"
    sha256 cellar: :any_skip_relocation, sonoma:        "eff5734ccd3956977cb1280db391ae26f5028be1832d3c3e0113210f6e84b7ba"
    sha256 cellar: :any_skip_relocation, ventura:       "d2f988f7b4cbc3219d4b0142849a7b9fbca3aa2afe8fb36596e78ff452b65840"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63f66ecbec4e6ce241e4f3b5dcc2ecc0d3e4c4a45093cff8e3dba6a246cc1b4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50fb25c2e867b69893c90835c3468b6b361ea9ec4804f6571f759b70993ee8e6"
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