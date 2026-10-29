class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.12.0",
      revision: "5e215b84234e9a14baa1a37b62cbdf9aa0cda3ac"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a734227e10b17e8bafd6529eabb6c1d4554a36fe76591706f095dbc5f80f9642"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "997e33efeffc6526c9b2682dbc35987d6614ba0eff6ec32953a2e47c2d44c678"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0c693d3f60a8890383d1cd8aeafb4a5e6e34c116d5896c1b054f005be740b450"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ee017bd38a4953bf1c54bc7f6a25c8e9e7a6c75513b904b1125ea9028a39d03e"
    sha256 cellar: :any,                 x86_64_linux:      "4659d4244d93dcbf246afe9dac817128a0c330ca03360fca7a84cd7a8b2beae7"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/circleci"

    generate_completions_from_executable(bin/"circleci", "completion")
    system bin/"circleci", "man", "--output", man1/"circleci.1"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    # assert basic script execution
    assert_match(/^circleci #{version} \(\h{12}\)$/, shell_output("#{bin}/circleci version").strip)
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci config pack #{testpath}/.circleci.yml")
    assert_match "version: 2.1", output
  end
end