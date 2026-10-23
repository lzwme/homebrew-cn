class PhotocraftCli < Formula
  desc "Headless PhotoCraft engine to convert, inspect and batch-edit images"
  homepage "https://getartcraft.com/apps/photocraft"
  url "https://ghfast.top/https://github.com/storytold/photocraft/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "c8ab313b268be5c7064def7d3b4bd0f924a54ed33db8b07229ba694c4e42e272"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/photocraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ba53833cf76e465efb8f43f2f0a1ccf5acd615a215e01372221ae30636902277"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b202b82f1e5bf32531a4b82edd7e079b6741bc699d1ce066b8b75c9aa4956805"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b798d2e57d03a628c265fbbbd64ab04e195c39b36545350aed24a3060890deb7"
    sha256 cellar: :any,                 arm64_linux:       "5827abff785294e12cad5cc04917b41967b55277a9c32ecccd06a6c348e83f9d"
    sha256 cellar: :any,                 x86_64_linux:      "14322915d84e06983b477b365a61a47e8143432fc22ff7210e00dce9a31fe761"
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