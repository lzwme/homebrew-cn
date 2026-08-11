class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghfast.top/https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.53.0.tar.gz"
  sha256 "df39811b5dc74e7fc2fa2d523e94fc5d5325cdc23d36e0a20e289e397521a22f"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c36e32c9915232e262da6edce158ef1f3994b0bb92370c3d3c70dd412f2ab23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6aa96150590fa6fed8a6e49672357c5df969c177298156a693661d6a4e02a73d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5946e3fd895740ba14ff37cc6c4ae5613e60d2bf1778dde2373bc497caf802f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1cc8f360e6bc1cf30a89a5309e8c4c71356bb6bbf475ed6bcf381a2b0ea6278"
    sha256 cellar: :any,                 arm64_linux:   "35c2fec5b79d48ad9fec0aae00098ee10b7ba0a26b97641aecd328dc3c804557"
    sha256 cellar: :any,                 x86_64_linux:  "263b55ea7c59d1740d3e9f1c9303a7e9f95c8fd26874c851b49970eaefa36fac"
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