class Nexttrace < Formula
  desc "Open source visual route tracking CLI tool"
  homepage "https://github.com/nxtrace/NTrace-core"
  url "https://ghproxy.com/https://github.com/nxtrace/NTrace-core/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "1ff9ce0d0d25078891e62ca0578ff13b1ece36e732f78a699a39909baf0030db"
  license "GPL-3.0-only"
  head "https://github.com/nxtrace/NTrace-core.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9df9e67e93b621d048edd3bb20cf3b1bea58f7976faf66f34c23268fe1a79a4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a30ccbca29041d4fa1113c20ada5c57a66e341f9aca2f57f0e7c5b93fb12356"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af7104ff20e9d2e7c9fa5fe768d4b4776005dc660a85d1422c37f53eab11cb83"
    sha256 cellar: :any_skip_relocation, sonoma:         "295cdaf91e068cf0b239620fa92c76ae61385736919eb1882ad6833657ba090e"
    sha256 cellar: :any_skip_relocation, ventura:        "f33ef941e0d9ad22af07a4047cad9c617cc9644bdf643e1708a6263e40850c37"
    sha256 cellar: :any_skip_relocation, monterey:       "6d3482230fe697df081e903bb9fb241f22de94b5e0448a7512b0ea0ac694c558"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c7899bfa0fa8b16cbdbfa96ccf064112844dcf8ea77bbc817132b8dd19fb9b2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nxtrace/NTrace-core/config.Version=#{version}
      -X github.com/nxtrace/NTrace-core/config.CommitID=brew
      -X github.com/nxtrace/NTrace-core/config.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  def caveats
    <<~EOS
      nexttrace requires root privileges so you will need to run `sudo nexttrace <ip>`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    # requires `sudo` to start
    output = shell_output(bin/"nexttrace --language en 1.1.1.1", 1)
    assert_match "[NextTrace API] preferred API IP", output
    assert_match version.to_s, shell_output(bin/"nexttrace --version")
  end
end