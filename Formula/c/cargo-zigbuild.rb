class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://ghproxy.com/https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.17.2.tar.gz"
  sha256 "50a5edadfaf5ce00472db1fff4d0abed3ea9ccc28d1ae24b782711206ab56539"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca73ef7407d32f58f2735455f5a29ef387e1d12e91cd568aae08c072f1bcf9f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a1cdbceea97253b4f3d4db60d683a933d7bf6cf6b78220c185c407f7f2ba557"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6f78ce2722ef3f9b3ae47b64cd05db1253612b3377ecf8e46c394235b08050b"
    sha256 cellar: :any_skip_relocation, ventura:        "f264c9584236b033ead7d2472f014a621508d1f475718fa51ff35c40be2df9e7"
    sha256 cellar: :any_skip_relocation, monterey:       "50a315d87b3c06f542c7059ada8beb2e55ed3027159aa0c65f0e0d73c305d304"
    sha256 cellar: :any_skip_relocation, big_sur:        "c53dbe5afa3e89817792f58e046378396f360db4f7aff9e3448d08e88f5057f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16eeede3237e98d9676ea10a9f48ef09dbc725e4da0f5509f779744d60ca8600"
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