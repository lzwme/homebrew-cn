class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghfast.top/https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.22.1.tar.gz"
  sha256 "7eea183fe96f088801b3d81384f1b8946e5cd961e660620c7e3d207bcd7bae42"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d99705f78e734c8523037640eeff80bb4dfe65b9b7820932560b2e29f2e2fbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "712701b5667082a4df9aade0ef043bd195e801f9048bcd198c22047b5dcdb632"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "391593eaa07b5c846b34a07178ac7c0ca7828aedf48f8c2f7b1da56c05e66ff3"
    sha256 cellar: :any_skip_relocation, sonoma:        "f90667f7f3e53dd940c72ddbbe843968156a9fa4488e3178244e466789649628"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a748f45c7701b6947e90edd18006977075cb6c306891421eb575c16e0cae36e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fde8654ed435deda82597a8ab3307e30d6f538de1ea5febb3dc37d3bdd21e8a"
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