class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https:www.elastic.cobeatsheartbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.14.2",
      revision: "e9455e203842edf9086f34b3ca2fa2b08bc76081"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c3441ee17861ffc82bea217ac7ce1564ea715f5c5d083715ba1e51f21bd56ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "962eedb3042eb6d8e603e4bb9f8a61e44fe0160f6c9896c35f90b5ce24f07a1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37fe07f9a342a745de79553589b79ee8b90f171a89bc8378f6b30f1be8d2c621"
    sha256 cellar: :any_skip_relocation, sonoma:         "d0e8339a7dbb29a7dc81f541f5aa2a9e3a9ff1c6f8515358ada1cd79b813ef45"
    sha256 cellar: :any_skip_relocation, ventura:        "bd29f7c7b10721cb69e3f9402d7b20b49534e6a410073b087285f70f96206ded"
    sha256 cellar: :any_skip_relocation, monterey:       "6154fb90157adf799782eb3059dc266fa7f918fe139937c886e1c6b7141a5fba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "670fe6e59564122bce59592322e88d52860be0b556d5f7a0edb2ac86d0f877a6"
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