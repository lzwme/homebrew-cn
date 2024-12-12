class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https:autobrr.com"
  url "https:github.comautobrrautobrrarchiverefstagsv1.53.1.tar.gz"
  sha256 "ccfb5540b4b36317628a866948576a4b5f56be9a3a376c8f1a79f19644a7e3bf"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0085bae66488a6cd321b33100daff05531d8f71331a7efac10c5fc114c3790b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0085bae66488a6cd321b33100daff05531d8f71331a7efac10c5fc114c3790b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0085bae66488a6cd321b33100daff05531d8f71331a7efac10c5fc114c3790b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d09d82fd7e4cb220a55aefe78056c58ff1efe3f2f988dc5f596c0f5dfe2999cc"
    sha256 cellar: :any_skip_relocation, ventura:       "d09d82fd7e4cb220a55aefe78056c58ff1efe3f2f988dc5f596c0f5dfe2999cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4381c7105df06282345eaa815c4dfa04cffa5cd014261048fb736c8dad91a86"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "install", "--dir", "web"
    system "pnpm", "--dir", "web", "run", "build"

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"

    system "go", "build", *std_go_args(output: bin"autobrr", ldflags:), ".cmdautobrr"
    system "go", "build", *std_go_args(output: bin"autobrrctl", ldflags:), ".cmdautobrrctl"
  end

  def post_install
    (var"autobrr").mkpath
  end

  service do
    run [opt_bin"autobrr", "--config", var"autobrr"]
    keep_alive true
    log_path var"logautobrr.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}autobrrctl version")

    port = free_port

    (testpath"config.toml").write <<~TOML
      host = "127.0.0.1"
      port = #{port}
      logLevel = "INFO"
      checkForUpdates = false
      sessionSecret = "secret-session-key"
    TOML

    pid = fork do
      exec bin"autobrr", "--config", "#{testpath}"
    end
    sleep 4

    begin
      system "curl", "-s", "--fail", "http:127.0.0.1:#{port}apihealthzliveness"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end