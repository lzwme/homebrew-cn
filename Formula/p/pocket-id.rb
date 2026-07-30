class PocketId < Formula
  desc "Open-source identity provider for secure user authentication"
  homepage "https://pocket-id.org"
  url "https://ghfast.top/https://github.com/pocket-id/pocket-id/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "7f8312ecb6545aa6e379af819db3f0800ce6fcf755dd2161ed3326fbb90a4166"
  license "BSD-2-Clause"
  head "https://github.com/pocket-id/pocket-id.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78e60ac5cfcf19cbbcfb419f0eba301557c831bdfc27711e7ef61087c245018f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5ad5a6590de243644552190e5ce0cabc44185e336c599c89ad85da4e15c9244"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e119c294a2a2ffd5dfaee015de5d6d21d64778d366b02bb9ccd926caeb8a5cb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d1e9fb2327034aceaefa017ff12bd198c21bec4769500e24376a7c7e23cafc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b75dfc50c99283223b1da2ea4d910762a522e12f03e6283694c1e67c95557edc"
    sha256 cellar: :any,                 x86_64_linux:  "0c6ca5b1555a865cc348901ea88984c5c2982e89ad16dd595e35a80c824b2055"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "with", "current", "--dir", "frontend", "install", "--frozen-lockfile", "--ignore-scripts"
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
    Process.kill("TERM", pid) if pid
    Process.wait(pid) if pid
  end
end