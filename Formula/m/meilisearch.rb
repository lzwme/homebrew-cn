class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https:docs.meilisearch.com"
  url "https:github.commeilisearchmeilisearcharchiverefstagsv1.10.1.tar.gz"
  sha256 "171106e786222b11cf11975a208eaf1312af4461c491af53eef15a6628a6c7a7"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bdc16d377b568506b45e8a35e36751153be9a8f97a3fe76714f4446a5522f8fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76c8d8ff034116f94b0cde8c437da5f70081df93163afa3ab25905c90c4b0ccc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88c5fb0ebec7d039b5c8714c73064f56fb2a25865ad10ddb752bea0c79821a0d"
    sha256 cellar: :any_skip_relocation, sonoma:         "5367f90d1641050c049cf4f288f6df8c681b84daae9f8aafa4988da1d898d06a"
    sha256 cellar: :any_skip_relocation, ventura:        "76fdef0c46fa824aea1063272bcd56c13f905a296f6eb356bbfef961af5a3ed9"
    sha256 cellar: :any_skip_relocation, monterey:       "ee1d1b419955e467d5ca94ce6fe0fb7574f27b7b6ee138eb76080c9680650b74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95864e2f475ed3f73ad98723ed9c7547a8287f458997f6376af78bc1154af37a"
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