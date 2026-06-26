class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.102.1.tar.gz"
  sha256 "1d0b4c1a761ee5207684e5d3b215eb33ad327d25422feb027883bb0ae6d021b7"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d41111a3a45d29dfde1f6b068d216bfe07bdffafcb5e213af3efd5bebe83994"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d41111a3a45d29dfde1f6b068d216bfe07bdffafcb5e213af3efd5bebe83994"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d41111a3a45d29dfde1f6b068d216bfe07bdffafcb5e213af3efd5bebe83994"
    sha256 cellar: :any_skip_relocation, sonoma:        "269486231bd9cc48aa77003fa8f1f44dbbf621704dcd6e760b738c2175ee722f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fbd4d306054219a246ceceb63331fa7dd8bc0cf127dc8c159d3e2d1c5117155"
    sha256 cellar: :any,                 x86_64_linux:  "77bcc9fb06149ef7a200009a7738d377196227293b9c8e3402846356607cde38"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "chainloop auth login", output
  end
end