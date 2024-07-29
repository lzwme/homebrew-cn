class Gossip < Formula
  desc "Desktop client for Nostr written in Rust"
  homepage "https:github.commikedilgergossip"
  url "https:github.commikedilgergossip.git",
      tag:      "v0.11.2",
      revision: "eaccb10674e01f2320a20908b6563faa953ef381"
  license "MIT"
  head "https:github.commikedilgergossip.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cee31302b47858a6c752a37e2a96221cbd7ca20b4fc0731a463d8e5688c2ab1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14ce92477d2d7947ac33988fa8e5eb730cd1474f2b4b92967e08f3af538fe2bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ef2726603cc94403915f66242ec42565735ced7a4a00c522763074eff4526c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a542d85357a2a8900401b04a0e66dbf7eaf8e6e62b4653612378e905a68a193"
    sha256 cellar: :any_skip_relocation, ventura:        "1c6bfafec913496d94c64fa38b64795e5e27dbc878a0c3f607e05eca1b6dfeba"
    sha256 cellar: :any_skip_relocation, monterey:       "93e0dcfd2f268ab7b6992397e3bd16ca5b1d28a7d592c29e9a281e24cd193a0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b54442bb5a265f5316852d945973c4b2fd65d199b299030266ea39b14171b9b8"
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