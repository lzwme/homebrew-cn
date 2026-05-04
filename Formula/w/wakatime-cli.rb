class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.11.3",
      revision: "25335e654ea6fcf0694e5e5706e0607bdf12cd64"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78980f0418f4d43da847c0824c86023cb47b271842f12fc38d9551fca3c29735"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78980f0418f4d43da847c0824c86023cb47b271842f12fc38d9551fca3c29735"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78980f0418f4d43da847c0824c86023cb47b271842f12fc38d9551fca3c29735"
    sha256 cellar: :any_skip_relocation, sonoma:        "af8f74279dd80b8b3d6461add9c0c5c4d4ad8cd69ca21f798a8271c6be46290a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6b3544acde57202d8dfbe65dbaa2f3dfb3f2206f2314dc135bfeb586e594422"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3249c382af8d333611a97586c9568b7cc64658ac058bdef5544532d0086dd121"
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