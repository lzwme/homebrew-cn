class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https:www.elastic.cobeatsmetricbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.16.0",
      revision: "dd6212261c57e41e1bf42532809a14a00c9072a9"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "759d9e9804aabea91e04991acfd537fea2cadd77bfa09b951a601a8821930eed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "220835b4ac2190f332f3fb6049edceaa2d6409612212481263eed867dbc3ff9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44ccac82f6d569bf53f6c6747a48a683372474fda68bcfbe49d478d8afb7ca9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "35556701112661bb29cab4466ecbc6989c802c3ade7e7a811e8e772bd3c8120f"
    sha256 cellar: :any_skip_relocation, ventura:       "de6c483cb5f5f287792d63ce8b2394eeb6d45aa1d588b461a1464b07656b4b0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06d9057a40ce6f844d0c2065919cc168947f7d12316d2cd63c26167d319e2555"
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

    (bin"metricbeat").write <<~EOS
      #!binsh
      exec #{libexec}binmetricbeat \
        --path.config #{etc}metricbeat \
        --path.data #{var}libmetricbeat \
        --path.home #{prefix} \
        --path.logs #{var}logmetricbeat \
        "$@"
    EOS

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