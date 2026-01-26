class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://ghfast.top/https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.21.3.tar.gz"
  sha256 "36887a1a6c9065c6d9c6b79e77c083cb8c7cb49d50a49cfea4f2294ab3d18f02"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d970151d51b96fe02749061f204df3f6e7cfff55baea296c7adb816997c33291"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e5f13bce4828e85b0c34bb4182cb2d52cb1e82ac93a9dae711c028fedc13237"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "746bd3ed916f9715b300e6942c747a7e356338987bc5f4de834e8881c494ba35"
    sha256 cellar: :any_skip_relocation, sonoma:        "4013929c460933adf246539a17391ce3384d2c258b86d69a4fed44bbe5c163c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f4eb902263c9226ccb135159456028f69ba36e0fea6079f1ea982ec8db34aee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7af46932b311ca67b79c04ea41b50f9670463b4ab854d6569306c331424b493"
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