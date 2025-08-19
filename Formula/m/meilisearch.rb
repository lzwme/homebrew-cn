class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghfast.top/https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "c3f8e88fe0c1841f67f0534992e040def89372cc57b1806965e484a88eb69e23"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3afeb180b631f85db747e5b104c38f155134da7605452775a3ea92e06f669975"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89840a077bd6e82fd87b4f1e3a68525f68787a0e469a2db5084173d7aeccf354"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b47b739884b07b56e8710fcdb5663d551e8950dc52a1948b4da82a006d449f75"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9adb68dba2c092623e5e2c8e65f221f7e3424f176ff131b7d0d91b12d2ec1f3"
    sha256 cellar: :any_skip_relocation, ventura:       "956a7ded78ee1130f2a0aec3ccf38c910363111739818c3d81b725d1efd9123b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37d504783a2a766c7c53c8c949d5420eea8275aa7e5fe39c161e88a0905142b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b16c5df4a2ed007402b2a73422d03f99bd8a845dbf0a8f3a518783aebca0dd34"
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