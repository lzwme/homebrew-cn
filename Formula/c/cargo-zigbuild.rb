class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://ghproxy.com/https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.17.4.tar.gz"
  sha256 "e0a8611e699be8650b9a99e9e8206380906d00df913e623e19bfb381b4f861a8"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d078cb40f6abb7fafae98971f4346da01011b80a581fed6f8158ff8c8b40dc2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acd7a65f8c59ae36240c30ddc49bfceb322fcd0baec4b2401c2466a9e7494c2d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71ae95a283eb5b353113e750b524982df850692c426d300f81da711ab0d7a643"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c80b92740c584d6d573695e64646088d1cb392472779264c68d220fb65a55b7"
    sha256 cellar: :any_skip_relocation, ventura:        "5e01b38c30e700be71a63f2b539d417534fbcba7b1a24652a4478e5dda6597f1"
    sha256 cellar: :any_skip_relocation, monterey:       "4bc07e3f3b021f32927f59cd3b4279d4af4c7a50b93b5bce6dbd25b7d8df2c86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c304df87d9503c8089b04b65248409d3d0a998f4c624428b926af5c44cdc0883"
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