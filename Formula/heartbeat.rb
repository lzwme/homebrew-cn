class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https://www.elastic.co/beats/heartbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.9.0",
      revision: "dd50d49baeb99e0d21a31adb621908a7f0091046"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "decaeae3b262d8cc253188231e30d85ab38d63b97d940f8c4b0afed55ac72aa4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7d984e981a81c2d7e04db3fb251bf5b32f525b3b4e9f1c8351980f64509e563"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a495d41e9eeeb0d4b41befaa07c7ab6b8d29a6dc5ede7ca4b44b1378d6fb11b9"
    sha256 cellar: :any_skip_relocation, ventura:        "50af84a819095203227d41485c37847b5fa103af50b1b220c88fe2aa2f11f190"
    sha256 cellar: :any_skip_relocation, monterey:       "690ac8687108def1f098ec3f7c78514f2f72360a51621157cbd2c0eaeabf3101"
    sha256 cellar: :any_skip_relocation, big_sur:        "916145d7ddc18c3f986546691cf3e9b4d741c62ff9904e2dec08d0387782d5e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "154e5686d97b065c2946f0df11257b0d7015ba9e8c00ed3f6e80681c1107ada9"
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