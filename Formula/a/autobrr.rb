class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https:autobrr.com"
  url "https:github.comautobrrautobrrarchiverefstagsv1.50.0.tar.gz"
  sha256 "0d95a264940a8751334b6c72282cf4109c55992948a04ad165dd8204f15901f2"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f1dfd195419f2c22bf5ced14f79295e329c96bb7ea0fb68e2d40bed01acef66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f1dfd195419f2c22bf5ced14f79295e329c96bb7ea0fb68e2d40bed01acef66"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f1dfd195419f2c22bf5ced14f79295e329c96bb7ea0fb68e2d40bed01acef66"
    sha256 cellar: :any_skip_relocation, sonoma:        "043122bd45ed77d72c358dbdf55cf5b9913e8c25070ac97a289bc1055d7ab7ef"
    sha256 cellar: :any_skip_relocation, ventura:       "043122bd45ed77d72c358dbdf55cf5b9913e8c25070ac97a289bc1055d7ab7ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "facf741a608e49696ab56197afa9a5e60aacf1c39f1cdb40963eb8f9d6497bc7"
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