class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.10.3",
      revision: "37113021c2d283b4f5a226d81bc77d9af0c8799f"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "194484f85526ad96f6223c00988ea371fca7f22e8ae20084bb663a20d8010b45"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44b6c3bf0097cd5066994c09dda7beddb4cf2e7507060f0a411fd9ac2ea037e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "233066a41b039173d94c68008dc35d2deed15a0f8165bd04f3d5d3624acb8f4b"
    sha256 cellar: :any_skip_relocation, sonoma:         "63964921c961d91989e1c1cd87edfec78ff31ac3f2585e4d89f68b87037001bd"
    sha256 cellar: :any_skip_relocation, ventura:        "b39904ddae6b6833bc2419aeed10bdb6dc92196038cb1f8e756dcc1f982109af"
    sha256 cellar: :any_skip_relocation, monterey:       "cb645fededd66f55544525d1deaee65a8101c69ec470f8fb0b4ce650cbe7058b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b4ea460dbb238ad3cc3e2199a7c1f9b810537b1bc679f2c7bd687500e87db62"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "python" => :build

  def install
    # remove non open source files
    rm_rf "x-pack"

    cd "metricbeat" do
      # don't build docs because it would fail creating the combined OSS/x-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", "mg.Deps(CollectDocs, FieldsDocs)", ""

      system "mage", "-v", "build"
      ENV.deparallelize
      system "mage", "-v", "update"

      (etc/"metricbeat").install Dir["metricbeat.*", "fields.yml", "modules.d"]
      (libexec/"bin").install "metricbeat"
      prefix.install "build/kibana"
    end

    (bin/"metricbeat").write <<~EOS
      #!/bin/sh
      exec #{libexec}/bin/metricbeat \
        --path.config #{etc}/metricbeat \
        --path.data #{var}/lib/metricbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/metricbeat \
        "$@"
    EOS

    chmod 0555, bin/"metricbeat" # generate_completions_from_executable fails otherwise
    generate_completions_from_executable(bin/"metricbeat", "completion", shells: [:bash, :zsh])
  end

  service do
    run opt_bin/"metricbeat"
  end

  test do
    (testpath/"config/metricbeat.yml").write <<~EOS
      metricbeat.modules:
      - module: system
        metricsets: ["load"]
        period: 1s
      output.file:
        enabled: true
        path: #{testpath}/data
        filename: metricbeat
    EOS

    (testpath/"logs").mkpath
    (testpath/"data").mkpath

    fork do
      exec bin/"metricbeat", "-path.config", testpath/"config", "-path.data",
                             testpath/"data"
    end

    sleep 15

    output = JSON.parse((testpath/"data/meta.json").read)
    assert_includes output, "first_start"

    (testpath/"data").glob("metricbeat-*.ndjson") do |file|
      s = JSON.parse(file.read.lines.first.chomp)
      assert_match "metricbeat", s["@metadata"]["beat"]
    end
  end
end