class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptoslabs.com/"
  url "https://ghproxy.com/https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v2.3.2.tar.gz"
  sha256 "5819379169ffd3b46800dbb67f7eb6b8724eb43256882a23cec14f5802523272"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "783f0bf0aa4aae38d7b4846f91ce6da9b5102148c0b4054ab5e96f6438f2ba2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e7bd2c9da7a8930c9008836d75592e81e1f2028e0563afd48311de8376d95b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c8c4118c576c3a37fdf6134f56de7da73f198e3e31422463a3938410ce74767"
    sha256 cellar: :any_skip_relocation, sonoma:         "966245149ed310ed0b91707cf14cc093ae08ac76af59590390186af62c8963fb"
    sha256 cellar: :any_skip_relocation, ventura:        "52b7cac2edf71ccc873b8d1f496ccf020248ffcef1dd101541e189ce55821a8f"
    sha256 cellar: :any_skip_relocation, monterey:       "dc5b4ef5a9557d7e0ee7a3a30b548ded05cb247f59ce3b4f7dcd33aed4c58ac7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "281d5cd528ffd273613bc87351e3220bf03abaf0769710beb7669c0184c11ebe"
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