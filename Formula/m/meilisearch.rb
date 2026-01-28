class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghfast.top/https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.34.1.tar.gz"
  sha256 "279a87edce4a1d00d2fcb7e0733ca1addfffc427ba277fa61a218ab6c55a7388"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f8587a3c658a4a7567455e5adfe59e441ff68405073a6af9d0ee978711ec174"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1cc872552d8d3ca00d7ab41d28f63196d6f58740668fe91a48580079bc07541"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf427939e6e97b1ffa9c78ac8e0c3a774d9ee926bad7d882a927573903755748"
    sha256 cellar: :any_skip_relocation, sonoma:        "e42f734e3c14610a1ccecfbbc8b1a217e38dcdcfbfe032ad8c83bda0d779ca7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2a2ac538a30207b014a0155c445ef1d18a6a4f1d6f17ed623f9bc80b1b7c57d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2fdc28b0956a20cb869c7754b5385bf3d25152fd589fc500087d203519fe40a"
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