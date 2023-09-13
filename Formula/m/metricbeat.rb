class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.10.0",
      revision: "62873ab51c9cb5492f3f2b1ec597396071564737"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "307bed1519b6d86499416a53ac40261dc02436fad96854ea38e4cb1753c9c8ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fd6c60aab31046c94eb57953889a7205b40213244cd535025ab9e7c63c45ce0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03057aa21d546bc3369d9a7adfd1161fb3d96974b3f733ac6d15efceabaf9f2f"
    sha256 cellar: :any_skip_relocation, ventura:        "6bf725244f5bbd95c3f18f529f08a70f53cd82a45a22626a2d2fc40ff292576c"
    sha256 cellar: :any_skip_relocation, monterey:       "9424031d583eaef1c79837da50ae179dda3ec37e556b77daed440b1292af1c46"
    sha256 cellar: :any_skip_relocation, big_sur:        "58c3d8666601162ae244a9dda91c5ef2a35f052dba9095cddafa0462bbe5d3a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97cd553f354b89d7d6b3ed8bea629758a755cd54f2923aa7a26d60bdb2cd96b8"
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