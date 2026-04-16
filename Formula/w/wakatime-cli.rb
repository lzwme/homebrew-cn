class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.3.0",
      revision: "eaf4827871a685bd1e0d0ce5db3e2604755f1c3c"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32f9790af0b23bd2d9cb356fdbf4f3994392fd2c107e2f661964565a0f327017"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32f9790af0b23bd2d9cb356fdbf4f3994392fd2c107e2f661964565a0f327017"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32f9790af0b23bd2d9cb356fdbf4f3994392fd2c107e2f661964565a0f327017"
    sha256 cellar: :any_skip_relocation, sonoma:        "3979cedac891a06375f48a97904dc3ff1183c66ff97d28f6f8ab70fd24c53822"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b23bdade14bf18564a0ea3a0aa568cc77bf8ce5dc23d676acf1db330710e507"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd2eca6c16976c9bd7a902ff575a70213e594a3fc32e709d693d36b37e05ab70"
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