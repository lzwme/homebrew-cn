class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https:www.openpolicyagent.org"
  url "https:github.comopen-policy-agentopaarchiverefstagsv1.2.0.tar.gz"
  sha256 "d6dfed400d5d3beacd97300a59b1d557f0ec5903571625a98d79cf9d09ce547a"
  license "Apache-2.0"
  head "https:github.comopen-policy-agentopa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f77ee5cda543c9152dfe7cecbbbfdf9614a27b33a0d8a338550ffd685557b46b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5e684f771b1171703e89a481b91ebf698fd638227c6345a2f2e195eeb7f8346"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a09fe81f6a9747283aef7dd49b595cfa81647046cf14a1af8c52e838de1545c"
    sha256 cellar: :any_skip_relocation, sonoma:        "75f278d86cc37b9f1eaa56c98a568512b1af8605e8d4158ff636fc068db7ddbc"
    sha256 cellar: :any_skip_relocation, ventura:       "48d6e54b736602aa3394ebace1988495d8ab3ed399aa8fe95d437caebc34c16a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68923c5c8345b6e53ac6cc8608a738ec92ddbabae8d7c91594fa7d08d1c2e0b5"
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