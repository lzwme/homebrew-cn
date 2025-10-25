class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.49.0.tar.gz"
  sha256 "408142f860210e0abff7e22e42cc90e59924d486d5df858c20c0ff809ab3569d"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36d52fc45b3d5b7cb549cf60fca8c19493fe6b317e3dc1b82644c1171d5a95a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4b3b7401223a34a30792b4e82ff2bd5f8dc58df88ce28a535460596c1bbed6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df915cf90e6fb453cd79e207396f3b9923b19c4369a2df27c744d6e556d12bfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "d673322489f82091b2ad5bd38bd43ea75e9cc308fb2d3c1f6422717008a6b3d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5805068d105f6ebf354fd04f9656e82bf82bd430410bef63d6b4eb57408dba85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ede7aa3d1734a2e60dc91d18e3fecac598c53223eda9f430505008903eb9315a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "run chainloop auth login", output
  end
end