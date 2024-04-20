class Gossip < Formula
  desc "Desktop client for Nostr written in Rust"
  homepage "https:github.commikedilgergossip"
  url "https:github.commikedilgergossip.git",
      tag:      "v0.10.0",
      revision: "a6b529ab59ab9c0f323efc495f441051a5d5ba03"
  license "MIT"
  head "https:github.commikedilgergossip.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd2f466b51baa4ebeb646e4b19042754195925c61c7fe3efcbda420779bd4836"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08c460e5c29f40b5ff5da8bccf20b684953b2aae945cbc5449df47d10c1e4cce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cadfea0111ef941865c8f0e72c88fe556a3bb5c74a1049d7708885885d5bc831"
    sha256 cellar: :any_skip_relocation, sonoma:         "df0934785fcf791f54caea4078f4aa9d303b1494f552c9aff9906ca76191049a"
    sha256 cellar: :any_skip_relocation, ventura:        "0c7dfb73f1cf1a924c66e75eb73e3c3e70cd59ba7786f7cac3f4def1aee4b52a"
    sha256 cellar: :any_skip_relocation, monterey:       "64c5f5393e852d6b02b47956ed1d144150817b0fc2768b2b030fc5bfb9169dc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c78fc5f19190d2e7efbe1d394fae236a7ffae39f096746147a66cf72825feb79"
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