class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https:docs.meilisearch.com"
  url "https:github.commeilisearchmeilisearcharchiverefstagsv1.12.1.tar.gz"
  sha256 "2784ea3042f8e044c6fd3f1f6c02aee8ea284e68d904e439b82406f2ee4c29ae"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73c792e2bf7f495e14f846801b71878dd9040615e65657dbd929c9547d638aa4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd92a08449cf9dc565d02beed6aa9383989e48422242b4731e12c18699d069e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed9d73befcca7dda9ec0b1e3fc82150b8617f96d8f599268f4592a9b163edad9"
    sha256 cellar: :any_skip_relocation, sonoma:        "54462317acc0a2324b01e148cd95ca96e9bbec6e08b1efcc101e87eadddbedd5"
    sha256 cellar: :any_skip_relocation, ventura:       "52d970011a0e9249982d6ee67312cdc9e29753b8fb45ca81a0d92302454779a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a75d18f14aa1692b0508f39601ceed6a4bde7d05235a3fd3064db6b0aecc09e8"
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