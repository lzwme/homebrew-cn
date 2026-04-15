class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.2.7",
      revision: "9a9e1f7c3c7e8cc9431d69f89f83a7e51c115e80"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "355ce1a39c5397061fc57f9421bbd0789cccff08066dcb2901c90db0a1c6c2a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "355ce1a39c5397061fc57f9421bbd0789cccff08066dcb2901c90db0a1c6c2a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "355ce1a39c5397061fc57f9421bbd0789cccff08066dcb2901c90db0a1c6c2a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c67efe012d69bd7daf390b9c85ba793f811abac7ece21f8b561879dac2c05740"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60a56095a19d00949bd8d93de3216f0caac0c19c078f032c3fd0179f7c1f82b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b091ce8f115b7568b6066b36320d14ce15aa94401509bfe1bea723dab25c3295"
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