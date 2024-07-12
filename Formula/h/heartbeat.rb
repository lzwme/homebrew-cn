class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https:www.elastic.cobeatsheartbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.14.3",
      revision: "71819961045386b23edc18455f1b54764292816c"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94a586c8236ef9a19b01cb6a145d5d6562468311d44d2a35ce68636865f318aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a78d4a41fe3fb3f9734a183c62145fcf5edcad3cc5af56aef4979b3168204f2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aae71eb7f577596b56968c4e15cc7d16a40c21d06b4cbb7c488600d36e5597cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "1dc1a5afb4ad96fcb4689fa4c327f33d44629a8aa1cdc6dc2d93ba969099bc62"
    sha256 cellar: :any_skip_relocation, ventura:        "d0a09e545f924619b4dc89652e1637c4e3a44aae11b679bf8feb3bce2e074a93"
    sha256 cellar: :any_skip_relocation, monterey:       "c56d1f7ed83d7b3d5072feecc761277dc51f4fdf192a056c05085cc040f502db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f683ebeda129dc2cc1d035ca254c420185001923a3388b0a1de2c67330fe7c6"
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