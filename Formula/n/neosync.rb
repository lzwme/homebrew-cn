class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.92.tar.gz"
  sha256 "e7ba2ced001db6d07542918ed41ad1958e504ae2255505b6b93bc6089c994c84"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a28acd3b74d5e33e0c7a4da8c15c16a6d506119db8d1f7f493e60b7e60ad148a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a28acd3b74d5e33e0c7a4da8c15c16a6d506119db8d1f7f493e60b7e60ad148a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a28acd3b74d5e33e0c7a4da8c15c16a6d506119db8d1f7f493e60b7e60ad148a"
    sha256 cellar: :any_skip_relocation, sonoma:        "bab568f7aed340d8242db85153e7c0ae7654e780b4ba15633c98f9762d104229"
    sha256 cellar: :any_skip_relocation, ventura:       "bab568f7aed340d8242db85153e7c0ae7654e780b4ba15633c98f9762d104229"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc299a5280b2ff8fa987f15b7dcb7e3417d5614143c427cbb3607fe9a88f6f5f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comnucleuscloudneosynccliinternalversion.gitVersion=#{version}
      -X github.comnucleuscloudneosynccliinternalversion.gitCommit=#{tap.user}
      -X github.comnucleuscloudneosynccliinternalversion.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".clicmdneosync"

    generate_completions_from_executable(bin"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}neosync connections list 2>&1", 1)
    assert_match "connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end