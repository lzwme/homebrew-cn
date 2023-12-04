class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://ghproxy.com/https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "2fbd69ebfc30925ccf5e7003900ad14b21fc0469b9e084827851a506900cc056"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "70cfee1c577db79bf1aec06a30591936323d6192d48e768d8517bd4bd51884d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c1c4bbfc6a912b0b63e99902b31d71e9bc163f8d2e7f234ebe48b70dae01acb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d314a5b4c2b5409fd6684a560db8a3be2420df6ccf4eba00dc227a91d8c82729"
    sha256 cellar: :any_skip_relocation, sonoma:         "88233b62762cd6a02ca6f8f6646157d6ca71bfcd0047cb0ae318714606678c69"
    sha256 cellar: :any_skip_relocation, ventura:        "2075bf9e52a1ba5a90e5e2c9752f9234a5572e68d8829328c9177e28bebe5cd4"
    sha256 cellar: :any_skip_relocation, monterey:       "dcfc100217d80f6901f79d60d10c4be162d457b0ebc68ac4d8cd977b505533b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3d54eabc9395e94784ae776a314c8670ac92fb8aa5905505b86ba60974167bf"
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