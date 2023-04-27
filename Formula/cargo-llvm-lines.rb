class CargoLlvmLines < Formula
  desc "Count lines of LLVM IR per generic function"
  homepage "https://github.com/dtolnay/cargo-llvm-lines"
  url "https://ghproxy.com/https://github.com/dtolnay/cargo-llvm-lines/archive/0.4.27.tar.gz"
  sha256 "7012cec8ea832e1c9f1fedee5d4fc766a5ee9e54c8dd94298a10a21b371a6f1a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-llvm-lines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "434a97ba164c20ef532a2c5302a3375d06fc367eb99a5b9f3b2a5b57ddc05f5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c5e30bf927ff37a4a64ecfb3dda37c993dcb8e769eb792c646f4040ca9eeeae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a389ca084b63408ce7c30e7396f62a5ad62db7496906259c6cd19fa81a2e9a6b"
    sha256 cellar: :any_skip_relocation, ventura:        "43eec4563c876c7e800b729a9ae80e2d367b6b1412ceeeca988382d46423091f"
    sha256 cellar: :any_skip_relocation, monterey:       "77da603024caae4b78f42331a6aec4c0516ef1fa687efa4eee801dbb007bfc37"
    sha256 cellar: :any_skip_relocation, big_sur:        "b674c8a83320a246ce457b82cf376a0d95c0267045b31db9d9446355fff1976c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c6616af2bffae5d8b70e653c16333cf9c4d3f44e2d2f9521d586383041c25de"
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