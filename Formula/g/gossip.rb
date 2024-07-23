class Gossip < Formula
  desc "Desktop client for Nostr written in Rust"
  homepage "https:github.commikedilgergossip"
  url "https:github.commikedilgergossip.git",
      tag:      "v0.11.1",
      revision: "e8e1f1e84d11075f42c09f89d4d6451cda52f76f"
  license "MIT"
  head "https:github.commikedilgergossip.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "06ee39810e6a8660e2298614af5ed87796f3eebcfa237fc9766fa83171806c7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d7651e155990be9554631270ea3957ff38356b5782a7371e262ad49f1eae92d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "574462d9e9cdca47a45da55ccaafcb35e0aa4aeb740e7572dde1d93804ff6385"
    sha256 cellar: :any_skip_relocation, sonoma:         "b55099ea8c4209f38dbff5e1d27dce6fbe69295e776faf3a883120be71681c0e"
    sha256 cellar: :any_skip_relocation, ventura:        "a7a06970116a9d3b267ce75d34039663a500d810253313a09b3a626631adb39a"
    sha256 cellar: :any_skip_relocation, monterey:       "9446ab7f0b429c3454e65dacc96177e61b77167a7b867368d1b1b326232a3c11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0beb6f365712accb8401c37734adf865dc8fcd1bb0b9fe51a42bb6a825e2d691"
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