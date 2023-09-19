class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https://www.elastic.co/beats/heartbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.10.1",
      revision: "ba6a0bcef9ec28790a10888070eab35b95277e38"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0274da2d4f6cd1c41aa42d3f454c9a9bfb510305ae838ad619aab56c16c04ae2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9e78f6226d15b5ad792a09c6917436e5d19fa76ccc47934d0e81bd0c11ad8a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee70fccff3baf4110439189ded0042ad637bc6bece0fefa0054884d7ab855c7f"
    sha256 cellar: :any_skip_relocation, ventura:        "5564aa313ca0bfb99d91a84fbe6122ea2b18cdb485062d8bf7c5404b553d1da0"
    sha256 cellar: :any_skip_relocation, monterey:       "84f1dfe8baeccb030522e3b98ff369c4b92c83647b15a6ddfc2b1af2d1f98267"
    sha256 cellar: :any_skip_relocation, big_sur:        "82953d54476476c4e5c3a7607909ca298c30ceda79d325a0e46d32b011a6a07d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8680ca4ebd9bb82db2ef568124b26a17e95e862e839a6ec60225da9e30057a63"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.11" => :build
  uses_from_macos "netcat" => :test

  def install
    # remove non open source files
    rm_rf "x-pack"

    cd "heartbeat" do
      # prevent downloading binary wheels during python setup
      system "make", "PIP_INSTALL_PARAMS=--no-binary :all", "python-env"
      system "mage", "-v", "build"
      ENV.deparallelize
      system "mage", "-v", "update"

      (etc/"heartbeat").install Dir["heartbeat.*", "fields.yml"]
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

    port = free_port

    (testpath/"config/heartbeat.yml").write <<~EOS
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
    EOS
    fork do
      exec bin/"heartbeat", "-path.config", testpath/"config", "-path.data",
                            testpath/"data"
    end
    sleep 5
    assert_match "hello", pipe_output("nc -l #{port}", "goodbye\n", 0)

    sleep 5
    output = JSON.parse((testpath/"data/meta.json").read)
    assert_includes output, "first_start"

    (testpath/"data").glob("heartbeat-*.ndjson") do |file|
      s = JSON.parse(file.read)
      assert_match "up", s["status"]
    end
  end
end