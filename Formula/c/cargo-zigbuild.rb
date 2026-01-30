class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://ghfast.top/https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.21.5.tar.gz"
  sha256 "968a8d448041a7f28bc6e4c8045b1e96d9ce649abe620e67c558a851c26ebbeb"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ec38844221db2d317ca5d584dfe6e91d4b49b4da4654dee054cc0c0992bde51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffb3fc356db6430b9aad3adbcebb68e35db355b12277ccdf3f7ac58af0447b69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c99f4e28b6dedb9475321f77dc18529f38c235e3df5407bf554d5c10218348bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "da2292ef6e4ae78e71a8fae84b2ea0ff0a47895ac217f579b777a1342329551a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bebbdb2a45554afdffdbf52a5bf5d3b3da17d0e8b7b6c047a24ce607a85802db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "640c55eb3cacfdcda8e6652f8dae0f62ae93b5a2e2d935986d5a0963e59c76b5"
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