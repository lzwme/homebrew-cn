class PhotocraftCli < Formula
  desc "Headless PhotoCraft engine to convert, inspect and batch-edit images"
  homepage "https://getartcraft.com/apps/photocraft"
  url "https://ghfast.top/https://github.com/storytold/photocraft/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "add4b604f0e754bb78f3320821cc4438940bb51c2cd51c0666ce2cfcb525bb3a"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/photocraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8800b918a3062f02a1cc5b920b351afe73795ed0dd1451dc39a71cc4f772dfbd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "55f0a68cfd1154bb23cb150a9383ab13164aef6d7c84c201516a4a8b0ebef3a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dc9c8862094a808cf59dafb3bdffcb715940a0e7847567caa5c2b2cdcc36a314"
    sha256 cellar: :any,                 arm64_linux:       "19a32c724720a7f6254b4dc4a2b9c645704f9bcd33927cae3e94759264d486d3"
    sha256 cellar: :any,                 x86_64_linux:      "3ac1f43fef82294ecaef600e87b2a51a1aead594631d576a511463dedfd98f2f"
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