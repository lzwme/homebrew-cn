class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://ghfast.top/https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.21.6.tar.gz"
  sha256 "e1b755632f51290344083865465ac3bd84ad1e31e676479b50beddb096bcbf97"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37507ffba03bdd4f1837f7000609060b41dceb4a1f6f62041185b525cbb41fb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a30cc6f74bef1ce05ac4c56cf211d0e7f209328cdb7bc3357d13306ccab33c3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "022fbf83a045228cd5fa6167be1b8ef638c4af3e482b975f3f891d32928ef565"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba5c5787bbf261bea595240cad8c5d757607ba87df53148e49a3f9b63adaffe5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d82d97c362f225448990bbdf844e111d27f5a2267e1a88287a47ada5f09552cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39f9cb4ed1223617ad1e922708b13101fe3a4c4ceba9f4c9df44290608a15203"
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