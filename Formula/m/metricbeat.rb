class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.2.2",
      revision: "46e1e32d1aac0400a852b4565f184e23ab03e0e1"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5ea1ef9b0d84aa5466c3a44cedc6006d6bfa4f2257b5c5cdcf0a5d65c332056"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d33ba3c08b67c6e3fa2fcb9a352fb473b2cf8f4fe17816a3f29be9e5c4bb75c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a20a7789e090a477785dabb973a853dc6bebb11f9824898373d192dfbcb4b070"
    sha256 cellar: :any_skip_relocation, sonoma:        "4984d4e414c8c4d3b837797f7090b2617cb087674a164cddaaad7852c8d17677"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f7663e6c9bd0d1a469d92704b3fbcfa31ddbf4b19477f6df55536777569894a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e26c8bf7232b915ff4d326568c68d6c4dbeaaead852dd3e01c001fa062ea13fa"
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