class Nextdns < Formula
  desc "CLI for NextDNS's DNS-over-HTTPS (DoH)"
  homepage "https:nextdns.io"
  url "https:github.comnextdnsnextdnsarchiverefstagsv1.44.0.tar.gz"
  sha256 "1b091d5c2ab968c498084db071daf632c89d9222679d224597dac28fc12a3674"
  license "MIT"
  head "https:github.comnextdnsnextdns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "360e29dbab5fd8edb97b1dbfbcdd87b48e75cfd364dc1596c002a05ddfb36083"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "360e29dbab5fd8edb97b1dbfbcdd87b48e75cfd364dc1596c002a05ddfb36083"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "360e29dbab5fd8edb97b1dbfbcdd87b48e75cfd364dc1596c002a05ddfb36083"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9839f4c266d25c8f49048462907005c2a98efec8545b76ac894b07d42ac9bd2"
    sha256 cellar: :any_skip_relocation, ventura:       "e9839f4c266d25c8f49048462907005c2a98efec8545b76ac894b07d42ac9bd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31329e99d4573991861c2de23d83d11543c185732ef4907b8c883bb0bc44f03a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output(bin"nextdns version")

    # Requires root to start
    output = if OS.mac?
      "Error: permission denied"
    else
      "Error: service nextdns start: exit status 1: nextdns: unrecognized service"
    end
    assert_match output, shell_output(bin"nextdns start 2>&1", 1)
  end
end