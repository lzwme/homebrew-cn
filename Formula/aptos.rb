class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptoslabs.com/"
  url "https://ghproxy.com/https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v2.0.2.tar.gz"
  sha256 "3487775e93a0b9b04239372f7e150a1c83b46f0f6e64ff8a5f6ee00f8f510e12"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "435004648c2f93ef57b9ae0ffb5b1ee6b402f7e426c29c9b5d92eaca31c2d999"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "400d2f0ef6d1f8d4a37cba5de9e4e2d7e648ee88915b115c4a84643b3af95f3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f151c62e4a17df36044735942553c73134b0108ca129f70328b6ae727a427259"
    sha256 cellar: :any_skip_relocation, ventura:        "07fda9ea7c3175892ed4d5553ed100929e15c979bfa0804b1588ff8a87a268f3"
    sha256 cellar: :any_skip_relocation, monterey:       "0e82772ca8ec148bb97ad25b3d2641b78e501e4ecb26b7295beaa46478ab2b2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d4a7582664823d95a6e92961e4c165f1fe19fec632f9b85c6cad6a14256bb15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5b00eaa9a75538041b1dc00fa66c259328d17d0a8b3b740268048c8e95a5a45"
  end

  depends_on "cmake" => :build
  depends_on "rustup-init" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "zip" => :build
    depends_on "openssl@3"
    depends_on "systemd"
  end

  def install
    system "#{Formula["rustup-init"].bin}/rustup-init",
      "-qy", "--no-modify-path", "--default-toolchain", "1.70"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    system "RUSTFLAGS='--cfg tokio_unstable -C force-frame-pointers=yes -C force-unwind-tables=yes' \
           cargo build -p aptos --profile cli"
    bin.install "target/cli/aptos"
  end

  test do
    assert_match(/output.pub/i, shell_output("#{bin}/aptos key generate --output-file output"))
  end
end