class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.1.5",
      revision: "49b225eb6f526f48c9a77f583b772ef97d90b387"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4ddc724642a68346ddacd3de7d05569522d5d69506d80ab105f480be8272609"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07fcabc8e6e6d30975224115783e931d49f96992822f3c1f3d08c59677c39b2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1280635ecc02e1a24baf88ff90d7a68dbc4735d9bcb26cbb4ea4fefb9cc799b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e120b5744cdc6886a17eaf7cd3a6de66d3ca57a8e8791455c2488c47c6c15b07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61582a99d6ea9fca7819aab28cee2fae8138f6d3080d8ce9f346136617aa2e81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e00f34cb65d980fb26c90d77ddf631609dfe64da475247d433b1ed7ebeea329"
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