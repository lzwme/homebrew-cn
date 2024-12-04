class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https:www.elastic.cobeatsmetricbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.16.1",
      revision: "f17e0828f1de9f1a256d3f520324fa6da53daee5"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af35e18906b37ef3d51b6e340253ddd941dcdc224e45bfc192e9d255b16e161d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25caf57547a4022a345851621763de9949d1d67c5f828ca62fe87aed35a219cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "26f901b91ada341403257bc00cc29103d47e1d6a1844a507c27db2cb54b01915"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e07cbfd0a40ebdccd3ef6039d19fa1e9760d6c8d0c07f25355335e059ce2913"
    sha256 cellar: :any_skip_relocation, ventura:       "31da669cb712f33e9c40d966b1377dfe53114e6eb9a40e9c1721a2869f465015"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f4d9ff70d3ef90d70f97b275900fc1f1153da5d9c0714940a51d2335e01a25c"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "python" => :build

  def install
    # remove non open source files
    rm_r("x-pack")

    cd "metricbeat" do
      # don't build docs because it would fail creating the combined OSSx-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", "mg.Deps(CollectDocs, FieldsDocs)", ""

      system "mage", "-v", "build"
      ENV.deparallelize
      system "mage", "-v", "update"

      (etc"metricbeat").install Dir["metricbeat.*", "fields.yml", "modules.d"]
      (libexec"bin").install "metricbeat"
      prefix.install "buildkibana"
    end

    (bin"metricbeat").write <<~SH
      #!binsh
      exec #{libexec}binmetricbeat \
        --path.config #{etc}metricbeat \
        --path.data #{var}libmetricbeat \
        --path.home #{prefix} \
        --path.logs #{var}logmetricbeat \
        "$@"
    SH

    chmod 0555, bin"metricbeat" # generate_completions_from_executable fails otherwise
    generate_completions_from_executable(bin"metricbeat", "completion", shells: [:bash, :zsh])
  end

  service do
    run opt_bin"metricbeat"
  end

  test do
    (testpath"configmetricbeat.yml").write <<~YAML
      metricbeat.modules:
      - module: system
        metricsets: ["load"]
        period: 1s
      output.file:
        enabled: true
        path: #{testpath}data
        filename: metricbeat
    YAML

    (testpath"logs").mkpath
    (testpath"data").mkpath

    fork do
      exec bin"metricbeat", "-path.config", testpath"config", "-path.data",
                             testpath"data"
    end

    sleep 15

    output = JSON.parse((testpath"datameta.json").read)
    assert_includes output, "first_start"

    (testpath"data").glob("metricbeat-*.ndjson") do |file|
      s = JSON.parse(file.read.lines.first.chomp)
      assert_match "metricbeat", s["@metadata"]["beat"]
    end
  end
end