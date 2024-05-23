class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https:aptosfoundation.org"
  url "https:github.comaptos-labsaptos-corearchiverefstagsaptos-cli-v3.3.1.tar.gz"
  sha256 "af9d936ee4a3b6e5f9968e975daa26ae2314f6b9cb5b467dfe94f34ffc206696"
  license "Apache-2.0"
  head "https:github.comaptos-labsaptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(^aptos-cli[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1afb25f4268bb26aae61e58ad314c761e69eeadc9eae94fd59ec73bf6d2aa2bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38a59e106504f3a672c767bdec9e25c969501bbe1d77f7132321b3a2f60f518e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16bc33041c00be3c2fd943a8c436eeff9995b76e99ba67c03bba06055fd3be2e"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b28099d96e17f5fccdfd9c3af7395714ac56bfe3de7885382d3677276cb0692"
    sha256 cellar: :any_skip_relocation, ventura:        "4b32dcc535e77eaf3d8f7f543d9dd27c4880b0b7139293d9e66e27a46e4ec4dc"
    sha256 cellar: :any_skip_relocation, monterey:       "42d8560882bba040066af720d15a25119e0651811a402c6ee303ab3a3e6157e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99cfbb145d2731d5860367f0195c0c4bb0b34fa5f5253f725f728ad4d31241ec"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "rustfmt" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "zip" => :build
    depends_on "openssl@3"
    depends_on "systemd"
  end

  def install
    # FIXME: Figure out why cargo doesn't respect .cargoconfig.toml's rustflags
    ENV["RUSTFLAGS"] = "--cfg tokio_unstable -C force-frame-pointers=yes -C force-unwind-tables=yes"
    system "cargo", "install", *std_cargo_args(path: "cratesaptos"), "--profile=cli"
  end

  test do
    assert_match(output.pubi, shell_output("#{bin}aptos key generate --output-file output"))
  end
end