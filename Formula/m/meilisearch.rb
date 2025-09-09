class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghfast.top/https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "3f3e810d2e105153645d123ebdbc7e00297c6bebac273ab6ea2dbba0e78c51b1"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3a9b2b62e40252fcae3171b1acae1943401e9c8706c5ea34b57dfaf1bc7ef60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "543ce9e8cc8fd2b39ae17ab4252e66bc1b2706a0e7b177bc9fb15a4c68decabc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fc0dade83e5a3a50826e920a259eca2503e37b8e52d8e1ed3298f6f72e3c483d"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf9f4736102c6dfd2fecd46f9a2433f1afe92bd561b690548094b6af25d3a011"
    sha256 cellar: :any_skip_relocation, ventura:       "250ed6294eb80e7cfd62e105004c5ca9def32a5de7368a978012fe668175a977"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f69267cc6aedb67160646a1da8f671d0233b8374726444152a44016879e2674e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d00c8aa01be140fc3d2f48e65b1affa147533b6f41bb116c6a832002aabe9a5d"
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