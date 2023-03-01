class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.68.1",
    revision: "0369af52cb8a5e806ef14fc7f3d08f54ef41e279"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "321bc334968d8b2e523a5d458d48489ced6acf09e62abdb69adcd4b91da06847"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "321bc334968d8b2e523a5d458d48489ced6acf09e62abdb69adcd4b91da06847"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "321bc334968d8b2e523a5d458d48489ced6acf09e62abdb69adcd4b91da06847"
    sha256 cellar: :any_skip_relocation, ventura:        "db1a5fd13429f7bc0fd8309e3e36c8014533b71a523517ccfa097f17d9788849"
    sha256 cellar: :any_skip_relocation, monterey:       "db1a5fd13429f7bc0fd8309e3e36c8014533b71a523517ccfa097f17d9788849"
    sha256 cellar: :any_skip_relocation, big_sur:        "db1a5fd13429f7bc0fd8309e3e36c8014533b71a523517ccfa097f17d9788849"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ddafe1d34ffdac95eaed72fb513f8c045542f34932924f0f47caf60c7f3b8d7"
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