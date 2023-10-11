class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https://www.elastic.co/beats/heartbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.10.3",
      revision: "37113021c2d283b4f5a226d81bc77d9af0c8799f"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "20bdd56350020428b09a7dcf94df5ec2c73bead2a6b8c4e22a4990d116961767"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b326e39473d0fdb7b490471e4fb4bc6fa2a0250534804f7377d510d3bf42b03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43c4cd6dd3d84f06849b5ae16431c559da354c0e87e4bd2347fab4c0954ddc96"
    sha256 cellar: :any_skip_relocation, sonoma:         "e1b6b1f89ebfed374445d81f2c8fc32396e110ffe8fb55bf0626122241768b3b"
    sha256 cellar: :any_skip_relocation, ventura:        "7c561ca370d26ffba89d66c6e05bf69e7fbc4fd42d1937e5659f70fc159de5d7"
    sha256 cellar: :any_skip_relocation, monterey:       "4a431418353d483e7551a3b15981afeda1295761b011d9855d59acf92eed4a5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05c824caf6630c800c2c1e3680df9c6ddbe26dd7f1760d57f89d05999f02eac7"
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