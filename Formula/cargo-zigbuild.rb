class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://ghproxy.com/https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.16.8.tar.gz"
  sha256 "fd7dbc78cd16a5e4fa6bb9e4af398fc54eef889044f463b601c083adcf0ac960"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "162378146cf4c3539922f7ec4d29434e63cbeb3362803876d1c9b5cf6e9e54c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fa1852738261432059bf7e97db46f1b1a9fac9edb96219998be9e95fd641c90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "682011b487241c21efca70d6afaf0b1a2257b98e671e4ad5d72199cbfee02db7"
    sha256 cellar: :any_skip_relocation, ventura:        "4f0978def495d0195884a55cc6c215d1a15595184e5d69819d6c4311ec0b4198"
    sha256 cellar: :any_skip_relocation, monterey:       "1b4e6f3ed8daa59f3de7048bb032151b743e7abdaacd08ce17438e79114d6a59"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa2474fcbf0167732e068c65d3c7eb4ef8a378e954a8eb9c841c1231ef5e345a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed3ed8adc4fa479cbab38046a77165bead3aba57a8fcda16e95ab38321fe7cae"
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