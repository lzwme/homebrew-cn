class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghfast.top/https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.30.1.tar.gz"
  sha256 "503c1eacfc28042fa96d07d31152274fc092c927bb5ca0a575c38d81ba8160b3"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "415040399a0e4dc3bc066f8eb0114d017b8ac412e68d32075d55c3e04cb43f16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a807f1b4544850a2a96bc16d22db4a7708ac0adde697198dcd6894bc31a3bb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a73d0a41607d4238f37114dcaaf876098d69ffad8afc0c0108e4e39b5615784"
    sha256 cellar: :any_skip_relocation, sonoma:        "002898ea9c6d4b821b556d559f83f3f7bdc4c946aa593acde5057f35343fff75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b2d5c033c380d7701dbcce6a3de1387fe0a1292c413e5034e4674934b80f1b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64abec07039b5446857e8be77ab484427ddfdf9392693ae4189963ebe701df3a"
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