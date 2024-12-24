class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https:docs.meilisearch.com"
  url "https:github.commeilisearchmeilisearcharchiverefstagsv1.12.0.tar.gz"
  sha256 "ea0afbec8c653fac621dde16b393c4a9e633a7e0f8468e91d869105504208478"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e59254705f13fb7c88df60e4e2465fe68583b301c3f0c71d9005164fc27dfb7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fd012867d7da810183f6f1de933bb389eb7d8a76d13899dcaae242be032d6df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "14104c13298d544d18b92db6b92171035e0fa028731f872ffcde9494f8a9852b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2ce1deec8755d1245723c78168289907ebd4319a94cb245f4a415ffa74891b3"
    sha256 cellar: :any_skip_relocation, ventura:       "b9dfc6e957656a60f75a325e1ab296cddb2bedf67f3af782ba9347d2a7b94da4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75911c189cf0bc3e22bf790f466068e920da7996ffafbfe29779600a49179c0a"
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