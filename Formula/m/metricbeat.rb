class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https:www.elastic.cobeatsmetricbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.11.4",
      revision: "61337102fc51ca447027380b50596966ba88b82b"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ab97aee85d324b13fb38f44f9bc4d3f01e320dfe36b3877c08a94550779a79d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76e494bfbd37996cfdc9a49e0f69173a4180068733690022428c8e60321fcab4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6d836eefde0555b12d83474b11878f3a00a098096bec4e5e33ef02be8b59124"
    sha256 cellar: :any_skip_relocation, sonoma:         "a38af5e01e08804a48052963c7fea101fba6f1fa41033b326847d9530dd2d826"
    sha256 cellar: :any_skip_relocation, ventura:        "54d5e87e42187e9a79fa341243fd1880584700e53664268dc5246af46da90d8e"
    sha256 cellar: :any_skip_relocation, monterey:       "d689f9b31a25241aaae5f1253eec9f36d13a5351aeffe6447c4b2e1ef75c05c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "743a521da6a5f26a2c912a6a94ad315e5053ec54d4cedf7980f241fe88f720c9"
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