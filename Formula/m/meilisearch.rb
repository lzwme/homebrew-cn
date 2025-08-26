class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghfast.top/https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "131b5804b851b891077bcbbdfb10a4622cd124ae7a3dccdeaa214b078e6bbf9f"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b896571602faba70f19998d04d55339fbabede25655f09ddaf539f69db32ce55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "437fa028b35e6236367b6e742ee9be2ca7a6117d3b2372127b0183a65efda358"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30032168c2b8bc5a12ccd49db02dfede11bab6c3912eca00dec93f142a253367"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4588c70042b4fbb050acfc2f76cf4b11d27c4df0962562066e20bb7241f1e5a"
    sha256 cellar: :any_skip_relocation, ventura:       "84fc92611c95fe4fdf0a01a425a2c16c00e1326e04c1e68627034f2e3cf8590a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c40907b74519821cbf05dd1fbfb9da8f3caf0018b6ee7a3ec7df250eb3d0c36e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "724debd8fe02612eed45b96543c85a6431c6843520260f7bc87625b318d5cf9c"
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