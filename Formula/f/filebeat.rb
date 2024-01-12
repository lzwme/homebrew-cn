class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https:www.elastic.coproductsbeatsfilebeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.11.4",
      revision: "61337102fc51ca447027380b50596966ba88b82b"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ed3381d57539ab7aa95b61110c6155cc1f5c21ddb594997e43feee8f51119531"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4be5d3c2b7853ce1b8b51c32a3ebc5eba8f78a888fafa048f48722390d7e283f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a908b8e95ebeeac19530705f9a06284fe54611404aa338d2262c5b1405b7737e"
    sha256 cellar: :any_skip_relocation, sonoma:         "91f41eb2b992c40e289bf459b3b4ec05d547ce379569e2f2faeba1359f5c157a"
    sha256 cellar: :any_skip_relocation, ventura:        "b35a011ffc024ac00e48be9699f0c12bc524c6ed238e7afc8fddc9ac529d022a"
    sha256 cellar: :any_skip_relocation, monterey:       "258201d5ccce4ed934948b7c470b6f0bcaa721c237f9731fba2d56d5cd407c8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83bfe3caf2d17508620587b036ac80d377bfba2ac237046eebb8ddf88f253f20"
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
      inreplace "magefile.go", "mg.SerialDeps(Fields, Dashboards, Config, includeList, fieldDocs,",
                               "mg.SerialDeps(Fields, Dashboards, Config, includeList,"

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