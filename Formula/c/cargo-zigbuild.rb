class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://ghproxy.com/https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.17.5.tar.gz"
  sha256 "bf59f406bf4d4e1069f38158c34322f5e328c9b84e4abfea91c3ec3aa53311b8"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f3f4be5126d939bd57a61ab32a91f4f3db6bad2f2265e281766cee57e41a8519"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "706760a3450893dd218f8f03b715d80c11c0bddb6ab2a09cbc2c7725ae4c3fba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "489481a437fb7de0003e52ee6b8271f56f0b090409bfd6821b6206bd90783d64"
    sha256 cellar: :any_skip_relocation, sonoma:         "e05516eeb8defb8712ebe3164e5f8c8cf114cc29236205e36c2994a1b8a13fa7"
    sha256 cellar: :any_skip_relocation, ventura:        "377c5d643eb08e07f9011c62326e91c8481f4a1cb38752c7f45f2fd9c50980ee"
    sha256 cellar: :any_skip_relocation, monterey:       "f56a3fa7f0dd9fd9ad928c1d6581933ffc8aa5d9d7e208ff995bf8b5a965ef53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3bb1784c206b702b5a314f0409c491a2c2dd5cda70a6b5f306a4d9a2d4a0a81"
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