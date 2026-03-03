class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghfast.top/https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.37.0.tar.gz"
  sha256 "b81c00d437d15de72b90468ee8c5b66385960067590bbf7f85c3caeee46a047f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e84f289d3633e499ed679254d10b8431a5fd33b71226f68d280cf8377495420a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c63bf2a047ca99271445d9bb1b5f47940f0b7353e40c1776afd1292d0dbc4bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e6a1a689ad954e5df7822e63015e35ed5a8928c7da014d9dbc352d0f3e045e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "65868f37ac51b9ccb1ef48f3741f80bb2c3abedf0f7c91d7511bf46b84093bef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fa1116c8e231bdd90511553bdb3a35042df8a0e37e3b2ebcc8a7055b0d6cadb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b054e469f096ccb8eea93173dca4b71e027c3c1b379be50c9284b582bd85a9d7"
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