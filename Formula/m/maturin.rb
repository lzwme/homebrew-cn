class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https:github.comPyO3maturin"
  url "https:github.comPyO3maturinarchiverefstagsv1.7.2.tar.gz"
  sha256 "522e763a77830dd4251bafeb83f376a29e225a06fbe985ed14d98e3db0ecabd9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comPyO3maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a897198760d67c67fff40f0600caca6f067db3e8378af4a05d61dca670c20bec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c6c5de55405f0e8d6515ffcf38bcf36c8fe84c0f5c5f99b2af6e84b8afb7bf4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4103219d430c9521d33bfd376bf6b908b79693b5be8f4cd000ebadbd714ac073"
    sha256 cellar: :any_skip_relocation, sonoma:        "44b6aebc0f1f54aa588fe965a40e7493f06e8d8ba68a11ca4d7aef7aa71d2333"
    sha256 cellar: :any_skip_relocation, ventura:       "c4b803594c3344fa1c2a39d56041616238ae3ac0423697b2f06fac6d15670826"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b7fefa0af5552c258f91522a3ca36ab14e53b4e9676352af0c5b721272fca2c"
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