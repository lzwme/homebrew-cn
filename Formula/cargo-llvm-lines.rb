class CargoLlvmLines < Formula
  desc "Count lines of LLVM IR per generic function"
  homepage "https://github.com/dtolnay/cargo-llvm-lines"
  url "https://ghproxy.com/https://github.com/dtolnay/cargo-llvm-lines/archive/0.4.28.tar.gz"
  sha256 "af3586435cf49d83ba4e9e93a68c8822cc290809f61b70742794f1686e4d7a05"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-llvm-lines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33215ee65797276fe174a24e0ebadb71218ff485201231df79a148a21e9421a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9850eba02f2c7e152cbaf1bf6d1063410142cad52e1e86958f77bc6f4e0063cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9d35fa7572612df764f50ec9437a8719679dfae284ec41c1e8502d8f5481eed"
    sha256 cellar: :any_skip_relocation, ventura:        "681ef8cec7b492417e8c6caf6df9c38b219a02bdef9a4d215991029fb96c06f3"
    sha256 cellar: :any_skip_relocation, monterey:       "03fdf1100e2f370e625a60cc54e9cdbd3b7d6c1e69db18cc557ff5c2a510d82c"
    sha256 cellar: :any_skip_relocation, big_sur:        "bfcf8d14ede230f35814968107545f693e4e6b59644adc5ea3b7dee1e7c07736"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1ce2550d1f67979a39f2f1ade1d1c4dec23c9b1e3fdac49f2fc552761def13e"
  end

  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      output = shell_output("cargo llvm-lines 2>&1")
      assert_match "core::ops::function::FnOnce::call_once", output
    end
  end
end