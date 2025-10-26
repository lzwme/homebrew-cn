class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://ghfast.top/https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v7.10.1.tar.gz"
  sha256 "6809239adc0bfef009a6ed929dc0c0fd5cb25885fc77bb695886d79a7653251d"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20dbdbd479b0a22e4d93d9fd4ba8da12979af946d379eaf62285d26e49b0e809"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c76394ec9297809ebbadb719121809020aba715d8b5dd64ea75649ca661ef37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78d92795e815cc68f287ee19c3336615a4a62590de587b9b35724d4890dae21e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae66995f43e0ad265321723c08b906276693776fb5ee250556d233c9fd78bdc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8cab085e76ec092ccdeae222a44c22ded3300e687feaba714b5fa78fa6e7d7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "791d248443b290cbd02b4013e45892e21d1805d0768a36fbab4108e81e5c5449"
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