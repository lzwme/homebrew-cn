class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https:www.elastic.coproductsbeatsfilebeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.14.2",
      revision: "e9455e203842edf9086f34b3ca2fa2b08bc76081"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d8147209f53f59562e158472480e5e86df7c77ed9c52d56f36e7628e1180a859"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba92c35fb703a79d6451723a3a1c1a01422a3b541a4441ae97884364589cc19e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6738101a6db2b68aba90fff5ea5ae8ccfd4bd8de18469d412fa55d1f18347cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "7a79056416e9e569a86ace6685ad669dceffa7b9ca314e31d4fbc8febf7455c1"
    sha256 cellar: :any_skip_relocation, ventura:        "fcf0a301cb19f63551cba64b75db5059518e479503be711384c1e24a375b46f1"
    sha256 cellar: :any_skip_relocation, monterey:       "43e86d7c0a305b6f7f63ed4eab2d739f669009fae1aacbd291df20d18d0b10e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fe342eca333d51a202bbae2b143bf5db403287b66a9ab972328ad96729bc38e"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "python" => :build
  uses_from_macos "rsync" => :build

  def install
    # remove non open source files
    rm_rf "x-pack"

    cd "filebeat" do
      # don't build docs because it would fail creating the combined OSSx-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", "mg.SerialDeps(Fields, Dashboards, Config, GenerateModuleIncludeListGo, fieldDocs,",
                               "mg.SerialDeps(Fields, Dashboards, Config, GenerateModuleIncludeListGo,"

      # prevent downloading binary wheels during python setup
      system "make", "PIP_INSTALL_PARAMS=--no-binary :all", "python-env"
      system "mage", "-v", "build"
      system "mage", "-v", "update"

      (etc"filebeat").install Dir["filebeat.*", "fields.yml", "modules.d"]
      (etc"filebeat""module").install Dir["buildpackagemodules*"]
      (libexec"bin").install "filebeat"
      prefix.install "buildkibana"
    end

    (bin"filebeat").write <<~EOS
      #!binsh
      exec #{libexec}binfilebeat \
        --path.config #{etc}filebeat \
        --path.data #{var}libfilebeat \
        --path.home #{prefix} \
        --path.logs #{var}logfilebeat \
        "$@"
    EOS

    chmod 0555, bin"filebeat" # generate_completions_from_executable fails otherwise
    generate_completions_from_executable(bin"filebeat", "completion", shells: [:bash, :zsh])
  end

  service do
    run opt_bin"filebeat"
  end

  test do
    log_file = testpath"test.log"
    touch log_file

    (testpath"filebeat.yml").write <<~EOS
      filebeat:
        inputs:
          -
            paths:
              - #{log_file}
            scan_frequency: 0.1s
      output:
        file:
          path: #{testpath}
    EOS

    (testpath"log").mkpath
    (testpath"data").mkpath

    fork do
      exec "#{bin}filebeat", "-c", "#{testpath}filebeat.yml",
           "-path.config", "#{testpath}filebeat",
           "-path.home=#{testpath}",
           "-path.logs", "#{testpath}log",
           "-path.data", testpath
    end

    sleep 1
    log_file.append_lines "foo bar baz"
    sleep 5

    assert_predicate testpath"meta.json", :exist?
    assert_predicate testpath"registryfilebeat", :exist?
  end
end