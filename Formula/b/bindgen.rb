class Bindgen < Formula
  desc "Automatically generates Rust FFI bindings to C (and some C++) libraries"
  homepage "https:rust-lang.github.iorust-bindgen"
  url "https:github.comrust-langrust-bindgenarchiverefstagsv0.69.1.tar.gz"
  sha256 "c10e2806786fb75f05ef32f3f03f4cb7e37bb8e06be5a4a0e95f974fdc567d87"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b2f91ae5ac5cc1cc501ed57b06560e92b1a49c9a4fb2d9282e462d4561a88af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ec048845fe908f93ad2fcdfb9b2743fd74f54d01454022710089d29a0f23a43"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a12b56c7799cc59fdc14ced387941bb0a16c5ea507e7b70a5851bb4bbbf50c07"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb3a10cf1599b349740d7ef9d44531f4f924a9c38e4f6c892c20fb0ba08b3777"
    sha256 cellar: :any_skip_relocation, ventura:        "51e960cd4288b62486904079985fefff78e0f9da8cdd7efd0e96abf9f5413d7a"
    sha256 cellar: :any_skip_relocation, monterey:       "ad8e603013e5bdc292dfa4041cd0ee9cfd9d5e829440ba66623fe9f4591e25fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04ace3a3a6ab513966a31ff8d507bae2ccd1f211de85dfe6a4b1caa5a8d6480d"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" # for libclang

  def install
    system "cargo", "install", *std_cargo_args(path: "bindgen-cli")
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
  end
end