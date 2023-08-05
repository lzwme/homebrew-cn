class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.73.2",
    revision: "31016a9c06f2c610ed88074dff0f6d84938b1b98"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ddef2401282b70aca3e83226803f78e2b49621964ebee9f61947f1fe52efbda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ddef2401282b70aca3e83226803f78e2b49621964ebee9f61947f1fe52efbda"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ddef2401282b70aca3e83226803f78e2b49621964ebee9f61947f1fe52efbda"
    sha256 cellar: :any_skip_relocation, ventura:        "a14319daae71c93a2fc0fc02d54ba3e5823a52efb84db363860b2e9670195769"
    sha256 cellar: :any_skip_relocation, monterey:       "a14319daae71c93a2fc0fc02d54ba3e5823a52efb84db363860b2e9670195769"
    sha256 cellar: :any_skip_relocation, big_sur:        "a14319daae71c93a2fc0fc02d54ba3e5823a52efb84db363860b2e9670195769"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "555e68dd5aff70f41b25b75a782e531139681482e55efd115027e76b95d4cad4"
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