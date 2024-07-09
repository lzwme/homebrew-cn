class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https:www.elastic.cobeatsmetricbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.14.2",
      revision: "e9455e203842edf9086f34b3ca2fa2b08bc76081"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca213bb805e13a9c6b6ccab49f15078e16fc72887662df79ccef3b4300db6446"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79ef11d2ab1f1d6b932445a7ca15f8bad6d6ae650246f555f02b06fd4948d8dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b4981be4a1ce1f708009028bebb0fb3b85ad162b9197ce08799d3a05e9e5938"
    sha256 cellar: :any_skip_relocation, sonoma:         "786ae55c0519eea18e5295fb4c5928dd61cb810a160cfd4c0eb864f7ed1ba805"
    sha256 cellar: :any_skip_relocation, ventura:        "e0ceeea7685a35b5b856d1a7c63eb55aad88236cf7454db9c0859ca8b73cb8ac"
    sha256 cellar: :any_skip_relocation, monterey:       "9dae25b7fb4e2cbf4b4802138f3ae653205995a8b1fe728a66438bdeb892191c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ef99d258ce63c46366b7342f9ed5dc8f24c00f2f8580c85c5cbc93a704cce8e"
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