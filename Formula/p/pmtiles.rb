class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https:protomaps.comdocspmtiles"
  url "https:github.comprotomapsgo-pmtilesarchiverefstagsv1.11.2.tar.gz"
  sha256 "eedaeeb821162d60880e382f181ac13dde71c54a1c6d0798b1ca7f4f02f4e5ad"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b33f6a740284e4d1e29768ec8469a3e0606c3d047866d2eee46f4ac0f886256f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1298295d2bef5cc2e25650d86de51f371ae6a6117b347319f4a82fd0f31197b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08193a0f6e4ee3d4a0eed353b27c1aa5441dc0c1ffea9f8d9b8366b9042c6116"
    sha256 cellar: :any_skip_relocation, sonoma:         "7a56e5f6cf5131e6250209ecff8f634c10810ca6d12a57efd4172da9aa63924b"
    sha256 cellar: :any_skip_relocation, ventura:        "14865073801bb3d6b4daf6bfa9804f7f3fce90d44d965006188028cfeb914012"
    sha256 cellar: :any_skip_relocation, monterey:       "20674cc2ec207079638a5fafe3975fcb838f9a3e2f5c4f16222045b980467c74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57fec0733006b1f7cb796375d4cdc3f11650576ff9d07f7987381c6e0bdf63ba"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    port = free_port

    pid = fork do
      exec "#{bin}pmtiles", "serve", ".", "--port", port.to_s
    end
    sleep 3
    output = shell_output("curl -sI http:localhost:#{port}")
    assert_match "404 Not Found", output
  ensure
    Process.kill("HUP", pid)
  end
end