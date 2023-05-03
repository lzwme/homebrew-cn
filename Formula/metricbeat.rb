class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.7.1",
      revision: "bda40535cf0743b97017512e6af6d661eeef956e"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c67d8f84e1bd9fff25e35c3cefb6d51844d80a7aa0a54c880bd365e2c64a9bf7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "198a8d2800ede81c888eb07229b484f530dc3ed0f22971527f84f3d7082f658d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9fa7745f06b7fed39bbbc956875f5f7117216e87dd8e8ddb8fbcdae539e6cb41"
    sha256 cellar: :any_skip_relocation, ventura:        "60f79792c363b6c91aad3713c34adba821817c6b47183cea333b1ef1f46039d6"
    sha256 cellar: :any_skip_relocation, monterey:       "8814f5b4e82c3eb5c8c6af3b4fde5812efcd2e15da9c840999c124adbeb72f0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e0078ca9ee7e1f968e85d8df4b1037ef37433def4a5443af62555074e010cdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4549168b8c684f54ae109d8f942222240e5cb71705ad70ec3ca9f86f21b54927"
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