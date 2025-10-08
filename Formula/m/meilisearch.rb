class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghfast.top/https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.22.3.tar.gz"
  sha256 "9ed77ffa7bda16d0e56440d1785bed1b6332254d044c2d177a9ab2a1f784c507"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf273b4734fe0606ed9d62be6d6155f7b1f9526d75651528ae65c2af338efb87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7ab8d9653a8d77786a017c61d3be0df8a2fbbcb6d575ec4f49c9a0ea5916bee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "902623076b3b15ed5ef11555336428bd936d611ffbe872d221aac0d24f0bd56e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a80064ce0fb4c2e94ffd902d100da94cb977d3090527da4382f5dc1ea566ea54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dad3fd4e5e34c00f9c7d66417cb3c9de010a4e57e3b624424ceb2c63a120f288"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "816d403d2b77d5fbaaaa0531f0265c73075fce15c3d256520c9ca505f6e6d9c9"
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
    fork { exec bin/"meilisearch", "--http-addr", "127.0.0.1:#{port}" }
    sleep_count = Hardware::CPU.arm? ? 3 : 10
    sleep sleep_count
    output = shell_output("curl -s 127.0.0.1:#{port}/version")
    assert_match version.to_s, output
  end
end