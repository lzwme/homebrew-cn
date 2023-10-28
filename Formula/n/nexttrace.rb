class Nexttrace < Formula
  desc "Open source visual route tracking CLI tool"
  homepage "https://github.com/nxtrace/NTrace-core"
  url "https://ghproxy.com/https://github.com/nxtrace/NTrace-core/archive/refs/tags/v1.2.3.1.tar.gz"
  sha256 "1492418da1504c0ecc9a6c6ebb61a9bd062d3d62c504c4ecd07fc190ae0ac38a"
  license "GPL-3.0-only"
  head "https://github.com/nxtrace/NTrace-core.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "373d346ac037cad7d45de4d73999ede310259ffd599b32347b4add3e6cdabb97"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9f80179e14a23ca9ecf9986761d2a9c4aefebf95d79a26b928fc3a27f1e4d19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d99946d87c1061d7edb77a457f7f379f16c47d2117328e22d61bb37dd01d5fc2"
    sha256 cellar: :any_skip_relocation, sonoma:         "f7e6d70275cf332702395c33f618e53825dd9aee604e9a977ff2b9e3e829dfd6"
    sha256 cellar: :any_skip_relocation, ventura:        "aa064555f74508222be90137a952a78ba92f4b8447af38a1801677ea3ab95352"
    sha256 cellar: :any_skip_relocation, monterey:       "307275a3a4d2769010ffc9994981dbaeb682fb9d60c6b2f285dd23c20d7935f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3219f4f58380b96e54edf85dca2840d6ae17072ca4162df34de71dbc5b0ebfbf"
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