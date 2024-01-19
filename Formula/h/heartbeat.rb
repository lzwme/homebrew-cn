class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https:www.elastic.cobeatsheartbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.12.0",
      revision: "27c592782c25906c968a41f0a6d8b1955790c8c5"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb38b9411c0c0671b07637df4da1b0bdd774680886b8d6a30ea9b6d8c7b4efe8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0736af0e697b5faae6b36b9b7f26983ca2a7f18c84bd7449d564a3c7cd06ae57"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef6572e9e7cf0d0de782942a7538f2f74f9ee8fb94da5a44b6ba0cc7366d82dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "829ecb5c0f837a8cd09f1ed9aa12f6434a70d8eb0b9378feb384b5c4588174d4"
    sha256 cellar: :any_skip_relocation, ventura:        "a58965b05d71bbaa015d4d173d599b2b3aa80f41ca0ca88451ff5d67c20ac994"
    sha256 cellar: :any_skip_relocation, monterey:       "2d745ed7c5a5f7367aab4af613a6fd38b3550a2132e55fdbfbecae84d924e971"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c29894e443d6e963849e5e9ac8f16fee5a26122b72a438ba7403b2eadc73054"
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