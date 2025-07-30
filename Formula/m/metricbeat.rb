class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.1.0",
      revision: "c53b4a051bee29d3e5b3cda16753ea18d47e339e"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e365990c7db5b04b316b9f2fe5dee22b8cdcbfe35aa07421efe8c51d0daeb96d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00c3275287eafa75af671a57486249be6fbf11225f2d2f163b645753fba63533"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3fa43347ed452e26c7686a92f37c62dd0954a293d6f1c779ded38f34226ba7c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "16cf21e4ff83e4e06ce1e9d8f2375dc510c1d620971801fd7b0f45b5016ba39f"
    sha256 cellar: :any_skip_relocation, ventura:       "6e1be012a288286a842d91207a954e3f48b8abbe4042788b92257fe1e1036d41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d07f5142918190b1529b4f296c29f510124ac51d35a646fbce11ff49e774cc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "916e0e0110adbda7de4c0e8a81eb43fbd9251cad473b901eedf045bd5f32388a"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  def install
    # remove non open source files
    rm_r("x-pack")

    cd "metricbeat" do
      # don't build docs because it would fail creating the combined OSS/x-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", "mg.Deps(CollectDocs, FieldsDocs)", ""

      system "mage", "-v", "build"
      system "mage", "-v", "update"

      pkgetc.install Dir["metricbeat.*", "fields.yml", "modules.d"]
      (libexec/"bin").install "metricbeat"
      prefix.install "build/kibana"
    end

    (bin/"metricbeat").write <<~SH
      #!/bin/sh
      exec #{libexec}/bin/metricbeat \
        --path.config #{etc}/metricbeat \
        --path.data #{var}/lib/metricbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/metricbeat \
        "$@"
    SH

    chmod 0555, bin/"metricbeat" # generate_completions_from_executable fails otherwise
    generate_completions_from_executable(bin/"metricbeat", "completion", shells: [:bash, :zsh])
  end

  service do
    run opt_bin/"metricbeat"
  end

  test do
    (testpath/"config/metricbeat.yml").write <<~YAML
      metricbeat.modules:
      - module: system
        metricsets: ["load"]
        period: 1s
      output.file:
        enabled: true
        path: #{testpath}/data
        filename: metricbeat
    YAML

    (testpath/"logs").mkpath
    (testpath/"data").mkpath

    pid = spawn bin/"metricbeat", "--path.config", testpath/"config", "--path.data", testpath/"data"

    sleep 15

    output = JSON.parse((testpath/"data/meta.json").read)
    assert_includes output, "first_start"

    (testpath/"data").glob("metricbeat-*.ndjson") do |file|
      s = JSON.parse(file.read.lines.first.chomp)
      assert_match "metricbeat", s["@metadata"]["beat"]
    end
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end