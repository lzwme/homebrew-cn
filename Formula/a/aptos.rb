class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://ghfast.top/https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v7.14.2.tar.gz"
  sha256 "88e8699c6cec1f6ff2b2d15479dc756476863c561abd525e157cee338a806d79"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ccf271b7d8072b9ef93b00464735e7fbd2e123ad4ba3a8472d0d82b6cc84cfbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e00a2ee537503d0a5223e270050b530292d224eba23d8cd18c111357fddf0b10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b1a6ce671c9d19f116b99626d5a8fb19c4e5dbace6794c284033ab271bf40be"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e86379aceabbcdba574b449bc6f84b626f9bc3430b17f0dae772f18ce8041b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "871129b27c02ca4ea780c940d590dc5a2354a71c82ae37c62066f4c2fa9f0d42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d87d62f8156ce8faeb22ae0aacdd1efc94aa13d3fc16df571cbc921ca3b25472"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "lld" => :build
    depends_on "pkgconf" => :build
    depends_on "zip" => :build
    depends_on "elfutils"
    depends_on "openssl@3"
    depends_on "systemd"
  end

  def install
    # Use correct compiler to prevent blst from enabling AVX support on macOS
    # upstream issue report, https://github.com/supranational/blst/issues/253
    ENV["CC"] = Formula["llvm"].opt_bin/"clang" if OS.mac?

    system "cargo", "install", *std_cargo_args(path: "crates/aptos"), "--profile=cli"
  end

  test do
    assert_match(/output.pub/i, shell_output("#{bin}/aptos key generate --output-file output"))
  end
end