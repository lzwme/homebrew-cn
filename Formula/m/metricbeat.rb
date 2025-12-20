class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.2.3",
      revision: "b95cc76490c9bb4184f98e0094be4af14b5d7bd2"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d21bd995b570f6576478b912e83f6d64a845dd6f3d557cfb5810acfdabf9df5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e0066e9333cd6ee7e9893def56b0a580c5a7494afbcdc64b1af45adbb65d81f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1013f1d9f21cec4149bc4b160cb902310c4a6045a721e9481f99e9b6adc3e58d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac9f1378910cb38ca7930d49fa664d4dc47cb7fc63c5cdcbc29912f3635c9ff6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "311e80e736baeeadb2c3b032f4b7392d7b5e492d7d07f21a0db2c6822b354683"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33ac6b2d1541d6420d73342100afce172019882fc1a5ab9b34f73087cecffe83"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    # remove non open source files
    rm_r("x-pack")

    cd "metricbeat" do
      # don't build docs because it would fail creating the combined OSS/x-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", "mg.Deps(CollectDocs, FieldsDocs)", ""

      system "mage", "-v", "build"
      system "mage", "-v", "update"

      pkgetc.install Dir["metricbeat.*", "fields.yml", "modules.d"]
      (libexec/"bin").install "metricbeat"
      prefix.install "build/kibana"
    end

    (bin/"metricbeat").write <<~SH
      #!/bin/sh
      exec #{libexec}/bin/metricbeat \
        --path.config #{etc}/metricbeat \
        --path.data #{var}/lib/metricbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/metricbeat \
        "$@"
    SH

    chmod 0555, bin/"metricbeat" # generate_completions_from_executable fails otherwise
    generate_completions_from_executable(bin/"metricbeat", "completion", shells: [:bash, :zsh])
  end

  service do
    run opt_bin/"metricbeat"
  end

  test do
    (testpath/"config/metricbeat.yml").write <<~YAML
      metricbeat.modules:
      - module: system
        metricsets: ["load"]
        period: 1s
      output.file:
        enabled: true
        path: #{testpath}/data
        filename: metricbeat
    YAML

    (testpath/"logs").mkpath
    (testpath/"data").mkpath

    pid = spawn bin/"metricbeat", "--path.config", testpath/"config", "--path.data", testpath/"data"

    sleep 15

    output = JSON.parse((testpath/"data/meta.json").read)
    assert_includes output, "first_start"

    (testpath/"data").glob("metricbeat-*.ndjson") do |file|
      s = JSON.parse(file.read.lines.first.chomp)
      assert_match "metricbeat", s["@metadata"]["beat"]
    end
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end