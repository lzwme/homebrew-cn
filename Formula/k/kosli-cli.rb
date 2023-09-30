class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli.git",
      tag:      "v2.6.7",
      revision: "1e5efbfb01effffd14a087144e3dd1f07b572d18"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "724565c391e0ca1f666bf884e65ead437357fd8d6a7ce633209be30f99d057d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0b9a1836ec4cd58e9e3b5fc9fcc3e173a2eb9b91ac9752beb2b4426471fd3a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbf09a64381444c707ad3d452a95938fac5b919d24ea8bc6b4da9b9c04e8faa0"
    sha256 cellar: :any_skip_relocation, sonoma:         "8732428b71917aa5030f67285898614fbcd4edfbbfdaa1953126db1761605f71"
    sha256 cellar: :any_skip_relocation, ventura:        "cb77b3fdd595f026a2e1e8cead8d67d59d575f26bdf17b4d2aa8f1a89c3b5b6c"
    sha256 cellar: :any_skip_relocation, monterey:       "63b5e67abe67d67a6c5cf6131fbb7ef7739fd4fada573cc0e502b41fae8be4e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4b5b0d2e2a580d782123c6697896b90acb57d72d4298615f57a0ae8d6eb68c5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{Utils.git_head}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags: ldflags), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end