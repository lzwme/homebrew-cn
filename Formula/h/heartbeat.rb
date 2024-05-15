class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https:www.elastic.cobeatsheartbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.13.4",
      revision: "b24ddd14c936c216817afed0cc7d0b23fd920194"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81e73c5b60ea405837abadff1b3e660026f41a97a1bee17f21e264bb4887dd87"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95a1a0be357d37e6b03c87c6abade3291f973d26c5228dc73662c1994b01479c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "298a7203581b1bc1616e91ee64a153c41d15ee4fabeeb9076cebc50e8edcc591"
    sha256 cellar: :any_skip_relocation, sonoma:         "7ca07801c55b4e138fc91ece97975af09047b2579df174f2be28771179ab6cae"
    sha256 cellar: :any_skip_relocation, ventura:        "aace77a079ed73bd48f376e254c0886fed4c792dccf61624dc9edcbd48590518"
    sha256 cellar: :any_skip_relocation, monterey:       "7a4092c45306bb7536fc01582711cdfcd442311573f1eee965995eb78be1a74a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13edca620d16fb93de5e9b88c01c335f9097eed163adadaccbeb44ff79898da4"
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

      (etc"heartbeat").install Dir["heartbeat.*", "fields.yml"]
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

    port = free_port

    (testpath"configheartbeat.yml").write <<~EOS
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
    EOS
    fork do
      exec bin"heartbeat", "-path.config", testpath"config", "-path.data",
                            testpath"data"
    end
    sleep 5
    assert_match "hello", pipe_output("nc -l #{port}", "goodbye\n", 0)

    sleep 5
    output = JSON.parse((testpath"datameta.json").read)
    assert_includes output, "first_start"

    (testpath"data").glob("heartbeat-*.ndjson") do |file|
      s = JSON.parse(file.read)
      assert_match "up", s["status"]
    end
  end
end