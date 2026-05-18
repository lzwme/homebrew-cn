class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.14.2",
      revision: "36537145260d6936d95bfa38d62d92e5e69f8a3a"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88eccc8af92381cd06bea1c189afeb9517458f7326df54b1e2065171952eef22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88eccc8af92381cd06bea1c189afeb9517458f7326df54b1e2065171952eef22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88eccc8af92381cd06bea1c189afeb9517458f7326df54b1e2065171952eef22"
    sha256 cellar: :any_skip_relocation, sonoma:        "aaea71fd1f4829e0ceaabea56b71b0c1a94a884149aaf8cd1ab32bba2053a4d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0851b007f36b22c4e28c0346083640f487c4a630721050bbc2033673eacbfb6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8fe200657e6787b7ee3c6fd98222ffb6d112921c5305af969dcf7f3608762c7"
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