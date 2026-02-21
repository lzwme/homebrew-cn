class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://ghfast.top/https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v8.1.0.tar.gz"
  sha256 "28ba2a5065011149dfb76518a3f48a5fec1da7a71acef4b4bcec2e49e6517e0c"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5484791aaa8b146a2eede6933c79f981136cbf30bf86163fd5045549575912e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eea006ed074627cfc1000881a4cc685807a2ee6679d91159c9cd1d3c0e89afb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91286662c8444684f1530f6bc43d83acd3317c5b97776b37efd321f0458ab38f"
    sha256 cellar: :any_skip_relocation, sonoma:        "32faaf97acb487b6bbab5770185835cd263583c271989e360cd5d27457a529a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1fef6ff1cca807bb631ffd06eaa08e0ade37cd7e5f16ea8e3c020d0c173a0a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecf7659c5c7940620fd655119a058e29b9cf6271875763b524cdf7c11b38b80e"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "zip" => :build
    depends_on "elfutils"
    depends_on "openssl@3"
    depends_on "systemd"

    on_intel do
      depends_on "lld" => :build
    end
  end

  def install
    # Remove optimization to allow bottles to be run on our minimum supported CPUs
    inreplace ".cargo/config.toml", /,\s*"-C",\s*"target-cpu=x86-64-v3"/, ""

    system "cargo", "install", *std_cargo_args(path: "crates/aptos"), "--profile=cli"
  end

  test do
    assert_match(/output.pub/i, shell_output("#{bin}/aptos key generate --output-file output"))
  end
end