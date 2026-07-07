class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.31.0.tar.gz"
  sha256 "0eebe641106da120a596e1e1b77e25e9ccc9036c54e31473966d885d2f333898"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "edd64a6413d2e7b25a6b4065598fd97f3519776f5e975b9e752bff8e4f66b2e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "316ce3883daef7bc7b3ee3150d10038a405a0479c23eb4b30aacde4f5c530bcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "100c7ff08470e94e95ae7e555995ba71f01ef77e439b798149c74c83bfc6c081"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd48b1d7cbf8dc87f159dfa80195c262a41eb1a42377b4eeb52d3ed91465b619"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eebe077d00be451c914f9dee1266f093ac4f94ce166d426a5c975537c4550135"
    sha256 cellar: :any,                 x86_64_linux:  "417408c2a2ba61196ed112817e237892d5089a9aba89064a4d2194740b5cd24a"
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