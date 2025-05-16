class WireguardGo < Formula
  desc "Userspace Go implementation of WireGuard"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-0.0.20250515.tar.xz"
  sha256 "c2861e387555fe8b93a123dc34a2e150971b831dda26dbac65a8db006654c859"
  license "MIT"
  head "https://git.zx2c4.com/wireguard-go.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20c2f87b999037bd44a18393bbe55def385c0149d88aef6fb42b0fcd18ec52bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20c2f87b999037bd44a18393bbe55def385c0149d88aef6fb42b0fcd18ec52bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "20c2f87b999037bd44a18393bbe55def385c0149d88aef6fb42b0fcd18ec52bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c64d6ba51816e5412f0b16d861bafbd2c19e0df4e1f7ad8664d2602d432f78e"
    sha256 cellar: :any_skip_relocation, ventura:       "4c64d6ba51816e5412f0b16d861bafbd2c19e0df4e1f7ad8664d2602d432f78e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49b377d62c441fa03196469d4c2fe3d8e88a056c2687ebc4c7fdb95fe9638ff8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    expected = OS.mac? ? "name must be utun" : "Running wireguard-go is not required"
    assert_match expected, shell_output("#{bin}/wireguard-go -f notrealutun 2>&1", 1)
  end
end