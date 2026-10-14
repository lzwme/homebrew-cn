class Algolia < Formula
  desc "Command-line tool to manage Algolia applications, accounts, and search resources"
  homepage "https://www.algolia.com/doc/tools/cli/get-started"
  url "https://ghfast.top/https://github.com/algolia/cli/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "e6e3474376bbe82a171a33d996a6df8f413dc75ee9225fe6a53eed83fb8f78cc"
  license "MIT"
  head "https://github.com/algolia/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "435b641687ade9c0988f371280f1bb9f7ad1be9cb3d16cb550506495940a2096"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "435b641687ade9c0988f371280f1bb9f7ad1be9cb3d16cb550506495940a2096"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "435b641687ade9c0988f371280f1bb9f7ad1be9cb3d16cb550506495940a2096"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7c4b1de891d99e09653c7d2ca373a6643f97fa88dcd6dc2b5d63a3abeda4574b"
    sha256 cellar: :any,                 x86_64_linux:      "ae03430e80d2292e2f810423607b883c342b0c3f2bbaa17c3f9170d59348fb13"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/algolia/cli/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/algolia"

    generate_completions_from_executable(bin/"algolia", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/algolia --version")

    output = shell_output("#{bin}/algolia apikeys list 2>&1", 4)
    assert_match "you have not configured your Application ID yet", output
  end
end