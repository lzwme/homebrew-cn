class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https:www.elastic.cobeatsheartbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v9.0.0",
      revision: "42a721c925857c0d1f4160c977eb5f188e46d425"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43b0778eab3196cfbe039f66b522bc7831b887d59e5536e98dd0c990513898f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1abf68c3a2596e110557d26f623b753eaf4c3f8c3736deb3bf0e1bc1f58eea8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0888969d278cbf3cac8cb01e1693da7d9af05b76a7e3b49f0c268179f5aa568d"
    sha256 cellar: :any_skip_relocation, sonoma:        "295d0e949a5d7ee6a57507687dff5d0e313c9aae0af84d1c867e7b44ccd2880c"
    sha256 cellar: :any_skip_relocation, ventura:       "916aa84a80b85a4efe79e2d15a92785b129f4601daf04751b57a6d66aef0d83d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06ec9bfa1651e23eca306189c20658772875973bea28d12fd157e4be653125e1"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "netcat" => :test

  def install
    # remove non open source files
    rm_r("x-pack")

    # remove requirements.txt files so that build fails if venv is used.
    # currently only needed by docstests
    rm buildpath.glob("**requirements.txt")

    cd "heartbeat" do
      # don't build docs because we aren't installing them and allows avoiding venv
      inreplace "magefile.go", "(Fields, FieldDocs,", "(Fields,"

      system "mage", "-v", "build"
      system "mage", "-v", "update"

      pkgetc.install Dir["heartbeat.*"], "fields.yml"
      (libexec"bin").install "heartbeat"
    end

    (bin"heartbeat").write <<~EOS
      #!binsh
      exec #{libexec}binheartbeat \
        --path.config #{etc}heartbeat \
        --path.data #{var}libheartbeat \
        --path.home #{prefix} \
        --path.logs #{var}logheartbeat \
        "$@"
    EOS

    chmod 0555, bin"heartbeat" # generate_completions_from_executable fails otherwise
    generate_completions_from_executable(bin"heartbeat", "completion", shells: [:bash, :zsh])
  end

  def post_install
    (var"libheartbeat").mkpath
    (var"logheartbeat").mkpath
  end

  service do
    run opt_bin"heartbeat"
  end

  test do
    # FIXME: This keeps stalling CI when tested as a dependent. See, for example,
    # https:github.comHomebrewhomebrew-corepull91712
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    begin
      port = free_port

      (testpath"configheartbeat.yml").write <<~YAML
        heartbeat.monitors:
        - type: tcp
          schedule: '@every 5s'
          hosts: ["localhost:#{port}"]
          check.send: "hello\\n"
          check.receive: "goodbye\\n"
        output.file:
          path: "#{testpath}heartbeat"
          filename: heartbeat
          codec.format:
            string: '%{[monitor]}'
      YAML

      pid = spawn bin"heartbeat", "--path.config", testpath"config", "--path.data", testpath"data"
      sleep 5
      sleep 5 if OS.mac? && Hardware::CPU.intel?
      assert_match "hello", pipe_output("nc -l #{port}", "goodbye\n", 0)
      sleep 5

      output = JSON.parse((testpath"datameta.json").read)
      assert_includes output, "first_start"

      (testpath"data").glob("heartbeat-*.ndjson") do |file|
        s = JSON.parse(file.read)
        assert_match "up", s["status"]
      end
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end