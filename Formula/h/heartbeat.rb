class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https:www.elastic.cobeatsheartbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.13.1",
      revision: "e9e462d71bdcd33a84d7f51753a116b5d418938f"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d34b68c6d047d74458275e93cf8db60d00822ae32b5a9d3639b0429ada17c68"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba3fe656cf6011a39b00d84466d00af94b98182389345643d76bd405195a3793"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9db743c108a055749dd9eceb08ba1393937f06611f335d47803b9441045f8ccd"
    sha256 cellar: :any_skip_relocation, sonoma:         "23ca5b260b7eb54e842f75eb2b02208eb5b43b814f6e95bc985195d39bf578b0"
    sha256 cellar: :any_skip_relocation, ventura:        "2b272fe5db4bceac5071d9a6334c703901450e1bb5dede4ec1322c46c6d9db33"
    sha256 cellar: :any_skip_relocation, monterey:       "520ba07de926f3286ddb4176982177b0a013e727bf63672fab727c5c784bf059"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffbf0134e73c6a3798e859cd3c99e0e08d3b46261d0f372b06c8175cf0764590"
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