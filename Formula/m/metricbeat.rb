class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https:www.elastic.cobeatsmetricbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.13.4",
      revision: "b24ddd14c936c216817afed0cc7d0b23fd920194"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d9f352af52be423d1e2c8f445844dc66a8f5c9ed8d4ccc1406cc4683badddc36"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49afcc78957ddc0ca50c7121c9070538b1fa11c0c51e0fc42e834b93ea19e834"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60dbcb7562d8ac5cc62e58aaa22c86ddfaa49a494d3f1fb6605ee9348803cd46"
    sha256 cellar: :any_skip_relocation, sonoma:         "e122fff818acae9e33b932b50b9cad8b97886d82602a914b0573124ae4a37e9b"
    sha256 cellar: :any_skip_relocation, ventura:        "261eb9421d337599fdfd57714273f56a87b5c41df5ca6531d3b705ff1a5d33bb"
    sha256 cellar: :any_skip_relocation, monterey:       "abf763fd4330455f8a7f54eae493d8e08f03bd89c3729bd402f1b82faf6cb260"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c1f3dff36d0e149c652fa519765fba9ebd5e087bb14c929621960b69c9fb5b1"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "python" => :build

  def install
    # remove non open source files
    rm_rf "x-pack"

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