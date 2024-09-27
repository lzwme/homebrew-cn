class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https:github.comPyO3maturin"
  url "https:github.comPyO3maturinarchiverefstagsv1.7.4.tar.gz"
  sha256 "19edb033a7d744dd2b4722218d9db47dadb633948577f957b44d8c9b8eececc8"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comPyO3maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f866d1f6b4fc0e9f1be55093d529ac7e45cc2f07d0dbfa96b3150446d4f400e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9671a64c6824117eae415931162102de7833043f8b2c0e6bea9ed5b47447f01b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "12e29c5eda7e9f6efa17550b0bcc2f52fbb8a28082f6c809352f5e04e1ea7483"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3e5894034f8f1c0959f571b2da92a1061033c126de82cc15717a7c76558709c"
    sha256 cellar: :any_skip_relocation, ventura:       "bb87085f856c08d323fc1da920b200088326e8a3e3ad6a1c317147ded7d4958f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f19d212e350ea72f7f94db4a3a623b5e8fe32889755fedfc663f45346b96d15"
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