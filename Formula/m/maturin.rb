class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https:github.comPyO3maturin"
  url "https:github.comPyO3maturinarchiverefstagsv1.7.3.tar.gz"
  sha256 "5c5f6c521c14342446397013a16872399882d33a886e546abdbfac24ac0a7e99"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comPyO3maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2db0e975803cfbd04e12a7ee1ec7c3cd216bbdec103269c19f57c248a3e63511"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cbbd5b493557a4066e01f156c779754d0618bd5be36e21e63b215e5edd254cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4865eb4804249bff8d1524e0a05c266c12d0e3ff08726d2b3c340040d71b20a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "31b1f5e75be13911e390cb66d55f06df14cc2292e036dee45847c93433bc710a"
    sha256 cellar: :any_skip_relocation, ventura:       "e08d4da914f80379f29b45cca4a10a15ddb7187376f65d9d4ce9f049a8dc046b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60747ad4972ef80beacc0899807ef1d67b8c301d49db676ed3946b61b96d2289"
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