class PhotocraftCli < Formula
  desc "Headless PhotoCraft engine to convert, inspect and batch-edit images"
  homepage "https://getartcraft.com/apps/photocraft"
  url "https://ghfast.top/https://github.com/storytold/photocraft/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "c1a0370920eae0c5517bbff9dc8d748f1cd7698cb8ae11f22e7ddae9aefc5b18"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/photocraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ebad8a3a371224b1a02bb51cfed339bc89755fcddfc1c31ce0391aefd78562bf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "27cd7e0f92d4ae4814e0141cb6cbbb6600ed12e33cbef9488b3cf7d014815ffa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1d29d5845d7e16f0c7d723a87708c54da285fbd4c5ab4e396e41d65a0260c61d"
    sha256 cellar: :any,                 arm64_linux:       "a9b94f7dec3938e511b0377122f534f9aba64f65c7e4229aef2d248c91ad9ec1"
    sha256 cellar: :any,                 x86_64_linux:      "eba92ab784bbaa82562574c8863ab1cd9321d1ac3fd29499ee9353baae3be6ff"
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