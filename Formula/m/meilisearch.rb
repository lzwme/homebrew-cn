class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghfast.top/https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.51.0.tar.gz"
  sha256 "255a0113f87bf434ccfd7faa9990f3a282fdd8d272ba17e62ee286953ed0d897"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c5e6e39c8f7a9f071f9b34b615adfc5036cf7a23c96208a1a1cab0cf7a892eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21a61366335fbf86efc0b6d8cb20ec2fa8c669a4351ca7278daab2671903f8ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ac87ee2c75f0413feb8b2da30dd49c462dd0a11523727dfbf122fbb3c47835e"
    sha256 cellar: :any_skip_relocation, sonoma:        "86152ec13d310b370f8fd942cf1daf1fb0c102a6d63a7242b0ba316826d9905f"
    sha256 cellar: :any,                 arm64_linux:   "f4198f1e82b6297bedc84b3fc6b9686b33fdf6867fd32cc5a8692b404fac5cf4"
    sha256 cellar: :any,                 x86_64_linux:  "6b807d38b2620712a4d40e625fc9083be283c2a2dc7f0a9240a7bb225cbbfc02"
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
    spawn bin/"meilisearch", "--http-addr", "127.0.0.1:#{port}"
    output = shell_output("curl --silent --retry 5 --retry-connrefused 127.0.0.1:#{port}/version")
    assert_match version.to_s, output
  end
end