class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://ghproxy.com/https://github.com/kosli-dev/cli/archive/refs/tags/v2.6.13.tar.gz"
  sha256 "d9f04fd54034dd3f5ef12938fd5063022aa6aaa46e8ac5b4090bc6c879ca528d"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "63b8c3d8d2415455f38bceaa2331cc6edf139ffa6016f2c382bfeda498066bfa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b84452646059bbc07c268753bcded7c8091fa524afc7274ec60ee90d5ee38cb3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "435bdb8c4925c47ac3dfda57d6855b464e2441eab956a9dea647a1e2a7b1966b"
    sha256 cellar: :any_skip_relocation, sonoma:         "8fbf925068112f11936cedb3f65cfe65740140b3e180a8d5151623f3611c2291"
    sha256 cellar: :any_skip_relocation, ventura:        "03a5c79c849e1c27ea6cf04b8408d3feca753bd6b7aa90d5b40f94bfee9885cb"
    sha256 cellar: :any_skip_relocation, monterey:       "1a24ca8e32edc54e3675b521d6e963f5f0077b6e2407cd59e7b82d42c8699fe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85eeddf727f41291ad44cbfb8097f34737be69740b8f8394b1f276e73f646ad6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
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