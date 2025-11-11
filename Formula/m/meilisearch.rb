class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghfast.top/https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "3a2738e4fc4f31b5990d613196c254656869c34a7926ee3f1138101c853cb242"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "139967c6e2546b34c900078702d95fac808de9f303898426d241dcce8714b143"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47f6049fd9445edbc89ee60851f41e7f906269b175ab82226b93646e5b616916"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfb6f4fce4b263dd899bb3b8870397ce50e9c1a014d0ee21aefc643a88007b6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "09fc15b2caeae2b038aa7b4649fafe6beabbffef626db05ec7d21215ff971e4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25bbcc3ef4a389ba2cf39fa9814b5577b2c791bd7a0be797f91cacb13d083533"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69dbf3edb8163212c2b01eacd37c05947745b1c8f264b4dc2d28bcfacbd95ee4"
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