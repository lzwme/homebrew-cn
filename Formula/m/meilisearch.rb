class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghfast.top/https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.33.0.tar.gz"
  sha256 "a7ce08cdaef27f7664e9d248a7512b77ad5baba4632bf5a0edadcdbb9bb2f272"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1cf2d17ab16c813ad33d9c1494b51b40f984d0370b4bf057a41566c526673222"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f5e08fa32a265f8ee66ca879a8c0a2bf7aa511631f9195bf5160e9b4829235b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85f0572f65db6b2357f061c2fb5bc93ce40b6282674e0c5300dff5f842a68508"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb731937461039dda4e81984ba9314660b08481a6339c6d62e6eafba4d433889"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04e1e99135c8331504c953e9fce816e71c5f83294c03934edb04fc8bad8897f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27d00ce915ee137fc4eab3179ad08ca75b0a072d4454cc207c6f352926120a20"
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