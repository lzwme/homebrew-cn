class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghfast.top/https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "9428a053a67723b93cec0ddf5fe75b2a5354df3de987c5896b73a3d56b5fc1f7"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e90d3bf306d470e3a5ee39b3d8fbb91eabd4b54b5c1954de8622f3252ca93555"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ff22e7ec52b094ac99b305693a97973c1d815582d976509fa8a59c06a7c0fb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a77e27bfaf7f126489472407e0f3000dfcb841702c158d612d8d9a23770f5d12"
    sha256 cellar: :any_skip_relocation, sonoma:        "9310acf90fc656777f66c7c7e60cc6d0856a5d1d4f13567e8abbc290a91ec609"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2e8e9528965e2c8c33d58564ba9681a770f30b5661c9617257ca987aed684ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1967d35e920d882ec5c5eca2d86c9c69451bcbdccda2c1fbe2fe96c4d8f5f8d2"
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