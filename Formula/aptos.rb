class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptoslabs.com/"
  url "https://ghproxy.com/https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v1.0.9.tar.gz"
  sha256 "266f8f1f7950f346b1479e0fce1fd909f159f6909e0a319073837770b2eb5014"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a874ab759bc531b657b56bb9b15d5125ebd4c57b2f3339f51d74d4e463f988c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8324a60207a5af4d4016cd11a77097c978e90767dbf72f260316fdf25c0c5122"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d643b62bc7d51434e6d962f02425ec6dd86dd9202dc21aa8674662d7effc6f0b"
    sha256 cellar: :any_skip_relocation, ventura:        "521cf5453e04c20a1a4f9bd06d2cd5519b16598d54e0b2f133df88a1cfd10f34"
    sha256 cellar: :any_skip_relocation, monterey:       "4d0bd601b9419d6d080ace07ae8a8e2b4757d93dc47c439414c2e558eee22335"
    sha256 cellar: :any_skip_relocation, big_sur:        "8be0b2c20a9adf617ddaf28566a3ee9c2c43fbbaa2be84b579400d1a04862368"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "108baf15576ee748f00bec42e3f18ba7f2d1efd3525389f1b2168069de89f163"
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