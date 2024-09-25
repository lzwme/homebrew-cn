class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https:docs.meilisearch.com"
  url "https:github.commeilisearchmeilisearcharchiverefstagsv1.10.2.tar.gz"
  sha256 "d209bc617be767bcd8e58d722bc3ca8d662bdcc83823017d33cf0094179bc62d"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7264882172be4c732c72d9ea429e45f06907b3e9c5a337ee02ff1dcee8dff704"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6c11a5192fe979954f96fe9609915a79ee044c508f32d78aaf0b6a5f65f2efd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f75cb5481e5525556dade4506db9af42c7c19be9df390c7be8be82d94ec7265"
    sha256 cellar: :any_skip_relocation, sonoma:        "3506f962673497ddadbfeb6440de8399eaf2ceea43cb846d7794301d52f1d5bd"
    sha256 cellar: :any_skip_relocation, ventura:       "a787367b62bb8708fc5cb2ab86b09b387b0ad4f57735f0c60deff316fed035b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbcd52ccb92e0abd8f84bf8b329a3622a5fbc7a976046afb19fb7527f14a0ff3"
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