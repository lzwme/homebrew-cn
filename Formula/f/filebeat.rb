class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https:www.elastic.coproductsbeatsfilebeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.13.4",
      revision: "b24ddd14c936c216817afed0cc7d0b23fd920194"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "690d6689848d9160793dff50915ed93cade993422ff20b4b470566f6b8e5064d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a807e72e0b1db9a699423f7579cdd57758e5d3078aa229db18dbff2952896269"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a5dabe56710651d92736ca91bcdad53ef44d7ba68daca0d7c81d7ffaf5ab8a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "fc0cec25b9e05419b458b88523d1026bd81ceaabdde7ba7b2f1e558bcac4231b"
    sha256 cellar: :any_skip_relocation, ventura:        "a69a46a774fa12f788abe55a26fba61dedbe8496035129f6a5b72fa413b360b1"
    sha256 cellar: :any_skip_relocation, monterey:       "f3fe2fc09df9c2a8a61b4aceabaf477a447776c818cca7d400ab7b1d38bc16da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd5f1793267203afba5c404af227b9caba2f66fb8b0b49b72ab0e7350ad9c1db"
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