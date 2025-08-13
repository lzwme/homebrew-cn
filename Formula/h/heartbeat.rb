class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https://www.elastic.co/beats/heartbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.1.2",
      revision: "b036c1c565cf24c9b720605632234d20cb9dba60"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12389bf070a6b84e4976a42c60d258df2282c2605b943e6da373dd381a4d6454"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0079887fb2d1792dc2dd6ec3788945fb3ae42a3ae32238f703c51e59e0cc82a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c10b94c21f527619e5077e8344e786aee38a87c659e6221e944890bdba9e9e2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c7f08f3ae7c7da76986c53c5b68e6f7fcbca8510d32a6160cf1c95bfb0849c7"
    sha256 cellar: :any_skip_relocation, ventura:       "926c961d510f97d86cd07b4967a9222b65224dd86e83a04330ae6fd660f10aa8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac5b725c1eaa864de37d06b94c13027d7ed19690754f9fe261b9c76be9ca163a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0ad295c91a58ee44e3f57b0e34fd90a852273225a829e208f295581d8393918"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  def install
    # remove non open source files
    rm_r("x-pack")

    # remove requirements.txt files so that build fails if venv is used.
    # currently only needed by docs/tests
    rm buildpath.glob("**/requirements.txt")

    cd "heartbeat" do
      # don't build docs because we aren't installing them and allows avoiding venv
      inreplace "magefile.go", "(Fields, FieldDocs,", "(Fields,"

      system "mage", "-v", "build"
      system "mage", "-v", "update"

      pkgetc.install Dir["heartbeat.*"], "fields.yml"
      (libexec/"bin").install "heartbeat"
    end

    (bin/"heartbeat").write <<~EOS
      #!/bin/sh
      exec #{libexec}/bin/heartbeat \
        --path.config #{etc}/heartbeat \
        --path.data #{var}/lib/heartbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/heartbeat \
        "$@"
    EOS

    chmod 0555, bin/"heartbeat" # generate_completions_from_executable fails otherwise
    generate_completions_from_executable(bin/"heartbeat", "completion", shells: [:bash, :zsh])
  end

  def post_install
    (var/"lib/heartbeat").mkpath
    (var/"log/heartbeat").mkpath
  end

  service do
    run opt_bin/"heartbeat"
  end

  test do
    # FIXME: This keeps stalling CI when tested as a dependent. See, for example,
    # https://github.com/Homebrew/homebrew-core/pull/91712
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    begin
      port = free_port

      (testpath/"config/heartbeat.yml").write <<~YAML
        heartbeat.monitors:
        - type: tcp
          schedule: '@every 5s'
          hosts: ["localhost:#{port}"]
          check.send: "hello\\n"
          check.receive: "goodbye\\n"
        output.file:
          path: "#{testpath}/heartbeat"
          filename: heartbeat
          codec.format:
            string: '%{[monitor]}'
      YAML

      pid = spawn bin/"heartbeat", "--path.config", testpath/"config", "--path.data", testpath/"data"
      TCPServer.open(port) do |server|
        session = server.accept
        assert_equal "hello", session.gets.chomp
        session.puts "goodbye"
        session.close
      end

      output = JSON.parse((testpath/"data/meta.json").read)
      assert_includes output, "first_start"

      (testpath/"data").glob("heartbeat-*.ndjson") do |file|
        s = JSON.parse(file.read)
        assert_match "up", s["status"]
      end
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end