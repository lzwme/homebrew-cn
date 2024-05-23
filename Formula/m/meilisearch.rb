class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https:docs.meilisearch.com"
  url "https:github.commeilisearchmeilisearcharchiverefstagsv1.8.1.tar.gz"
  sha256 "1b75e79065435faecc250590cc2389f23728c9a5832df782d42114ed596d7131"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ed8322b6b0c1534aaf953e48bafa5f34342c852d1d8771a73ce1bf6e313c46a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d2dc9a9aba305c1604673f56eaac56120ac020c4ca7458a424b69952342b2d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21da88020c8b4269ebf8c6ca9033d907e63cbf6ec99dd9d4cbc9541b8f2dbfb2"
    sha256 cellar: :any_skip_relocation, sonoma:         "eac060ef7bd45912b09f726c6d225620a9df77ad3e8ee299336419be6350b09c"
    sha256 cellar: :any_skip_relocation, ventura:        "a60d5495243c24407d8a83c62cd99a33517c17752cc5f0e262e3bf12aad12c01"
    sha256 cellar: :any_skip_relocation, monterey:       "c71c821c7e09188941cb2c7db0a29b58127f9225d62c417c1f14aa75db8c1a96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7f51104116b8e419dc54e6cfbb13de1ab2e85be49fe7264c2e26668f1979d30"
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