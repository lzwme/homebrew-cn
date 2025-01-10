class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https:docs.meilisearch.com"
  url "https:github.commeilisearchmeilisearcharchiverefstagsv1.12.2.tar.gz"
  sha256 "32d7d95aa5afda051eb3ee3d909445ce8c1936b9eb665eb050fc2685e4537bac"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16edb385dc72e704785a6755f55eedbc13247f277d0f0c67aecbbcdbced7d9e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b626ac204869dab95dfc0f9f8af683247eb7cce2359d3c5429e880398279e84"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "00086f521ae7d51535e5a32e61a1592919e467bd75fe22ca9598106a18900bdf"
    sha256 cellar: :any_skip_relocation, sonoma:        "3492843c09b3fe95755218a262adbb6680db9a8b3abea8706fa0feecda55a1d2"
    sha256 cellar: :any_skip_relocation, ventura:       "7ebaffc5c75e414759a067d05e24ad780b2345a16e4c1174dbf7352f3c0e0ab9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aceca20a0dd932a120344feb2fb6e762ee3cdb9889f34c6b3a8af1de66f03743"
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