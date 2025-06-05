class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https:www.openpolicyagent.org"
  url "https:github.comopen-policy-agentopaarchiverefstagsv1.5.1.tar.gz"
  sha256 "ea34c1f9a27501d0c6313f96bf33665333c395536bf6a849c6d0253c5a807795"
  license "Apache-2.0"
  head "https:github.comopen-policy-agentopa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7021f2a9354cd1f49a1e232c67c8068bea714652032c85495bdb761b2348a4a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c360b098c94fa5244a59305e5ba384f85d63832fca558808b29722329927bbb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "33791bbdcdabb38dc20fb75c3df6351740a0952031ce909f5c4a0636f0a69dae"
    sha256 cellar: :any_skip_relocation, sonoma:        "770397dea31bd408649c9dd13aff6a350da48218b4a7ddb4ac89a2dcaf370cf4"
    sha256 cellar: :any_skip_relocation, ventura:       "8e21334a4866aeee366697aa1f6ac1b729094ae0a885b8aad34b716b98d3c4f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eddb52b6ea76a306fdb9059ffb9c15e074323b5a3770594f6c322d4a9a663884"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comopen-policy-agentopaversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    system ".buildgen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin"opa", "completion")
  end

  test do
    output = shell_output("#{bin}opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}opa version 2>&1")
  end
end