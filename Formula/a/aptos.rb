class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://ghfast.top/https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v7.10.0.tar.gz"
  sha256 "102756f42b4e45dea8fbf157a60c70fa4c83d2812725be96e9a4e4a3b5a3e5a7"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "006b3bf6379453de19e7f18a6fc6dce4bbab70864ecd83af0725fca91eb3e3ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e375e66ab389c3c4d9beb75d88952581164126c1e3ae37eedf71f3fc20d4b0c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b973fea7a128287293f1cc3c1e3b73c4fc9ff93e024ecc8f74bb26b436226a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "783f83249d01bcee4f9e9d68b4841763d5527b1b5a3b5dbafb4352dd9aa4c113"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0405accd591c5777af8b5af004d603fd241a940ed3261671278cda16772fb81c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfd640e1071763fc2241acab6cf8a81e609fdf426badc514fc96e64be17f5f56"
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