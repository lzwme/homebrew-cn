class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https:github.comPyO3maturin"
  url "https:github.comPyO3maturinarchiverefstagsv1.7.1.tar.gz"
  sha256 "40259109a3d941237db3dff2f34c5e953904de86410e516c098f824d6160109b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comPyO3maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7789fcba4232c7a79638aefb1d6b51dc13b71ce60b5b5df4422d0d4260633e72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f81fc6199f5d227c4e383a1a3c02dc17124fd335295192e453b83175cbe30853"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91dd42b9a1744ff2255a57c14ea8310804b01e4ab3fbf9e730ce11d082a56933"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56958180cb1b895f95d15a4c5fd57d872bb1abbf1e8072598db57625b0a055bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff3f1b9be9e2413f988479e71803d51274d96c67beb30d26d8189201ee128ef4"
    sha256 cellar: :any_skip_relocation, ventura:        "bc97b823c8d86fdfecc3d7d756f084b0df911649484dc82774831af8b9c4487e"
    sha256 cellar: :any_skip_relocation, monterey:       "32f227193f90f81823b1a549f89edb4e47f53ddd73674ae0a6221712eb14dc30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a09ffc0d393a43b242e74f6a96bc0ed1b696011586fe29ccf432eef72f25c208"
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
  end

  test do
    system "cargo", "init", "--name=brew", "--bin"
    system bin"maturin", "build", "-o", "dist", "--compatibility", "off"
    system "python3.12", "-m", "pip", "install", "brew", "--prefix=.dist", "--no-index", "--find-links=.dist"
  end
end