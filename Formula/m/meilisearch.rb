class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghfast.top/https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.34.0.tar.gz"
  sha256 "e900a6674382d46f91c72b3811b887c6dc0d7501977ff8d665f3fe38a09a51b5"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad56aaf4c356bb80f957be5308e201035c9480c5ab9a8de46b8c20e730cb6709"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3776c3fe0b657df0b803f86cd597e37d5e006cbdab6919cbf2a8e8326724387"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14af5c13c8ab1f8b6c81485f4665a54de4f1b08e43e41e63d2b0b5a4c770d1bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e057d83fd35014794db6e04e941d4860f18dd2a629b9a981566db70a8d0dcf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd657b2d79f96432af9a0c4c6104a124830c717e30db51e9fd91ee568e7d6a89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f045fb3ac356376a7f2b69f80fa721c60310ea11f06140d5335c4f0d437eed3d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/meilisearch")
  end

  service do
    run [opt_bin/"meilisearch", "--db-path", "#{var}/meilisearch/data.ms"]
    keep_alive false
    working_dir var
    log_path var/"log/meilisearch.log"
    error_log_path var/"log/meilisearch.log"
  end

  test do
    port = free_port
    spawn bin/"meilisearch", "--http-addr", "127.0.0.1:#{port}"
    output = shell_output("curl --silent --retry 5 --retry-connrefused 127.0.0.1:#{port}/version")
    assert_match version.to_s, output
  end
end