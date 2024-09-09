class Nexttrace < Formula
  desc "Open source visual route tracking CLI tool"
  homepage "https:nxtrace.github.ioNTrace-core"
  url "https:github.comnxtraceNTrace-corearchiverefstagsv1.3.3.tar.gz"
  sha256 "5823ade91cb2b26aa24583582b1d996170b2efdfd7038ade46c87419cab43b3b"
  license "GPL-3.0-only"
  head "https:github.comnxtraceNTrace-core.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "139f7d7e2df64b1c590c7619e31d2e648023c8c90084561d6a5688e682f64b44"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f29e9a6e3a58b7771681e8b237afef53a552d7214f798518f48e3a14522f38f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69bd7445b228442c9942d65dd741ff3d15ce612c717495738bfb4eb93be315bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "466fa1e40126bbee1e871156e57390cb8540932932dbb4a6cef818ddf0eef133"
    sha256 cellar: :any_skip_relocation, ventura:        "3efb05ba7b8065b3b59f1b42ecd212bf010cda6c9e7b32711f7e4f266d1d7227"
    sha256 cellar: :any_skip_relocation, monterey:       "c60d0d743db01e53c022b4e2b49ab3a6235dc202807d8bf1af2f23fb11873efe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79017c76c2967c2c8f4d70443440c5ed62ccfb483c9cd910f7e6f345b335d747"
  end

  # use "go" again after https:github.comnxtraceNTrace-coreissues247 is fixed and released
  depends_on "go@1.22" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comnxtraceNTrace-coreconfig.Version=#{version}
      -X github.comnxtraceNTrace-coreconfig.CommitID=brew
      -X github.comnxtraceNTrace-coreconfig.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
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
    output = shell_output("#{bin}nexttrace --language en 1.1.1.1 2>&1", return_status)
    assert_match "[NextTrace API]", output
    assert_match version.to_s, shell_output(bin"nexttrace --version")
  end
end