class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.1.0",
      revision: "c53b4a051bee29d3e5b3cda16753ea18d47e339e"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93d7f0db1af4523ead3f10802d471152c4e2386119511254f5bdac283598ed96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25273dbb8691b02750f61d67bd33c4a283e9494727aa02179e6101546c4db6cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d322ead91038cc5d2a76f7e6bc8307fe9266b7f7a771ea96bd5763d311939e0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "fdea37909b1a0f1a54c32b4591706dab30828350b857ebb58531ac953ac730b3"
    sha256 cellar: :any_skip_relocation, ventura:       "cdddaff9b5073159ca34b66c14ba65a0c9b7f42e95a611ad31dee1d154245379"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d90a33fdf5ea0b76a5eb0fcfe2de6300a1140dbd90fe082a0c6046eb992f2993"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70fe4faf997f26e9b8da24823170ba065b604108d007625f602a62c0836d86dd"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  def install
    # remove non open source files
    rm_r("x-pack")

    # remove requirements.txt files so that build fails if venv is used.
    # currently only needed by docs/tests
    rm buildpath.glob("**/requirements.txt")

    cd "filebeat" do
      # don't build docs because it would fail creating the combined OSS/x-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", /GenerateModuleIncludeListGo, fieldDocs,\s*filebeat\.CollectDocs,/,
                               "GenerateModuleIncludeListGo,"

      system "mage", "-v", "build"
      system "mage", "-v", "update"

      pkgetc.install Dir["filebeat.*"], "fields.yml", "modules.d"
      (pkgetc/"module").install Dir["build/package/modules/*"]
      (libexec/"bin").install "filebeat"
      prefix.install "build/kibana"
    end

    (bin/"filebeat").write <<~EOS
      #!/bin/sh
      exec #{libexec}/bin/filebeat \
        --path.config #{etc}/filebeat \
        --path.data #{var}/lib/filebeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/filebeat \
        "$@"
    EOS

    chmod 0555, bin/"filebeat" # generate_completions_from_executable fails otherwise
    generate_completions_from_executable(bin/"filebeat", "completion", shells: [:bash, :zsh])
  end

  service do
    run opt_bin/"filebeat"
  end

  test do
    log_file = testpath/"test.log"
    touch log_file

    (testpath/"filebeat.yml").write <<~YAML
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

    (testpath/"log").mkpath
    (testpath/"data").mkpath

    pid = spawn bin/"filebeat", "-c", "#{testpath}/filebeat.yml",
                                "--path.config", "#{testpath}/filebeat",
                                "--path.home=#{testpath}",
                                "--path.logs", "#{testpath}/log",
                                "--path.data", testpath

    sleep 1
    log_file.append_lines "foo bar baz"
    sleep 5

    assert_path_exists testpath/"meta.json"
    assert_path_exists testpath/"registry/filebeat"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end