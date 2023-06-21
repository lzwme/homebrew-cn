class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://ghproxy.com/https://github.com/onflow/cadence/archive/v0.39.11.tar.gz"
  sha256 "b0ce9de051903be42321b80ef8a15f644c33dc52734c33e9db1297d48a218483"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9f025045f29a5adf9d7c2cecd12d16de7e7b102cb2fc84a2b86c039227f283d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9f025045f29a5adf9d7c2cecd12d16de7e7b102cb2fc84a2b86c039227f283d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9f025045f29a5adf9d7c2cecd12d16de7e7b102cb2fc84a2b86c039227f283d"
    sha256 cellar: :any_skip_relocation, ventura:        "623aa9d022d302a3d2180703c1929ccb3f275c7ee1bd7b80c9e828a85d783591"
    sha256 cellar: :any_skip_relocation, monterey:       "623aa9d022d302a3d2180703c1929ccb3f275c7ee1bd7b80c9e828a85d783591"
    sha256 cellar: :any_skip_relocation, big_sur:        "623aa9d022d302a3d2180703c1929ccb3f275c7ee1bd7b80c9e828a85d783591"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "035b6fbd7ce63dc86b381fea9dab1e53f905d75d452ac6a66f7490506bd91edd"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./runtime/cmd/main"
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main(): Int {
        return 0
      }
    EOS
    system "#{bin}/cadence", "hello.cdc"
  end
end