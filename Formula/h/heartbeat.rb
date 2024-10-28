class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https:www.elastic.cobeatsheartbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.15.3",
      revision: "bbed3ae55602e83f57c62de85b57a3593aa49efa"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6113519f910332309fb639e2b7b03bc99b1b9b6a3f3a76040d879249449c568"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad1a4dad8aad9407f5cfc54b03d72c7d65abc3652047d141e81f2c23545c7c8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eb9e0bc1f034c0c7f1a4914747892bba65d20edf7059ef4be28fe41f1a004687"
    sha256 cellar: :any_skip_relocation, sonoma:        "bddf58fac8536bed40493d19fe6b783fc1a8b94a7f07d781d9f2100f2ba506cb"
    sha256 cellar: :any_skip_relocation, ventura:       "343dc7dd42afc4577e924a5cfeafe76b9f67cf8fd034da3a4f819c75a30f30d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad795c28f00b925ecd571b2da11050d1a6ae9418efa39f27457c96ce1ba5620a"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.12" => :build

  uses_from_macos "netcat" => :test

  def install
    # remove non open source files
    rm_r("x-pack")

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