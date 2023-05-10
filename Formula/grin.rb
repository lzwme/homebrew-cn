class Grin < Formula
  desc "Minimal implementation of the Mimblewimble protocol"
  homepage "https://grin.mw/"
  # TODO: remove the `cargo update` line when this is next updated (5.2.x).
  url "https://ghproxy.com/https://github.com/mimblewimble/grin/archive/v5.1.2.tar.gz"
  sha256 "a4856335d88630e742b75e877f1217d7c9180b89f030d2e1d1c780c0f8cc475c"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1fab9195a99a295a16188c052518879bd5dadedc2ebcbd8c320ed498facf1f28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6401984d8253b18d9b6ddb50d7804d53e77df627b97430a4dc7403f24e8ee2de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e85a55594c77f1a6864064b8764221e543b679b673adab978e586c21945bee4b"
    sha256 cellar: :any_skip_relocation, ventura:        "33b88a2920ae853a8945fb31b60fb913b729618811a1ed2059bf34ac862011fa"
    sha256 cellar: :any_skip_relocation, monterey:       "379a7ae7790a3e4eaa6d43da60a43e9d431dd94cb9c21165be3cd5ce640b8161"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c30855732887dd75a1fdb3e88127a42c3f748f2787cf133c5643ba8bf976f34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4be0f608e09ddd44d9f897f6cdf080411306d47967b135a806c616931e89c84"
  end

  # Use `llvm@15` to work around build failure with Clang 16 described in
  # https://github.com/rust-lang/rust-bindgen/issues/2312.
  # TODO: Switch back to `uses_from_macos "llvm" => :build` when `bindgen` is
  # updated to 0.62.0 or newer. There is a check in the `install` method.
  depends_on "llvm@15" => :build # for libclang
  depends_on "rust" => :build

  uses_from_macos "ncurses"

  def install
    # Fixes compile with newer Rust.
    # REMOVE ME in the next release.
    system "cargo", "update", "--package", "socket2", "--precise", "0.3.16"

    bindgen_version = Version.new(
      (buildpath/"Cargo.lock").read
                              .match(/name = "bindgen"\nversion = "(.*)"/)[1],
    )
    if bindgen_version >= "0.62.0"
      odie "`bindgen` crate is updated to 0.62.0 or newer! Please remove " \
           'this check and try switching to `uses_from_macos "llvm" => :build`.'
    end

    ENV["CLANG_PATH"] = Formula["llvm@15"].opt_bin/"clang"

    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"grin", "server", "config"
    assert_predicate testpath/"grin-server.toml", :exist?
  end
end