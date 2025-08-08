class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v1.130.1",
      revision: "a7da4de82edc4d17dfe0d78704ce7d414462db27"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df8c6c6e4ec665362dd770b44ba84fddb45de564c56914a60f11a2fd027363f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df8c6c6e4ec665362dd770b44ba84fddb45de564c56914a60f11a2fd027363f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "df8c6c6e4ec665362dd770b44ba84fddb45de564c56914a60f11a2fd027363f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3738d51c1bb6019b5606dc5a0b3ae3a203585835e04f0f4c3ff73c80092b740"
    sha256 cellar: :any_skip_relocation, ventura:       "e3738d51c1bb6019b5606dc5a0b3ae3a203585835e04f0f4c3ff73c80092b740"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fb6c24eea707db0c9f56778bf34765eca0e10a5857694cc0c4967655764d351"
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