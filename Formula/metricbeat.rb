class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.8.2",
      revision: "92c6b2370e46e549acda91b396f665a7e51e249c"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84bf0a83610c672a9ad52262fce1d9673fc4e11739aa4831f37eb98346a9357c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "981c7a7ac36001aba4027fc729231fe93caa88adadf64a0dd9363a1d6e406679"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e09bb6c9376874da0d558ec9017e71c1e42da4eb84cc2d6243840246a796cddb"
    sha256 cellar: :any_skip_relocation, ventura:        "1a2667b6d35ea70fe6dc7db288efe9061a52f389da8713bc1b602cf11e8869e7"
    sha256 cellar: :any_skip_relocation, monterey:       "3c9791856ad2f3d09ea96dec3b607fe1d2d6bd1ef9b6e6ad32907304ec5b1117"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e3df3d2714b27cd0bea48a311dfe4e03323ea91a73bf2ccd6a176bf441c3d08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0fbe2c237db4c6f8232865e5abcd476e8d68641ea049ce3c172ee57f9b72157"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.11" => :build

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