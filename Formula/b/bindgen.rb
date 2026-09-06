class Bindgen < Formula
  desc "Automatically generates Rust FFI bindings to C (and some C++) libraries"
  homepage "https://rust-lang.github.io/rust-bindgen/"
  url "https://ghfast.top/https://github.com/rust-lang/rust-bindgen/archive/refs/tags/v0.73.1.tar.gz"
  sha256 "11d72970909c7b333eb6685054e7bbd36fd8892eab40ce3a93da06f066ed983d"
  license "BSD-3-Clause"
  head "https://github.com/rust-lang/rust-bindgen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4dff32b063aee03dbeb2d7b9f0ae6b9059cdaa3064abca04836e9a76529a434"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b250841334fbbe9dcd3a3159f4ec760ea1e9eac54428e4531603e862dccb934"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5150acf866424f3494df1bc534d5c024352d6b57d868ce718001b342797e5f98"
    sha256 cellar: :any,                 arm64_linux:   "10bacae0457afbc83e08fe7bca8d362c531d92e3dda258748ee977d2d83bb831"
    sha256 cellar: :any,                 x86_64_linux:  "3e0519d0941522fddea413e70178dd18f298a7460f8b45ce4f30530c34a98521"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" # for libclang

  def install
    system "cargo", "install", *std_cargo_args(path: "bindgen-cli")

    generate_completions_from_executable(bin/"bindgen", "--generate-shell-completions",
                                                        shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    (testpath/"cool.h").write <<~C
      typedef struct CoolStruct {
          int x;
          int y;
      } CoolStruct;

      void cool_function(int i, char c, CoolStruct* cs);
    C

    output = shell_output("#{bin}/bindgen cool.h")
    assert_match "pub struct CoolStruct", output

    assert_match version.to_s, shell_output("#{bin}/bindgen --version")
  end
end