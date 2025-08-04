class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v1.129.1",
      revision: "a29713d4f4e53a60e5f72ca6fa26e0409847f4a0"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b84fb3140182b349d7da2893ed77083394be7096b5e04fc0991b2529ea99458"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b84fb3140182b349d7da2893ed77083394be7096b5e04fc0991b2529ea99458"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b84fb3140182b349d7da2893ed77083394be7096b5e04fc0991b2529ea99458"
    sha256 cellar: :any_skip_relocation, sonoma:        "0338782a4411dd2be0df97d2b6be7cd5bd1e5422687cbf39f12bd1412625b6e5"
    sha256 cellar: :any_skip_relocation, ventura:       "0338782a4411dd2be0df97d2b6be7cd5bd1e5422687cbf39f12bd1412625b6e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a687f8ff80cfb7b8151150de9c37c33ca4e531b9882da5d595e2f0b66aee6786"
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