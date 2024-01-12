class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https:www.elastic.cobeatsheartbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.11.4",
      revision: "61337102fc51ca447027380b50596966ba88b82b"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "208e9590785ce63b91c5c456f63d557e7cd9f4cea4f2599c905c3ac7a22dc419"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f29151500834b69e62a7905303b36b8bc98b01fd8f8b409c77ccc3835bd6eeaf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d140b32a220d91522be1a44c0907ed7d3d6f822dc072d6faec4a5841bc661bf5"
    sha256 cellar: :any_skip_relocation, sonoma:         "4842c7bc6bb3acfa2fb3f73e75dde3e95e066eebd2ee36333fc1e4a3459c5ec0"
    sha256 cellar: :any_skip_relocation, ventura:        "3a97743888e8b21f1aee6436ae7c829ec1590875b31d559d7482204fa37fc213"
    sha256 cellar: :any_skip_relocation, monterey:       "1fe717a5cbfd9cff540abdd18a71204c7cf69d9264e3c13fa4e27172002ab464"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb40d4b2ed37f5b938001fc76533c5e0110da840b3da2238eda43d4052d658c1"
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