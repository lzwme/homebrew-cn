class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.1.2",
      revision: "b036c1c565cf24c9b720605632234d20cb9dba60"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e0504e0d68ced69c138fa94b166b60730e5af6c47a4e4c4429e0c700d92c745"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e28fd20184b640c53aa5d0be86683093f916b3528bb99d3bf3f8f9c2c9c48a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7887f3c234e96f327591973bf88c051187fd14372e1c7a9b4ee3a2ae63e96650"
    sha256 cellar: :any_skip_relocation, sonoma:        "75fd584b2cdf7e68010020b7a01815e5832c66a68f050c677e61cf97bc1a3f28"
    sha256 cellar: :any_skip_relocation, ventura:       "79f1893e153f1272cad5ce1b60901d84bf6a098aec83ba0bd8bb14383c5facb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be4c40f6ac9987c81337c4e509b82fd55c0169c2ae1a1f01db84e75ba8ad780b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9e27dcec98d06216f0f6ef50643004a0ff46cdd66ae0210b13525e31f34cfa2"
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