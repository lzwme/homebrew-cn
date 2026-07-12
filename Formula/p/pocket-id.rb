class PocketId < Formula
  desc "Open-source identity provider for secure user authentication"
  homepage "https://pocket-id.org"
  url "https://ghfast.top/https://github.com/pocket-id/pocket-id/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "6748470f32a84fa46ff48383739ab44285acc8214f8afaf1b7b81935b112ec09"
  license "BSD-2-Clause"
  head "https://github.com/pocket-id/pocket-id.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb5adb1cc99de5ee182e8e36c41141cbbc1a0783af818f0f3f355aaa0df192da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41b91708d217a0aa26bcac9c08cfc19208b335c33ae151332e5f4abd121affdf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab04b99a41532b89d82cfaee855ba0053e8d1cad563b0fb98380f88e0c7858ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d7265711995d99d5824ca6bddf14a90c9d54b5fa5105b1a7cd860ebc659c632"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efa4ff899df632be9f5721e4c3233863d485e2584695e2e742f21864b01d34bb"
    sha256 cellar: :any,                 x86_64_linux:  "4b3047a2810f4c04ec272fa70db6857e8b1df2b2c1bd8f45e4e20b86e8fa8306"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "with", "current", "--dir", "frontend", "install", "--frozen-lockfile", "--ignore-scripts"
    system "pnpm", "with", "current", "--dir", "frontend", "run", "build"
    system "go", "build", "-C", "backend/cmd", *std_go_args(output: bin/"pocket-id", ldflags: "-s -w")
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