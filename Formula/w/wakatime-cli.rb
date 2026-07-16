class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.22.1",
      revision: "92616b2868a42e9b276b9a8917040a184b027b04"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a1b167eeae717b0a32635f43f4f3f7d1db3cdb08b8b4472bad205e90a03a5df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a1b167eeae717b0a32635f43f4f3f7d1db3cdb08b8b4472bad205e90a03a5df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a1b167eeae717b0a32635f43f4f3f7d1db3cdb08b8b4472bad205e90a03a5df"
    sha256 cellar: :any_skip_relocation, sonoma:        "950650ebfa037ae50d626b67de0cabe33e405bb6f4381f3e99a3fa53e0eefe5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68e66479787a00b4b2bd7bb7fbdb29eeef2945da29d3ed79d0525321a7d54864"
    sha256 cellar: :any,                 x86_64_linux:  "9a0c3e9fb866cd776c92fea2145f2f977a9fc450897b088dbf7a35d94d3c26b4"
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