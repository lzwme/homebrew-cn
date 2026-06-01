class PocketId < Formula
  desc "Open-source identity provider for secure user authentication"
  homepage "https://pocket-id.org"
  url "https://ghfast.top/https://github.com/pocket-id/pocket-id/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "d20a5b4f538ab76ceae7d8eca079afa21063d486a61035e2fff378b46945878f"
  license "BSD-2-Clause"
  head "https://github.com/pocket-id/pocket-id.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f77e972f2f6096d04e91e5a3699d7d2396a6f2d3d8fac6c1c7a1f38391ffd95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "838cc0075c2e0aea9c4b2b1e3736fa0a0bc0642fa63a1c181c10c673f7b43326"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "208a6f18fab9acc7a29c6dcfe0bd993e49684f34e41a7a4e9263063c7620d901"
    sha256 cellar: :any_skip_relocation, sonoma:        "282d53256a7f7b7f9280d8c528916fb5b376a36b11cdcd0e93865866173c98ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27fab1f42bb4c27626816a575ccd948683ab102df093d18f0b35f56b595c3ee1"
    sha256 cellar: :any,                 x86_64_linux:  "2fd1aff8d8459e0bcc75079f3766150ee938924d80069c8f6037b2fb76e8b182"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    # Prevent pnpm from downloading another copy due to `packageManager` feature
    (buildpath/"pnpm-workspace.yaml").append_lines <<~YAML
      managePackageManagerVersions: false
    YAML

    system "pnpm", "--dir", "frontend", "install", "--frozen-lockfile"
    system "pnpm", "--dir", "frontend", "run", "build"

    cd "backend/cmd" do
      system "go", "build", *std_go_args(output: bin/"pocket-id", ldflags: "-s -w")
    end

    (var/"pocket-id").mkpath
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