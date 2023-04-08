class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://ghproxy.com/https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.16.6.tar.gz"
  sha256 "96a710f9a0368017e80294d96b457a2dc891da4ef2cdcfabfbd600804cab916f"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6166add9afff379f7dad02d31c54a0a246f835acea1353b559174ee2d4b92b62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdab78a6235859773c53d31c271733147a4e0cf1ae1713a25d2c5eef78653111"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0374f521970f0a23289c3cb557695269d20f1f6bd4a72ad5fdeaa5934751a82c"
    sha256 cellar: :any_skip_relocation, ventura:        "15089b31bdabd601a3855c6eeb019643d9fa1859710cb72b6d427b603c1f10ab"
    sha256 cellar: :any_skip_relocation, monterey:       "6fcce8eda6c649294619504cdb17721e7fb34226f06aa70a2bf34ef21598065e"
    sha256 cellar: :any_skip_relocation, big_sur:        "56c5c3fd6fc01bdd4e969277dae1a541cf5b4ea1f0aebf31ccafea015a6068d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ddf5c43bc437a2af396e807c5b95a79c592be7f9a317423f68a0fd6bfdf6136"
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