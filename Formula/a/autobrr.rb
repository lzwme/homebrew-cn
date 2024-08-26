class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https:autobrr.com"
  url "https:github.comautobrrautobrrarchiverefstagsv1.45.0.tar.gz"
  sha256 "6ce3d421b0d691ba2556ebf80f957964d83f43b9f0eecf75aec91b6e0cc9e1e5"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3bd6350c1605055f29e9792695ce19d33c1e836dacca9ce2e5cf7b5783261276"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3bd6350c1605055f29e9792695ce19d33c1e836dacca9ce2e5cf7b5783261276"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bd6350c1605055f29e9792695ce19d33c1e836dacca9ce2e5cf7b5783261276"
    sha256 cellar: :any_skip_relocation, sonoma:         "5449e06eadcc1106a520262dade64f8a93a77b58bc5030013be1ae243959540b"
    sha256 cellar: :any_skip_relocation, ventura:        "5449e06eadcc1106a520262dade64f8a93a77b58bc5030013be1ae243959540b"
    sha256 cellar: :any_skip_relocation, monterey:       "5449e06eadcc1106a520262dade64f8a93a77b58bc5030013be1ae243959540b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0599a567aebb922964614edcd001e46025d136fecfe4be86bfa52609b67dcff8"
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