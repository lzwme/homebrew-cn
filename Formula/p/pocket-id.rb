class PocketId < Formula
  desc "Open-source identity provider for secure user authentication"
  homepage "https://pocket-id.org"
  url "https://ghfast.top/https://github.com/pocket-id/pocket-id/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "2ead69bed9e714171f5536b5badaa0eae2a1ce95a3af9af7359d91e07bc7bce5"
  license "BSD-2-Clause"
  head "https://github.com/pocket-id/pocket-id.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bdfb3238aab0d085cee8075c6c3af680e9860304b072afcbdc86a9d95f9c8db3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ad2ae501b6a299d2bc6807bce66ce716133a9d7a7a5cc520bbd565d40bf7ff6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a06cfe5b177988ef4526ce2bdbdda9883404cfb43e9745f43b84203f466700b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce7f3caa4f48507a007b30de5b6d1564c1ec966e9f37908ded1ff106037b68d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a7c71357ca5da6f12bd542c867ff07dfbb5ccec56143186b8cd0282a80744a6"
    sha256 cellar: :any,                 x86_64_linux:  "f53d1c172ecadf71eef365e6fb0372fa84c067e9c8c28d62c6a6116ef4685885"
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