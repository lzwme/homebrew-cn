class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https:autobrr.com"
  url "https:github.comautobrrautobrrarchiverefstagsv1.46.1.tar.gz"
  sha256 "0b96dbb6d48f5063c36dc3a39d6baeabeb6ccf5974ab9bb38268be86a438fb89"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f36d0ae1a1bcca5f0ed81d6b71b410597a01fcf9f7a6c652d0928bba861a5d45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f36d0ae1a1bcca5f0ed81d6b71b410597a01fcf9f7a6c652d0928bba861a5d45"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f36d0ae1a1bcca5f0ed81d6b71b410597a01fcf9f7a6c652d0928bba861a5d45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f36d0ae1a1bcca5f0ed81d6b71b410597a01fcf9f7a6c652d0928bba861a5d45"
    sha256 cellar: :any_skip_relocation, sonoma:         "203222f1cfeab9981ec989cf7fb086b83442cf8fdc365ba8002507e8fb865140"
    sha256 cellar: :any_skip_relocation, ventura:        "203222f1cfeab9981ec989cf7fb086b83442cf8fdc365ba8002507e8fb865140"
    sha256 cellar: :any_skip_relocation, monterey:       "203222f1cfeab9981ec989cf7fb086b83442cf8fdc365ba8002507e8fb865140"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e3d17e202a7d6b5f8bd4f7ea3140db0aa427ba1d36faad0b65218ca4f9e163d"
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

    (testpath"config.toml").write <<~EOS
      host = "127.0.0.1"
      port = #{port}
      logLevel = "INFO"
      checkForUpdates = false
      sessionSecret = "secret-session-key"
    EOS

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