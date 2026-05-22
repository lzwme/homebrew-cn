class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.14.7",
      revision: "d58d10b31315eaabad5ce4da758d369c32c76e2c"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12ce761f7b367881674ec465bf26a5c55f1bc4e5ce20a06b865dde00a8d4ddea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12ce761f7b367881674ec465bf26a5c55f1bc4e5ce20a06b865dde00a8d4ddea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12ce761f7b367881674ec465bf26a5c55f1bc4e5ce20a06b865dde00a8d4ddea"
    sha256 cellar: :any_skip_relocation, sonoma:        "d72ba22193c17c7f4263036297e38d151cf1de91d9c149e31fab685cde7963c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba38edd28a1fcce8f6320b02518c4767e4ca4c0baddef7a32e8a723cd60a885f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25dad615aed5d1f2171c77f8278d9153bf59cd087fa66e40ccced3dd7e3bff86"
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