class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v1.137.0",
      revision: "9d06f7cedecd05ba57a0aedce4d3d2555d494125"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c58c10af861daf66860c20a6a7c83cb80cc16e7b32d01d2f5ca748404d79dbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c58c10af861daf66860c20a6a7c83cb80cc16e7b32d01d2f5ca748404d79dbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c58c10af861daf66860c20a6a7c83cb80cc16e7b32d01d2f5ca748404d79dbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec62641a5774953ee17abee30c6753b1bbb9b609bf8f6338ed9e5c8c69a6e784"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d68aae07e7c139ed70ac8581245458fef53a1509d7a4f4535fb241bcea64978f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2867a39305948d2a7c1b0f2fcfb4cbc05698c5aa799329f59d795dc8a86f37cd"
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