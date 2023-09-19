class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.10.1",
      revision: "ba6a0bcef9ec28790a10888070eab35b95277e38"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed718a5d9599a94c5a3fe13becb418e1315a76b241136a82358890c7ecea81f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b55e40046eccd8e7536fd5146e7681c690e06efb4973e47a75cec89312082e52"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d45b516336b7a2173224a063cd18b4102116de496844788eebf34f3db6a1363c"
    sha256 cellar: :any_skip_relocation, ventura:        "1a73014bc352f98bafa59ac62104ba492415c1a9e1b56d8a50f99d2d172f69bf"
    sha256 cellar: :any_skip_relocation, monterey:       "21cdf80718fa94b6f36e8ebad3da81ecbcdf72813c4c33ecfa1a7800168d71dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "697381ef84ce7eb7b2effb817f6c4c90d3f5ed124b406b69f7b117bb11fb9325"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fb1916033c7cae15ceb60c103797350176c0071bd0c447a2837d571e29f5cf5"
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