class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghfast.top/https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "470812c36ff4f90ea0b97c072a3b68d4b3dc2e814293f40e5fbe863d030d97b6"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "220551c0a2a85caf1189bf467e6fab7df161bd64951b075d5b9ef626f43738eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf511a25d351c12dbcf1f830bbd4eda3e9152eb506244089c465964b5209f72f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3afe180594df68e677f9648f984695959fb36f05b651e40f484cb4179ec86a67"
    sha256 cellar: :any_skip_relocation, sonoma:        "93f0141389439e1425b106b5c9553f6a6757866809fc3e325345ad975cf3bb67"
    sha256 cellar: :any_skip_relocation, ventura:       "0da746759174f410e6cebfdc251b807751364613e5d1674c1c7c44dec3497f0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eaa98a74a858768d3c2d34ec523a9dc845fbf2c9bc72f74384d66db4b13ba914"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cfeb0dff3e8d3a4f540d3594b2bebba8f29a988bdc8314fa992a855cacb37ea"
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