class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://ghfast.top/https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.21.8.tar.gz"
  sha256 "fb83f29fa12622a72cc56de97f7b8c27a2d3081ab9174062761bb84ed00e367a"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77383f2a5d261215b6bd64087b00fc58f976c92f1429173a1149ff08dfdf0272"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e1f6887718e8523f886b4411cf7e047344bef8aefc6bde23292e23e9da1708c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d835d4d0f6069d25a72d467fbf9dd149daecf2d20515bf4bd20d11736371e366"
    sha256 cellar: :any_skip_relocation, sonoma:        "e24b5a220478f905e5d86be2cd598baf95300b668a224e169265599fefdc296c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75d40dbea0a00401afe61400e09ffb7df60b2784a856ca5ae9a9cd2de65eea2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a44f4eb99926fdd9ccabf37abaf632904f0a7c31c4968f2e088187575aed3b7"
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