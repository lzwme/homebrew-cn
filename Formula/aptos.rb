class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptoslabs.com/"
  url "https://ghproxy.com/https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v2.0.0.tar.gz"
  sha256 "35f47c87ae05b690c3970a7254b256fa85a892715941f5b2cffa1803d4460c0c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebe0284dc60a2a7d69d9680956bf7f68d6822c7437c363cc17a6ffca199e3353"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15a80b914a0c62e656411aa90f5f44094c0e09c0d204c85cbb99cb5f9169f3c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9cda2cee6fe179f97bf2834b2ee193041e9c4ad4addb09c55b001e3478400b0c"
    sha256 cellar: :any_skip_relocation, ventura:        "840a0320255090069ece926e0736fc21c10f8d3f1d052344b08bbb3a5259e576"
    sha256 cellar: :any_skip_relocation, monterey:       "05de0cb04cd6c1474cff76929a51b058a0d0351a04898341779bf6c5e5d4fe90"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0e0e44ab2eff8a74077c6a3103bc1f62541be3f99166be2bc854e7a1dc8d8a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c1c4863d90c345bfc07703fddbee09d042dc8ed4e77db7cad27dbc46622f542"
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