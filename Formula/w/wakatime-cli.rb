class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.1.3",
      revision: "610322c8138fb91ed5942cfc2aafadcec56f74c5"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81f3ff3eaa1096545da4fcde8fd3d3b8b378d2f4ff51ddb1000c35fb81b38b21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81f3ff3eaa1096545da4fcde8fd3d3b8b378d2f4ff51ddb1000c35fb81b38b21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81f3ff3eaa1096545da4fcde8fd3d3b8b378d2f4ff51ddb1000c35fb81b38b21"
    sha256 cellar: :any_skip_relocation, sonoma:        "049140462e36112b7b307a06ce73f4de2b2f6aef626a1ad90aff5f488fa29d9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9113e7cef44208a97cd8502040ed36b1c2cfdf51b4766646d2f20f77b02f3023"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2781c106dbf9f23f1b64a8b4a5ccee7c99b7efc81c39c46b1dea1b6c3037494"
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