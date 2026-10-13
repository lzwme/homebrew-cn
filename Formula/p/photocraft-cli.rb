class PhotocraftCli < Formula
  desc "Headless PhotoCraft engine to convert, inspect and batch-edit images"
  homepage "https://getartcraft.com/apps/photocraft"
  url "https://ghfast.top/https://github.com/storytold/photocraft/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "458e8d7c54ee5cdf104415515d9b314115fde6f9b235ab0ac17775b72bdd1400"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/photocraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1bec4306503858c52c5b578aaa2691c63f3c03e89241242c39db6cc45768f1a8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7f9a26e567b0cbc3c95137ed4748f5cd31b3e416ed0b3aa80fb2eaeb3bd1149d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4eefb2f6321d5228de55b20a9322e7f7ac0842a01df576a4975bc47d89dbb7b0"
    sha256 cellar: :any,                 arm64_linux:       "682f53cb4978fec09fdc1784b870f95a367745461cce63bfc7e3041380b8f694"
    sha256 cellar: :any,                 x86_64_linux:      "5be88b504f72c1122ace14949fa4d3bce9006af52054b6c085c82bdd5041ddef"
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