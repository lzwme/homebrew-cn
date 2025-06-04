class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https:www.elastic.coproductsbeatsfilebeat"
  url "https:github.comelasticbeats.git",
      tag:      "v9.0.2",
      revision: "26ce6f2d4c4de66c3b73a1acf3d1be01b817d791"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "309576fdd5f119040f8aa87dacaf5f12a9aa8d4505bfa4654ef0533c4b6a283c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44da6be600600bc22ab80bb23060b69cb9917b238913c0eee3a61fdc832a80cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7cbb953f68ba770674e0a8ac74434eb62ee684a9f20901c0e611382febb8ec66"
    sha256 cellar: :any_skip_relocation, sonoma:        "b966dd8fe0f5c8ec14817db19eb71e967088f185a7f0c9be83229e4f2d99845f"
    sha256 cellar: :any_skip_relocation, ventura:       "a7bc3ed5db81f44a808d9f75cfff2f51ee156f7f4289840e53a4062c730540ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d152aef9b63e867321963a5b6059e9b5c83acde278ea29f57a24ce299e2c0ebc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d153dd34c44a587a3f1f444b76428d9b6b2c713d7f79e661be5c00c51f9de27"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  def install
    # remove non open source files
    rm_r("x-pack")

    # remove requirements.txt files so that build fails if venv is used.
    # currently only needed by docstests
    rm buildpath.glob("**requirements.txt")

    cd "filebeat" do
      # don't build docs because it would fail creating the combined OSSx-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", GenerateModuleIncludeListGo, fieldDocs,\s*filebeat\.CollectDocs,,
                               "GenerateModuleIncludeListGo,"

      system "mage", "-v", "build"
      system "mage", "-v", "update"

      pkgetc.install Dir["filebeat.*"], "fields.yml", "modules.d"
      (pkgetc"module").install Dir["buildpackagemodules*"]
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

    pid = spawn bin"filebeat", "-c", "#{testpath}filebeat.yml",
                                "--path.config", "#{testpath}filebeat",
                                "--path.home=#{testpath}",
                                "--path.logs", "#{testpath}log",
                                "--path.data", testpath

    sleep 1
    log_file.append_lines "foo bar baz"
    sleep 5

    assert_path_exists testpath"meta.json"
    assert_path_exists testpath"registryfilebeat"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end