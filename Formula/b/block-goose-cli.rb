class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.29.1.tar.gz"
  sha256 "faf89a8309f725c928c82f94a9ccd017dbd0fc3bf79bd3533962ba97d056f762"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99b3a76ae94d03378c6e8aaeadae8dd94c884bbc06922cc6eb9ca8307aef16f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "caf51fc4ecc8e5488af92be07ae5f80dfc6386a44eb7759e35dffcc535889520"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4fc00857795d28a5889d0d479a4d3c377602737832a6f05077a988941260423"
    sha256 cellar: :any_skip_relocation, sonoma:        "91aae562cebf54be4cf193ef497520dd7a5ea961de3a6273a0cbede39cbcfd73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fe55141e4bf2befdded53a4a2d2b64f953aff33577375e95cd12fd2994c0f0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf2df21522323a45c6d90673a8fab2f832ac78ce25b7dea7e43a148dda4555ae"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build # for lance-encoding
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  on_linux do
    depends_on "dbus"
    depends_on "libxcb"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "goose", because: "both install `goose` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/goose-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version")
    output = shell_output("#{bin}/goose info")
    assert_match "Paths:", output
    assert_match "Config dir:", output
    assert_match "Sessions DB (sqlite):", output
  end
end