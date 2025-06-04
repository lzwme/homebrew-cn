class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https:www.elastic.cobeatsmetricbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v9.0.2",
      revision: "26ce6f2d4c4de66c3b73a1acf3d1be01b817d791"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7184dde2765a70b162f4ee2ae3e04e467fcf585110989e66964036718c43e87b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb308f69b54e673ece4b81ca86b5a15b6ad6b25bc9caa3e7c02d6ad5b5396393"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dba60f7c6c0a6c50fa8b12eae582c7b947e4c8342c0b201e572f0be915621f91"
    sha256 cellar: :any_skip_relocation, sonoma:        "056ef77d0ddf8cd800882c6c0a6d255ea3fa8d2b3007839ed55dbca8bd5dc531"
    sha256 cellar: :any_skip_relocation, ventura:       "965dbbd7b8a75626e5c250d540c7f1d7c636e795c1c83acb28f6c2ab26da21fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad86154b64c35d8bf948b9f883edbd83c400f6b47c8ffe982c737ca6d8facace"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75f1083a35fb686a2ed8561bdebb90e94b476e4fb5e5a48a2efb0fc65e19a0a9"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  def install
    # remove non open source files
    rm_r("x-pack")

    cd "metricbeat" do
      # don't build docs because it would fail creating the combined OSSx-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", "mg.Deps(CollectDocs, FieldsDocs)", ""

      system "mage", "-v", "build"
      system "mage", "-v", "update"

      pkgetc.install Dir["metricbeat.*", "fields.yml", "modules.d"]
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

    pid = spawn bin"metricbeat", "--path.config", testpath"config", "--path.data", testpath"data"

    sleep 15

    output = JSON.parse((testpath"datameta.json").read)
    assert_includes output, "first_start"

    (testpath"data").glob("metricbeat-*.ndjson") do |file|
      s = JSON.parse(file.read.lines.first.chomp)
      assert_match "metricbeat", s["@metadata"]["beat"]
    end
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end