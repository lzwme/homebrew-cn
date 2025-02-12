class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https:www.elastic.cobeatsmetricbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.17.2",
      revision: "cf5c18e080581711e9189290187fbd721e962fac"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5164589c98271ebdf3760b9f0e6b5495b6a4a4d4d3885dd3f2be368787a22e7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a99727b666aa477779ec3b9b3df1477d9167a013f36658b9c9d0a4f375c2a790"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8068c8964aeee0bada29b304eae1b2c8a447e66748f5728364e9b70838e56849"
    sha256 cellar: :any_skip_relocation, sonoma:        "0dff585793cbbe21325e1b205ec054b07bbc7372d97b327c9973aa2ae1320478"
    sha256 cellar: :any_skip_relocation, ventura:       "13c388df5e815a9f0da1dc539c6b660f768bdefbd339db513b3610dfee861216"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca69c1f4fb148127f1ae3b9733152e3268f40f925fda806aa4250381b4349014"
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