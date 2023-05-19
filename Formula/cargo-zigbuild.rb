class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://ghproxy.com/https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.16.9.tar.gz"
  sha256 "a63555dc93997320fbcb4bca0baa5fb0166601688fcb2bb5016e727fc7a98cad"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "735860032c041e249d26cab0c915f551ea5934ede6ab001100575bbac75395a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef0425c444d33a0f3bff205185dec882833ae19e04d287ceca820cdbd5e49a4b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9836f37ebd66db4066c48faa48f1cfd553fe47f286ae2aea5dde51a3cd77bf83"
    sha256 cellar: :any_skip_relocation, ventura:        "3a2844b01da9ba91ad4bb653932b6e271d2ddcee9a231078bfc5d7cc01f25643"
    sha256 cellar: :any_skip_relocation, monterey:       "22706d2c714f25ac73848bfc34e0ecca7a0906099ecc8ed16d1c555544d317fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a58518a8d790c49d0a83849f522dcf117c2ed37857eabc1595c6e8a799143a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15ad2395e19c9523f562d7d8ef58425431b4eec8922ec7f2c1ee4a12c95421ce"
  end

  depends_on "rustup-init" => :test
  depends_on "rust"
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