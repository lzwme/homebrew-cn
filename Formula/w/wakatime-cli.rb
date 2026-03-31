class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.0.7",
      revision: "7f5716428f40f45f5137208e661540d33110f827"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "acbfc1dd60465527c863feccdb872b2dc51421db39aa45e34b320aacb3643e2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acbfc1dd60465527c863feccdb872b2dc51421db39aa45e34b320aacb3643e2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acbfc1dd60465527c863feccdb872b2dc51421db39aa45e34b320aacb3643e2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ebb1fea737933c9c9686e8fd6082f306daef3aea85e36610ccb8573de96af86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d2cfc608a66bed91e735bf17b37ecb911fadaf78780d82f161a9a886de618e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5f0bcba7601536e8384515affc2d6c3dd49f9d781fa4a5223d5ee307cebf288"
  end

  depends_on "go" => :build

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    ldflags = %W[
      -s -w
      -X github.com/wakatime/wakatime-cli/pkg/version.Arch=#{arch}
      -X github.com/wakatime/wakatime-cli/pkg/version.BuildDate=#{time.iso8601}
      -X github.com/wakatime/wakatime-cli/pkg/version.Commit=#{Utils.git_head(length: 7)}
      -X github.com/wakatime/wakatime-cli/pkg/version.OS=#{OS.kernel_name.downcase}
      -X github.com/wakatime/wakatime-cli/pkg/version.Version=v#{version}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end