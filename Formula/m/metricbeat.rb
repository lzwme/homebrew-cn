class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.11.1",
      revision: "19c8672c0a5bf2fb15648c0caf62d985af5a987f"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3166150ecd751bad34be4a6d4766db8b070e3447de9f17b853dd97ba827c9f74"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38eb662d6b80b6b5d907d27e8543828dbd2c4dd832f809f8d6851cc377c3e212"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0681c11da317b0c5148c18c6c05f8a0cfda8c097040ccf7ce66cf25cf2a9333c"
    sha256 cellar: :any_skip_relocation, sonoma:         "b13fec0e47c7685577c910e1fc02a6693eff4a61a981043fbf0746706c4e9121"
    sha256 cellar: :any_skip_relocation, ventura:        "8ad857b96e26aee72c90e56b2beb67ce16459b860856aa955f00ed5f7c3e793b"
    sha256 cellar: :any_skip_relocation, monterey:       "d6a6256fce4216191855adaa02c049d68108bf8a4270436efb3421de2a1249f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54ca4117325906d7ca68c70f1d78c83fa46e7d0606f541f94bf6b050cef3cc16"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "python" => :build

  def install
    # remove non open source files
    rm_rf "x-pack"

    cd "metricbeat" do
      # don't build docs because it would fail creating the combined OSS/x-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", "mg.Deps(CollectDocs, FieldsDocs)", ""

      system "mage", "-v", "build"
      ENV.deparallelize
      system "mage", "-v", "update"

      (etc/"metricbeat").install Dir["metricbeat.*", "fields.yml", "modules.d"]
      (libexec/"bin").install "metricbeat"
      prefix.install "build/kibana"
    end

    (bin/"metricbeat").write <<~EOS
      #!/bin/sh
      exec #{libexec}/bin/metricbeat \
        --path.config #{etc}/metricbeat \
        --path.data #{var}/lib/metricbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/metricbeat \
        "$@"
    EOS

    chmod 0555, bin/"metricbeat" # generate_completions_from_executable fails otherwise
    generate_completions_from_executable(bin/"metricbeat", "completion", shells: [:bash, :zsh])
  end

  service do
    run opt_bin/"metricbeat"
  end

  test do
    (testpath/"config/metricbeat.yml").write <<~EOS
      metricbeat.modules:
      - module: system
        metricsets: ["load"]
        period: 1s
      output.file:
        enabled: true
        path: #{testpath}/data
        filename: metricbeat
    EOS

    (testpath/"logs").mkpath
    (testpath/"data").mkpath

    fork do
      exec bin/"metricbeat", "-path.config", testpath/"config", "-path.data",
                             testpath/"data"
    end

    sleep 15

    output = JSON.parse((testpath/"data/meta.json").read)
    assert_includes output, "first_start"

    (testpath/"data").glob("metricbeat-*.ndjson") do |file|
      s = JSON.parse(file.read.lines.first.chomp)
      assert_match "metricbeat", s["@metadata"]["beat"]
    end
  end
end