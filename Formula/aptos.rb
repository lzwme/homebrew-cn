class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptoslabs.com/"
  url "https://ghproxy.com/https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v1.0.12.tar.gz"
  sha256 "5e4077ac05e251ac1f9cc628e5653d07ba83415ea4c1fa3b8cb1f8dcc97c1955"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91d471b8827be29438ac03faa46506c166749569df309b140c71bd817a68fa63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f478a1c74696514a21937fb7116422cd65ad0ff39722996b058d024e78d8920e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c7e1ee380bac56c9a79bbc12221f68ecc61df90d945459a728a5da4bd924583"
    sha256 cellar: :any_skip_relocation, ventura:        "274703e357abdb91e3d26864cea044c7fc55f2217f9bc3aefec839584cfc0cf4"
    sha256 cellar: :any_skip_relocation, monterey:       "4d6e8ee1ebccac85d9f3ba46ffbd468bc62f4d15f1e768aacdcb55332869322a"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8cb6dfdc7c552e45f437ba239f98827050403bbbf08fe26d75c772861cdc0a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81f38a5f42258bd7f4a9a24c99df3d7ba21b05b2a8a8d0a0cbc08391d77fee28"
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