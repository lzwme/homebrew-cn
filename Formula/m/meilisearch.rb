class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghfast.top/https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "3d82853dde450f1d7f8311ff8777f9a94205f8ceda633904bab7451b54d4b957"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "196933166377ea9cd6b45fd00dfd6a778cb3fb6f596ce66fc9dae5c77dd5967d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e69beffc3667ec1d7fe9210d20a3ba8f2ad43e5317602b4b1d7c29f9c4fb9df4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "270e82738c1a330ce42528b059b0f0cf3d761b1324f521db2a28ac004ec14af0"
    sha256 cellar: :any_skip_relocation, sonoma:        "39c34bd25b824c829394c30a79f20c7113b104386d3749f9197adbfc37509708"
    sha256 cellar: :any_skip_relocation, ventura:       "f8f723d29db4f515d60b3182e1f1f4a76bbfe8d3d39d4865d17a5944a97c4766"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "998b2152f05e9146a70fc543c813cee4d5072a48c3ca2d509e514decb8e22868"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dfcb99791dfe5a3e40e7cce77c41e3c8dccfb1175c8bf53267609c996bd8985"
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