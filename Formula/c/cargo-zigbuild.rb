class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://ghfast.top/https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.21.4.tar.gz"
  sha256 "afa34e881ad340d2f0fb8466756471968655a70625796abb05688e4482772d39"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4241bf24f93dea8b785b62512df8b2808c150134e1ddfe789085d4c8b945ccb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e41e944338dcd2dbf509e3caa1e32d852d421f5626c262ca2d7e23004782bf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c7fbcf756f1ea1be4a813df66b4dd5604e3be8656d413b2b25c3eb44baedd14"
    sha256 cellar: :any_skip_relocation, sonoma:        "305dd4b15e6a88a3a0bb16f00553761fc1d5de6e1463793072c4f0321998d581"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5fb283a0f5827f41fba57594d97b2e87ee2f31c0f5a763cab68a55692ba3739"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "978cf4473db36ecf9f42abb6a3c3be07dfea002273d3b7c88bb5d7498aaebba6"
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