class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https://www.elastic.co/beats/heartbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.8.0",
      revision: "ae3e3f9194a937d20197a7be5d3cbbacaceeb9cc"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57651c5dd12578bd027456cc1ac3e115021bbbe902f981b935b67c799a1be72b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c742a7af794ab54f64b7f3c385f7b78016853929f99353ce108118baca9272b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a9b9ee0c27e59d83dd6b36282d859d52e1b08b7bd158bfc65bd13652d59bdd1"
    sha256 cellar: :any_skip_relocation, ventura:        "f105e0188ebc3c4674d9a27d134fb21d4935d164202b64a67aee22586c81ff5e"
    sha256 cellar: :any_skip_relocation, monterey:       "e8bbe6964356c73cf4fb1f74de90dcd47d119b3a81c50a4422b2e286a3145c83"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9e2055d58480a781c00e9f4977ae097bc578331975039337d3071fb76d1c882"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6e279e8fbc6bea8471bd4ad73b3fe9d9895448c8b7836cb00e9fb1376ae0280"
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