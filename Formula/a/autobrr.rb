class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https:autobrr.com"
  url "https:github.comautobrrautobrrarchiverefstagsv1.51.0.tar.gz"
  sha256 "f4598f86181ebd320d115022c4207fe2871fa75751b7b08ca07dac9352ab5528"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6c8ce17b062ce8c40da2fc39089ab735c95cc281a68016485388d6930d0d8db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6c8ce17b062ce8c40da2fc39089ab735c95cc281a68016485388d6930d0d8db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e6c8ce17b062ce8c40da2fc39089ab735c95cc281a68016485388d6930d0d8db"
    sha256 cellar: :any_skip_relocation, sonoma:        "7997fff1efbd2aa7897930f4d4cd32b5f84dfbde773925f4c36e79dede81fdcc"
    sha256 cellar: :any_skip_relocation, ventura:       "7997fff1efbd2aa7897930f4d4cd32b5f84dfbde773925f4c36e79dede81fdcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd6b189a7f751f4484459aba7b84f853a345699a28aa1f8fa93ac239456c4b24"
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