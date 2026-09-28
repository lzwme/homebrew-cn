class Tinyice < Formula
  desc "Modern, all-in-one Icecast-compatible audio/video streaming server"
  homepage "https://datanoisetv.github.io/tinyice/"
  url "https://ghfast.top/https://github.com/DatanoiseTV/tinyice/archive/refs/tags/v2.12.1.tar.gz"
  sha256 "895b38b9c7083413b492cb32bb9311c3b305ad29e2f80087b6c881ee874ff294"
  license "Apache-2.0"
  head "https://github.com/DatanoiseTV/tinyice.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2982428702ea69ec0a018e0f047f47ba6de89de6278c98d624cb41b49f481843"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2982428702ea69ec0a018e0f047f47ba6de89de6278c98d624cb41b49f481843"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2982428702ea69ec0a018e0f047f47ba6de89de6278c98d624cb41b49f481843"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d47375329d5b2cd5a8ab60da0d423164fa7cdc8a0582b80ff1904bc268833a01"
    sha256 cellar: :any,                 x86_64_linux:      "157cad065344bbad439b4774cd78a7787ebee3cb750ee8ed8a34bbb4854a326a"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.Version=#{version}
      -X main.Commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  service do
    run [opt_bin/"tinyice"]
    keep_alive true
    working_dir var/"tinyice"
    log_path var/"log/tinyice.log"
    error_log_path var/"log/tinyice.log"
  end

  test do
    port = free_port

    # Write minimal config
    (testpath/"tinyice.json").write <<~JSON
      {
        "bind_host": "127.0.0.1",
        "port": "#{port}",
        "admin_user": "admin",
        "admin_password": "test"
      }
    JSON

    pid = spawn bin/"tinyice", chdir: testpath
    sleep 3

    begin
      output = shell_output("curl -s --fail http://127.0.0.1:#{port}/")
      assert_match("TinyIce", output)
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end