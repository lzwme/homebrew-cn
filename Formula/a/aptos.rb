class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptoslabs.com/"
  url "https://ghproxy.com/https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v2.1.1.tar.gz"
  sha256 "a7da6602c70e22d38bb6759d9f86bbcbd1c066e5bbe17f258b6185258f379558"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "10a50967d6fef179bbc3c9b9739aaf9285cca69de1c0a3a4b46f28d7e3a02412"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fdb4d26a6b20a3a4f56b7549ea6c91054a9f612aeeb4daab390bf654736e5690"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9836df8ce3f77e57f22fb9d78097ce1675f79e5de052563ba523624a6281e938"
    sha256 cellar: :any_skip_relocation, sonoma:         "3dab1a74ad3de2602bc2cbe10ce4b23b849906c6cc3f0d3b5ebb30a49bc55301"
    sha256 cellar: :any_skip_relocation, ventura:        "f200addb6f3c3b85be6b31503eceb5fe4a92a3ef9a7ea91e06836756eeb11f9e"
    sha256 cellar: :any_skip_relocation, monterey:       "27628e2ddbc83b524f0da2f5b653d4eadf64686a91550ef0fb9adc849ad6b090"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5477ccf54224bad7f1cc28b196ec4da06fea716e18faffce9c8f5a51a52d63e"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "rustfmt" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "zip" => :build
    depends_on "systemd"
  end

  def install
    # FIXME: Figure out why cargo doesn't respect .cargo/config.toml's rustflags
    ENV["RUSTFLAGS"] = "--cfg tokio_unstable -C force-frame-pointers=yes -C force-unwind-tables=yes"
    system "cargo", "install", *std_cargo_args(path: "crates/aptos"), "--profile=cli"
  end

  test do
    assert_match(/output.pub/i, shell_output("#{bin}/aptos key generate --output-file output"))
  end
end