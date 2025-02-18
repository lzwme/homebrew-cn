class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https:docs.meilisearch.com"
  url "https:github.commeilisearchmeilisearcharchiverefstagsv1.13.0.tar.gz"
  sha256 "cc43ef948fc2701fea894d88c08724bcac7339d029fe97937e9bc8204d6d4533"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66563c05dd42f1cb955f6043867d2a1f02e41a7fb878cd10dea7ec77ae013f9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d799e7988abf13c5c270061f0bdb8be4f9334fe71af1519dbaf58539c84e904"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "070ad9a622bc94451e7a979ab59106971783d635004e7f3ba3b729aa03658cb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "fed627fecc0bfdffe9268c583a51583bf76c89c8d199559347d8b08f12e99789"
    sha256 cellar: :any_skip_relocation, ventura:       "81e56980302084fa6dc66e29547f2d2c5696bb964b21cb3100954937aa8242ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "864f71e3a7c1ac92d25c72dbb7310b799de11294bca487547383cf251e72d520"
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