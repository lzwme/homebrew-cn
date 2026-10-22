class PhotocraftCli < Formula
  desc "Headless PhotoCraft engine to convert, inspect and batch-edit images"
  homepage "https://getartcraft.com/apps/photocraft"
  url "https://ghfast.top/https://github.com/storytold/photocraft/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "48742a420d9cf4d166ec1b778f43a86d529de5069828b457c38977232c37a401"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/photocraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4c3633e1481b29c33ce2e7f5157abf4c84d34f4475f0c79c9661fb5206bf87d9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2ddb2819d2e70c1b04a212213e2ec7aaff6ef183909967e148a071b8e02e478f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f6746c4903074d4b88bb4c4588065c9faf997f363616f3e90a4ed0b15dc18bc9"
    sha256 cellar: :any,                 arm64_linux:       "1bb13419624ce20d3ef6b35385341f121271541a816262a2db029c45e3766500"
    sha256 cellar: :any,                 x86_64_linux:      "66165d876761f3841016640731ef912ebd457b4df661424ac4f8c017621d6829"
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