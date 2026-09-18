class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.50694",
      revision: "ea868a3151514f394db692e73eb1e2d1f1e8e9d3"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a347b76ad03cc0eadf83bd5fb892e84da32ecef0193aedc9a7b64c490c611d39"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ba0b00a4f8211a4b9025d67b8972c689a86002e3ea39a0056dfa80ae8967f634"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5d72f0e7bacc6d6a5b44a0d601718216f0b1f987f222932f3b8d605893ef4f78"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "47685caa356c819824dd946fe7cb59c9a0e61868689ed7adaa82b13d0d44c4be"
    sha256 cellar: :any,                 x86_64_linux:      "f6c536077fc742d774b9506abde325772e02cfe299d50f33b8bd1c03b5b5dcf4"
  end

  depends_on "go" => :build

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