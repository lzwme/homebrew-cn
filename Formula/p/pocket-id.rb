class PocketId < Formula
  desc "Open-source identity provider for secure user authentication"
  homepage "https://pocket-id.org"
  url "https://ghfast.top/https://github.com/pocket-id/pocket-id/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "152e7c22064922e81429fda1c04231c66364d1d6b01ba674bee7a13d237ddc27"
  license "BSD-2-Clause"
  head "https://github.com/pocket-id/pocket-id.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28f536b00fc54f979ac9a8a47c409b0fbb394f3adc486c650b6c5d8fe601ec20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69b60408b9f13441fd6d7ac110833438624ab376d674ea526066210f28a03a23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eed4801a058be610f3c182c462479d6b9cb596d54668276040670792e367d296"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f93366eebf1c4602f654bcf71d8081a542b03eaf5f068099bbf14459a35a0aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0439b67d8ca0618309abcb08d7908d625c263faa8d7b3f91285626f536f6b1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de3ce3b86f1f00388a7a117f093a90f7e8918c32e693088dea4e01fcbce538b7"
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