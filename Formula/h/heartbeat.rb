class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https:www.elastic.cobeatsheartbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v9.0.2",
      revision: "26ce6f2d4c4de66c3b73a1acf3d1be01b817d791"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66ec91e74cd6cedf0740dc8e07a8005431f9109a57f4c8c0f888c6bf3b5b1360"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcec1d0a779fc24074f1a6938806838712090b3d2fe795ebd667d73c93f033c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "019568450ff837fcaa1bc11bdd10747245d16239da96203b1c3c438633eddeb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "6260bcc01f52e76aab7fa2757a71acd960c4b89061223ff9afc40d299b7527b8"
    sha256 cellar: :any_skip_relocation, ventura:       "1cb636a58791633addb819c52dc65852c037929f80f160f4925e99bd1b7036b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe5d7cc8e56a8ed6be3344a90e7dd0f2b766dbe4f90ab85147c362eaf4b39a3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ec07fccc523c365c4156f12cc91fbc00d21f075125ce695cd52f368e0967e46"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

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
      TCPServer.open(port) do |server|
        session = server.accept
        assert_equal "hello", session.gets.chomp
        session.puts "goodbye"
        session.close
      end

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