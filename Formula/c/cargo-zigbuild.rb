class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://ghproxy.com/https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.16.12.tar.gz"
  sha256 "1cb8253043d5c9acd0b12fa98fc30dc7970fa07240a9014dc8f9dc87742e19c8"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ffe372bf9e4aef74d6df6d0cb4d13fe2b7c1b11bacbcf6dbea68461621bdc45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80c3c0fa04a00843ac8018764b925468ee44bc04f0b4c95b419bc7fb7250b48c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d82133d878a4f47cfd6004bc898f73ec161f1273160efb9f80b46a0ce7b56f8c"
    sha256 cellar: :any_skip_relocation, ventura:        "5ca796a46576696791794fe6bd1b23b98f17838359b6635e5048104f7c3cc0c8"
    sha256 cellar: :any_skip_relocation, monterey:       "acbd073492493dfb4ea3248f2e83fa2f01cb0563d4b98ac497f90d77dafde9bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "826455cc9fb5ed9e7a83c6bcff0124762c370f5405da54e7504e4c82b1a7302f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d281d463fcd4d2172f25ffd931064b7ea7dc0a13ac5aca3bcd4bb7b66a042ec"
  end

  depends_on "rust" => :build
  depends_on "rustup-init" => :test
  depends_on "zig"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Ignore rust installation path check
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    # Remove errant CPATH environment variable for `cargo zigbuild` test
    # https://github.com/ziglang/zig/issues/10377
    ENV.delete "CPATH"

    system "#{Formula["rustup-init"].bin}/rustup-init", "-y", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    system "rustup", "target", "add", "aarch64-unknown-linux-gnu"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      system "cargo", "zigbuild", "--target", "aarch64-unknown-linux-gnu.2.17"
    end
  end
end