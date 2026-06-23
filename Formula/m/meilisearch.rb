class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghfast.top/https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.48.1.tar.gz"
  sha256 "150fdf26cf47b982b0e474ae4b053b3dc643f6613622476925b938503046579f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11502caaee83674cc018659b4df06d74ab5d79144d14ec410497715c76459a83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66f829db274310b6683607ecd8981c083a5b6e8b66df2c89048fce91e461f3c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d616b94a8ea16f2bfc5c91131afe21ecac0cb58c58c6a7d740301b61adef842d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae07721107b645999c57b66128498f3aebca37bb3e6ef11df70f8bd1667253dc"
    sha256 cellar: :any,                 arm64_linux:   "bbe7f222a8e446d255b3a75923677595963838877f1dbaecbce0a5322ef5abf1"
    sha256 cellar: :any,                 x86_64_linux:  "ffed4a1ed45cd3e4ea5b12fbff09b21cc6595bbcd9c7ebdef87f73fc68945976"
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