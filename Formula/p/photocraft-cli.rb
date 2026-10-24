class PhotocraftCli < Formula
  desc "Headless PhotoCraft engine to convert, inspect and batch-edit images"
  homepage "https://getartcraft.com/apps/photocraft"
  url "https://ghfast.top/https://github.com/storytold/photocraft/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "14fad2da57ff87a37235455421c6127da50233e72963ba5dddf9dd800b02a8ab"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/photocraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "85f9fcd086c33e794d5489b5b01efdf31227d647be767a28bad3878f1fe6552f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7736130f151abda8127302609358e73216f9941c90d3552a4ba212ee1d27b4fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "36de8095b6fa9bf66ea2facc59063db8f8a623c552a4ae23f88f086d069e17ea"
    sha256 cellar: :any,                 arm64_linux:       "69b151966f0906ab5f12ff69bbe46c46307527ff3078a465d8b8c17697200ccd"
    sha256 cellar: :any,                 x86_64_linux:      "68a5ec12f6484ec833ebedafea674af4d2229e19a1d5d884648a47a4348fac5f"
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