class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https:docs.meilisearch.com"
  url "https:github.commeilisearchmeilisearcharchiverefstagsv1.15.0.tar.gz"
  sha256 "6e7f6e0474ad1d940903ff71c0369f610137849159a27335d9ba503a78d81d4a"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dde9b8292bc5f66f0d340e9077223c872de907b43b8b63aff105bdcf0a88815a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89b1bf29654fb3314d3f5e20d59d807e09e60fd34b3ec349c763bf90d3581a61"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9c8a48fd5e12682c4bc63d165223ecd318bfd894a7fa568713219ce501c3234e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec59720955d431fa8039eb89097136e915ce33e0fa373fa44c1f3dc1aa2bb052"
    sha256 cellar: :any_skip_relocation, ventura:       "3d3392e136fa4c40543044dd96cb11dfacdd1493989dccde504c48416d1b32b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f36fc54349e0877b11e8ed3168a9b0508b130eb30e51be8dd1cb01732a3c900"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e1c7d2f18fc01ad435bc58d4aa35b5de5fcc43d8bb09078cb50cc3dcdd58152"
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