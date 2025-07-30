class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https://www.elastic.co/beats/heartbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.1.0",
      revision: "c53b4a051bee29d3e5b3cda16753ea18d47e339e"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c5e91ad29793bc087e17af5fb36b7f39084454fd11b2a91787e5135e0ab2f83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcce0d8a929268c0362d5b1c77bbbf704ba58d91102e32b052803ed186490470"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5ee6eab4bba0195f293164ebe9e5f6033f83ea8370ceea021e40a331386b1031"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b21e7ad436cc9e42cb7dcb610ecd9a893c467aab4cb4576cda2c3899eca2fd7"
    sha256 cellar: :any_skip_relocation, ventura:       "a0ba4d46578650c75e40617ad5a534203612d0590d0c35f015d39ae28c32635b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "beddc11360de869f42544ae825e876d212c6296a7039b17cb88f816484c08e31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c5370a2f8ac577be55df5b62bf9bea6b8a481ff2dc73fa9ca39a5301daf271c"
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