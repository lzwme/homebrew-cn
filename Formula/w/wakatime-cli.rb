class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.11.0",
      revision: "83f70672358aac814f88bf6952db0d81f83bf2dd"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60e02730a6bee60c77527d78e224e1417d6a3fc3d1e032df56811c6efeebce71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60e02730a6bee60c77527d78e224e1417d6a3fc3d1e032df56811c6efeebce71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60e02730a6bee60c77527d78e224e1417d6a3fc3d1e032df56811c6efeebce71"
    sha256 cellar: :any_skip_relocation, sonoma:        "0dc1888973311e8b805fa91e2c7c236187ec08f5f67f0415fd1038d6503b2aae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0af56471fba51da5b1c22588f2c83b495e6e3dcf6b15d4ddbff351904735ed95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "253fc02b71f427d752e00add2572ea5728e27450a1a5ec47d16268432001d899"
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