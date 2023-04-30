class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptoslabs.com/"
  url "https://ghproxy.com/https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v1.0.13.tar.gz"
  sha256 "c31392863d10dc0830bacea75d558fe48faf56f55f9b8d22a68fcb48b8dce033"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7cc9b1464f9e9ef07c0961a04fadc12bcd2814b8e95921b532f3c045ec15cb7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03e6d070c8ed98f36b54c0c23858350b6bc9d2cb4bcece7b0965fd89c9c9bfb5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3064d78651b44066296ec8478e8bc0217663ff3f64a08748ad00b01780c5769f"
    sha256 cellar: :any_skip_relocation, ventura:        "3f36a6f6c47f7fdb72f5112cfb1a3b31da3fbe1a0838cfadcb6e78f87d2b1bd2"
    sha256 cellar: :any_skip_relocation, monterey:       "00617acb333ca32a2eda4492e745b66c22e4d170e7d59946fd1848176e0da60c"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b7b823cc16652dd8a8089dab663b4f4ec838b06fb3f104b2e1ed44627104ce4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2788988ef4029263ddee23e94f6fbafd7d95f6497d1f9d3fae41d9c41e5ed5df"
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
      "-qy", "--no-modify-path", "--default-toolchain", "1.64"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    system "./scripts/cli/build_cli_release.sh", "homebrew"
    bin.install "target/cli/aptos"
  end

  test do
    assert_match(/output.pub/i, shell_output("#{bin}/aptos key generate --output-file output"))
  end
end