class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://ghfast.top/https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v7.12.1.tar.gz"
  sha256 "9510a60c253375bbbaa3c7ab8d4fc5ee17e7e3cc21e807beb0a42b53f4b81361"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "242e1c8b937d1651555f83030123bb9f1626b540da506ff067dfc1427fbf427e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fde434ff344ec19259f9435caf31d813b121a0d50aa9c4f692a741d13f49846"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9fec97aa177219cc4c5ea4ca77fbe83fe787c6eb1db3538efb9d723911ccc6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a13af6bb4e65bc7e95e275d809212f309d46fb7fdcd3f5aa7c557ba1558a3b82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0e82289ee352d6008e0ec2f4c2c85f53d50c613798c3e30ae49648ade420a3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2975048a1addd7377c1d13a957cd900ff566ca29f5a3f6653db4e8fc29fb4efe"
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