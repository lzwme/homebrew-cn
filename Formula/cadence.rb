class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://ghproxy.com/https://github.com/onflow/cadence/archive/v0.39.10.tar.gz"
  sha256 "2e78e650bd968c74c746e1dfb7d2be0cb798a667c0ff8a6ded7ea278cc04d92d"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d74aceff05903cd4edfe1dbde8459018504f4e1299cf8ec974b7537d50cda27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d74aceff05903cd4edfe1dbde8459018504f4e1299cf8ec974b7537d50cda27"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d74aceff05903cd4edfe1dbde8459018504f4e1299cf8ec974b7537d50cda27"
    sha256 cellar: :any_skip_relocation, ventura:        "e65d963170858956a68dc32ee3fbd5336e10788222a24241a96b3bad8948c923"
    sha256 cellar: :any_skip_relocation, monterey:       "e65d963170858956a68dc32ee3fbd5336e10788222a24241a96b3bad8948c923"
    sha256 cellar: :any_skip_relocation, big_sur:        "e65d963170858956a68dc32ee3fbd5336e10788222a24241a96b3bad8948c923"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d93e70ffe706849b004d217a8f4befc87783b1f4f9b8388abd330113f9dc1fcc"
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