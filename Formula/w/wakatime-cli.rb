class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v1.132.0",
      revision: "ccfd1f14f534b31dd5c15aeddfb3b4cbbae6f006"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "174d094210cc3da229af4217b7d1f5838b72861af1b564254954520b031cd598"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "174d094210cc3da229af4217b7d1f5838b72861af1b564254954520b031cd598"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "174d094210cc3da229af4217b7d1f5838b72861af1b564254954520b031cd598"
    sha256 cellar: :any_skip_relocation, sonoma:        "2583f211645a9922657ec9aeda571aba0ec405e6ed059fd71ecafd921fbcee4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2b1bf059f99f87cbb391cee825329fcd2121b44f96b676310434b4979d4c424"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d2c3b72bba0974722d846d16eec850be6196a1e6160bd25858f68cab34fd70e"
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