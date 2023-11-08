class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https://www.elastic.co/beats/heartbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.11.0",
      revision: "d3facc808d2ba293a42b2ad3fc8e21b66c5f2a7f"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c79380e47574ad5f5e9ba05bbe6b0c9520649ea435d2a9bfbd858b4fcf334265"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17f3d295d7352f5a072dfc9c0bf21aad96da19be7527a8cc6d1671bb75d0b921"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "342dea3b61cf927d66eef034a178df8f6386ba44b2d8b2794a97cb3d3faff5f7"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d1c5279216acf4a14e8679541ec6fc256673c4cad69f7fd0846d9b7a8ceec9a"
    sha256 cellar: :any_skip_relocation, ventura:        "210f0186bd76b33a7c613e706a37d186771cf832ef88087f043f21c1e863674d"
    sha256 cellar: :any_skip_relocation, monterey:       "6e833d96d1087a34fb7d598cf2a72bfc1802a06962e50766c7ec006d0af7d412"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "630c2354eb154c13be5c56e4ace682a8c139421bc1a0e258b4940134f0664e82"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "python" => :build
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