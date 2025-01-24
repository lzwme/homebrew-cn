class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https:docs.meilisearch.com"
  url "https:github.commeilisearchmeilisearcharchiverefstagsv1.12.7.tar.gz"
  sha256 "ede32402654b5165d904f6ba60f5ec79be7c035a74d081687e9f63b8f268f8a3"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "735e0afbc84d8472baeed13aba6b3c1aa6e979760e9ad8bf8e9050c86da7d4dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d37ada5733a94f75a0042e91f430bba428083d131f87971015369c0c9eeb2ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e22a787ed6189a0bd3488b1c734e26faeaf2f557f3709402f488913047eb16f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9710745b06395d04578ab7cf6c331d405bf66abe91e8b5a48f3b5ca0e74928ec"
    sha256 cellar: :any_skip_relocation, ventura:       "dfa665b24bfd47d5e88c69c6d33fbe09d375b5ddf5566b295d328fe6b587ec80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f476fa8db50c838e276e0a0dcc3b3343cdf24fd23241db4fb13034cf8050825"
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