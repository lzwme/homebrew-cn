class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https:docs.meilisearch.com"
  url "https:github.commeilisearchmeilisearcharchiverefstagsv1.13.2.tar.gz"
  sha256 "7462c72b31fb8ad737a475630813411fd52c1e5466fc8b2a4cda4d48b4a02e88"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb4bc6f4f5210f3a2fc908bdad4acbe1eafe0522316fa95161a0a298cb5b9e81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d90014ef3a87f496ba2339705074450a5f327f7925c7155a73910a36231f4348"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1bababdf4901d0ad2330b7b7c025e9faca259b2c2077926decefe9ec0809c4a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "52a986331895fa5e9de57df03db8a087b45fe9af6b2a53f2fc1ba47db138ca06"
    sha256 cellar: :any_skip_relocation, ventura:       "5267148fc3c32f57ede97e0ef2d59853b6337ffd6b4d6f202a6e4292c3862108"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3691490cd86487bcded49e87bcba55b1c9c26a86bd2ad7b70d7c932458ec283"
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