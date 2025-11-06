class Q < Formula
  desc "Tiny command-line DNS client with support for UDP, TCP, DoT, DoH, DoQ and ODoH"
  homepage "https://github.com/natesales/q"
  url "https://ghfast.top/https://github.com/natesales/q/archive/refs/tags/v0.19.10.tar.gz"
  sha256 "994d248ce9be9552872c6e62d20dfb0aa93919e78e9a889c40012907728a8c3e"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8eb36a748ef1e7d3788f3e8dca7714964bb1eecb7488040e151b2566e69b82e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8eb36a748ef1e7d3788f3e8dca7714964bb1eecb7488040e151b2566e69b82e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8eb36a748ef1e7d3788f3e8dca7714964bb1eecb7488040e151b2566e69b82e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "6caa1e226f9e704b29ee49439a1c67df7f0d28ceb5a9039adb042b5a8f7328f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41de6e7e399efbc87012758a02cd29b715edf074ec0481dfe4339b582c7ddcd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4d87e0aca754929a28e89a2112492f9e4448b7df7bf5247d2f3f679080db63d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/q --version")
    assert_match "ns: ns1.dnsimple.com.", shell_output("#{bin}/q brew.sh NS --format yaml")
  end
end