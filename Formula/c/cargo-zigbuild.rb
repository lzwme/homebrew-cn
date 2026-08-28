class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://ghfast.top/https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.23.3.tar.gz"
  sha256 "867c9fc9dde1941711afdfc38ae6a31edcce029921d8bd8a9f40f620e5efc524"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f8da51a8d64d0782c28ece9f545c20083bfed5e7b87fe4b344eec3d1c8d07ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebcf4a4bbad2508587721e889f1a35a417d5a9d099f849b40bd86f532b5efccd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43549df8829724e8207726c73c11c777762e68613bdc4e8596b07369de4cc1a8"
    sha256 cellar: :any,                 arm64_linux:   "7f458d0f606da921d1e9e9d1e5a133266fc0941e94de4d8c32eaee493f37341f"
    sha256 cellar: :any,                 x86_64_linux:  "68109d76b23c50f34a738f25d2712d08e07741eb9fa10d48ccc6edaa0175ba27"
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