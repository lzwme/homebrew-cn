class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghproxy.com/https://github.com/meilisearch/meilisearch/archive/v1.3.0.tar.gz"
  sha256 "ca8092001d46ad666c16d2220a65edc25c4d9a2c385dbdecd4d90a0778d84910"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a56b1e619352a081ba4ee0e5d58b3b69a7b3f9c275d4aca6dc52a29d325c046f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c685f123faff5d0a1b19c8653ec1abcf764ef0d3685b3cdd746f514ee842385"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e725eb53fc07bd3c195764ac20e1e240abd0e65c09823fce645618fbcf231b5"
    sha256 cellar: :any_skip_relocation, ventura:        "33b75be973466962c549b90b58e52903ec624f1a3f42fc934a8853660d6a8276"
    sha256 cellar: :any_skip_relocation, monterey:       "2ebfcfe99685a51faedeb036a87fdfa58e8ef3fba4b2e69248ec5d3183f35a23"
    sha256 cellar: :any_skip_relocation, big_sur:        "50e61cd4764de3fac8da7a5273b11189d5b9e92193b54e516c0d518112a0aaa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5c13a9cd5e5ca41401a592f84d9b65b7e6ea62575be7f5618d7d946837904c0"
  end

  depends_on "rust" => :build

  def install
    cd "meilisearch" do
      system "cargo", "install", *std_cargo_args
    end
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