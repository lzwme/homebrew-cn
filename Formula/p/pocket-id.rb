class PocketId < Formula
  desc "Open-source identity provider for secure user authentication"
  homepage "https://pocket-id.org"
  url "https://ghfast.top/https://github.com/pocket-id/pocket-id/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "1f8cce4c4dbb3d4c33b56eaa829d62c6c4fa1d6103156b5138ddbf7baf41d29a"
  license "BSD-2-Clause"
  head "https://github.com/pocket-id/pocket-id.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02b9be9dbaf2a3e845eb0466c5ae080fe07993e5309100642e4257f8bcae0aa3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e9145123c4f98461f540fff7760f9275147bc4d19b9c1e6139e8adaab2fb8bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61d526e8c2244bd21421419271a427c23061d24acc762ea42253ab90b0614e1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea4313c8055a9e86e567bffcce5c468e875936301e395b215a9a913f25c8a91a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20300ffca8a35fe072423539861dccecf8e30689551730d67f235e798d7ec51e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f70791782d7379c415c98409d8b0202241c83046f586efe9f163e6a4ab9c20e"
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