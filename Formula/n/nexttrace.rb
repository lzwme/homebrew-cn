class Nexttrace < Formula
  desc "Open source visual route tracking CLI tool"
  homepage "https://nxtrace.github.io/NTrace-core/"
  url "https://ghproxy.com/https://github.com/nxtrace/NTrace-core/archive/refs/tags/v1.2.6.tar.gz"
  sha256 "3a81106d73ef5d2d85f717339088a2c9bb62aec5e7a0eef491d8a24d7640772b"
  license "GPL-3.0-only"
  head "https://github.com/nxtrace/NTrace-core.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5676e7948517d009d4cc373f2139426f91ca471e5c478415a76ec6028c8f6704"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62dd4fbd83cd08b3007855763c95bc857d23d27c53095c7ab9413e703b632b8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "919f409b37314c6cd8f05a3809bf6ebcbfdbc0a2ec45d7ff4b05d088216da752"
    sha256 cellar: :any_skip_relocation, sonoma:         "d39fd489f22e4f200771319349f0d5d9afe7490bcc0887e366c63c6d743a0e52"
    sha256 cellar: :any_skip_relocation, ventura:        "dec6ac3b134cc78645548683565bc97158532de40194f53135e4754577acabe4"
    sha256 cellar: :any_skip_relocation, monterey:       "60d2734b4850cc6d1729fda16a3b80844842ecadd9fe158f2e0fe617801e18c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b212e3aa0e2d3869feae3ddea9da041c6931857fdbb50f0c3287f667cb47d72"
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
    # requires `sudo` for linux
    return_status = OS.mac? ? 0 : 1
    output = shell_output("#{bin}/nexttrace --language en 1.1.1.1 2>&1", return_status)
    assert_match "[NextTrace API] preferred API IP", output
    assert_match version.to_s, shell_output(bin/"nexttrace --version")
  end
end