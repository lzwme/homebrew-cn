class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https:docs.meilisearch.com"
  url "https:github.commeilisearchmeilisearcharchiverefstagsv1.15.1.tar.gz"
  sha256 "67e7201a58bca5abfe23eb291c0d0261f0d81f7fd39415fbc502391d1879d63d"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8735754937ba03ee7eb2cda0f1b261e65566f0749f91ca32bf89ea6b80d91aeb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9324d9dcc6dae75a5d1544b889b4e387a8c1b936f63bdd877170fe9a0ee04dbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b31bae56bc4cc0a1d794ced72df8a1004179c1c0367a76ae02b849274ca77d12"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6cd1f5b328950b032f6089c2fe607930265cb3ed709b5b320abd82f19fa3d61"
    sha256 cellar: :any_skip_relocation, ventura:       "2163f8fab713037d68460b6fa6a03fbadc27696d93700805bced73d475765335"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9507824c796e84cf9a23ca7892316bbf7385f128a104808756a9ecb0f3ad37a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe067bc98105a14e9090b9c24f773d03167e91d24c56d53ccf61c65afa6dd564"
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