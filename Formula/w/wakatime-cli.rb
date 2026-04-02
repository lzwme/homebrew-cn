class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.0.14",
      revision: "cce6b6f47c8c8286d09642d51acd1a0887a7be7e"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b247f3fb430659cc1e171757e34c09d1555c21f3aad8c6847686a88539b4e19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b247f3fb430659cc1e171757e34c09d1555c21f3aad8c6847686a88539b4e19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b247f3fb430659cc1e171757e34c09d1555c21f3aad8c6847686a88539b4e19"
    sha256 cellar: :any_skip_relocation, sonoma:        "1923e8d36ec06059e480cd75da2f833634fc6a99053a7345acb8704100aa28f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9999adaf0af6c3a0e17d521efba16ac9af2429ea606877da7d8b73a2915cead6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8cb36eef90e7077da05b9f33700ffebb289b18bcbc94d77fff72b24d13cd264"
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