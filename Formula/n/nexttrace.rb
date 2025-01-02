class Nexttrace < Formula
  desc "Open source visual route tracking CLI tool"
  homepage "https:nxtrace.github.ioNTrace-core"
  url "https:github.comnxtraceNTrace-corearchiverefstagsv1.3.6.tar.gz"
  sha256 "ddfae697445b0e86ddada4c0871f6cd7646f26bb2653b33b09e03becdebe7ced"
  license "GPL-3.0-only"
  head "https:github.comnxtraceNTrace-core.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c57764f36ebfc297e2132aa35dc7b3b991ee4fe5d3d0706f1b5c06d1ac6fb20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffe4fae8edb111f8fa2e762a6472ecc6ae1bbf5419031959b64688a11b0e27e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eda048fdcb66d64e7b47abcd8884eca52584a0f677539dd86017258db879a6db"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e2b845a6755e635f570f9a1cc03df29417c4ef496b2ac94320fcf49319524a6"
    sha256 cellar: :any_skip_relocation, ventura:       "8fa1f225ffacfcafa8a98013465a908323f126575de7bfb132a5594cea2dee67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be00c4943af521d667ba4dc21000c6f5aeb434ad4c30683e0fc0046549362f23"
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