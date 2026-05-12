class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.13.1",
      revision: "531adcd59e5f3dfd737607006555dfe1cffd3383"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1090ae4e82cf00ab25abdcf1595fe27946570d7ad33da86b4cdf42ddcc3a89fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1090ae4e82cf00ab25abdcf1595fe27946570d7ad33da86b4cdf42ddcc3a89fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1090ae4e82cf00ab25abdcf1595fe27946570d7ad33da86b4cdf42ddcc3a89fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0ccfbbf9bb2ef4be7e13f2a99540941e8c4a09b3283af84963d3229af71dde2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f6daa5afc619d2e30a460db5186f94877cf9d9669adcc5c569317817ed11f25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d7670a19eceac2df9887ae71d667d0676bb76c26a8449d06fd74c9c86b38cd7"
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
    generate_completions_from_executable(bin/"wakatime-cli", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end