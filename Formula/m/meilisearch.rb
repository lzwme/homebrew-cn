class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghfast.top/https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.38.0.tar.gz"
  sha256 "85addb391dbf3f70cfcbf551826e4dd123556f6341250efc69cc952151f4e9f5"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb685ebb922e82f7c1cbe5b694bb7f54b40e3802947744c1ddcfc62d97ab6c9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c43e42c35d21538209b01d43fe32f52653c26185d1240ec3122ab019aac22973"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "052195c310f94402221f18b6199917465fd81298ce776a623dc0db1f3ca1422e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c3b70e845b016a74f59f557b70a44fbbdc538f812d460f7a59cfb1b3658707c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f71100733916b7f6d1fb7a8237b2f94fb15092e9a833a3696a32503adda3fa81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f3240846aa49a47c3c993c2c5759b07523404e1a9d120ad04db6422839904e3"
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