class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https:www.elastic.cobeatsmetricbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.12.0",
      revision: "27c592782c25906c968a41f0a6d8b1955790c8c5"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5bafaae5fb2cd7db040228fee5a1f08c69715129b1c222c559b52ea448b68519"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c962bc38404255ac13405b51c7c968fddc3c37883dbe395349d692325149520"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a17e9b2009f8ec1d56a6cbf6505ce61f5379488fc57ea4c5ed641d900bb75d1d"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc67def66cb07bf903b9fddad1d55a2b917a5c6da9482831884f3d5eae533112"
    sha256 cellar: :any_skip_relocation, ventura:        "2dfa9fca6c11d3d86e32e2d43b4a91edf5d0f1cce2983676a2fb6f36a1d526ed"
    sha256 cellar: :any_skip_relocation, monterey:       "4751eae7b4c026d79344cb12401abd19ae8e37b9087473fc890b1dabec376492"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86973f7465679cbebef2e6432367d08d97202e699f6ab9594cb6bfa275dbfe7e"
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