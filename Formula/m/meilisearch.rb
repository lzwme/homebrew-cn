class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghfast.top/https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.32.0.tar.gz"
  sha256 "bb6a700f0383d6bbbaf9029baa7e743c35be93a36cf9df626ac13aa33ab888a9"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1c1d50751a6b098e2bc3a295bb583a101c9c0115633c924f5f3a33264287d54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebfe493423e22d9b6c156c55067780d4e8a7b86bf7a51609e97f71a0d775ba68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60dbfcc458e0ccf1142a5a1c42c3b62ca38c76747eef2ac0b8ebcdb6070dfac8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee4e559fed384010eef9975a4fef67a7cd54b954262ac24f25636c421bd4ce78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7b1ced0ea7449d5e9f463ec8258a03e979a7f631a39490db50326eb0061b3c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de3a4da0998cfb124d24a169418b5fb78fbe98010d5681b3fec8a1776f018b08"
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