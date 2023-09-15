class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://ghproxy.com/https://github.com/onflow/cadence/archive/v0.41.0.tar.gz"
  sha256 "060824c5aa4c1f0db931f37302d706e1c31abc81d77e166b48f44b9656db515b"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "384d78497eee47e862ab4fd2cd4eb1192f80e01026c41c482199083b951b67cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "522d365601770d0e9742348d031c366b153161c277d230e08df7c8e844beb610"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c234852ae0aa9f555562ff4bd62503f25aed8be9c23f282a9a9adbe8ccabcf6"
    sha256 cellar: :any_skip_relocation, ventura:        "2ef27c8523c44eb49e0dca6491bb6c8c28b8dcc4877a2fe31d4ef8c9d0a30d90"
    sha256 cellar: :any_skip_relocation, monterey:       "82d1beb7ff39f0258b282d5e537c6a8cc0ad65715430c3ec5c51e825874c7afe"
    sha256 cellar: :any_skip_relocation, big_sur:        "a50dc18fb9e6276670aa88fc6966f10199d3e67e0da2632e9b99450d998e374b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "faad3d6bd4228a9c7b43aad34b15775f4cd0519d9a0b108f43666c8c0dd45190"
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