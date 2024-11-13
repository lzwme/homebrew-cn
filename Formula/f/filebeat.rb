class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https:www.elastic.coproductsbeatsfilebeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.16.0",
      revision: "dd6212261c57e41e1bf42532809a14a00c9072a9"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61492bdb3611f256d53ff7289c7afd84346e36f9d0335eed0afff88fd2116043"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb3d9dd58e732bc15c7d7a5fa6f5bac8e40438cc59b5b6ed6cf218e370e92134"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe82c88f3406c47646534ff7cd1901a3d7a391288e2542e984706bfc0a5965e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf9c7f2709da83656ed2e8520a0537e90eaccbbbce5f20382a5f6eec936b1cbc"
    sha256 cellar: :any_skip_relocation, ventura:       "c144cad00bec4f43beeb4b944b21d307888f75b1569e77e9e072abea2c306dbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f5e60f927c411700349b41221fd782b70aad82300414a596d873fd78c417761"
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