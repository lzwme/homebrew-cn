class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v1.127.0",
      revision: "a69e7a688909867b79a14f43b8ec3b717fba143f"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "992267d0be1ec9e19a70f28cb212a230f15f1d5b6aa00d24e327e27fe49a7554"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "992267d0be1ec9e19a70f28cb212a230f15f1d5b6aa00d24e327e27fe49a7554"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "992267d0be1ec9e19a70f28cb212a230f15f1d5b6aa00d24e327e27fe49a7554"
    sha256 cellar: :any_skip_relocation, sonoma:        "989001c1809e96ac49ee98540c1d9d7043c50fcc651981403b32649b280af5eb"
    sha256 cellar: :any_skip_relocation, ventura:       "989001c1809e96ac49ee98540c1d9d7043c50fcc651981403b32649b280af5eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1af3d043f8091544525d21c96a8077e6c532d2a658dca4fbf90504d44c7752b5"
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