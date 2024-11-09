class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https:www.elastic.coproductsbeatsfilebeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.15.3",
      revision: "bbed3ae55602e83f57c62de85b57a3593aa49efa"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b79751cafb036a6e40836d35a788d3e9401aef9e95e388011e96f984d18c09e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33af33cf02e034a06050c0e0d2beefa48ed2bed144ceea7b27ca23ae077c1cd3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a02b939ebf5a129ab1cef3342c7cb6146ce52118d5ffc66bc0257478764b1646"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cbffe0aab79f276e53990a86882dcadd829f2bb97ec018a7e5c6736b2d317d4"
    sha256 cellar: :any_skip_relocation, ventura:       "8d4df125b1704af1b950bbc2beb756af809a477ef8d7b2970fe43e5d61752803"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bb3a9f4c6c1ee3097485fffe4a63ee19a255ec62e05f2b7bc5be57d34f64a83"
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