class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.11.2",
      revision: "ce367ff5456dd8a1a93d6bae8fd600bb04816718"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59454a9e884143c4af56108427b41b074c90d064069015b0e5d48421482b3e9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8fb39461c9572f7b5ae24ed59ba30dbfcab298576c684ab62d5445dbd8cb52b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c27d6ce55c78bfaa7ff4e038508ebecfd577d3d6b64828ac9740c863b21f0ea7"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e3ae2781f1662d1023137382e945692f7f5a0b9dc00f45e2d0ff33760a27319"
    sha256 cellar: :any_skip_relocation, ventura:        "ba8a5bd72ceb7f554001d25d153d2159c23f1f6b53ff164c5ac3f1fccbbed85d"
    sha256 cellar: :any_skip_relocation, monterey:       "d45cd9490905b9c3b8026ed3796407c6a9635f44ba71bb12bbca5910e8215925"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf40525367b19e61c3e0c4af810bf141ed254a8f916ed1ade888bf948c5eed0d"
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