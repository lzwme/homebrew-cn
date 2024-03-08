class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https:autobrr.com"
  url "https:github.comautobrrautobrrarchiverefstagsv1.39.1.tar.gz"
  sha256 "ae6beeba003ac1d20176e8060b749709357dd6231d730de851bb1ac34372c78c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a36524a56df79c9a5489cf89850baebb585111bcef121ae764cc03934d586e78"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efa9e4dd04e91c35fa312d472f65f58fc7baf35fbbc5b20b88efdadb0149eef9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24f3fe5c37a650e2bbf2b0d2ece3b3f49a9fe4679c7dad5051703bbcbcd1a18f"
    sha256 cellar: :any_skip_relocation, sonoma:         "59df141f2d231879748dc5fba7d81bc166e5f09290d5b62201f297f0775d28e1"
    sha256 cellar: :any_skip_relocation, ventura:        "e6be6884f23784a989e2c4d386ceb8d4e61f3a4d00939ce324d6538c79156957"
    sha256 cellar: :any_skip_relocation, monterey:       "fa8f8c61c9352c66b0057ebc31c35a0a18f1eb1bc5dc6a6dee6197c727514822"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8471e2ed35e359b7d5db4acfa2cdf14630b92dbc48e14cf6065e3fa7f33e4d58"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npx", "pnpm", "install", "--dir", "web"
    system "npx", "pnpm", "--dir", "web", "run", "build"

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

    (testpath"config.toml").write <<~EOS
      host = "127.0.0.1"
      port = #{port}
      logLevel = "INFO"
      checkForUpdates = false
      sessionSecret = "secret-session-key"
    EOS

    pid = fork do
      exec "#{bin}autobrr", "--config", "#{testpath}"
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