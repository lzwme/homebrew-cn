class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.8.0",
      revision: "ae3e3f9194a937d20197a7be5d3cbbacaceeb9cc"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a890c74500b0620f1de284d0295942e9accb1a474f25a57170c461b3d1f9b651"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "156c0181c7a57839624e12c131341363ca869c1dbad092a82a65f4118ecbae43"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b8438e0cc8d25d7a20d957a2bb1c6719e3e854fa83edb87dff59da4c068f751"
    sha256 cellar: :any_skip_relocation, ventura:        "53639885cda0ea4a4c6e1d42c6ab52d22095c16ccde6f8387e1bbd174ea4e9c2"
    sha256 cellar: :any_skip_relocation, monterey:       "acbaa3dd0adc1fb81cc3e8c5f5d20dc58a870b9a7618f6b2ea9628c32a99162a"
    sha256 cellar: :any_skip_relocation, big_sur:        "1af81b4bb956f5c01e509900255b8bb3a226d01a72127014395f6cbea4d956d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e7e6dfac937c56ff7db789553be809f401c0f75d173cc3a2cab406d6d98dbdf"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.11" => :build

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