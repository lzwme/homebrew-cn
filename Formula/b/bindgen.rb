class Bindgen < Formula
  desc "Automatically generates Rust FFI bindings to C (and some C++) libraries"
  homepage "https:rust-lang.github.iorust-bindgen"
  url "https:github.comrust-langrust-bindgenarchiverefstagsv0.69.2.tar.gz"
  sha256 "78fbb8bd100e145d1effc982eaab21b555ccc3fc1cbe6e734f17cdfe5c33af32"
  license "BSD-3-Clause"
  head "https:github.comrust-langrust-bindgen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b20caf714363dded3cea6bbe50925778daecdb7d599eb30f72b5a1221b08efab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46b45dd201f17c6f20b33b1d185baf7300abe03c0f4ac144d1dbc4b7f9b8487f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3b463ad8b01d7517d04dc883e2435eee97b5530a9952fddcd5575ba7e0c74e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "1138a4838572c40f702bb0757dc32e6c79ee4e4628a0ec3f0711e3656c82ac87"
    sha256 cellar: :any_skip_relocation, ventura:        "2b5db616c128a2b160a7f34a527b8e735e0fdb5a8d3300829e0fd2bd8c93cb25"
    sha256 cellar: :any_skip_relocation, monterey:       "c5bde98fe299d17842f76ad388054b362aab3fbbfc21a695d9e99cf33645007c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58b0d0644ffe4dd6a688c40d57d23e6bb6efffbfacb2f9e0a8574b3ecb42f3df"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" # for libclang

  def install
    system "cargo", "install", *std_cargo_args(path: "bindgen-cli")

    generate_completions_from_executable(bin"bindgen", "--generate-shell-completions")
  end

  test do
    (testpath"cool.h").write <<~EOS
      typedef struct CoolStruct {
          int x;
          int y;
      } CoolStruct;

      void cool_function(int i, char c, CoolStruct* cs);
    EOS

    output = shell_output("#{bin}bindgen cool.h")
    assert_match "pub struct CoolStruct", output

    assert_match version.to_s, shell_output("#{bin}bindgen --version")
  end
end