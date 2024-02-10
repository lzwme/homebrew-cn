class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https:autobrr.com"
  url "https:github.comautobrrautobrrarchiverefstagsv1.36.0.tar.gz"
  sha256 "631ee5f858c5952e1d7a8c27b13fe33aea9021ffd814bb540f0e494291168309"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4101f0e10b3ea44eda1ed2841a377f583126970cace67f06e6af8254a6de9ddf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8c85936be47f23027db8dfbbfa4ebe492c445b9208794b551acd1b679c1f742"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25d8aeee0a9b772ff23bda09aa87f4c7f644fdd6b7e7c51b600e7463c56690d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d242aae47f297fb9b77b956ced9422010d3978a8c4cb2a3486d1b1f5cd18553"
    sha256 cellar: :any_skip_relocation, ventura:        "164decb89c963f05481e499610f28f6eb122bbcb1437854c51ffb936b5365111"
    sha256 cellar: :any_skip_relocation, monterey:       "f1e6b0dabe8f0846c892317ba62cc1b06fd34af2617bb38fa9225e60c6b0d3a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95adc355ece9f48ddb921001757c0a230a89fc137ccc1ea718967f5b6388a8fa"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npx", "pnpm", "install", "--dir", "web"
    system "npx", "pnpm", "--dir", "web", "run", "build"

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"

    system "go", "build", *std_go_args(output: bin"autobrr", ldflags: ldflags), ".cmdautobrr"
    system "go", "build", *std_go_args(output: bin"autobrrctl", ldflags: ldflags), ".cmdautobrrctl"
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