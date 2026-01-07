class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghfast.top/https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.31.0.tar.gz"
  sha256 "ea5099731516b6ec03142f06503c489dd93256f090efef08c6ddef54e5d56556"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d14e76a7f13d47d7e6a16b6323a85e5267ac7d7de2adfcec64dd3457d47a5201"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17c9e578d6d5ae447ec1cc5237d72b4895166cd752b03eb7b58f95afe60c65f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3eaac30f36102f6eb2d39f702b37bb1a6a7f32fb05d6ea0ed1a35bc3e61ceeca"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8a2e1fdf88bbbd5e3c54efd3b70cd258fca541a11d08b1dd62c15650e91d272"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79a0e3b08c2307ed9f6de8594300272edae566d19a91ff94fb6cc6f2cb1a5e74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39278b3378e13253845774c6df62b7917161ae9f84cc710bea0aef9e99a39e72"
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