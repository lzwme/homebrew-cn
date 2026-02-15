class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://ghfast.top/https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "5e47aedd4d77eee92995a0a9e9aaa945c3f75e502ac5a1f624c111bdbf87b129"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8239ce19f991bce880a25e3cfd6efcc71c98e0bec08ba8a08be6612686b01a8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70f9fc4095dfb23f44566bd225aebcb2edce019117e28ba4662bacf89e215c92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58ad13f8509b3021a5fde2259288976ad54ed152dd854369f5035a3c822b8309"
    sha256 cellar: :any_skip_relocation, sonoma:        "c69acc13ebb79ae8ff63d0badf3a262c647ca6f7229d283944eb2ccd4f127be9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22323755e6c899d917c2a8c2c9fb2a8cbb09e7668d238389906466ef17b42b95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "821ed85fb07643fc408bca65935107b3df602a0d76164d77e443681e95cc1a13"
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