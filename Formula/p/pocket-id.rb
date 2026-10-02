class PocketId < Formula
  desc "Open-source identity provider for secure user authentication"
  homepage "https://pocket-id.org"
  url "https://ghfast.top/https://github.com/pocket-id/pocket-id/archive/refs/tags/v2.17.0.tar.gz"
  sha256 "73b18d405caec36f2a7063b8f0e071a12319c8d6765235c4fc09c02c21330e84"
  license "BSD-2-Clause"
  head "https://github.com/pocket-id/pocket-id.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7705ed15097747bb0ec295b28583f727e9139681aa7ad300cce94b5c7c6a3f13"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "67df675e7c1b09e5a5b84953019faeea99701736890ee747ed42ef7338d570ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1e3aca06a1c4e6438441f1df3a0ecd707cd6ff9b16237341a40468108d55131f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7cd7b8c36f0e87a04929d6818e75d8c65edd9c72b6207cb6180e8b045deb054a"
    sha256 cellar: :any,                 x86_64_linux:      "7cab9bcf8623c1372ad3213d0150ecd1a5d43902ee236b2914c3977ac7164e8f"
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