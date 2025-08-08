class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https://www.elastic.co/beats/heartbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.1.1",
      revision: "1292cd58f48325c041317d9a8bc1f1875bc6cf5f"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22fb6793130baeef9ce4b782e833a76b00c6c55c86644b393bb831be6ab93a53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "febe9bcbec48e59a1d62207918c1411593651a576476975ce098ca10fe1e011b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "578e9ebb38862eeb3b11a958e292ae6193ce9674eeae7fec83224ca355067344"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcc8a734ec158a50f25b75e0cfe81c85ae1ea750a34396aa263326fcd8345a03"
    sha256 cellar: :any_skip_relocation, ventura:       "d3683bde717cc5573fc51d63f41d2982ce799b485d8daba55317802a6f1bc3bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8256e379f3eec0eaa8cbd66eaf9bb5f8fa34ed2c034de1ed3d419aa9aa013dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fed902866a98524ef1463583d6a8946d6c75c748880a9407448adb8a3741424"
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