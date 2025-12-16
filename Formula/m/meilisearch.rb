class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghfast.top/https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "685a6399f2a857b9714273c697e69e9f26f4739db9848d38d942c09182695f53"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d8c8213d5ab2c95aeb07744f4a06fcac399f1bb4285942123ef50748aca5e75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5dc5edb86dc1e1c73020c2c668ff474524f50c1d29f6545f3976447757392fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a3b524fa07fe08da26de1696af09f92b5338f4dcd6ffa855b7c47cc72f2f424"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5a65748b2f3da262d8ecf8bc43b71272578cb3a599998591e9270e7651f8995"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "452a7f6ee425ef5b2f2ca313c83c2ff9e2f051b14d2d7511892c70adce0d617a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1abc53eabbed651d5721ceb5b38c36f63e5c84a892b230938d09a32c7b067c9"
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