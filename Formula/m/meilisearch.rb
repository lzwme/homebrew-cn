class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghfast.top/https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "a75ce4f64a25d45e8a22383b726f8c417dab387e32c3802526bb63272cc8dbac"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "188aef91865226f0480aaccfc77006d354632d0837fcfac21fb4a6af2e9ca8b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c65144d602d92b8972536f567cf5092a95c26a2d366fa0a7beb95c9b5e9bed7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0811155c45e674250df4fa313a070bdd3eaacac79920fb827769d89756f23e1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbeab213ed74bd05c8a1bbf4ab76eeed2f9864806a86588e6e1bbd76ed58b43a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b3932de8f1b5be915cd7bd88cec127ace5bc932316d169ac21ab4e2e0981cb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1437c896234901113569c7cd3e73002618040bfece8769fb7fbffcecef82744"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/meilisearch")
  end

  service do
    run [opt_bin/"meilisearch", "--db-path", "#{var}/meilisearch/data.ms"]
    keep_alive false
    working_dir var
    log_path var/"log/meilisearch.log"
    error_log_path var/"log/meilisearch.log"
  end

  test do
    port = free_port
    fork { exec bin/"meilisearch", "--http-addr", "127.0.0.1:#{port}" }
    sleep_count = Hardware::CPU.arm? ? 3 : 10
    sleep sleep_count
    output = shell_output("curl -s 127.0.0.1:#{port}/version")
    assert_match version.to_s, output
  end
end