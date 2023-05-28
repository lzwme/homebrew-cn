class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptoslabs.com/"
  url "https://ghproxy.com/https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v1.0.14.tar.gz"
  sha256 "b59b8c90f9910ad881f75afc05bb40774f0d743b318a397a35ce9388c8b31f2d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c41766ce1c4a9e7cfbfa9dfe567b821ca3e21c3330eeb1f8c44c4ad9b72c505"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "198a19ebe2826593880d392516cecaddf42f90db78eec2c9bcd1e8d42142e2b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "84527d79477eaa28494191f364d3a14c8da7e92e4214f9f536d8e6908fc5670e"
    sha256 cellar: :any_skip_relocation, ventura:        "94305bfbe243cb595f35299e0fbba5a1c3c0bf4a5d77bad1efd589de6da93ac6"
    sha256 cellar: :any_skip_relocation, monterey:       "74ea74881f64e27c412ae9d48bb2b5e07f3bae1ba700514bf05d0ce66f5ec55c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8dbdb12844f5cb80495c9ddc3a2f6af9b08bffdc2cf6bdb4900372359695214"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ddf6ec4002156b042a4186f174f357119155734071dfeefe24fca5dad127f9b"
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