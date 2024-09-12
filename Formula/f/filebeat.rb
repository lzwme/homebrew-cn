class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https:www.elastic.coproductsbeatsfilebeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.15.1",
      revision: "88cc526a2d3e52dcbfa52c9dd25eb09ed95470e4"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b848f5f08eb936243e401b317061aea9df8cb79e97bdb1ea74a3c719c131a489"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fbe496be27995e1fda93b832b6ab0fdfd735127fa112d4063e2dafa805c6d39d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ed3451a147b129de040da24ce6c6add7ecab25796809c3b42818c3ba79a01ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bed0af5f2dd1e915ecebec31152343296072a72503bc06359a1b1c1207f5530"
    sha256 cellar: :any_skip_relocation, sonoma:         "07c07e2f33b18c4d5353f1a32c6722432f15ffa4883856e6d4db4e7f3f6b8067"
    sha256 cellar: :any_skip_relocation, ventura:        "9e2caec9962e6bd196c890cada1bc463a7123d916ee68cda1da3772af3bcc1ef"
    sha256 cellar: :any_skip_relocation, monterey:       "307242e1253a6811efc2c687a7586b38aff07764e6ad22916ffba6cfbc0e7be3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa662c11391518c4fa2c0e9b1fcafc36ba64ea71ee78dda37333bab75a23640c"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "python" => :build
  uses_from_macos "rsync" => :build

  def install
    # remove non open source files
    rm_r("x-pack")

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
      exec bin"filebeat", "-c", "#{testpath}filebeat.yml",
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