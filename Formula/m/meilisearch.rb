class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghfast.top/https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.47.0.tar.gz"
  sha256 "24d52f6ca88122c9567073fd5882124c28f8ba316a5a5b1e39a4cfff0a74d470"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a947f09a1c81f1da22b3b198b577bff84885ddf4e29ae431834a69aea24fe340"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5df6efd99bb431378c9b8f68527cbc6295024a3c245c9037fb9f8933c0a51fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5269048a58df668278eae135b84b29de1759d9aa12ffb0c8b51329d20e0d3c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f14be2c59a40b6ce7e8b8d046c9664feeaf08bf141414b0bd669c89ef5b4c10"
    sha256 cellar: :any,                 arm64_linux:   "db3d4a59bd20d9716cba7c4e7353e4bb1a9b00cd6a880a8b2811064c24b211e3"
    sha256 cellar: :any,                 x86_64_linux:  "cf3620a2234b14f2d3d0e9c22bf347b85a165b7cd7a8a967c18c9b2ae45367d7"
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