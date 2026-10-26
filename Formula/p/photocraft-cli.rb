class PhotocraftCli < Formula
  desc "Headless PhotoCraft engine to convert, inspect and batch-edit images"
  homepage "https://getartcraft.com/apps/photocraft"
  url "https://ghfast.top/https://github.com/storytold/photocraft/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "9e6ce75e785928e0e94a94ae71007103135c0b559fc6ffbb8934c0db0ce5b644"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/photocraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0d1a107dfdb006c1858dd3db6704e8efdbab8d0b66630f4023328c4b03829c4c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8aab89b02b48d507d4e8680db6f4592b9961d3dbabba857cb4edf24625d7b04b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "550fba4a3ef2c11b29b22919d76bf0e4644b5ea1e25d8ae922d3e71c31cfd673"
    sha256 cellar: :any,                 arm64_linux:       "6279698e3802cec14765d95cb2188d6355b27924c7b25467af66e084a48d3083"
    sha256 cellar: :any,                 x86_64_linux:      "299b81de089e09c9335e6e05071fdcec24c6a9f2de3c56333da035ef8d75ed96"
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