class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.11.0",
      revision: "d3facc808d2ba293a42b2ad3fc8e21b66c5f2a7f"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a9989cc1cd604d3a59f533a99f839afa3ab7d389d8677694253b7c14dbd17b77"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "130ab987498ef168f4fb8a7c3f57fd3cf565fd8d52f0e7bac2100d849975fe7f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "719038e694724121d185ad6ddb59d5970854f934ea73fa52c0a8f457f19671af"
    sha256 cellar: :any_skip_relocation, sonoma:         "b9b506355091943812f20fa66202173e6a19c6dbc149cbbaeb1e281df693954f"
    sha256 cellar: :any_skip_relocation, ventura:        "c99491b36ac1f5daf54104243889b4bdd8b5c7f3017ff3a1ee1260f68b2f17ac"
    sha256 cellar: :any_skip_relocation, monterey:       "d776588f7319c3ae54426cfa2caebf75e3f817c78122b0b87cd2d56781626add"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "432801b7ea85cfbcfe034a9dabfee8047d74bb8705d260c83ceb1ae61996f200"
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