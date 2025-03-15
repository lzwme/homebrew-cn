class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.181.0.tar.gz"
  sha256 "df59158adcc7d74e1c87397dbad091baff0d1ae828ac75fda984ad158c479c45"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7b2fd035ed55b2cfff104279ef81f0dc6a545e3b36714cbd9ac36e202361807"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7b2fd035ed55b2cfff104279ef81f0dc6a545e3b36714cbd9ac36e202361807"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c7b2fd035ed55b2cfff104279ef81f0dc6a545e3b36714cbd9ac36e202361807"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c184b3545e96a27128c855796d9118a9f96ec4f9c6d5adb13f17fa0e538eb66"
    sha256 cellar: :any_skip_relocation, ventura:       "cb1ab2eacec5f8573722d83b6e9de0f1293be4c51b77d4f3fb3705be6149c0e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7a4ae7c28ae55c6365e3be545d6b9771af3efbdb5c9997783b69a25204a62f4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comchainloop-devchainloopappclicmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin"chainloop"), ".appcli"

    generate_completions_from_executable(bin"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}chainloop version 2>&1")

    output = shell_output("#{bin}chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end