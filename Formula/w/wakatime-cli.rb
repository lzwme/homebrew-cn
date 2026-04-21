class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.6.2",
      revision: "b877ba2ab10ff85bb2686f7f64b012d291ab2d0a"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1fecf34576f3fd219bbd0fad74bd040e7a39412be9bf0492583e38945a94392"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1fecf34576f3fd219bbd0fad74bd040e7a39412be9bf0492583e38945a94392"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1fecf34576f3fd219bbd0fad74bd040e7a39412be9bf0492583e38945a94392"
    sha256 cellar: :any_skip_relocation, sonoma:        "9cafa0a79059ff2a606445b5f3d7fd108082bb43b8a7e5cad594625846252d0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af3a6fa0f498ff70f16a5c7b49dbf7efaa622a0875a47fabb321aa17ec62c763"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6476ebe0dee2f4b8f68c26ca209bd9fc920a1ebc6d1f10f6d5ee0347b9d3abe5"
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