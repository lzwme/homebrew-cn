class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.1.1",
      revision: "1292cd58f48325c041317d9a8bc1f1875bc6cf5f"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07d5c600b0b26ec466f70bf839b9bb295c8822ffcaac4b78a4df77abcd8a00aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41b621e60c98055edaab0ba805892af10c233bee0bfedaaae9dcda3abd032d0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "112cb945173a953806a8121a6aeab31358485097afa978fe6aa6b651cce100fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "9dd81a830f6c522f255d9752049fe480acc2c549712f5dd7ce8416af0d0be153"
    sha256 cellar: :any_skip_relocation, ventura:       "d5de45674d6a29fb16f52c067eb8d8919bb59cd39b18006b4b8509507b5eeb0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6252b5e2735102753fc8ed63ad61fe226a91bef2208d1f8cffdfadf777b38b4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1606a436657e759022a0417ba054ca33d3ea6c93481d9218e16be7c5d156cc83"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  def install
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