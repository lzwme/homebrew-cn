class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptoslabs.com/"
  url "https://ghproxy.com/https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v2.2.1.tar.gz"
  sha256 "2f73d91398a475dd6c42600e7003b0f56a95df15646149e7efa5c84c3b2f58df"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d8ed0de38663ee8b4385d511c8f85baeb7b2c8bfac4c6fd0101da8e284b41aea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "028b3a8feb40e0711b973bf36b920f40f2cfb8e27c1ec722dee868be93c7ed62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9558ba8ce806f7e1f36955598d3052dbf97a38a9e0a34c51065cf026008cb195"
    sha256 cellar: :any_skip_relocation, sonoma:         "b8281d4ccec55023e8867b36bdc3c90e8cec7fc0326ec3c009f3e1e819920d54"
    sha256 cellar: :any_skip_relocation, ventura:        "36d14db990ce58722838b7c99e1235cd6bfa6bda5b8f941312eba23770411601"
    sha256 cellar: :any_skip_relocation, monterey:       "247d4102d6d367ad35fc4b1a74f9e4fbb7148c16d2627064ab666dfeb1342b26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5368fa257ba8c2834092f81651a912643812a3ca3936a7eeadcd6dae3fdd333c"
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