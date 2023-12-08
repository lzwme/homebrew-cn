class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https://www.elastic.co/beats/heartbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.11.2",
      revision: "ce367ff5456dd8a1a93d6bae8fd600bb04816718"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc4c7682ced9f49c9dc99005186fa56dc0470bd0123064e025e149d635106b98"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9ca6f6210dc3daf8f54723dabc2d3fd5076acfeab52cec98b2d6220030a2f99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf2c0022301d4f0f57a4b2e8e880f42feaaf49a7a973e16f51c5499374362b03"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4bdbf3a12ad518c68f5ebfbe20595e4cde610ac9c2809097726f21f6b48287d"
    sha256 cellar: :any_skip_relocation, ventura:        "3a791cb57213259070a986340d2d8f1505ce4e3e1d75edc17b0549324c0849e0"
    sha256 cellar: :any_skip_relocation, monterey:       "449567bbcab444c1a23eeb3965cb383d174cbadc4a9dcbffed979d8886e4e38f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b6eb803ed13aa5bfeee3fb131ecc4d597ef03b070b1756710714afd332b8bb7"
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