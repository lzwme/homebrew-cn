class Gossip < Formula
  desc "Desktop client for Nostr written in Rust"
  homepage "https:github.commikedilgergossip"
  url "https:github.commikedilgergossip.git",
      tag:      "v0.8.2",
      revision: "32eecc4c465660be149148f8940ae4ec4a5f94da"
  license "MIT"
  head "https:github.commikedilgergossip.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "061e378f584dc7ede34bedf729c33f5e27184e712d22dd7566c7507b2610db0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc79bf4e8e16aec4b3962cc4cfaab2a612c75ff34a1b822b5702f77a7cf5ffc3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29cc8e926859a9f6c12375cd57654d5a088d66d6edc819eb8d421210ce425d04"
    sha256 cellar: :any_skip_relocation, sonoma:         "a4fe8cd421ef8b21c8ea00d2913a45bcc1d03148fc36d33d2d76fda90f51dac8"
    sha256 cellar: :any_skip_relocation, ventura:        "ea263e57409621b974dbbe3963bb5261dc6310ee11a0535ad2259ad31fa78b8f"
    sha256 cellar: :any_skip_relocation, monterey:       "c0340f56d321d4f09dbe17a6acec823bbd369a5d8e2ac1155a81e4d20e34d070"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cf7f84da749fec10aa8c255d5d0ad10e17c8640c1ead13ff7f9522efbff646f"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "libxkbcommon"
    depends_on "mesa"
  end

  def install
    ENV["RUSTFLAGS"] = "--cfg tokio_unstable"
    system "cargo", "install", *std_cargo_args, "--features", "lang-cjk"
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