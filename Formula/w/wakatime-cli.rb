class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https:wakatime.com"
  url "https:github.comwakatimewakatime-cli.git",
      tag:      "v1.115.4",
      revision: "85251e6360e46a71afd0a438b9241ecd70780910"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "937a4294dbbcd7fea4464d6210daa2364828285fcabf3ef8cd1d11f1ac57ee34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "937a4294dbbcd7fea4464d6210daa2364828285fcabf3ef8cd1d11f1ac57ee34"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "937a4294dbbcd7fea4464d6210daa2364828285fcabf3ef8cd1d11f1ac57ee34"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a31678a9a205310babf552fc49bb4d944ea746b4632543e83bbb7de95c175ad"
    sha256 cellar: :any_skip_relocation, ventura:       "1a31678a9a205310babf552fc49bb4d944ea746b4632543e83bbb7de95c175ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fab8bb433c14f151d2e1c74245ab04f2fde478f2f83fb2bc3f07a9b28687a220"
  end

  depends_on "go" => :build

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    ldflags = %W[
      -s -w
      -X github.comwakatimewakatime-clipkgversion.Arch=#{arch}
      -X github.comwakatimewakatime-clipkgversion.BuildDate=#{time.iso8601}
      -X github.comwakatimewakatime-clipkgversion.Commit=#{Utils.git_head(length: 7)}
      -X github.comwakatimewakatime-clipkgversion.OS=#{OS.kernel_name.downcase}
      -X github.comwakatimewakatime-clipkgversion.Version=v#{version}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end