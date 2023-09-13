class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https://www.elastic.co/beats/heartbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.10.0",
      revision: "62873ab51c9cb5492f3f2b1ec597396071564737"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1cd9c7618835f87fdd2ff7b34236c31e65c3dc412a7eb4a03b874a2471950aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f090e2b7ea0c816c49ae9a64f8540ca0ed0286bf90ec07f2635a48f00e829e25"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "09e583c0193f10d55818c58ebafc0709d5e41267ab32fa70c564329dfda4a9cc"
    sha256 cellar: :any_skip_relocation, ventura:        "a1cfff68eb4fa72abc836d14a639e5fd4dbbbc7237ae13f99aa11076d3c732a7"
    sha256 cellar: :any_skip_relocation, monterey:       "f2da4a82912d6198b9dd55c3f7ed5de47afe6abe2bb4a3498712d571c9d46a1a"
    sha256 cellar: :any_skip_relocation, big_sur:        "2aef4dedaffc25921c5963325189d461432d51b064656a0105a4cd32c0afe407"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcace3311afda4608c33dad4ad843e45da8bf4f7461208d24c1556c6ea7aed78"
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