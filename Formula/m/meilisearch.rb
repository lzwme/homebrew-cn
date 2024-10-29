class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https:docs.meilisearch.com"
  url "https:github.commeilisearchmeilisearcharchiverefstagsv1.11.0.tar.gz"
  sha256 "24351415cb98734fd000e40468787c71e18463a6f5978ec2801d94834bc78c32"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e8c869d29dc978c89274efacf0cb8300dc6a509956dd9f99cead72bd716b4d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53231f44fa5dd83bfec10ec83ea69163fc2d8d082047d07947b96c1ec67d3ef4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "966e6d13a8932c8f72c52519a31cab7910419bae4a3febb68ae508dd45df7b83"
    sha256 cellar: :any_skip_relocation, sonoma:        "8da1de7eb9b6ffa6882c653793e11b298da559f34d2bec99a8820b80fdd2d811"
    sha256 cellar: :any_skip_relocation, ventura:       "66a9e79c1a49a1a0b347d2c95f1c6b2efe6e147afe144b2f51b1fb63beb59d9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "106e92b73038f290948a11cdc26ba7bcc67d614eb850517ce17743b069eb0d3a"
  end

  depends_on "rust" => :build

  def install
    cd "meilisearch" do
      system "cargo", "install", *std_cargo_args
    end
  end

  service do
    run [opt_bin"meilisearch", "--db-path", "#{var}meilisearchdata.ms"]
    keep_alive false
    working_dir var
    log_path var"logmeilisearch.log"
    error_log_path var"logmeilisearch.log"
  end

  test do
    port = free_port
    fork { exec bin"meilisearch", "--http-addr", "127.0.0.1:#{port}" }
    sleep_count = Hardware::CPU.arm? ? 3 : 10
    sleep sleep_count
    output = shell_output("curl -s 127.0.0.1:#{port}version")
    assert_match version.to_s, output
  end
end