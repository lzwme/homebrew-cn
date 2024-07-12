class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https:www.elastic.cobeatsmetricbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.14.3",
      revision: "71819961045386b23edc18455f1b54764292816c"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "908a5e53228ca2c13144883e1b39a6a1bfceded6f72b581d68465327d714138c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5b2a2b1e499455c92a0765a961e86a54e61d9fb1bd57e52b1116ab2c42dfeb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bdcd3af3ec78424283d891bea925c6eef1852d5aeca68510191399719e7d63c"
    sha256 cellar: :any_skip_relocation, sonoma:         "df1c2dae18220dbf8c699fd217bea87eca189316ccbf5bd24e58a009f2730c98"
    sha256 cellar: :any_skip_relocation, ventura:        "6ea47f67dcbf6418d6cb7cadb54625ffb1d45937c2905416f14e1309c16e57bb"
    sha256 cellar: :any_skip_relocation, monterey:       "95515a5b806f74ca9011c46625f9c5cea7facad8c1548d62d4b7416b42dc7ba2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e2141cda702a6b72196b56c7f34b899c7a9305b50dde0d406ff94da621067c0"
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