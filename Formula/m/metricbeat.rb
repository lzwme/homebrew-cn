class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https:www.elastic.cobeatsmetricbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.15.1",
      revision: "88cc526a2d3e52dcbfa52c9dd25eb09ed95470e4"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f2a41fe3623a15d26322c48802cd3b004f8e0e1f3ce43ee773d7a4c57ef88036"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ad0d4b8f672e32867b6bc3728037935e4cdc01fa0a24db9b8fac8376ed3729b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e144c3f663df0660884bb0d8142db010d79610951b451cc33602f2c468f517eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f7eed026ac5c7d351e60b47ceb4bca5776931f0c59ced4bd439b05f287436f6"
    sha256 cellar: :any_skip_relocation, ventura:        "49b66de8c0079183492d5618ca5d9921d8324dc63c13aa9983ce2c1aba68f232"
    sha256 cellar: :any_skip_relocation, monterey:       "e351e4c8f35137ad10db45e0e34447608577032264c41c53dd236bcbf733496d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd7a4b46db1323a9b7c577eb2994e4d2f0ce50d8ac71c74bb7a7008d8e920df7"
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
    (testpath"configmetricbeat.yml").write <<~EOS
      metricbeat.modules:
      - module: system
        metricsets: ["load"]
        period: 1s
      output.file:
        enabled: true
        path: #{testpath}data
        filename: metricbeat
    EOS

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