class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghfast.top/https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "23ec9f97b4bac7c2d779913b3fb6ce5ec5beb51239fdbd78a120f360ecb95826"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c5f27032b0b9ff0838005ef06212512717fc297dce190a9a5bf24f9f1d1d0c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba7bd5ea502194920ff6273be0b486e9c3310eb8039a0ecd1c0fea10c64eab9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10d11f0f9d889d1a237c52133961ab25125662123db4f7b7e66b6a01c1664e96"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d1df5f027bb28585f8980dc3c495ddc8307b878a23badac8fc10fe3deeea5fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70fda7d2c3b2bfe56513c7ea9ba25802fc44d1606fc12b0f0e620eddf0f7b96a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d12d59f3c375005a319112651686de2a6022ad114862af175b9185e184546d41"
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