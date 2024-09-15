class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https:wakatime.com"
  url "https:github.comwakatimewakatime-cli.git",
    tag:      "v1.98.5",
    revision: "f480c039209cba141f1a3b07143331ac8655a8ee"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e7c795d26d9f66a20616715e1d11ac9e6f1e573abb2f9edf0318a430916fe4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e7c795d26d9f66a20616715e1d11ac9e6f1e573abb2f9edf0318a430916fe4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7e7c795d26d9f66a20616715e1d11ac9e6f1e573abb2f9edf0318a430916fe4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c885931148dfbf1117502388adbb3d72e99d0f328109756136f0f3bc18985592"
    sha256 cellar: :any_skip_relocation, ventura:       "c885931148dfbf1117502388adbb3d72e99d0f328109756136f0f3bc18985592"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3e6be256b9f483252a93df0a240ac9336a92a2f780f37be9c1b245e43af49fa"
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