class Nexttrace < Formula
  desc "Open source visual route tracking CLI tool"
  homepage "https:nxtrace.github.ioNTrace-core"
  url "https:github.comnxtraceNTrace-corearchiverefstagsv1.2.7.tar.gz"
  sha256 "68cffa061b6ca67359f45d797ba0c604d8ea728d98bc9cf13be8dc487de86907"
  license "GPL-3.0-only"
  head "https:github.comnxtraceNTrace-core.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d45a3cdb54727b6ded71a2481866b488556442c90a5395d6e3803fe94ca9a35"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0afbe18417c5f7f862d63b8fc646af69bbf89afaa917529809103e3f598df5c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00879fb16b7efd82d26c4a4eee291ce9fa12e79b8d8dfeb7bb677dd8a097c21b"
    sha256 cellar: :any_skip_relocation, sonoma:         "98ae6d72cc6c59ab7c99b5f76a11669696953a3de0b53b0a80ba9de031dbd435"
    sha256 cellar: :any_skip_relocation, ventura:        "a1f29eab1dff0497216c09b02c0249c33f31f202d12270b4b5e6d7a62ec3e25d"
    sha256 cellar: :any_skip_relocation, monterey:       "d62bdcc226a3cfbb45ed6e4236ad7c0de0b60aabcc68e6ee8bb3dad8db456bd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ef6874b7e6703f94b71321db8f5580044407ab13265dffc04651e65a6c258df"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comnxtraceNTrace-coreconfig.Version=#{version}
      -X github.comnxtraceNTrace-coreconfig.CommitID=brew
      -X github.comnxtraceNTrace-coreconfig.BuildDate=#{time.iso8601}
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
    output = shell_output("#{bin}nexttrace --language en 1.1.1.1 2>&1", return_status)
    assert_match "[NextTrace API]", output
    assert_match version.to_s, shell_output(bin"nexttrace --version")
  end
end