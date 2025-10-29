class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://ghfast.top/https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v7.10.2.tar.gz"
  sha256 "643a8e8d73dccb67e95117dd444679bd286281da877a6ad7271ece7b2b7baecb"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30b699b9c7e523e80d88f874449e0bb1f062a778636a93e84c0505e318b5afd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37ab2cc1f0cbae2a3efd49c3d47dbb231266984ce4a040b954a88f5a8def6733"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5407004f7aff8333e94de402cdb80990c21b6565b03816069ed970d656e54d86"
    sha256 cellar: :any_skip_relocation, sonoma:        "cdf91a916c54438196c62200e2d0cb7a2dfaaeb10d7577e7c4475fb6aefc43f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e90c489f6e32c56912a1c2869e473f01e2c32ead3884b677293e69394cb50ab0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ba02e88138c5fdf11aed36b90a0bd4bd73e6c22d69f5dc264dd74ecf7f04a44"
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