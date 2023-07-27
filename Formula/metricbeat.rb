class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.9.0",
      revision: "dd50d49baeb99e0d21a31adb621908a7f0091046"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43d56066f47e954f414a2a535cf0a2b5a72d6cd1d61ca26a40a05329ffd68507"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "baae1a601c40fd3b748ecf15b38a6036cc54ba2b0620354cce92aadf9a28aeb0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2252bf5317e2c430dd274f231ce97104e253a316e800dc693fb24efed6dab94"
    sha256 cellar: :any_skip_relocation, ventura:        "9b3d39049d0702e88cac51d817ec06034932e16a4dbaca31126bae3eb85392d9"
    sha256 cellar: :any_skip_relocation, monterey:       "bf2e9c8de075f8e7c35206fae6f02a955c862d83643cdb65814619313276b138"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f29674cb6d6e27a5e27b96e5a68b00beb3079362519f6b1127d6802534dc936"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4266201d2a2b7abd58565e3f77b852dd5fcf663474b12ce36a60628f0c77895e"
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