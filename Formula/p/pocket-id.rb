class PocketId < Formula
  desc "Open-source identity provider for secure user authentication"
  homepage "https://pocket-id.org"
  url "https://ghfast.top/https://github.com/pocket-id/pocket-id/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "c8296ea0b760dbf058d42cdc12eeb402a058be9d77b7b64f09d987c635fbc3c7"
  license "BSD-2-Clause"
  head "https://github.com/pocket-id/pocket-id.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "36731eb94a57492c5b9973a4408d1c78a40b0ba188c2b5921b7ecbaa877f1323"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a49458e8a23f43b3e9d5e8bae546963381ed8768929a29a2a2f277af770a1833"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "08d2636f9b1ac07f587e1745eeb0a737208e1499858b109022d67bfbc725dc93"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "712d26751d9438954c408bd0a0e66c74524a9ef15a1316f6c85ad42fb2eda118"
    sha256 cellar: :any,                 x86_64_linux:      "7e08a0309d175b9c3c16a2ac12add17e0280aacc380f9396d4b1ae3b00b29265"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  allow_network_access! :test

  def fetch
    system "pnpm", "with", "current", "--dir", "frontend", "install", "--frozen-lockfile", "--ignore-scripts"
    system "go", "mod", "download", "-C", "backend/cmd"
  end

  def install
    system "pnpm", "with", "current", "--dir", "frontend", "run", "build"
    system "go", "build", "-C", "backend/cmd", *std_go_args(output: bin/"pocket-id")
  end

  service do
    run [opt_bin/"pocket-id"]
    keep_alive true
    working_dir var/"pocket-id"
    log_path var/"log/pocket-id.log"
    error_log_path var/"log/pocket-id.log"
  end

  test do
    port = free_port
    (testpath/"test.db").write ""
    (testpath/".env").write <<~ENV
      APP_URL=http://localhost:#{port}
      ENCRYPTION_KEY=test-key-for-ci-123456789012345678901234
      DB_CONNECTION_STRING=#{testpath}/test.db
      PORT=#{port}
    ENV

    pid = spawn bin/"pocket-id"
    sleep 5

    system "curl", "-s", "--fail", "http://127.0.0.1:#{port}/health"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end