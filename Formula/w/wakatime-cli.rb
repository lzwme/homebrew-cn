class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.9.0",
      revision: "2490570f0840349e0b49f3e1e14387a422f2a580"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "816340f2b5d08bb0466ef437b6a68830db1c604e8f1839d366735735d20ceb01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "816340f2b5d08bb0466ef437b6a68830db1c604e8f1839d366735735d20ceb01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "816340f2b5d08bb0466ef437b6a68830db1c604e8f1839d366735735d20ceb01"
    sha256 cellar: :any_skip_relocation, sonoma:        "df0bdf4b966013251660c5f187d6302b0f35025565c44ae2407ac4c397bf8a92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3a559068f867e7e99ce2d85c606fec039bdad9e0cb72ced48fa8fea98d37e5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3722488f9e571d902323a5e4edcae92935f0c8b79531a7f90fc5302e8ad72b0f"
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