class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://ghfast.top/https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.21.2.tar.gz"
  sha256 "7e46e0c280659f5412eb797507c3b98936e1a775322d24e49afd6da9c4b0ca4d"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d65ecd79551b4758be501d5d5d3f997bd044d934198b0cb1ca76473912b6e58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1655e637d161c34009f075f5014b73cf99755f27a97ae944ba1cd7c67cc98b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0cf9b7664eab96d06645aefa97e66b67c196cf5db47fc5c08fc6ce4d529e606"
    sha256 cellar: :any_skip_relocation, sonoma:        "e28f12ecb15ba63c1cd40939d7b34d297c5f161d5135d30a33f0e79bd3020a2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38ecaa857feac37c2ad8ef36249e3c32155e3048a9a54724a30f8c4514cef0e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f2ad708f515127ecd986394073d85b42b623f57ff2cace3600c033091f1f472"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "zig"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Remove errant CPATH environment variable for `cargo zigbuild` test
    # https://github.com/ziglang/zig/issues/10377
    ENV.delete "CPATH"
    ENV.delete "RUSTFLAGS"

    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"
    system "rustup", "target", "add", "aarch64-unknown-linux-gnu"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      system "cargo", "zigbuild", "--target", "aarch64-unknown-linux-gnu"
    end
  end
end