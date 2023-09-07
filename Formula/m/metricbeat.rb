class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.9.2",
      revision: "d355dd57fb3accc7a2ae8113c07acb20e5b1d42a"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fceb1bbc09d6eb27c70edc5eab7eb10bf8d271e11629f5b4362da05a7cecc83b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f184546543ea1234663d83a54668ecabb974860bdbf39b1d6d7f7976247e4304"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d8b1f5d3b28d415b4ee35e8db02b5c05256c97080d29a242c770d3a8cef4075"
    sha256 cellar: :any_skip_relocation, ventura:        "227b9a4e39a67adb2191546fe89837038d4a5daf8f3bd8d717eeff76b204dde3"
    sha256 cellar: :any_skip_relocation, monterey:       "b764f329ad09486668f651de7cd05f4069c2b5dc0ace80d59f7160146fb1bf5a"
    sha256 cellar: :any_skip_relocation, big_sur:        "90e680f0b7cb122fe55f41d4a3993e643a14b1ce52d8a085bb6286b1c3d588d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0ad638c76d9ad08e0ba59c8dc5ec222e5475907c8f9a247b7b904a0119ce00f"
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