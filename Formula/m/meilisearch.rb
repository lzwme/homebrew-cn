class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghfast.top/https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "ac646a187446320784330d9b7759ec962f85a23e4aee7a3c278da2ed2a9d4c4f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "944d00bd0649c74b6e863c7d8eb087db7fdb212adc79270ce622e394553e53d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6598fc58a9386c5ac6f49274825d25378364be73b4d4b7451e9f7d89ace60c20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ec772853726bdd5da0f9495b59860d22bd393f2eff7bc4728ccb3c17a33b1ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "0628ceb3e138a775e04e617a7af4e76a87ffb17d8013d66352225a61de5d1529"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3de8e63a3d258bb5ada7b2fe5a655ae22b7ebc650886e9834375e543e0ab262"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e1c7809e5a22902fa61c5ee752cef7573014022af8f20e24f7a2ba9f95815e9"
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