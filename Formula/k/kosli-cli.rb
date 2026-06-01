class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.23.1.tar.gz"
  sha256 "f97788cda1be2f13939ee74273985c56b88083e3ac653e82a35bb2aecd83bd2b"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8c3b724f42bb63dcf93b5c0410e589440dbaeca3b870a6ee0c0cb5557c54f7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a64d611964416da4b1aa9a44be612a75a3237adc61148459a3f530f4ade13bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cd6115b3bb2761b5f7588d8911d3fb4fdfc4d265789387115a6ba288fb041ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4a03bea8679594032b91dff6e009fbc972527cc8afdc05f0eb1d262f168c35a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3680bcdf66f5c4e04f9663a9f93133265bcf5107c1e8a94338db092740218ae1"
    sha256 cellar: :any,                 x86_64_linux:  "6ce48ffdf0bf7550c6b773c3997f91beef0790b8e972f143b1cf91be08356774"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end