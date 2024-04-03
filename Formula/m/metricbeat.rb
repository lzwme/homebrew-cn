class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https:www.elastic.cobeatsmetricbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.13.1",
      revision: "e9e462d71bdcd33a84d7f51753a116b5d418938f"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b28665a3e67a641f18f4cb93a6a2fbefb89c4073d6d896b68037870f9a52d835"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69b4745dd9aa003219aeb450ae94c42d14863a1c51d752a96cfa823785bfb0e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b164abc92d4863cee98a5c900a4e8c9c67d159c2af03d0b737527d64d5406a5"
    sha256 cellar: :any_skip_relocation, sonoma:         "7990ebbb6e6dfb2369e566463ef681e41ef0f7cd974387c65dff351c0136dd50"
    sha256 cellar: :any_skip_relocation, ventura:        "296da2544b6d0240bc27bc8924a7a29dd035317fcc1c8ef25eee1d605da74582"
    sha256 cellar: :any_skip_relocation, monterey:       "7d8b29c151dd05d0853e998322d53e5f56c0311e7009391ade4a9595bb23fde5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2262e92e582818e776ce6a9375b8af9253190689941ce299ac0ff2b95a1ebeb1"
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