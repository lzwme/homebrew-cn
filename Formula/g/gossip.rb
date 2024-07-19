class Gossip < Formula
  desc "Desktop client for Nostr written in Rust"
  homepage "https:github.commikedilgergossip"
  url "https:github.commikedilgergossip.git",
      tag:      "v0.11",
      revision: "5b0fb2ae5f1134793c5c3318aefda880738a07ac"
  license "MIT"
  head "https:github.commikedilgergossip.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db890b7ffc873036e7a3a85cfacfab05654a8e9569934f38c92f9e7b523d3ff7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8242f5aadae9432186bf4f3ab1d4025d26c4c28457438ae49a51f00f0490ee04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5486b4a11b87c94eb9e3dbe3963a9494cb5b705b57edbbd09145ede3a153e99"
    sha256 cellar: :any_skip_relocation, sonoma:         "74448b5163d95a02ee1b605a438cae1a804c16678150f7539fb15bc39ffae80b"
    sha256 cellar: :any_skip_relocation, ventura:        "3441a58d2f5a08e0cd85edb988ca21affaebf3bca970aab8286a929f06a7c4e0"
    sha256 cellar: :any_skip_relocation, monterey:       "76c5750edd1a19b8b04c972a45a5235837d731fd033b3191c56166d202e77bb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9683b2780b0ccb0414c0d9f4fecba72cc183c9e7e6f423ce418e4efa04dd2d9"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "libxkbcommon"
    depends_on "mesa"
  end

  def install
    ENV["RUSTFLAGS"] = "--cfg tokio_unstable"
    system "cargo", "install", *std_cargo_args(path: "gossip-bin"), "--features", "lang-cjk"
  end

  test do
    mkdir_p testpath"LibraryApplication Support" # for macos
    mkdir_p testpath".localshare" # for linux
    json = <<~JSON
      {
        "id": "b9fead6eef87d8400cbc1a5621600b360438affb9760a6a043cc0bddea21dab6",
        "kind": 1,
        "pubkey": "82341f882b6eabcd2ba7f1ef90aad961cf074af15b9ef44a09f9d2a8fbfbe6a2",
        "created_at": 1676161639,
        "content": "this is going to work",
        "tags": [],
        "sig": "76d19889a803236165a290fa8f3cf5365af8977ee1e002afcfd37063d1355fc755d0293d27ba0ec1c2468acfaf95b7e950e57df275bb32d7a4a3136f8862d2b7"
      }
    JSON
    assert_match "Valid event", shell_output("#{bin}gossip verify_json '#{json}'")
  end
end