class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https:wakatime.com"
  url "https:github.comwakatimewakatime-cli.git",
    tag:      "v1.102.0",
    revision: "9a2395d7f5aacf0f8213516e312dd55f85bd932c"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee54c58a80b6d581b66d03ff7526585ed146254cb81f64668c9f4f6197c4dd05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee54c58a80b6d581b66d03ff7526585ed146254cb81f64668c9f4f6197c4dd05"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ee54c58a80b6d581b66d03ff7526585ed146254cb81f64668c9f4f6197c4dd05"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f7ac381abea7eb2b4de163dc33f6864ba9d15642137bf069451c11c1d943f75"
    sha256 cellar: :any_skip_relocation, ventura:       "9f7ac381abea7eb2b4de163dc33f6864ba9d15642137bf069451c11c1d943f75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8b76566c080eab897f6e015728bdccfbda678da36e61b8d469b613090d3e2fd"
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