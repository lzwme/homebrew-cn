class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https:docs.meilisearch.com"
  url "https:github.commeilisearchmeilisearcharchiverefstagsv1.13.1.tar.gz"
  sha256 "4c11a9c3118ad1cf71345fdab0f5aed71e07e0499dabc5ab4dca6ebe666f3b80"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4ca65d1e684301ff5c0ae204d9e48076f662842d5fcf78d8887ade2a5b9b215"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec28ea7df2a5be602363d099247eb13732676e4d6fd29e7d07c252cd3d57e471"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a2a61899ce0f5bcf8b17eecac43e972cd5ac46aa4554f9186901332b99a1172d"
    sha256 cellar: :any_skip_relocation, sonoma:        "313583b52b3f6d1c3db2e85157723cf0f9dfb7ffd05dca613a3f63b1c114fd02"
    sha256 cellar: :any_skip_relocation, ventura:       "9637a3a9544708e689c9454e362d3dc7f5d1c99d997e7bfd0f57fc286c5b0a19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3d88cfb733062793e0061aeac78760b15eb4467391ac65fe59a80f846517d45"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratesmeilisearch")
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