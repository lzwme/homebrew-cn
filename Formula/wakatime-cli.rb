class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.70.1",
    revision: "ac825e98090967eb3e0eb5848e5c73b7d82d3566"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84e77a932e9addb3006b107edba1e72a8fda09edb596c297f8b0c040a6ffaf84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84e77a932e9addb3006b107edba1e72a8fda09edb596c297f8b0c040a6ffaf84"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "84e77a932e9addb3006b107edba1e72a8fda09edb596c297f8b0c040a6ffaf84"
    sha256 cellar: :any_skip_relocation, ventura:        "4f8dab3873dcd6aece83a407fc3f6eb3936640087a260886ba46393e1669a4f4"
    sha256 cellar: :any_skip_relocation, monterey:       "4f8dab3873dcd6aece83a407fc3f6eb3936640087a260886ba46393e1669a4f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f8dab3873dcd6aece83a407fc3f6eb3936640087a260886ba46393e1669a4f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af2e5cbb2eb08bd2eea6f2f16c4eb2fd598a77d16cee248d10117d1e072dd284"
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
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    output = shell_output("#{bin}/wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end