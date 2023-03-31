class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://ghproxy.com/https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.16.5.tar.gz"
  sha256 "d5689640135dfbdc625b91a7319457b5096535bdf5b25fc4a65fe7ca1c740834"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8aaa67048e12ae91a862543f1265151fdc194a7a44cbdc309b07fd8f74161e40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6d7f367b20041d2e8170337157abc8413cf0e409ffbf57cab3f8cc453caf7b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e37e5e0e328cabc3f2592da17c1685c112ed5883fb6f9e7466363dcd73e45d12"
    sha256 cellar: :any_skip_relocation, ventura:        "d7bebc61304a94dd20ebd765cd53fa512c3b5391436ae8d63dae26a0170eb1aa"
    sha256 cellar: :any_skip_relocation, monterey:       "1c5b6ad889b20f11109ac1f996ea9da921aa7b6f310f6268351698876c01f8e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a7d460b69c907bfc93f8f55ed4b2fad07295a48cf23823d240dbfb93930cb55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "971095a132edd9cd6ac6107dfe147346be60e92ab714269db6c31710bbd2f569"
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