class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.1.2",
      revision: "6b30a5333992e225ad6c19acc19a1f9e1ac06ea1"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fdb31206304426c3abbf93075e16440525a469bd213ff917ddc4c8e29a9d9f8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdb31206304426c3abbf93075e16440525a469bd213ff917ddc4c8e29a9d9f8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdb31206304426c3abbf93075e16440525a469bd213ff917ddc4c8e29a9d9f8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1233896a59c46794c04dcd80a78b8bbf1b3ebc95b505a4d2864017b977772312"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef10d30c128fed1ff25088962132a32e744ebf80845d24e34ed2584dec53f10c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24effa1da8854ae78e80c1c5cd1d6afbb3fd6371fb32c3cb8d2b583159ebb227"
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