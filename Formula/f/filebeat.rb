class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https:www.elastic.coproductsbeatsfilebeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.16.1",
      revision: "f17e0828f1de9f1a256d3f520324fa6da53daee5"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17300db7bbbc676f71e8b48595a2f01fef9c79e96f9ea8e86a3f59784b5642e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c39af42b63aaab00a4419846d5017bc78a9aee79c30051f452d06982c89cad15"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "70d8349b14cf8527805712e2e8894c16277abaf1a6808c6532389b3bc635531c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e0c082403857a7e0560ee9f393a3214a5d21c81251f56ae49180d0511e754e7"
    sha256 cellar: :any_skip_relocation, ventura:       "79de5912a7a590a6263e0d1e8290efd768d181e9823ffc3513042f81058edbf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3930310b95c1343681c527cfbb354f07b91c9b0e1c91d2c6d972da5bcbdd82b3"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.12" => :build

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

    (testpath"filebeat.yml").write <<~YAML
      filebeat:
        inputs:
          -
            paths:
              - #{log_file}
            scan_frequency: 0.1s
      output:
        file:
          path: #{testpath}
    YAML

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