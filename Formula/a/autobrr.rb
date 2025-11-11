class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://ghfast.top/https://github.com/autobrr/autobrr/archive/refs/tags/v1.69.0.tar.gz"
  sha256 "3ff6814da9457355c63244fb72196934e2851a9c3df6f24081ca8a2b9bb93aa4"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6b740c77fd6e0ea0f1b32793160503113ae7e8f1048672dd517e75b5b6ba7a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b92a9da1d73c12febf9afe648ca96927a4c6f368bda8af94d947ef2df68975f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abb3cd6ad17847dabd3d213089946ec54b0a426ea1ae319a3e99b9303f235d49"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc801092dfa38ce2de3a622d475637e1dd1f4f510b5570ea344c24fe51589157"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ce64ce3efe52d3b8e58feb431f568979b1cd8317a553c790d2d104392e1c97c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6904c337d63ade73e6af3962c34e1da2c3f9d3a994a48fc1cbb0d49a272798b1"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "install", "--dir", "web"
    system "pnpm", "--dir", "web", "run", "build"

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"

    system "go", "build", *std_go_args(output: bin/"autobrr", ldflags:), "./cmd/autobrr"
    system "go", "build", *std_go_args(output: bin/"autobrrctl", ldflags:), "./cmd/autobrrctl"
  end

  def post_install
    (var/"autobrr").mkpath
  end

  service do
    run [opt_bin/"autobrr", "--config", var/"autobrr/"]
    keep_alive true
    log_path var/"log/autobrr.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/autobrrctl version")

    port = free_port

    (testpath/"config.toml").write <<~TOML
      host = "127.0.0.1"
      port = #{port}
      logLevel = "INFO"
      checkForUpdates = false
      sessionSecret = "secret-session-key"
    TOML

    pid = fork do
      exec bin/"autobrr", "--config", "#{testpath}/"
    end
    sleep 4

    begin
      system "curl", "-s", "--fail", "http://127.0.0.1:#{port}/api/healthz/liveness"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end