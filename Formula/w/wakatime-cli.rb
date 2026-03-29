class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.0.0",
      revision: "236e37b9f4555e91f379d187702bb8b9d52b4bf0"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c36d0940f2ce010d904256abe194cb09e1c26432ae3bcbc9a6c52ad10635e9ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c36d0940f2ce010d904256abe194cb09e1c26432ae3bcbc9a6c52ad10635e9ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c36d0940f2ce010d904256abe194cb09e1c26432ae3bcbc9a6c52ad10635e9ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "af0376e9791b669bfbc8a68168e4904320a446171fae3b7adf4c36dde67835b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ff146da5898d0d9c4d7a7592b1b7dac558a05a66d8d056d73674608152f2307"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e034aea1effbc7314b6b62b2476b7c3f7dabf161326de687d7b200837a5c0625"
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