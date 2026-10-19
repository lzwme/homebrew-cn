class PhotocraftCli < Formula
  desc "Headless PhotoCraft engine to convert, inspect and batch-edit images"
  homepage "https://getartcraft.com/apps/photocraft"
  url "https://ghfast.top/https://github.com/storytold/photocraft/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "161889ae860280c4a583f42c3e5400e4440a900c2c17bb860219a8d7c1692207"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/photocraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "395144dda9deef23e93e1e7d34abef9011fdb5c850b110e39a509c13c4289a3e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9de772e75e04d706ae4d617a2d6b0d794b2741e07aa8f16f4289ca0880dbaa96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8bb1a55eaf71cd0663b1951e56c8abc0292162a85c364a83a7812bd6389c0ca3"
    sha256 cellar: :any,                 arm64_linux:       "7451ef8eb3f35ffebeb27ac5e16cfb41d90cba0aabbd616db84eb6bd83a209ba"
    sha256 cellar: :any,                 x86_64_linux:      "6434cf5a25726f7459b7d773671920b36ec5c6d643ecfe389e60f07fd24fb463"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/photocraft-cli", features: "heif")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/photocraft-cli --version")

    system bin/"photocraft-cli", "run", "--new", '{"width":16,"height":12}',
           "--cmd", "layer.new.layer", "--out", "test.pcraft"
    info = JSON.parse(shell_output("#{bin}/photocraft-cli info test.pcraft --compact"))
    assert_equal [16, 12], [info["width"], info["height"]]
    assert_equal ["Layer 1", "Background"], info["layers"].map { |layer| layer["name"] }

    system bin/"photocraft-cli", "convert", "test.pcraft", "test.png"
    assert_equal "\x89PNG".b, (testpath/"test.png").binread(4)
  end
end