class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https:www.elastic.cobeatsheartbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.15.1",
      revision: "88cc526a2d3e52dcbfa52c9dd25eb09ed95470e4"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "95fbbce6cc097ca35e1301517a7bcd72dd5968b7ed42812c0b525400e3329c10"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "670b0d11fe1b23b86cdc2b9a81e7c330dbb1756fd64c9f35ade986423192025a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55bda8000c9e906b265d9889f5de16c6b1fc56c4b96d02fe1e6c9c25432b68ef"
    sha256 cellar: :any_skip_relocation, sonoma:         "659fd20301ca7c75db7e0e8a00e0ba81cf65c8fccc6216f833c21b7aa542a4ef"
    sha256 cellar: :any_skip_relocation, ventura:        "152c390e584bedb761eecddb48fe829eb5b163c0d2a504b487a74614ab4a574d"
    sha256 cellar: :any_skip_relocation, monterey:       "34e73a6d8319d68783e9c27d84f7ec8db9bcf8a4ebffd0f920f76c88a7c52995"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20bd9a5fa4f8bfd758a43b2c4b54d29da998b523a2d4321f6b7f58720ecae951"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "python" => :build
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