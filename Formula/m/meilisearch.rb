class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghfast.top/https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.54.3.tar.gz"
  sha256 "cac4e4b1ebfef7c76fc14527dca79b69501ffbf63938dfe08ffc2fcf849e283a"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4068bb3af93272972e5c9e6c4697503e9531f0b9c5a4c9d51cdf350d5f83fdb4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e7981fdc07bfc1d35fe2b4757cc6c226a497d2cf1d67ffd9238c33b8a2a00590"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0e3f223add055c3c9f9dfafcded8cd4bd9819109947d3ef65ee7becfb02cbf5d"
    sha256 cellar: :any,                 arm64_linux:       "f891857407ba4db212c9b555b3902cc2c3d71e679ab865a6bf6141cbcd02ead4"
    sha256 cellar: :any,                 x86_64_linux:      "590d76681bad9c192cfef833ce7245817c4ab5c54ea0d2f821da4b4b15ab4857"
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