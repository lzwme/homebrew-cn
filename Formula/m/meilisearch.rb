class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghfast.top/https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.53.2.tar.gz"
  sha256 "01ecd573e9327e12e6b6e3f40506e319d73601c380266bb9b6da0b87b9fd7a0f"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "50343f32d047cc0a43038e76777d35906668ab98ab717e1d9653ee95f29e1b8b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1b488010a5064ec4819e770a4d01443beaae5f732c3f9e5a3552dc3310102569"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a8637c83a3882bdafe90a02d07ebecd0fc17e49d9154c09949f42a51cc567003"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "ed0fd005a659d4bdfa1489a70a110b81f26498a8bd239e831ceeada9cc277330"
    sha256 cellar: :any,                 arm64_linux:       "282b289f03ab74e1e6982cc90b64edad3255e72b0cd3f2057e6e42ab5586bdaf"
    sha256 cellar: :any,                 x86_64_linux:      "53a7f9d01df8be1f946794e78b7c0f7d1b0eecea70e5fea938fae224fa02abe3"
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