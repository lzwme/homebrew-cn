class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https:www.elastic.cobeatsheartbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.17.2",
      revision: "cf5c18e080581711e9189290187fbd721e962fac"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2981c0ada1f6557226f057c877e20211d4f1af05274127cf54586ccc25a913a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1cdfcaa1f093cf0b116cbf4cff5d0d0311ef0f2964afcc6d13b50143b49b8fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d512f77e97eaa4d6e541fb0225d443dbc70ecf0463b291ed61b1ce894dd9465"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec56a79a46514a1f46dc395ba52c0fa89ddb837001bce585f2a0ca113dea2b4f"
    sha256 cellar: :any_skip_relocation, ventura:       "f9f8f0c08f76a6402a4e5b6130c31186fc7d6c33599401981967f92d8d7fbc0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3535eebfdde40f3654dff8bb8942c3f151c976d2ac0fd9416224bd50fbac9f58"
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