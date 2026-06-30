class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghfast.top/https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.48.3.tar.gz"
  sha256 "a100f5d6a7ebcbf46bfd7175ed585bc193c059fd43029be0a0ddfdb87c0a253b"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a0b872fc1cda3aeb376e669f2f1c7335acb1fea0e4d33b1607a21879df48c96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e94611fc438728802f6d7b97f8d271d4304b041ebaf05aecb20dc69382124c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53acbdf3c3acbd8cc02bf340c78bde39c6a97e2c4c9d2ce3a8938c55da2ac312"
    sha256 cellar: :any_skip_relocation, sonoma:        "a95cbd0e468302937a439e164da84e5571ce81ae7dde81d8eca733f9d7adc83a"
    sha256 cellar: :any,                 arm64_linux:   "8337002a9bacbc89a7f19a31bc53af454d6698dbb335e770e1333b7e344a0331"
    sha256 cellar: :any,                 x86_64_linux:  "92fb0e46cf5e91b04fc2f7e43a454d703b79fc87b27072a0351acf1afcae4146"
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