class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://ghfast.top/https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v7.9.0.tar.gz"
  sha256 "48dc1c132ecda885b9af00ff5fdcbba4057861502053d04643eb7d6372badae3"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9bfc5281496ac69980dd31c5550a258eaefe73c3b3ca0c102d6245d3e62a26a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cb08ce364d5a7944bd15594b79b56b2a512e2770739a02a14659ae21e89004c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "212edb9a550acf8fe082881e8c1a90201e9eca103f86970aadb007f2d6606e18"
    sha256 cellar: :any_skip_relocation, sonoma:        "4694be7f9623962c3f5b1c7ed30cafd1c10781532ef6fb13f86a117793014dbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f204de40c26bda2a24a6d68272114873d20b420eeaf364a29442a080165b352"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e49a8dcab6ed194050e000e54ecef224dff77c64d0e2a3b80512ee57fe373a1"
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