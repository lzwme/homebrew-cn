class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghfast.top/https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "a3fc716c43e673f478766483a5385941cb4d7913b299bbdde5295ae56f9eeda6"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91dda5d2f33618a765a56a35a0154e46e38aa3e84a21762a5cb35962d4f6e1ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d1a2df120e120825aa795f2240bc51bac40330e6298c987a27e7bc8daee9323"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "372478c9e3590ced930d46e62d622fb3ad2d9e0e99015f70e8219009c33e8876"
    sha256 cellar: :any_skip_relocation, sonoma:        "45e51d922aff98874096f355c80eabc23884631e9c6843bc081ac6449629dad0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9db75dce4408e9de960b0e09b1d7f2f0fbe3daf43a737ba3f872295d7bdbf494"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e608d1b763bf0a58e399c30fc3d8d7803b23e9442452711ebc9fe2e49d400aae"
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